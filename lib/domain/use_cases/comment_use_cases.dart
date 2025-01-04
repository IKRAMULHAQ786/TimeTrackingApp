import 'package:dartz/dartz.dart';
import 'package:time_tracking_to_do/domain/entities/comment_entity.dart';
import 'package:time_tracking_to_do/domain/repositories/comment_repository.dart';
import 'package:time_tracking_to_do/domain/use_cases/task_use_cases.dart';
import 'package:time_tracking_to_do/domain/use_cases/use_case.dart';

/// Use case for fetching comments.
class FetchCommentsUseCase implements UseCase<Either<Map<String, dynamic>, List<CommentEntity>>, String>{
  final CommentRepo commentRepo;

  FetchCommentsUseCase(this.commentRepo);

  /// Fetches comments for the given task ID.
  @override
  Future<Either<Map<String, dynamic>, List<CommentEntity>>> call(String taskId) {
    return commentRepo.fetchComments(taskId);
  }
}
/// Use case for sending a comment.
class SendCommentUseCase implements UseCase<Either<Map<String, dynamic>, CommentEntity>, Map<String, dynamic>>{
  final CommentRepo commentRepo;

  SendCommentUseCase(this.commentRepo);

  /// Sends a comment for the given task ID.
  @override
  Future<Either<Map<String, dynamic>, CommentEntity>> call(Map<String, dynamic> commentData) {
    return commentRepo.sendComment(commentData);
  }
}