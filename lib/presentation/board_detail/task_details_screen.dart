import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:time_tracking_to_do/core/utils/helpers.dart';
import 'package:time_tracking_to_do/data/models/status_enum.dart';
import 'package:time_tracking_to_do/data/models/task_model.dart';
import 'package:time_tracking_to_do/presentation/comment/task_comment_screen.dart';
import 'package:time_tracking_to_do/presentation/widgets/loader_widget.dart';
import 'package:time_tracking_to_do/presentation/widgets/update_task_dialog.dart';
import 'bloc/task_bloc.dart';

/// The `TaskDetailScreen` widget displays detailed information about a specific task.
/// It shows the task's content, description, status, and duration, and allows the user
/// to interact with the task's status via a popup menu. The screen also provides a section
/// for displaying comments related to the task.
class TaskDetailScreen extends StatefulWidget {
  final TaskModel task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late String _currentStatus;

  @override
  void initState() {
    _currentStatus =
        widget.task.status; // Initialize with the current task status
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title:
            const Text('Task Details', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueGrey,
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close, color: Colors.white),
          ),
        ],
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state.isLoading) {
            return  Loader(text: state.loadingMessage);
          }

          if (state.errorMessage.isNotEmpty) {
            return Center(
              child: Text(
                'Error: ${state.errorMessage}',
                style: TextStyle(color: Colors.redAccent, fontSize: 16.sp),
              ),
            );
          }
          final task = state.selectedTask;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                       task?.content ?? 'Untitled Task',
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey[900],
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) =>
                              UpdateTaskDialog(task: task!),
                        );
                      },
                      icon: const Icon(Icons.edit, color: Colors.blueGrey),
                    ),
                  ],
                ),
                SizedBox(height: 10.sp),
                Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.blueGrey.shade200,
                  child: PopupMenuButton<TaskStatus>(
                    onSelected: (status) {
                      _currentStatus = status.name; // Update the current status
                      context.read<TaskBloc>().add(
                            MoveTaskEvent(task?.id ?? '', status.name),
                          );
                    },
                    itemBuilder: (context) {
                      return TaskStatus.values
                          .where((status) => status.name != _currentStatus)
                          .map((status) => PopupMenuItem<TaskStatus>(
                                value: status,
                                child: Text(
                                  status.name.capitalize(),
                                  style: TextStyle(color: Colors.blueGrey[800]),
                                ),
                              ))
                          .toList();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Status: $_currentStatus',
                          style: TextStyle(color: Colors.blueGrey[700]),
                        ),
                        const Icon(Icons.keyboard_arrow_down,
                            color: Colors.white),
                      ],
                    ),
                  ),
                ),
                Divider(
                    color: Colors.blueGrey[300], thickness: 1, height: 22.sp),
                const Text(
                  'Description:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.blueGrey,
                  ),
                ),
                SizedBox(height: 8.sp),
                Text(
                  task?.description ?? 'No description provided.',
                  style:
                      TextStyle(fontSize: 10.sp, color: Colors.blueGrey[700]),
                ),
                Divider(
                    color: Colors.blueGrey[300], thickness: 1, height: 22.sp),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Time Logged (in min): ${task?.duration?.amount ?? 'N/A'}',
                      style: TextStyle(
                          fontSize: 10.sp, color: Colors.blueGrey[700]),
                    ),

                    /// if the Task is inProgress then show the start-stop timer button
                    if (task?.labels?.first == 'inProgress')
                      BlocBuilder<TaskBloc, TaskState>(
                        builder: (context, state) {
                          /// fetch the task from the state
                          final taskInProgress = state.tasks
                              .firstWhere((t) => t.id == widget.task.id);
                          /// set the flag for timer
                          bool timerRunning = taskInProgress.isTimerRunning;

                          return TextButton.icon(
                            label: Text(
                                timerRunning ? 'Stop Timer' : 'Start Timer'),
                            icon: Icon(
                              timerRunning ? Icons.pause_circle_filled : Icons.play_circle_filled,
                              color: timerRunning ? Colors.red : Colors.green,
                            ),

                            /// Toggles the timer state for the task.
                            onPressed: () {
                              final taskBloc = context.read<TaskBloc>();
                              if (timerRunning) {
                                taskBloc.add(StopTimerEvent(taskInProgress.id!));
                              } else if (!state.isTimerOn) {
                                taskBloc.add(StartTimerEvent(taskInProgress.id!));
                              }
                            },
                          );
                        },
                      ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    'Created: ${formatDateTime(task?.createdAt ?? DateTime.now())}',
                    style:
                        TextStyle(fontSize: 10.sp, color: Colors.blueGrey[700]),
                  ),
                ),
                Divider(
                    color: Colors.blueGrey[300], thickness: 1, height: 22.sp),
                TaskComments(taskId: task!.id!),
                SizedBox(height: 16.sp),
              ],
            ),
          );
        },
      ),
    );
  }
}
