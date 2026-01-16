import 'package:json_annotation/json_annotation.dart';

part 'project_model.g.dart';

/// Project model representing a Todoist project
@JsonSerializable()
class ProjectModel {
  final String id;
  final String name;
  final int color;
  final int? parentId;
  final int order;
  final int commentCount;
  final bool isShared;
  final bool isFavorite;
  final bool isInboxProject;
  final bool isTeamInbox;
  final String viewStyle;
  final String url;

  ProjectModel({
    required this.id,
    required this.name,
    required this.color,
    this.parentId,
    required this.order,
    required this.commentCount,
    required this.isShared,
    required this.isFavorite,
    required this.isInboxProject,
    required this.isTeamInbox,
    required this.viewStyle,
    required this.url,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) =>
      _$ProjectModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectModelToJson(this);
}
