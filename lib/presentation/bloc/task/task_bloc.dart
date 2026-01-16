import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/task_repository.dart';
import '../../../data/repositories/time_tracking_repository.dart';
import '../../../data/models/task_model.dart';
import '../../../domain/entities/task_entity.dart';
import '../../../core/constants/app_constants.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository _taskRepository;
  final TimeTrackingRepository _timeTrackingRepository;

  TaskBloc({
    required TaskRepository taskRepository,
    required TimeTrackingRepository timeTrackingRepository,
  })  : _taskRepository = taskRepository,
        _timeTrackingRepository = timeTrackingRepository,
        super(const TaskInitial()) {
    on<LoadTasksEvent>(_onLoadTasks);
    on<CreateTaskEvent>(_onCreateTask);
    on<UpdateTaskEvent>(_onUpdateTask);
    on<DeleteTaskEvent>(_onDeleteTask);
    on<MoveTaskEvent>(_onMoveTask);
  }

  Future<void> _onLoadTasks(
    LoadTasksEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(const TaskLoading());
    try {
      final tasks = await _taskRepository.getTasks();
      final timeTrackings = await _timeTrackingRepository.getAllTimeTrackings();
      final timeTrackingMap = {
        for (var tt in timeTrackings) tt.taskId: tt
      };

      final taskEntities = tasks.map((task) {
        final column = _determineColumn(task);
        return TaskEntity(
          task: task,
          timeTracking: timeTrackingMap[task.id],
          kanbanColumn: column,
        );
      }).toList();

      emit(TaskLoaded(taskEntities));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  String _determineColumn(TaskModel task) {
    if (task.isCompleted) {
      return AppConstants.columnDone;
    }
    return AppConstants.columnTodo;
  }

  Future<void> _onCreateTask(
    CreateTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    try {
      await _taskRepository.createTask(
        content: event.content,
        description: event.description,
        priority: event.priority,
      );
      add(const LoadTasksEvent());
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onUpdateTask(
    UpdateTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    try {
      await _taskRepository.updateTask(
        event.id,
        content: event.content,
        description: event.description,
        priority: event.priority,
      );
      add(const LoadTasksEvent());
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onDeleteTask(
    DeleteTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    try {
      await _taskRepository.deleteTask(event.id);
      await _timeTrackingRepository.deleteTimeTracking(event.id);
      add(const LoadTasksEvent());
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onMoveTask(
    MoveTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    final currentState = state;
    if (currentState is! TaskLoaded) return;

    // Optimistically update UI
    final updatedTasks = currentState.tasks.map((task) {
      if (task.task.id == event.taskId) {
        return task.copyWith(kanbanColumn: event.newColumn);
      }
      return task;
    }).toList();
    emit(TaskLoaded(updatedTasks));

    // If moving to Done, mark as completed
    if (event.newColumn == AppConstants.columnDone) {
      try {
        await _taskRepository.closeTask(event.taskId);
        final tracking = await _timeTrackingRepository.getTimeTracking(event.taskId);
        if (tracking != null) {
          await _timeTrackingRepository.saveTimeTracking(
            tracking.copyWith(completedAt: DateTime.now()),
          );
        }
        add(const LoadTasksEvent());
      } catch (e) {
        add(const LoadTasksEvent()); // Reload on error
      }
    } else if (event.newColumn == AppConstants.columnInProgress) {
      // If moving from Done to In Progress, reopen
      final task = currentState.tasks.firstWhere((t) => t.task.id == event.taskId);
      if (task.isDone) {
        try {
          await _taskRepository.reopenTask(event.taskId);
          add(const LoadTasksEvent());
        } catch (e) {
          add(const LoadTasksEvent());
        }
      }
    }
  }
}
