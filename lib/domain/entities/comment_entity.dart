/// Represents a Comment entity in the domain layer.
class CommentEntity {
  final String content;
  final String? id;
  final DateTime? postedAt;
  final String taskId;

  const CommentEntity({
    required this.content,
    this.id,
    this.postedAt,
    required this.taskId,
  });
}
