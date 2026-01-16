# BLoC Migration Guide

This document outlines the migration from Riverpod to BLoC state management.

## Completed Conversions

✅ **BLoC Classes Created:**
- `TaskBloc` - Manages task state and operations
- `TimerBloc` - Manages timer state
- `CommentBloc` - Manages comment state per task

✅ **Files Updated:**
- `main.dart` - Now uses MultiBlocProvider
- `home_screen.dart` - Converted to use BLoC
- `kanban_board.dart` - Converted to use BlocBuilder

## Remaining Conversions Needed

The following files still need to be converted from Riverpod to BLoC:

1. **lib/presentation/widgets/kanban_column.dart**
   - Replace `ConsumerWidget` with `StatelessWidget`
   - Replace `ref.watch(tasksProvider)` with `BlocBuilder<TaskBloc, TaskState>`
   - Replace `ref.read(tasksProvider.notifier).moveTask()` with `context.read<TaskBloc>().add(MoveTaskEvent())`
   - Replace `ref.read(tasksProvider.notifier).deleteTask()` with `context.read<TaskBloc>().add(DeleteTaskEvent())`
   - Replace `ref.read(tasksProvider.notifier).updateTask()` with `context.read<TaskBloc>().add(UpdateTaskEvent())`

2. **lib/presentation/widgets/task_card.dart**
   - Replace `ConsumerWidget` with `StatelessWidget`
   - Replace `ref.watch(activeTimerProvider)` with `BlocBuilder<TimerBloc, TimerState>`

3. **lib/presentation/widgets/timer_widget.dart**
   - Replace `ConsumerStatefulWidget` with `StatefulWidget`
   - Replace `ref.watch(activeTimerProvider)` with `BlocBuilder<TimerBloc, TimerState>`
   - Replace `ref.read(activeTimerProvider.notifier).startTimer()` with `context.read<TimerBloc>().add(StartTimerEvent())`
   - Replace `ref.read(activeTimerProvider.notifier).stopTimer()` with `context.read<TimerBloc>().add(StopTimerEvent())`
   - Replace `ref.read(activeTimerProvider.notifier).getTotalTime()` with direct repository call or add to TimerBloc

4. **lib/presentation/widgets/comments_section.dart**
   - Replace `ConsumerStatefulWidget` with `StatefulWidget`
   - Use `BlocProvider.value` or create CommentBloc per task
   - Replace `ref.watch(taskCommentsProvider(widget.taskId))` with `BlocBuilder<CommentBloc, CommentState>`
   - Replace `ref.read(taskCommentsProvider(widget.taskId).notifier).addComment()` with `context.read<CommentBloc>().add(AddCommentEvent())`
   - Replace `ref.read(taskCommentsProvider(widget.taskId).notifier).deleteComment()` with `context.read<CommentBloc>().add(DeleteCommentEvent())`

5. **lib/presentation/screens/history_screen.dart**
   - Replace `ConsumerWidget` with `StatelessWidget`
   - Replace `ref.watch(tasksProvider)` with `BlocBuilder<TaskBloc, TaskState>`
   - Replace `ref.read(tasksProvider.notifier).loadTasks()` with `context.read<TaskBloc>().add(const LoadTasksEvent())`

## Key Changes

### State Management Pattern

**Before (Riverpod):**
```dart
final tasksAsync = ref.watch(tasksProvider);
return tasksAsync.when(
  data: (tasks) => ...,
  loading: () => ...,
  error: (e, s) => ...,
);
```

**After (BLoC):**
```dart
return BlocBuilder<TaskBloc, TaskState>(
  builder: (context, state) {
    if (state is TaskLoading) return ...;
    if (state is TaskError) return ...;
    if (state is TaskLoaded) {
      final tasks = state.tasks;
      return ...;
    }
    return ...;
  },
);
```

### Dispatching Events

**Before (Riverpod):**
```dart
ref.read(tasksProvider.notifier).createTask(...);
```

**After (BLoC):**
```dart
context.read<TaskBloc>().add(CreateTaskEvent(...));
```

### Accessing State

**Before (Riverpod):**
```dart
final timerState = ref.watch(activeTimerProvider);
```

**After (BLoC):**
```dart
BlocBuilder<TimerBloc, TimerState>(
  builder: (context, timerState) {
    // Use timerState
  },
)
```

## Notes

- CommentBloc needs to be provided per task (use BlocProvider.value in TaskDetailsSheet)
- TimerBloc is global and provided at app level
- TaskBloc is global and provided at app level
