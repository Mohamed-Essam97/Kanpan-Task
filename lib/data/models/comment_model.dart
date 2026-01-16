import 'package:json_annotation/json_annotation.dart';

part 'comment_model.g.dart';

/// Comment model representing a Todoist comment
@JsonSerializable()
class CommentModel {
  @JsonKey(name: 'id', fromJson: _idFromJson)
  final String id;
  
  @JsonKey(name: 'task_id', fromJson: _taskIdFromJson)
  final String taskId;
  
  @JsonKey(name: 'project_id')
  final String? projectId;
  
  @JsonKey(name: 'content')
  final String content;
  
  @JsonKey(name: 'posted_at')
  final String postedAt;

  CommentModel({
    required this.id,
    required this.taskId,
    this.projectId,
    required this.content,
    required this.postedAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) =>
      _$CommentModelFromJson(json);

  Map<String, dynamic> toJson() => _$CommentModelToJson(this);

  CommentModel copyWith({
    String? id,
    String? taskId,
    String? projectId,
    String? content,
    String? postedAt,
  }) {
    return CommentModel(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      projectId: projectId ?? this.projectId,
      content: content ?? this.content,
      postedAt: postedAt ?? this.postedAt,
    );
  }
}

// Helper functions for ID conversion
String _idFromJson(dynamic json) {
  if (json == null) throw Exception('Comment id cannot be null');
  return json.toString();
}

String _taskIdFromJson(dynamic json) {
  if (json == null) throw Exception('Task id cannot be null');
  return json.toString();
}
