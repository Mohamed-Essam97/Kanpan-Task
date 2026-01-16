import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/task_model.dart';
import '../models/comment_model.dart';
import '../models/project_model.dart';
import '../../core/constants/api_constants.dart';

part 'todoist_api_service.g.dart';

/// Retrofit API service for Todoist REST API v2
@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class TodoistApiService {
  factory TodoistApiService(Dio dio, {String baseUrl}) = _TodoistApiService;

  // Tasks
  @GET(ApiConstants.tasksEndpoint)
  Future<List<TaskModel>> getTasks({
    @Query('project_id') String? projectId,
    @Query('section_id') String? sectionId,
    @Query('label_id') String? labelId,
    @Query('filter') String? filter,
    @Query('lang') String? lang,
    @Query('ids') String? ids,
  });

  @GET('/tasks/{id}')
  Future<TaskModel> getTask(@Path('id') String id);

  @POST(ApiConstants.tasksEndpoint)
  Future<TaskModel> createTask(@Body() Map<String, dynamic> task);

  @POST('/tasks/{id}')
  Future<TaskModel> updateTask(
    @Path('id') String id,
    @Body() Map<String, dynamic> task,
  );

  @DELETE('/tasks/{id}')
  Future<void> deleteTask(@Path('id') String id);

  @POST('/tasks/{id}/close')
  Future<void> closeTask(@Path('id') String id);

  @POST('/tasks/{id}/reopen')
  Future<void> reopenTask(@Path('id') String id);

  // Comments
  @GET(ApiConstants.commentsEndpoint)
  Future<List<CommentModel>> getComments({
    @Query('task_id') String? taskId,
    @Query('project_id') String? projectId,
  });

  @GET('/comments/{id}')
  Future<CommentModel> getComment(@Path('id') String id);

  @POST(ApiConstants.commentsEndpoint)
  Future<CommentModel> createComment(@Body() Map<String, dynamic> comment);

  @POST('/comments/{id}')
  Future<CommentModel> updateComment(
    @Path('id') String id,
    @Body() Map<String, dynamic> comment,
  );

  @DELETE('/comments/{id}')
  Future<void> deleteComment(@Path('id') String id);

  // Projects
  @GET(ApiConstants.projectsEndpoint)
  Future<List<ProjectModel>> getProjects();

  @GET('/projects/{id}')
  Future<ProjectModel> getProject(@Path('id') String id);
}
