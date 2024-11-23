part of 'task_bloc.dart';

/// The `TaskState` class represents the state of the task-related features in the application.
/// It contains information about the list of tasks, loading state, error messages, and other UI-related states.
class TaskState {
  final List<TaskModel> tasks;
  final bool isLoading;
  final String errorMessage;
  final String loadingMessage;
  final bool isTimerOn;
  final bool isEditing;
  final TaskModel? selectedTask;

  /// Constructor for initializing the `TaskState` class with default values.
  TaskState({
    this.tasks = const [],
    this.isLoading = false,
    this.errorMessage = '',
    this.loadingMessage = 'Loading',
    this.isTimerOn = false,
    this.isEditing = false,
    this.selectedTask,
  });

  /// Creates a new `TaskState` with the provided values, leaving unchanged those not provided.
  ///
  /// This method is useful for updating the state without having to reinitialize it from scratch.
  TaskState copyWith({
    List<TaskModel>? tasks,
    bool? isLoading,
    bool? isTimerOn,
    String? errorMessage,
    String? loadingMessage,
    bool? isEditing,
    TaskModel? selectedTask,
  }) {
    return TaskState(
      tasks: tasks ?? this.tasks,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      loadingMessage: loadingMessage ?? this.loadingMessage,
      isTimerOn: isTimerOn ?? this.isTimerOn,
      isEditing: isEditing ?? this.isEditing,
      selectedTask: selectedTask ?? this.selectedTask,
    );
  }
}
