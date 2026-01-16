import '../../data/models/task_model.dart';
import '../../data/models/task_time_tracking.dart';
import '../../core/constants/app_constants.dart';

/// Domain entity representing a task with its state
class TaskEntity {
  final TaskModel task;
  final TaskTimeTracking? timeTracking;
  final String kanbanColumn;

  TaskEntity({
    required this.task,
    this.timeTracking,
    required this.kanbanColumn,
  });

  bool get isCompleted => task.isCompleted;
  bool get isInProgress => kanbanColumn == AppConstants.columnInProgress;
  bool get isTodo => kanbanColumn == AppConstants.columnTodo;
  bool get isDone => kanbanColumn == AppConstants.columnDone;

  Duration get totalTimeSpent {
    if (timeTracking == null) return Duration.zero;
    return timeTracking!.totalDuration;
  }

  bool get hasActiveTimer {
    if (timeTracking == null) return false;
    return timeTracking!.sessions.any((s) => s.isActive);
  }

  TaskEntity copyWith({
    TaskModel? task,
    TaskTimeTracking? timeTracking,
    String? kanbanColumn,
  }) {
    return TaskEntity(
      task: task ?? this.task,
      timeTracking: timeTracking ?? this.timeTracking,
      kanbanColumn: kanbanColumn ?? this.kanbanColumn,
    );
  }
}
