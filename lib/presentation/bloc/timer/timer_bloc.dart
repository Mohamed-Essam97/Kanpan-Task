import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/time_tracking_repository.dart';
import '../../../data/models/task_time_tracking.dart';
import '../../../core/constants/app_constants.dart';
import 'timer_event.dart';
import 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  final TimeTrackingRepository _repository;
  Timer? _timer;

  TimerBloc({required TimeTrackingRepository repository})
      : _repository = repository,
        super(const TimerState()) {
    on<StartTimerEvent>(_onStartTimer);
    on<StopTimerEvent>(_onStopTimer);
    on<TimerTickEvent>(_onTimerTick);
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(
      const Duration(seconds: AppConstants.timerUpdateInterval),
      (_) {
        if (state.isActive) {
          add(const TimerTickEvent());
        }
      },
    );
  }

  Future<void> _onStartTimer(
    StartTimerEvent event,
    Emitter<TimerState> emit,
  ) async {
    if (state.isActive && state.taskId == event.taskId) {
      return; // Already running for this task
    }

    // Stop current timer if different task
    if (state.isActive && state.taskId != event.taskId) {
      await _stopTimer(emit);
    }

    // Get existing tracking or create new
    var tracking = await _repository.getTimeTracking(event.taskId);
    if (tracking == null) {
      tracking = TaskTimeTracking(
        taskId: event.taskId,
        totalDuration: Duration.zero,
        sessions: [],
      );
    }

    // Add new session
    final newSession = TimeSession(startTime: DateTime.now());
    final updatedSessions = [...tracking.sessions, newSession];
    final updatedTracking = tracking.copyWith(sessions: updatedSessions);

    await _repository.saveTimeTracking(updatedTracking);

    emit(TimerState(
      taskId: event.taskId,
      startTime: DateTime.now(),
      elapsed: tracking.totalDuration,
    ));
  }

  Future<void> _onStopTimer(
    StopTimerEvent event,
    Emitter<TimerState> emit,
  ) async {
    await _stopTimer(emit);
  }

  Future<void> _stopTimer(Emitter<TimerState> emit) async {
    if (!state.isActive) return;

    final taskId = state.taskId!;
    final tracking = await _repository.getTimeTracking(taskId);
    if (tracking == null) {
      emit(const TimerState());
      return;
    }

    // Update the last active session
    final sessions = tracking.sessions.toList();
    if (sessions.isNotEmpty) {
      final lastSession = sessions.last;
      if (lastSession.isActive) {
        final updatedSession = TimeSession(
          startTime: lastSession.startTime,
          endTime: DateTime.now(),
        );
        sessions[sessions.length - 1] = updatedSession;
      }
    }

    // Calculate total duration
    final totalDuration = sessions.fold<Duration>(
      Duration.zero,
      (sum, session) => sum + session.duration,
    );

    final updatedTracking = tracking.copyWith(
      sessions: sessions,
      totalDuration: totalDuration,
    );

    await _repository.saveTimeTracking(updatedTracking);

    emit(const TimerState());
  }

  void _onTimerTick(
    TimerTickEvent event,
    Emitter<TimerState> emit,
  ) {
    if (state.isActive) {
      emit(state.copyWith());
    }
  }

  Future<Duration> getTotalTime(String taskId) async {
    final tracking = await _repository.getTimeTracking(taskId);
    if (tracking == null) return Duration.zero;

    final total = tracking.sessions.fold<Duration>(
      Duration.zero,
      (sum, session) => sum + session.duration,
    );

    return total;
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
