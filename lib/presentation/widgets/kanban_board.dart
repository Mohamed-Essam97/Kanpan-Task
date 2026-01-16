import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../bloc/task/task_bloc.dart';
import '../bloc/task/task_state.dart';
import '../bloc/task/task_event.dart';
import 'kanban_column.dart';

class KanbanBoard extends StatelessWidget {
  const KanbanBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        if (state is TaskLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is TaskError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: AppTheme.errorColor),
                const SizedBox(height: AppTheme.spacingM),
                Text(
                  'Error loading tasks',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppTheme.spacingS),
                Text(
                  state.message,
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppTheme.spacingL),
                ElevatedButton(
                  onPressed: () => context.read<TaskBloc>().add(const LoadTasksEvent()),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state is TaskLoaded) {
          final tasks = state.tasks;
          final todoTasks = tasks.where((t) => t.isTodo).toList();
          final inProgressTasks = tasks.where((t) => t.isInProgress).toList();
          final doneTasks = tasks.where((t) => t.isDone).toList();

          return Container(
            color: AppTheme.backgroundColor,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: KanbanColumn(
                    title: AppConstants.columnTodo,
                    tasks: todoTasks,
                    color: AppTheme.todoColor,
                  ),
                ),
                Expanded(
                  child: KanbanColumn(
                    title: AppConstants.columnInProgress,
                    tasks: inProgressTasks,
                    color: AppTheme.inProgressColor,
                  ),
                ),
                Expanded(
                  child: KanbanColumn(
                    title: AppConstants.columnDone,
                    tasks: doneTasks,
                    color: AppTheme.doneColor,
                  ),
                ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
