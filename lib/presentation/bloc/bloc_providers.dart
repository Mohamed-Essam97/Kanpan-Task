import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/task_repository.dart';
import '../../data/repositories/time_tracking_repository.dart';
import '../../data/repositories/comment_repository.dart';
import 'task/task_bloc.dart';
import 'task/task_event.dart';
import 'timer/timer_bloc.dart';
import 'comment/comment_bloc.dart';

class BlocProviders {
  static List<BlocProvider> get providers => [
        BlocProvider<TaskBloc>(
          create: (context) => TaskBloc(
            taskRepository: TaskRepository(),
            timeTrackingRepository: TimeTrackingRepository(),
          )..add(const LoadTasksEvent()),
        ),
        BlocProvider<TimerBloc>(
          create: (context) => TimerBloc(
            repository: TimeTrackingRepository(),
          ),
        ),
      ];

  static BlocProvider<CommentBloc> commentBlocProvider(String taskId) {
    return BlocProvider<CommentBloc>(
      create: (context) => CommentBloc(
        repository: CommentRepository(),
        taskId: taskId,
      ),
    );
  }
}
