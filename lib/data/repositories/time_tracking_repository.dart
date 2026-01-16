import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/task_time_tracking.dart';

/// Repository for time tracking operations (local storage)
class TimeTrackingRepository {
  static const String _keyPrefix = 'time_tracking_';

  Future<void> saveTimeTracking(TaskTimeTracking tracking) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_keyPrefix${tracking.taskId}';
    final json = jsonEncode({
      'taskId': tracking.taskId,
      'totalDuration': tracking.totalDuration.inMilliseconds,
      'sessions': tracking.sessions.map((s) => {
            'startTime': s.startTime.toIso8601String(),
            'endTime': s.endTime?.toIso8601String(),
          }).toList(),
      'completedAt': tracking.completedAt?.toIso8601String(),
    });
    await prefs.setString(key, json);
  }

  Future<TaskTimeTracking?> getTimeTracking(String taskId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_keyPrefix$taskId';
    final jsonString = prefs.getString(key);
    if (jsonString == null) return null;

    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    return TaskTimeTracking(
      taskId: json['taskId'] as String,
      totalDuration: Duration(milliseconds: json['totalDuration'] as int),
      sessions: (json['sessions'] as List)
          .map((s) => TimeSession(
                startTime: DateTime.parse(s['startTime'] as String),
                endTime: s['endTime'] != null
                    ? DateTime.parse(s['endTime'] as String)
                    : null,
              ))
          .toList(),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
    );
  }

  Future<List<TaskTimeTracking>> getAllTimeTrackings() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((k) => k.startsWith(_keyPrefix));
    final trackings = <TaskTimeTracking>[];

    for (final key in keys) {
      final jsonString = prefs.getString(key);
      if (jsonString != null) {
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        trackings.add(TaskTimeTracking(
          taskId: json['taskId'] as String,
          totalDuration: Duration(milliseconds: json['totalDuration'] as int),
          sessions: (json['sessions'] as List)
              .map((s) => TimeSession(
                    startTime: DateTime.parse(s['startTime'] as String),
                    endTime: s['endTime'] != null
                        ? DateTime.parse(s['endTime'] as String)
                        : null,
                  ))
              .toList(),
          completedAt: json['completedAt'] != null
              ? DateTime.parse(json['completedAt'] as String)
              : null,
        ));
      }
    }

    return trackings;
  }

  Future<void> deleteTimeTracking(String taskId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_keyPrefix$taskId';
    await prefs.remove(key);
  }
}
