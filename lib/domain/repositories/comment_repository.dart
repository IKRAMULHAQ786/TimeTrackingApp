import 'package:dartz/dartz.dart';
import 'package:time_tracking_to_do/domain/entities/comment_entity.dart';

/// Abstract repository for handling comment-related operations.
abstract class CommentRepo {
  /// Fetches comments for the given task ID.
  Future<Either<Map<String, dynamic>, List<CommentEntity>>> fetchComments(String taskId);

  /// Sends a comment for a specific task.
  Future<Either<Map<String, dynamic>, CommentEntity>> sendComment(Map<String, dynamic> commentData);
}