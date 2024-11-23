import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_tracking_to_do/core/utils/helpers.dart';

import 'package:time_tracking_to_do/data/models/status_enum.dart';
import 'package:time_tracking_to_do/data/models/task_model.dart';
import 'package:time_tracking_to_do/presentation/board_detail/bloc/task_bloc.dart';

import 'package:time_tracking_to_do/presentation/board_detail/task_details_screen.dart';
import 'package:time_tracking_to_do/presentation/comment/bloc/comment_bloc.dart';
import 'package:time_tracking_to_do/presentation/comment/bloc/comment_event.dart';
import 'package:time_tracking_to_do/presentation/widgets/task_card.dart';

/// A widget that represents a column of tasks categorized by their status.
/// Tasks can be dragged and dropped to update their status.
class TaskColumn extends StatelessWidget {
  /// The list of tasks associated with this column.
  ///The status category of the tasks in this column
  final TaskStatus status;
  final List<TaskModel> tasks;

  const TaskColumn({super.key, required this.status, required this.tasks});

  @override
  Widget build(BuildContext context) {
    return Column(
      //crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Displays the title of the column based on the task status.
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            status.name.capitalize(),
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        const SizedBox(height: 8),

        /// Creates a drag-and-drop area to manage task reordering or status updates.
        Expanded(
          child: DragTarget<TaskModel>(onAcceptWithDetails: (details) {
            final task = details.data;
            context.read<TaskBloc>().add(MoveTaskEvent(task.id!, status.name));
          }, builder: (context, candidateData, rejectedData) {
            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                log(task.id.toString());

                /// Creates a draggable card for each task.
                return InkWell(
                    onTap: () {
                      context.read<CommentBloc>().add(FetchComments(task.id!));
                      /// update the state with selected task
                      context.read<TaskBloc>().add(SelectTaskEvent(task: task));
                      showDialog(
                          context: context,
                          builder: (context) {
                            return TaskDetailScreen(task: task);
                          });
                    },
                    child: TaskCardDraggable(task: task));
              },
            );
          }),
        ),
      ],
    );
  }
}
