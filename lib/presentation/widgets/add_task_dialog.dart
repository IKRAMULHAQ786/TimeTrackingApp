import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_tracking_to_do/presentation/board_detail/bloc/task_bloc.dart';

/// A dialog widget for creating and adding a new task.
class TaskDialog extends StatefulWidget {
  /// Creates an instance of `TaskDialog`.
  const TaskDialog({super.key});

  @override
  /// ignore: library_private_types_in_public_api
  _TaskDialogState createState() => _TaskDialogState();
}

/// State class for the `TaskDialog` widget, managing user input and actions.
class _TaskDialogState extends State<TaskDialog> {
  /// Controller for managing the task title input field.
  final _titleController = TextEditingController();

  /// Controller for managing the task description input field.
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      backgroundColor: Colors.blueGrey[50],

      /// Dialog title displayed at the top.
      title: Text(
        'Add New Task',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.blueGrey[900],
        ),
      ),

      /// Dialog content containing input fields for task details.
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// TextField for entering the task title.
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
          SizedBox(height: 12),

          /// TextField for entering the task description.
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

      /// Dialog action buttons for confirming or canceling the operation.
      actions: [
        /// Button for canceling the dialog.
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(
            foregroundColor: Colors.blueGrey,
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
          child: const Text('Cancel'),
        ),

        /// Button for adding the task.
        ElevatedButton(
          onPressed: () {
            /// Retrieve input values from the text controllers.
            final title = _titleController.text;
            final description = _descriptionController.text;

            /// Dispatch event to add the task if inputs are valid.
            if (title.isNotEmpty && description.isNotEmpty) {
              context.read<TaskBloc>().add(AddTaskEvent(title, description));
              Navigator.of(context).pop(); // Close the dialog.
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
            'Add',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
