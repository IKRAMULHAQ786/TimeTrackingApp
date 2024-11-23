part of 'task_bloc.dart';

/// The base class for all task-related events in the `TaskBloc`.
/// Every specific event extends this class.
abstract class TaskEvent {}

/// Event triggered to load tasks from the data source and update the task list in the state.
class LoadTasksEvent extends TaskEvent {
  final bool shouldDisplayLoader;

  LoadTasksEvent({this.shouldDisplayLoader = true});
}

/// Event triggered to add a new task with the provided `title` and `description`.
class AddTaskEvent extends TaskEvent {
  final String title;
  final String description;

  /// Constructor to initialize `AddTaskEvent` with a title and description.
  AddTaskEvent(this.title, this.description);
}

/// Event triggered to update an existing task identified by `taskId`,
/// with optional updated `title` and/or `description`.
class UpdateTaskEvent extends TaskEvent {
  final String taskId;
  final String? title;
  final String? description;
  final bool fromDetailsPage;

  /// Constructor to initialize `UpdateTaskEvent` with a `taskId` and optional `title` and `description`.
  UpdateTaskEvent(
    this.taskId, {
    this.title,
    this.description,
    this.fromDetailsPage = false,
  });
}

/// Event triggered to move a task identified by `taskId` to a new status,
/// which is represented by a label in the task.
class MoveTaskEvent extends TaskEvent {
  final String taskId;
  final String newStatus; // Using label as status

  /// Constructor to initialize `MoveTaskEvent` with `taskId` and `newStatus`.
  MoveTaskEvent(
    this.taskId,
    this.newStatus,
  );
}

/// Event triggered to delete a task identified by `taskId`.
class DeleteTaskEvent extends TaskEvent {
  final String taskId;

  /// Constructor to initialize `DeleteTaskEvent` with `taskId`.
  DeleteTaskEvent(this.taskId);
}

/// Event triggered to toggle the loading state, with an optional `text` message
/// and a `loading` flag indicating whether loading is in progress.
class ToggleLoadingEvent extends TaskEvent {
  final String? text;
  final bool loading;

  /// Constructor to initialize `ToggleLoadingEvent` with a loading flag and optional `text`.
  ToggleLoadingEvent({
    this.text = 'Loading..',
    required this.loading,
  });
}

/// Event triggered to start the timer for a task identified by `taskId`.
class StartTimerEvent extends TaskEvent {
  final String taskId;

  /// Constructor to initialize `StartTimerEvent` with `taskId`.
  StartTimerEvent(this.taskId);
}

/// Event triggered to stop the timer for a task identified by `taskId`.
class StopTimerEvent extends TaskEvent {
  final String taskId;

  /// Constructor to initialize `StopTimerEvent` with `taskId`.
  StopTimerEvent(this.taskId);
}

/// Event triggered when a ticket is clicked to see the details page
class SelectTaskEvent extends TaskEvent {
  final TaskModel task;

  SelectTaskEvent({required this.task});
}
