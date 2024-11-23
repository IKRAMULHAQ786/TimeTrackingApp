class Comment {
  final String content;
  final String? id;
  final DateTime? postedAt;
  final String taskId;

  const Comment({
    required this.content,
    this.id,
    this.postedAt,
    required this.taskId,
  });

  /// Convert Comment instance to JSON
  Map<String, dynamic> toJson() => {
        'content': content,
        'task_id': taskId,
        //'posted_at': postedAt ?? DateTime.now()
      };

  /// Create Comment instance from JSON
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      content: json['content'] ?? '',
      id: json['id'] as String?, // Nullable field, keep it as is
      postedAt: json['posted_at'] != null
          ? DateTime.parse(json['posted_at'] as String)
          : null,
      taskId: json['taskId'] as String? ?? '', // Provide a default if null
    );
  }

  /// Create a copy of Comment with some fields updated
  Comment copyWith({
    String? content,
    String? id,
    DateTime? postedAt,
    String? taskId,
  }) {
    return Comment(
      content: content ?? this.content,
      id: id ?? this.id,
      postedAt: postedAt ?? this.postedAt,
      taskId: taskId ?? this.taskId,
    );
  }

  @override
  String toString() =>
      'Comment(content: $content, id: $id, postedAt: $postedAt, taskId: $taskId)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Comment &&
          runtimeType == other.runtimeType &&
          content == other.content &&
          id == other.id &&
          postedAt == other.postedAt &&
          taskId == other.taskId;

  @override
  int get hashCode =>
      content.hashCode ^ id.hashCode ^ postedAt.hashCode ^ taskId.hashCode;
}
