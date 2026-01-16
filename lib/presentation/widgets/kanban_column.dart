import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task/presentation/widgets/comments_section.dart';
import 'package:task/presentation/widgets/timer_widget.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/task_entity.dart';
import '../../data/repositories/comment_repository.dart';
import '../bloc/task/task_bloc.dart';
import '../bloc/task/task_event.dart';
import '../bloc/comment/comment_bloc.dart';
import 'task_card.dart';

class KanbanColumn extends StatelessWidget {
  final String title;
  final List<TaskEntity> tasks;
  final Color color;

  const KanbanColumn({
    super.key,
    required this.title,
    required this.tasks,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppTheme.spacingS),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppTheme.radiusM),
                topRight: Radius.circular(AppTheme.radiusM),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingS),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingS),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingS,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${tasks.length}',
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: tasks.isEmpty
                ? DragTarget<TaskEntity>(
                    onAccept: (draggedTask) {
                      if (draggedTask.kanbanColumn != title) {
                        context.read<TaskBloc>().add(
                              MoveTaskEvent(
                                taskId: draggedTask.task.id,
                                newColumn: title,
                              ),
                            );
                      }
                    },
                    builder: (context, candidateData, rejectedData) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppTheme.radiusM),
                          border: candidateData.isNotEmpty
                              ? Border.all(
                                  color: color,
                                  width: 2,
                                  style: BorderStyle.solid,
                                )
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            'Drop task here',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: candidateData.isNotEmpty ? color : AppTheme.textSecondary,
                                ),
                          ),
                        ),
                      );
                    },
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(AppTheme.spacingS),
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return DragTarget<TaskEntity>(
                        onAccept: (draggedTask) {
                          if (draggedTask.kanbanColumn != title &&
                              draggedTask.task.id != task.task.id) {
                            context.read<TaskBloc>().add(
                                  MoveTaskEvent(
                                    taskId: draggedTask.task.id,
                                    newColumn: title,
                                  ),
                                );
                          }
                        },
                        builder: (context, candidateData, rejectedData) {
                          return Stack(
                            children: [
                              TaskCard(
                                task: task,
                                currentColumn: title,
                                onTap: () => _showTaskDetails(context, task),
                                onLongPress: () => _showTaskOptions(context, task),
                              ),
                              if (candidateData.isNotEmpty)
                                Container(
                                  margin: const EdgeInsets.only(bottom: AppTheme.spacingS),
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: color,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                            ],
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showTaskDetails(BuildContext context, TaskEntity task) {
    // Navigate to task details screen
    // For now, show a dialog
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BlocProvider(
        create: (context) => CommentBloc(
          repository: CommentRepository(),
          taskId: task.task.id,
        ),
        child: TaskDetailsSheet(task: task),
      ),
    );
  }

  void _showTaskOptions(BuildContext context, TaskEntity task) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Task'),
              onTap: () {
                Navigator.pop(context);
                _showEditTaskDialog(context, task);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete Task'),
              onTap: () {
                context.read<TaskBloc>().add(DeleteTaskEvent(task.task.id));
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showEditTaskDialog(BuildContext context, TaskEntity task) {
    final contentController = TextEditingController(text: task.task.content);
    final descriptionController = TextEditingController(
      text: task.task.description ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Task'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: contentController,
                decoration: const InputDecoration(
                  labelText: 'Task Title',
                  hintText: 'Enter task title',
                ),
                autofocus: true,
              ),
              const SizedBox(height: AppTheme.spacingM),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (Optional)',
                  hintText: 'Enter task description',
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (contentController.text.trim().isNotEmpty) {
                context.read<TaskBloc>().add(
                      UpdateTaskEvent(
                        id: task.task.id,
                        content: contentController.text.trim(),
                        description: descriptionController.text.trim().isEmpty
                            ? null
                            : descriptionController.text.trim(),
                      ),
                    );
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

class TaskDetailsSheet extends StatelessWidget {
  final TaskEntity task;

  const TaskDetailsSheet({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.radiusL)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    task.task.content,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (task.task.description != null) ...[
                    Text(
                      'Description',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppTheme.spacingS),
                    Text(
                      task.task.description!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: AppTheme.spacingL),
                  ],
                  // Timer widget
                  TimerWidget(taskId: task.task.id),
                  const SizedBox(height: AppTheme.spacingL),
                  // Comments section
                  CommentsSection(taskId: task.task.id),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
