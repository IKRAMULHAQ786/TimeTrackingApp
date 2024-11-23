import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_tracking_to_do/data/models/status_enum.dart';
import 'package:time_tracking_to_do/presentation/board_detail/bloc/task_bloc.dart';
import 'package:time_tracking_to_do/presentation/widgets/add_task_dialog.dart';
import 'package:time_tracking_to_do/presentation/widgets/kanban_column.dart';
import 'package:time_tracking_to_do/presentation/widgets/loader_widget.dart';

/// The `KanbanBoardScreen` widget is the main screen displaying the task board.
/// It includes an AppBar with a title and an action button that opens a dialog
/// to add new tasks to the board. The body contains the `KanbanBoard` widget
/// which displays tasks categorized by their status.
class KanbanBoardScreen extends StatelessWidget {
  const KanbanBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Task Board'),
          backgroundColor: Colors.blueGrey,
        ),
        floatingActionButton: BlocBuilder<TaskBloc, TaskState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const SizedBox();
            }
            return FloatingActionButton(
              onPressed: () => _showAddTaskDialog(context),
              shape: const CircleBorder(),
              backgroundColor: Colors.blueGrey,
              child: const Icon(Icons.add, color: Colors.white),
            );
          },
        ),
        body: const KanbanBoard());
  }

  void _showAddTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const TaskDialog(),
    );
  }
}

/// The `KanbanBoard` widget is responsible for displaying tasks grouped by their status.
/// It uses a `BlocBuilder` to listen to the `TaskBloc` state and updates the UI when
/// tasks are loaded, while handling loading and error states. The tasks are displayed in
/// columns, each representing a specific status (e.g., "To Do", "In Progress").
class KanbanBoard extends StatelessWidget {
  const KanbanBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        if (state.isLoading) {
          return Loader(text: state.loadingMessage);
        }
        if (state.errorMessage.isNotEmpty) {
          return Center(child: Text('Error: ${state.errorMessage}'));
        }

        final screenWidth = MediaQuery.of(context).size.width;

        // Set a threshold for switching between layouts (e.g., 600px)
        final isMobile = screenWidth < 600;

        if (isMobile) {
          // Horizontal scroll for small screens (mobile)
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: TaskStatus.values.map((status) {
                // Filter tasks based on the status
                final tasksInStatus = state.tasks.where((task) {
                  return task.labels?.contains(status.name) ?? false;
                }).toList();
                return Container(
                  width: 300, // Fixed width for each column
                  margin: const EdgeInsets.only(right: 16.0),
                  child: TaskColumn(
                    status: status,
                    tasks: tasksInStatus,
                  ),
                );
              }).toList(),
            ),
          );
        } else {
          // Regular grid display for larger screens (tablets and desktops)
          return Row(
            children: TaskStatus.values.map((status) {
              // Filter tasks based on the status
              final tasksInStatus = state.tasks.where((task) {
                return task.labels?.contains(status.name) ?? false;
              }).toList();
              return Expanded(
                child: TaskColumn(
                  status: status,
                  tasks: tasksInStatus,
                ),
              );
            }).toList(),
          );
        }
      },
    );
  }
}
