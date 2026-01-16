/// Application-wide constants
class AppConstants {
  AppConstants._();

  // Kanban Columns
  static const String columnTodo = 'To Do';
  static const String columnInProgress = 'In Progress';
  static const String columnDone = 'Done';

  static const List<String> kanbanColumns = [
    columnTodo,
    columnInProgress,
    columnDone,
  ];

  // Task Priority Levels (Todoist uses 1-4, where 1 is highest)
  static const int priorityLow = 1;
  static const int priorityNormal = 2;
  static const int priorityHigh = 3;
  static const int priorityUrgent = 4;

  // Timer
  static const int timerUpdateInterval = 1; // seconds
}
