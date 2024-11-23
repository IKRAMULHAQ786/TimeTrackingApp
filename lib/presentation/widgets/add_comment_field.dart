import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_tracking_to_do/data/models/comment_model.dart';
import 'package:time_tracking_to_do/presentation/comment/bloc/comment_bloc.dart';
import 'package:time_tracking_to_do/presentation/comment/bloc/comment_event.dart';


/// A widget that provides a text input field for adding comments to a task.
class AddCommentField extends StatefulWidget {
  /// The ID of the task to which the comment will be added.
  final String taskId;

  /// Creates an instance of `AddCommentField` with the specified task ID.
  const AddCommentField({
    super.key,
    required this.taskId,
  });

  @override
  State<AddCommentField> createState() => _AddCommentFieldState();
}

/// The state for the `AddCommentField` widget.
class _AddCommentFieldState extends State<AddCommentField> {
  /// Controller to manage the input text field.
  final _controller = TextEditingController();

  @override
  void dispose() {
    /// Dispose the controller to release resources when the widget is removed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      /// Binds the controller to the input field.
      controller: _controller,

      /// Configures the input field decoration.
      decoration: InputDecoration(
        hintText: 'Add a comment...',

        /// A button to send the comment, located at the end of the input field.
        suffixIcon: IconButton(
          icon: const Icon(Icons.send),

          /// Handles the action of sending a comment.
          onPressed: () async {
            /// Creates a `Comment` object with the entered text and task ID.
            final comment =
                Comment(content: _controller.text, taskId: widget.taskId);

            /// Sends the comment if the text field is not empty.
            if (_controller.text.isNotEmpty) {
              context.read<CommentBloc>().add(SendComment(comment));

              /// Clears the input field after sending the comment.
              _controller.clear();
            }
          },
        ),
      ),
    );
  }
}
