import 'package:time_tracking_to_do/data/models/task_model.dart';
import 'package:time_tracking_to_do/domain/entities/task.dart';

/// Maps a Task model to TaskEntity.
extension TaskMapper on TaskModel {
  // Converts TaskModel to TaskEntity
  TaskEntity toEntity() {
    return TaskEntity(
        id: id ?? '',
        content: content ?? '',
        description: description ?? '',
        createdAt: createdAt ?? DateTime.now(),
        labels: labels ?? [],
        isCompleted: isCompleted ?? false,
        duration: duration);
  }
}