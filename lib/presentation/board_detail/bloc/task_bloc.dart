import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:time_tracking_to_do/core/utils/helpers.dart';
import 'package:time_tracking_to_do/data/mapper/task_mapper.dart';
import 'package:time_tracking_to_do/data/models/task_duration_model.dart';
import 'package:time_tracking_to_do/data/models/task_model.dart';
import 'package:time_tracking_to_do/domain/entities/task.dart';
import 'package:time_tracking_to_do/domain/use_cases/task_use_cases.dart';

part 'task_event.dart';

part 'task_state.dart';

/// The `TaskBloc` class handles all the task-related events and manages the state
/// of tasks in the application. It interacts with the domain layer via the
/// use cases and emits states based on the execution of these use cases.
class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetTasksUseCase getTasksUseCase;
  final AddTaskUseCase addTaskUseCase;
  final UpdateTaskUseCase updateTaskUseCase;
  final MoveTaskUseCase moveTaskUseCase;
  final DeleteTaskUseCase deleteTaskUseCase;
  TimerInMinutes timer = TimerInMinutes();

  TaskBloc({
    required this.getTasksUseCase,
    required this.addTaskUseCase,
    required this.updateTaskUseCase,
    required this.moveTaskUseCase,
    required this.deleteTaskUseCase,
  }) : super(TaskState()) {
    on<LoadTasksEvent>(_onLoadTasks);
    on<AddTaskEvent>(_onAddTask);
    on<UpdateTaskEvent>(_onUpdateTask);
    on<MoveTaskEvent>(_onMoveTask);
    on<DeleteTaskEvent>(_onDeleteTask);
    on<ToggleLoadingEvent>(_onToggleLoading);
    on<StartTimerEvent>(_onStartTimer);
    on<StopTimerEvent>(_onStopTimer);
    on<SelectTaskEvent>(_onTicketSelected);
  }

  /// Handles loading tasks by calling the `getTasksUseCase` and updating the state
  /// with the list of tasks.
  Future<void> _onLoadTasks(
      LoadTasksEvent event, Emitter<TaskState> emit) async {
    if (event.shouldDisplayLoader) {
      emit(state.copyWith(isLoading: true, loadingMessage: 'Fetching Tasks..'));
    }
    final tasks = await getTasksUseCase(NoParams());
    final taskModels = tasks.map((e) => TaskModel.fromEntity(e)).toList();
    emit(state.copyWith(tasks: taskModels, isLoading: false));
  }

  /// Handles adding a new task by calling the `addTaskUseCase` and triggering
  /// a reload of the task list after the task is added.
  Future<void> _onAddTask(AddTaskEvent event, Emitter<TaskState> emit) async {
    emit(state.copyWith(isLoading: true, loadingMessage: 'Adding Task..'));
    await addTaskUseCase(TaskEntity(
      id: '',
      content: event.title,
      description: event.description,
      createdAt: DateTime.now(),
      labels: ['todo'],
      isCompleted: false,
    ));
    add(LoadTasksEvent(shouldDisplayLoader: false));
  }

  /// Handles updating an existing task by calling the `updateTaskUseCase`
  /// and updating the task list in the state after the task is successfully updated.
  Future<void> _onUpdateTask(
      UpdateTaskEvent event, Emitter<TaskState> emit) async {
    emit(state.copyWith(loadingMessage: 'Updating Task..', isLoading: true));

    final task = state.tasks.firstWhere((task) => task.id == event.taskId);
    final updatedTask =
        task.copyWith(description: event.description, content: event.title);

    await updateTaskUseCase(updatedTask.toEntity());
    if (event.fromDetailsPage) {
      emit(state.copyWith(selectedTask: updatedTask, isLoading: false));
    }

    add(LoadTasksEvent(shouldDisplayLoader: !event.fromDetailsPage));
  }

  /// Handles moving a task to a new status by calling the `moveTaskUseCase`
  /// and then triggering a reload of the task list after the move is successful.
  Future<void> _onMoveTask(MoveTaskEvent event, Emitter<TaskState> emit) async {
    emit(state.copyWith(isLoading: true, loadingMessage: 'Updating Task Status'));
    /// Update the status of the task
    await moveTaskUseCase(
        MoveTaskParams(taskId: event.taskId, newStatus: event.newStatus));

    /// Fetch the index of the task being moved
    final taskIndex = state.tasks.indexWhere((t) => t.id == event.taskId);

    if (taskIndex != -1) {
      // Create a copy of the task with the updated status
      final updatedTask = state.tasks[taskIndex].copyWith(labels: [event.newStatus]);

      // Update the list of tasks with the updated task
      final updatedTasks = List<TaskModel>.from(state.tasks)
        ..[taskIndex] = updatedTask; // Replace the task at the found index

      // Update the state
      emit(state.copyWith(isLoading: false, tasks: updatedTasks));
    } else {
      // Handle the case where the task was not found, if necessary
      emit(state.copyWith(isLoading: false)); // or some other appropriate action
    }
  }

  /// Handles deleting a task by calling the `deleteTaskUseCase` and then
  /// reloading the task list after the task is deleted.
  Future<void> _onDeleteTask(
      DeleteTaskEvent event, Emitter<TaskState> emit) async {
    await deleteTaskUseCase(event.taskId);
    add(LoadTasksEvent());
  }

  /// Toggles the loading state by updating the `isLoading` and `loadingMessage`
  /// in the current state based on the event data.
  FutureOr<void> _onToggleLoading(
      ToggleLoadingEvent event, Emitter<TaskState> emit) {
    emit(state.copyWith(isLoading: event.loading, loadingMessage: event.text));
  }

  /// Starts the task timer by updating the task's `isTimerRunning` field to `true`
  /// and emits a new state with the updated task list. Also starts the timer for the task.
  Future<void> _onStartTimer(
      StartTimerEvent event, Emitter<TaskState> emit) async {
    emit(state.copyWith(isTimerOn: true));

    /// Locate the task
    final task = state.tasks.firstWhere((task) => task.id == event.taskId);

    final updatedTask = task.copyWith(isTimerRunning: true);

    ////**/ Update the task list
    final updatedTasks = state.tasks.map((t) {
      return t.id == task.id ? updatedTask : t;
    }).toList();
    timer.start();

    emit(state.copyWith(tasks: updatedTasks));
  }

  /// Stops the task timer, calculates the total time spent on the task, and updates
  /// the task's duration. It also triggers an API call to update the task's information
  /// in the backend and updates the state with the new task list.
  Future<void> _onStopTimer(
      StopTimerEvent event, Emitter<TaskState> emit) async {
    emit(state.copyWith(isTimerOn: false));
    final elapsedMinutes = timer.stop();

    /// Locate the task
    final task = state.tasks.firstWhere((task) => task.id == event.taskId);
    final previousTime = task.duration?.amount ?? 1;
    int totalTime = previousTime + elapsedMinutes;
    final updatedTask = task.copyWith(
        isTimerRunning: false,
        durationUnit: 'minute',
        durationValue: totalTime,
        duration: TaskDuration(amount: totalTime, unit: 'minute'));

    /// Update the task list
    final updatedTasks = state.tasks.map((t) {
      return t.id == task.id ? updatedTask : t;
    }).toList();

    /// call the update task use-case
    await updateTaskUseCase(updatedTask.toEntity());

    /// update the state
    emit(state.copyWith(tasks: updatedTasks, selectedTask: updatedTask));
  }

  FutureOr<void> _onTicketSelected(
    SelectTaskEvent event,
    Emitter<TaskState> emit,
  ) {
    emit(state.copyWith(selectedTask: event.task));
  }
}
