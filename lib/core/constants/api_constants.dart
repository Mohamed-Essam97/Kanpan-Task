import '../config/app_config.dart';

/// API Constants for Todoist REST API v2
class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://api.todoist.com/rest/v2';
  static const String apiTokenHeader = 'Authorization';
  static const String apiTokenPrefix = 'Bearer ';
  
  /// Get API token from AppConfig
  /// 
  /// To configure your token:
  /// 1. Get your token from: https://developer.todoist.com/appconsole.html
  /// 2. Replace 'YOUR_TODOIST_API_TOKEN_HERE' in app_config.dart with your actual token
  /// 3. Or use environment variables for better security
  static String get testToken => AppConfig.todoistApiToken;
  
  // Endpoints
  static const String tasksEndpoint = '/tasks';
  static const String projectsEndpoint = '/projects';
  static const String commentsEndpoint = '/comments';
  static const String sectionsEndpoint = '/sections';
}
