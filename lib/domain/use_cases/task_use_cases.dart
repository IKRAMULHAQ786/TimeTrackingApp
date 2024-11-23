import 'package:time_tracking_to_do/domain/entities/task.dart';
import 'package:time_tracking_to_do/domain/repositories/task_repository.dart';
import 'package:time_tracking_to_do/domain/use_cases/use_case.dart';

/// The `GetTasksUseCase` class is a use case for retrieving a list of tasks from the repository.
/// It implements the `UseCase` interface and calls the `getTasks` method of the `TaskRepository`.
///
/// The `call` method invokes the `getTasks` method of the repository and returns the list of tasks.
class GetTasksUseCase implements UseCase<List<TaskEntity>, NoParams> {
  final TaskRepository repository;

  GetTasksUseCase(this.repository);

  /// The `call` method fetches tasks from the repository.
  ///
  /// Returns:
  ///   - A list of `TaskEntity` objects representing the tasks retrieved from the repository.
  ///
  /// Throws:
  ///   - Any exception thrown by the repository's `getTasks` method.
  @override
  Future<List<TaskEntity>> call(NoParams params) async {
    return repository.getTasks();
  }
}

/// The `AddTaskUseCase` class is responsible for adding a new task to the repository.
/// It implements the `UseCase` interface and calls the `addTask` method of the `TaskRepository` to
/// add the task to the backend.
///
/// It takes a `TaskEntity` object as a parameter, representing the task to be added, and returns `void`.
class AddTaskUseCase implements UseCase<void, TaskEntity> {
  final TaskRepository repository;

  AddTaskUseCase(this.repository);

  @override
  Future<void> call(TaskEntity task) async {
    return repository.addTask(task);
  }
}

/// The `UpdateTaskUseCase` class is responsible for updating an existing task in the repository.
/// It implements the `UseCase` interface and calls the `updateTask` method of the `TaskRepository` to
/// update the task details.
///
/// It takes a `TaskEntity` object as a parameter, representing the task to be updated, and returns `void`.
class UpdateTaskUseCase implements UseCase<void, TaskEntity> {
  final TaskRepository repository;

  UpdateTaskUseCase(this.repository);

  @override
  Future<void> call(TaskEntity task) async {
    return repository.updateTask(task);
  }
}

/// The `MoveTaskUseCase` class is responsible for moving a task from one status to another in the repository.
/// It implements the `UseCase` interface and calls the `moveTask` method of the `TaskRepository` to
/// update the task's status.
///
/// It takes `MoveTaskParams` as a parameter, which contains the task ID and the new status to be set,
/// and returns `void`.
class MoveTaskUseCase implements UseCase<void, MoveTaskParams> {
  final TaskRepository repository;

  MoveTaskUseCase(this.repository);

  @override
  Future<void> call(MoveTaskParams params) async {
    return repository.moveTask(params.taskId, params.newStatus);
  }
}

/// The `DeleteTaskUseCase` class is a use case for deleting a task from the repository.
/// It implements the `UseCase` interface and calls the `deleteTask` method of the `TaskRepository`.
///
/// The `call` method takes a `taskId` and passes it to the `deleteTask` method of the repository.
class DeleteTaskUseCase implements UseCase<void, String> {
  final TaskRepository repository;

  DeleteTaskUseCase(this.repository);

  @override
  Future<void> call(String taskId) async {
    return repository.deleteTask(taskId);
  }
}

/// The `MoveTaskParams` class is a simple data container used to hold the task ID and the new status
/// when moving a task between statuses.
///
/// This class is used as a parameter object for the `MoveTaskUseCase` class to pass the task details.
class MoveTaskParams {
  final String taskId;
  final String newStatus;

  MoveTaskParams({required this.taskId, required this.newStatus});
}

/// The `NoParams` class is a placeholder class used when no parameters are needed for a use case.
/// It is used in the `GetTasksUseCase` class to signify that no parameters are passed to the use case.
class NoParams {}
