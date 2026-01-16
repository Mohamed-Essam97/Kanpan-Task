import 'package:json_annotation/json_annotation.dart';

part 'task_model.g.dart';

/// Task model representing a Todoist task
@JsonSerializable()
class TaskModel {
  @JsonKey(name: 'id', fromJson: _idFromJson)
  final String id;
  
  @JsonKey(name: 'project_id', fromJson: _projectIdFromJson)
  final String projectId;
  
  @JsonKey(name: 'section_id')
  final String? sectionId;
  
  @JsonKey(name: 'content')
  final String content;
  
  @JsonKey(name: 'description')
  final String? description;
  
  @JsonKey(name: 'is_completed')
  final bool isCompleted;
  
  @JsonKey(name: 'labels', fromJson: _labelsFromJson, toJson: _labelsToJson)
  final List<String>? labelIds;
  
  @JsonKey(name: 'parent_id')
  final int? parentId;
  
  @JsonKey(name: 'order', fromJson: _orderFromJson)
  final int order;
  
  @JsonKey(name: 'priority', fromJson: _priorityFromJson)
  final int priority;
  
  @JsonKey(name: 'due')
  final DueDate? due;
  
  @JsonKey(name: 'url')
  final String? url;
  
  @JsonKey(name: 'comment_count', fromJson: _commentCountFromJson)
  final int commentCount;

  TaskModel({
    required this.id,
    required this.projectId,
    this.sectionId,
    required this.content,
    this.description,
    required this.isCompleted,
    this.labelIds,
    this.parentId,
    required this.order,
    required this.priority,
    this.due,
    this.url,
    required this.commentCount,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) =>
      _$TaskModelFromJson(json);

  Map<String, dynamic> toJson() => _$TaskModelToJson(this);

  TaskModel copyWith({
    String? id,
    String? projectId,
    String? sectionId,
    String? content,
    String? description,
    bool? isCompleted,
    List<String>? labelIds,
    int? parentId,
    int? order,
    int? priority,
    DueDate? due,
    String? url,
    int? commentCount,
  }) {
    return TaskModel(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      sectionId: sectionId ?? this.sectionId,
      content: content ?? this.content,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      labelIds: labelIds ?? this.labelIds,
      parentId: parentId ?? this.parentId,
      order: order ?? this.order,
      priority: priority ?? this.priority,
      due: due ?? this.due,
      url: url ?? this.url,
      commentCount: commentCount ?? this.commentCount,
    );
  }
}

// Helper functions for JSON conversion
String _idFromJson(dynamic json) {
  if (json == null) throw Exception('Task id cannot be null');
  return json.toString();
}

String _projectIdFromJson(dynamic json) {
  if (json == null) throw Exception('Project id cannot be null');
  return json.toString();
}

int _orderFromJson(dynamic json) {
  if (json == null) return 0;
  if (json is num) return json.toInt();
  if (json is String) return int.tryParse(json) ?? 0;
  return 0;
}

int _priorityFromJson(dynamic json) {
  if (json == null) return 1; // Default priority
  if (json is num) return json.toInt();
  if (json is String) return int.tryParse(json) ?? 1;
  return 1;
}

int _commentCountFromJson(dynamic json) {
  if (json == null) return 0;
  if (json is num) return json.toInt();
  if (json is String) return int.tryParse(json) ?? 0;
  return 0;
}

List<String>? _labelsFromJson(dynamic json) {
  if (json == null) return null;
  if (json is List) {
    return json.map((e) => e.toString()).toList();
  }
  return null;
}

dynamic _labelsToJson(List<String>? labels) {
  return labels;
}

@JsonSerializable()
class DueDate {
  @JsonKey(name: 'string')
  final String? string;
  
  @JsonKey(name: 'date')
  final String? date;
  
  @JsonKey(name: 'is_recurring')
  final bool isRecurring;
  
  @JsonKey(name: 'datetime')
  final String? datetime;
  
  @JsonKey(name: 'timezone')
  final String? timezone;

  DueDate({
    this.string,
    this.date,
    required this.isRecurring,
    this.datetime,
    this.timezone,
  });

  factory DueDate.fromJson(Map<String, dynamic> json) =>
      _$DueDateFromJson(json);

  Map<String, dynamic> toJson() => _$DueDateToJson(this);
}
