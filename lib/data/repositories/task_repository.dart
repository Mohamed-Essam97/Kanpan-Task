import '../api/todoist_api_service.dart';
import '../api/dio_client.dart';
import '../models/task_model.dart';

/// Repository for task operations
class TaskRepository {
  final TodoistApiService _apiService;

  TaskRepository() : _apiService = TodoistApiService(DioClient.createDio());

  Future<List<TaskModel>> getTasks({String? projectId}) async {
    try {
      return await _apiService.getTasks(projectId: projectId);
    } catch (e) {
      throw Exception('Failed to fetch tasks: $e');
    }
  }

  Future<TaskModel> getTask(String id) async {
    try {
      return await _apiService.getTask(id);
    } catch (e) {
      throw Exception('Failed to fetch task: $e');
    }
  }

  Future<TaskModel> createTask({
    required String content,
    String? description,
    String? projectId,
    int? priority,
    String? dueString,
  }) async {
    try {
      final taskData = <String, dynamic>{
        'content': content,
        if (description != null) 'description': description,
        if (projectId != null) 'project_id': projectId,
        if (priority != null) 'priority': priority,
        if (dueString != null) 'due_string': dueString,
      };
      return await _apiService.createTask(taskData);
    } catch (e) {
      throw Exception('Failed to create task: $e');
    }
  }

  Future<TaskModel> updateTask(
    String id, {
    String? content,
    String? description,
    int? priority,
    String? dueString,
  }) async {
    try {
      final taskData = <String, dynamic>{};
      if (content != null) taskData['content'] = content;
      if (description != null) taskData['description'] = description;
      if (priority != null) taskData['priority'] = priority;
      if (dueString != null) taskData['due_string'] = dueString;

      return await _apiService.updateTask(id, taskData);
    } catch (e) {
      throw Exception('Failed to update task: $e');
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      await _apiService.deleteTask(id);
    } catch (e) {
      throw Exception('Failed to delete task: $e');
    }
  }

  Future<void> closeTask(String id) async {
    try {
      await _apiService.closeTask(id);
    } catch (e) {
      throw Exception('Failed to close task: $e');
    }
  }

  Future<void> reopenTask(String id) async {
    try {
      await _apiService.reopenTask(id);
    } catch (e) {
      throw Exception('Failed to reopen task: $e');
    }
  }
}
