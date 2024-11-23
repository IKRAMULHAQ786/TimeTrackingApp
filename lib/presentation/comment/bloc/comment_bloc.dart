import 'package:bloc/bloc.dart';
import 'package:time_tracking_to_do/domain/entities/comment_entity.dart';
import 'package:time_tracking_to_do/domain/use_cases/comment_use_cases.dart';
import 'comment_event.dart';
import 'comment_state.dart';

/// Bloc for managing comment-related state and logic.
class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final FetchCommentsUseCase fetchCommentsUseCase;
  final SendCommentUseCase sendCommentUseCase;

  /// Constructor to initialize the BLoC with the necessary use cases.
  ///
  /// The [fetchCommentsUseCase] is used to fetch comments for a specific task.
  /// The [sendCommentUseCase] is used to send a new comment.
  ///
  /// Example usage:
  /// ```dart
  /// final commentBloc = CommentBloc(
  ///   fetchCommentsUseCase: fetchCommentsUseCase,
  ///   sendCommentUseCase: sendCommentUseCase,
  /// );
  /// ```
  CommentBloc({
    required this.fetchCommentsUseCase,
    required this.sendCommentUseCase,
  }) : super(const CommentState()) {
    /// Handles the FetchComments event to load comments for a task.
    /// This event triggers fetching the comments for a given task.
    /// The state is updated to reflect the loading status and any errors or success.
    ///
    /// [event.taskId] The ID of the task for which comments need to be fetched.
    ///
    /// The state will have the following properties:
    /// - isLoading: indicates if the comments are being fetched.
    /// - loadingMessage: displays the loading message.
    /// - errorMessage: shows any error message if the fetch fails.
    /// - comments: contains the list of fetched comments if successful.
    on<FetchComments>((event, emit) async {
      emit(state.copyWith(
        isLoading: true,
        loadingMessage: 'Fetching comments...',
        errorMessage: '',
      ));
      final result = await fetchCommentsUseCase(event.taskId);
      result.fold(
        (failure) => emit(
          state.copyWith(
            isLoading: false,
            errorMessage: failure['message'],
          ),
        ),
        (comments) => emit(
          state.copyWith(
            isLoading: false,
            comments: comments,
          ),
        ),
      );
    });

    /// Handles the SendComment event to submit a new comment.
    /// This event triggers sending a new comment. The state is updated to reflect the
    /// loading status during submission and any errors or success after submission.
    ///
    /// [event.comment] The comment data to be sent.
    ///
    /// The state will have the following properties:
    /// - isLoading: indicates if the comment is being sent.
    /// - loadingMessage: displays the sending message.
    /// - errorMessage: shows any error message if the send operation fails.
    /// - comments: the updated list of comments after a new one is added successfully.
    on<SendComment>((event, emit) async {
      emit(state.copyWith(
        isLoading: true,
        loadingMessage: 'Sending comment...',
        errorMessage: '',
      ));
      final result = await sendCommentUseCase(event.comment.toJson());
      result.fold(
        (failure) => emit(
          state.copyWith(
            isLoading: false,
            errorMessage: failure['message'],
          ),
        ),
        (comment) {
          final updatedComments = List<CommentEntity>.from(state.comments)
            ..add(comment);
          emit(state.copyWith(
            isLoading: false,
            comments: updatedComments,
          ));
        },
      );
    });
  }
}
