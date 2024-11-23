import 'package:time_tracking_to_do/domain/entities/comment_entity.dart';

class CommentState {
  final List<CommentEntity> comments;
  final bool isLoading;
  final String errorMessage;
  final String loadingMessage;

  const CommentState({
    this.comments = const [],
    this.isLoading = false,
    this.errorMessage = '',
    this.loadingMessage = 'Loading',
  });

  CommentState copyWith({
    List<CommentEntity>? comments,
    bool? isLoading,
    String? errorMessage,
    String? loadingMessage,
  }) {
    return CommentState(
      comments: comments ?? this.comments,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      loadingMessage: loadingMessage ?? this.loadingMessage,
    );
  }
}
