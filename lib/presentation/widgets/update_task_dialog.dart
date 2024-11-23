import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_tracking_to_do/data/models/task_model.dart';
import 'package:time_tracking_to_do/presentation/board_detail/bloc/task_bloc.dart';

/// A dialog widget for updating a task's title and description.
class UpdateTaskDialog extends StatefulWidget {
  /// The task to be updated.
  final TaskModel task;

  /// Constructor to initialize the dialog with the task to be updated.
  const UpdateTaskDialog({super.key, required this.task});

  @override
  UpdateTaskDialogState createState() => UpdateTaskDialogState();
}

/// State class for the `UpdateTaskDialog` widget.
class UpdateTaskDialogState extends State<UpdateTaskDialog> {
  /// Controller for the task title input field.
  late final TextEditingController _titleController;

  /// Controller for the task description input field.
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();

    /// Initialize controllers with the current task data.
    _titleController = TextEditingController(text: widget.task.content);
    _descriptionController =
        TextEditingController(text: widget.task.description);
  }

  @override
  void dispose() {
    /// Dispose controllers to free up resources.
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      backgroundColor: Colors.blueGrey[50],

      /// Dialog title.
      title: Text(
        'Update Task',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.blueGrey[900],
        ),
      ),

      /// Dialog content containing input fields for title and description.
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Input field for updating the task title.
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'Task Title',
              labelStyle: TextStyle(color: Colors.blueGrey[800]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.blueGrey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.blueGrey.shade500, width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 12),

          /// Input field for updating the task description.
          TextField(
            controller: _descriptionController,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Task Description',
              labelStyle: TextStyle(color: Colors.blueGrey[800]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.blueGrey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.blueGrey.shade500, width: 1.5),
              ),
            ),
          ),
        ],
      ),

      /// Action buttons for the dialog.
      actions: [
        /// Button to update the task and dispatch an event.
        ElevatedButton(
          onPressed: () {
            /// Get trimmed input values.
            final title = _titleController.text.trim();
            final description = _descriptionController.text.trim();

            /// Ensure both fields are filled before proceeding.
            if (title.isNotEmpty && description.isNotEmpty) {
              context.read<TaskBloc>().add(
                UpdateTaskEvent(
                  widget.task.id!,
                  title: title,
                  description: description,
                  fromDetailsPage: true,
                ),
              );
              Navigator.of(context).pop(); // Close the dialog.
            } else {
              /// Show a warning if any field is empty.
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Both fields must be filled.')),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueGrey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          ),
          child: const Text(
            'Update',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),

        /// Button to cancel and close the dialog without updating.
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(
            foregroundColor: Colors.blueGrey,
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
