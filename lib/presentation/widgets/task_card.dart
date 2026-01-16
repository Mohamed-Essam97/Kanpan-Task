import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/date_formatter.dart';
import '../../domain/entities/task_entity.dart';
import '../bloc/timer/timer_bloc.dart';
import '../bloc/timer/timer_state.dart';

class TaskCard extends StatelessWidget {
  final TaskEntity task;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final String? currentColumn;

  const TaskCard({
    super.key,
    required this.task,
    this.onTap,
    this.onLongPress,
    this.currentColumn,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, timerState) {
        final isTimerActive = timerState.isActive && timerState.taskId == task.task.id;

        return Draggable<TaskEntity>(
      data: task,
      feedback: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.25,
          padding: const EdgeInsets.all(AppTheme.spacingM),
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(AppTheme.radiusM),
            border: Border.all(
              color: AppTheme.primaryColor,
              width: 2,
            ),
          ),
          child: Text(
            task.task.content,
            style: Theme.of(context).textTheme.titleMedium,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: _buildCard(context, isTimerActive),
      ),
      child: _buildCard(context, isTimerActive),
    );
      },
    );
  }

  Widget _buildCard(BuildContext context, bool isTimerActive) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppTheme.spacingS),
        padding: const EdgeInsets.all(AppTheme.spacingM),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
          border: Border.all(
            color: isTimerActive
                ? AppTheme.primaryColor
                : AppTheme.borderColor,
            width: isTimerActive ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    task.task.content,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          decoration: task.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                  ),
                ),
                if (isTimerActive)
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.timer,
                      size: 16,
                      color: AppTheme.primaryColor,
                    ),
                  ),
              ],
            ),
            if (task.task.description != null) ...[
              const SizedBox(height: AppTheme.spacingS),
              Text(
                task.task.description!,
                style: Theme.of(context).textTheme.bodySmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: AppTheme.spacingS),
            Row(
              children: [
                if (task.totalTimeSpent > Duration.zero) ...[
                  Icon(
                    Icons.access_time,
                    size: 14,
                    color: AppTheme.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    DateFormatter.formatDurationShort(task.totalTimeSpent),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(width: AppTheme.spacingS),
                ],
                if (task.task.commentCount > 0) ...[
                  Icon(
                    Icons.comment_outlined,
                    size: 14,
                    color: AppTheme.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${task.task.commentCount}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
