import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/comment_repository.dart';
import 'comment_event.dart';
import 'comment_state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final CommentRepository _repository;
  final String taskId;

  CommentBloc({
    required CommentRepository repository,
    required this.taskId,
  })  : _repository = repository,
        super(const CommentInitial()) {
    on<LoadCommentsEvent>(_onLoadComments);
    on<AddCommentEvent>(_onAddComment);
    on<DeleteCommentEvent>(_onDeleteComment);
    add(LoadCommentsEvent(taskId));
  }

  Future<void> _onLoadComments(
    LoadCommentsEvent event,
    Emitter<CommentState> emit,
  ) async {
    if (event.taskId != taskId) return;
    
    emit(const CommentLoading());
    try {
      final comments = await _repository.getComments(taskId: event.taskId);
      emit(CommentLoaded(comments));
    } catch (e) {
      emit(CommentError(e.toString()));
    }
  }

  Future<void> _onAddComment(
    AddCommentEvent event,
    Emitter<CommentState> emit,
  ) async {
    if (event.taskId != taskId) return;
    
    try {
      await _repository.createComment(taskId: event.taskId, content: event.content);
      add(LoadCommentsEvent(taskId));
    } catch (e) {
      emit(CommentError(e.toString()));
    }
  }

  Future<void> _onDeleteComment(
    DeleteCommentEvent event,
    Emitter<CommentState> emit,
  ) async {
    if (event.taskId != taskId) return;
    
    try {
      await _repository.deleteComment(event.commentId);
      add(LoadCommentsEvent(taskId));
    } catch (e) {
      emit(CommentError(e.toString()));
    }
  }
}
