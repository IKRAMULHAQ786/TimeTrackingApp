import 'package:time_tracking_to_do/data/models/comment_model.dart';
import 'package:time_tracking_to_do/domain/entities/comment_entity.dart';

/// Maps a Comment model to CommentEntity.
extension CommentMapper on Comment {
  // Converts TaskModel to TaskEntity
  CommentEntity toEntity() {
    return CommentEntity(
      id: id ?? '',
      content: content,
      taskId: taskId,
      postedAt: postedAt,
    );
  }
}
