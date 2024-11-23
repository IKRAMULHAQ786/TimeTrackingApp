import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:time_tracking_to_do/core/utils/helpers.dart';
import 'package:time_tracking_to_do/data/models/task_model.dart';
import 'package:time_tracking_to_do/presentation/board_detail/bloc/task_bloc.dart';

/// A draggable task card widget that allows dragging tasks to different columns.
class TaskCardDraggable extends StatelessWidget {
  /// The task data associated with this draggable card.
  final TaskModel task;

  /// Constructor to initialize the draggable task card with required task data.
  const TaskCardDraggable({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {

    return Draggable<TaskModel>(
      /// The data being passed when this card is dragged.
      data: task,

      /// The widget displayed while the card is being dragged.
      feedback: SizedBox(
        width: 300,
        child: Transform.rotate(
          angle: 0.15,
          child: TaskCard(task: task, isDragging: true),
        ),
      ),

      /// A placeholder shown in place of the card while it's being dragged.
      childWhenDragging: SizedBox(height: 100.sp),

      /// The actual card displayed in the column.
      child: TaskCard(task: task),
    );
  }
}

/// A widget that represents an individual task card.
class TaskCard extends StatelessWidget {
  /// The task data displayed in this card.
  final TaskModel task;

  /// Indicates whether the card is in a dragging state.
  final bool isDragging;

  /// Constructor to initialize the task card with required data and optional dragging state.
  const TaskCard({
    super.key,
    this.isDragging = false,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: IntrinsicHeight( // Automatically adjusts height to fit content
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status icon with colored background.
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 6),
                child: CircleAvatar(
                  backgroundColor: task.status == 'done'
                      ? Colors.green
                      : task.status == 'inProgress'
                      ? Colors.orange
                      : Colors.blueGrey,
                  child: Icon(
                    task.status == 'done'
                        ? Icons.check_circle
                        : task.status == 'inProgress'
                        ? Icons.timelapse
                        : Icons.task,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Task content: title, description
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Task title
                    Text(
                      task.content ?? 'No title',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.blueGrey[900],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    // Task description
                    const SizedBox(height: 4),
                    Text(
                      task.description ?? 'No description',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blueGrey[700],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Action buttons in the trailing row.
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Popup menu for changing the task's status.
                  PopupMenuButton<String>(
                    onSelected: (status) {
                      context.read<TaskBloc>().add(
                        MoveTaskEvent(task.id ?? '', status),
                      );
                    },
                    itemBuilder: (context) {
                      final possibleStatuses = ['todo', 'inProgress', 'done'];
                      return possibleStatuses
                          .where((status) => status != task.status)
                          .map((status) {
                        return PopupMenuItem<String>(
                          value: status,
                          child: Text(status.replaceAll('_', ' ').capitalize()),
                        );
                      }).toList();
                    },
                    icon: const Icon(Icons.more_vert, color: Colors.blueGrey),
                  ),

                  // Timer control buttons for 'inProgress' tasks.
                  if (task.status == 'inProgress')
                    BlocBuilder<TaskBloc, TaskState>(
                      builder: (context, state) {
                        return IconButton(
                          icon: Icon(
                            task.isTimerRunning ? Icons.pause_circle_filled : Icons.play_circle_filled,
                            color: task.isTimerRunning ? Colors.red : Colors.green,
                            size: 28,
                          ),
                          onPressed: () {
                            final taskBloc = context.read<TaskBloc>();
                            if (task.isTimerRunning) {
                              taskBloc.add(StopTimerEvent(task.id!));
                            } else if (!state.isTimerOn) {
                              taskBloc.add(StartTimerEvent(task.id!));
                            }
                          },
                        );
                      },
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
