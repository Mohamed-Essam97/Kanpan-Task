import '../api/todoist_api_service.dart';
import '../api/dio_client.dart';
import '../models/comment_model.dart';

/// Repository for comment operations
class CommentRepository {
  final TodoistApiService _apiService;

  CommentRepository() : _apiService = TodoistApiService(DioClient.createDio());

  Future<List<CommentModel>> getComments({String? taskId}) async {
    try {
      return await _apiService.getComments(taskId: taskId);
    } catch (e) {
      throw Exception('Failed to fetch comments: $e');
    }
  }

  Future<CommentModel> createComment({
    required String taskId,
    required String content,
  }) async {
    try {
      return await _apiService.createComment({
        'task_id': taskId,
        'content': content,
      });
    } catch (e) {
      throw Exception('Failed to create comment: $e');
    }
  }

  Future<CommentModel> updateComment(String id, String content) async {
    try {
      return await _apiService.updateComment(id, {'content': content});
    } catch (e) {
      throw Exception('Failed to update comment: $e');
    }
  }

  Future<void> deleteComment(String id) async {
    try {
      await _apiService.deleteComment(id);
    } catch (e) {
      throw Exception('Failed to delete comment: $e');
    }
  }
}
