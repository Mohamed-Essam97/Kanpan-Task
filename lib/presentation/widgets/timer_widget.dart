import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/date_formatter.dart';
import '../bloc/timer/timer_bloc.dart';
import '../bloc/timer/timer_state.dart';
import '../bloc/timer/timer_event.dart';

class TimerWidget extends StatefulWidget {
  final String taskId;

  const TimerWidget({super.key, required this.taskId});

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  Timer? _updateTimer;
  Duration _totalTimeSpent = Duration.zero;
  bool _isLoading = true;
  bool _wasActive = false;

  @override
  void initState() {
    super.initState();
    _loadTotalTime();
    _startUpdateTimer();
  }

  Future<void> _loadTotalTime() async {
    final timerBloc = context.read<TimerBloc>();
    final totalTime = await timerBloc.getTotalTime(widget.taskId);
    if (mounted) {
      setState(() {
        _totalTimeSpent = totalTime;
        _isLoading = false;
      });
    }
  }


  void _startUpdateTimer() {
    _updateTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        if (mounted) {
          setState(() {});
        }
      },
    );
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, timerState) {
        final isActive = timerState.isActive && timerState.taskId == widget.taskId;
        
        // Track state changes to reload total time when timer stops
        if (_wasActive && !isActive) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _loadTotalTime();
          });
        }
        _wasActive = isActive;

        // Calculate current duration
        Duration currentDuration;
        if (isActive) {
          // If timer is active, show total accumulated + current session
          // timerState.currentDuration already includes elapsed (previous sessions) + current session
          currentDuration = timerState.currentDuration;
        } else {
          // If timer is not active, show total accumulated time from storage
          currentDuration = _totalTimeSpent;
        }

    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.timer_outlined, size: 20),
              const SizedBox(width: AppTheme.spacingS),
              Text(
                'Time Tracker',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingM),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            )
          else ...[
            // Total time spent
            Center(
              child: Column(
                children: [
                  Text(
                    DateFormatter.formatDuration(currentDuration),
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  if (isActive) ...[
                    const SizedBox(height: AppTheme.spacingS),
                    Text(
                      'Timer running...',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.primaryColor,
                          ),
                    ),
                  ] else if (_totalTimeSpent > Duration.zero) ...[
                    const SizedBox(height: AppTheme.spacingS),
                    Text(
                      'Total time spent',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppTheme.spacingM),
            Center(
              child: ElevatedButton.icon(
                onPressed: isActive
                    ? () async {
                        context.read<TimerBloc>().add(const StopTimerEvent());
                        // Reload total time after stopping to show updated value
                        await _loadTotalTime();
                      }
                    : () async {
                        context.read<TimerBloc>().add(StartTimerEvent(widget.taskId));
                        // Reload total time after starting to get the latest elapsed time
                        await _loadTotalTime();
                      },
                icon: Icon(isActive ? Icons.stop : Icons.play_arrow),
                label: Text(isActive ? 'Stop Timer' : 'Start Timer'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isActive ? AppTheme.errorColor : AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ],
      ),
    );
      },
    );
  }
}
