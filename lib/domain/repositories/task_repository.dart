import 'package:time_tracking_to_do/domain/entities/task.dart';

abstract class TaskRepository {
  Future<List<TaskEntity>> getTasks();
  Future<void> addTask(TaskEntity task);
  Future<void> updateTask(TaskEntity task);
  Future<void> moveTask(String taskId, String newStatus);
  Future<void> deleteTask(String taskId);
}
