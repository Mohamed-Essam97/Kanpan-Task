import 'package:equatable/equatable.dart';

abstract class CommentEvent extends Equatable {
  const CommentEvent();

  @override
  List<Object?> get props => [];
}

class LoadCommentsEvent extends CommentEvent {
  final String taskId;

  const LoadCommentsEvent(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

class AddCommentEvent extends CommentEvent {
  final String taskId;
  final String content;

  const AddCommentEvent({
    required this.taskId,
    required this.content,
  });

  @override
  List<Object?> get props => [taskId, content];
}

class DeleteCommentEvent extends CommentEvent {
  final String taskId;
  final String commentId;

  const DeleteCommentEvent({
    required this.taskId,
    required this.commentId,
  });

  @override
  List<Object?> get props => [taskId, commentId];
}
