import 'package:equatable/equatable.dart';

class TimerState extends Equatable {
  final String? taskId;
  final DateTime? startTime;
  final Duration elapsed;

  const TimerState({
    this.taskId,
    this.startTime,
    this.elapsed = Duration.zero,
  });

  bool get isActive => taskId != null && startTime != null;
  Duration get currentDuration =>
      elapsed + (startTime != null ? DateTime.now().difference(startTime!) : Duration.zero);

  TimerState copyWith({
    String? taskId,
    DateTime? startTime,
    Duration? elapsed,
  }) {
    return TimerState(
      taskId: taskId ?? this.taskId,
      startTime: startTime ?? this.startTime,
      elapsed: elapsed ?? this.elapsed,
    );
  }

  @override
  List<Object?> get props => [taskId, startTime, elapsed];
}
