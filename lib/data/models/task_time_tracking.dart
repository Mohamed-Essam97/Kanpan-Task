import 'package:json_annotation/json_annotation.dart';

part 'task_time_tracking.g.dart';

/// Model for tracking time spent on tasks (stored locally)
@JsonSerializable()
class TaskTimeTracking {
  final String taskId;
  @JsonKey(fromJson: _durationFromJson, toJson: _durationToJson)
  final Duration totalDuration;
  final List<TimeSession> sessions;
  final DateTime? completedAt;

  TaskTimeTracking({
    required this.taskId,
    required this.totalDuration,
    required this.sessions,
    this.completedAt,
  });

  factory TaskTimeTracking.fromJson(Map<String, dynamic> json) =>
      _$TaskTimeTrackingFromJson(json);

  Map<String, dynamic> toJson() => _$TaskTimeTrackingToJson(this);

  TaskTimeTracking copyWith({
    String? taskId,
    Duration? totalDuration,
    List<TimeSession>? sessions,
    DateTime? completedAt,
  }) {
    return TaskTimeTracking(
      taskId: taskId ?? this.taskId,
      totalDuration: totalDuration ?? this.totalDuration,
      sessions: sessions ?? this.sessions,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}

@JsonSerializable()
class TimeSession {
  final DateTime startTime;
  final DateTime? endTime;

  TimeSession({
    required this.startTime,
    this.endTime,
  });

  Duration get duration {
    if (endTime == null) {
      return DateTime.now().difference(startTime);
    }
    return endTime!.difference(startTime);
  }

  bool get isActive => endTime == null;

  factory TimeSession.fromJson(Map<String, dynamic> json) =>
      _$TimeSessionFromJson(json);

  Map<String, dynamic> toJson() => _$TimeSessionToJson(this);
}

// Helper functions for Duration serialization
Duration _durationFromJson(int milliseconds) =>
    Duration(milliseconds: milliseconds);

int _durationToJson(Duration duration) => duration.inMilliseconds;
