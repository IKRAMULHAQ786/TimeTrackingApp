import 'package:time_tracking_to_do/domain/entities/task.dart';
import 'task_duration_model.dart';

class TaskModel {
  final String? id;
  final DateTime? createdAt;
  final String? assigneeId;
  final String? assignerId;
  final int? commentCount;
  final bool? isCompleted;
  final String? content;
  final String? description;
  final List<String>? labels; // Status stored as labels
  final int? order;
  final int? priority;
  final int? durationValue;
  final String? durationUnit;
  final TaskDuration? duration; // Modified to TaskDuration
  final String? projectId;
  final String? sectionId;
  final String? parentId;
  final String? url;
  final bool isTimerRunning;

  TaskModel({
    this.id,
    this.createdAt,
    this.assigneeId,
    this.assignerId,
    this.commentCount,
    this.isCompleted,
    this.content,
    this.description,
    this.labels,
    this.order,
    this.priority,
    this.durationValue,
    this.durationUnit,
    this.duration,
    this.projectId,
    this.sectionId,
    this.parentId,
    this.url,
    this.isTimerRunning = false,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      assigneeId: json['assignee_id'] as String?,
      assignerId: json['assigner_id'] as String?,
      commentCount: json['comment_count'] as int?,
      isCompleted: json['is_completed'] as bool?,
      content: json['content'] as String?,
      description: json['description'] as String?,
      labels: json['labels'] != null
          ? List<String>.from(json['labels'] as List)
          : null,
      order: json['order'] as int?,
      priority: json['priority'] as int?,
      duration: json['duration'] != null
          ? TaskDuration.fromJson(json['duration'])
          : null,
      projectId: json['project_id'] as String?,
      sectionId: json['section_id'] as String?,
      parentId: json['parent_id'] as String?,
      url: json['url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt?.toIso8601String(),
      'assignee_id': assigneeId,
      'assigner_id': assignerId,
      'comment_count': commentCount,
      'is_completed': isCompleted,
      'content': content,
      'description': description,
      'labels': labels ?? [],
      'order': order,
      'priority': priority,
      'duration': durationValue, // Should serialize the value properly
      'duration_unit': durationUnit,
      // Ensure this serializes correctly if needed
      'project_id': projectId,
      'section_id': sectionId,
      'parent_id': parentId,
      'url': url,
    };
  }

  factory TaskModel.fromEntity(TaskEntity entity) {
    return TaskModel(
        id: entity.id,
        content: entity.content,
        description: entity.description,
        createdAt: entity.createdAt,
        labels: entity.labels,
        isCompleted: entity.isCompleted,
        duration: entity.duration);
  }

  TaskModel copyWith({
    String? id,
    DateTime? createdAt,
    String? assigneeId,
    String? assignerId,
    int? commentCount,
    bool? isCompleted,
    String? content,
    String? description,
    TaskDuration? duration,
    List<String>? labels,
    int? order,
    int? priority,
    int? durationValue,
    String? durationUnit,
    String? projectId,
    String? sectionId,
    String? parentId,
    String? url,
    bool? isTimerRunning,
  }) {
    return TaskModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      assigneeId: assigneeId ?? this.assigneeId,
      assignerId: assignerId ?? this.assignerId,
      commentCount: commentCount ?? this.commentCount,
      isCompleted: isCompleted ?? this.isCompleted,
      content: content ?? this.content,
      description: description ?? this.description,
      labels: labels ?? this.labels,
      order: order ?? this.order,
      priority: priority ?? this.priority,
      durationValue: durationValue ?? this.durationValue,
      durationUnit: durationUnit ?? this.durationUnit,
      duration: duration ?? this.duration,
      projectId: projectId ?? this.projectId,
      sectionId: sectionId ?? this.sectionId,
      parentId: parentId ?? this.parentId,
      url: url ?? this.url,
      isTimerRunning: isTimerRunning ?? this.isTimerRunning,
    );
  }

  String get status => labels?.firstOrNull ?? 'unknown';
}

