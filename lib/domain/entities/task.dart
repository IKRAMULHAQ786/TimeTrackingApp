import 'package:time_tracking_to_do/data/models/task_duration_model.dart';

class TaskEntity {
  final String? id;
  final DateTime? createdAt;
  final String? assigneeId;
  final String? assignerId;
  final int? commentCount;
  final bool? isCompleted;
  final String? content;
  final String? description;
  final List<String>? labels;
  final TaskDuration? duration;
  final int? order;
  final int? priority;
  final String? projectId;
  final String? sectionId;
  final String? parentId;
  final String? url;

  TaskEntity({
    this.id,
    this.createdAt,
    this.assigneeId,
    this.assignerId,
    this.commentCount,
    this.isCompleted,
    this.content,
    this.description,
    this.duration,
    this.labels,
    this.order,
    this.priority,
    this.projectId,
    this.sectionId,
    this.parentId,
    this.url,
  });

  String get status => labels?.isNotEmpty == true ? labels!.first : 'unknown';
}
