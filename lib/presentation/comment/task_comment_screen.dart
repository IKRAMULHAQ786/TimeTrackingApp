import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:time_tracking_to_do/core/utils/helpers.dart';
import 'package:time_tracking_to_do/presentation/widgets/add_comment_field.dart';
import 'package:time_tracking_to_do/presentation/widgets/comments_widget.dart';
import 'package:time_tracking_to_do/presentation/widgets/loader_widget.dart';

import 'bloc/comment_bloc.dart';
import 'bloc/comment_state.dart';

class TaskComments extends StatelessWidget {
  final String taskId;

  const TaskComments({
    super.key,
    required this.taskId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentBloc, CommentState>(builder: (context, state) {
      if (state.isLoading) {
        return Loader(text: state.loadingMessage);
      } else if (state.errorMessage.isNotEmpty) {
        return Text("Error: ${state.errorMessage}");
      } else if (state.comments.isEmpty) {
        return Column(
          children: [
            const Text("No comments available."),
            AddCommentField(taskId: taskId)
          ],
        );
      } else {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                title: Text('Comments',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                tileColor: Colors.blueGrey,
              ),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                itemCount: state.comments.length,
                padding: EdgeInsets.symmetric(horizontal: 6.sp),
                itemBuilder: (context, index) {
                  return CommentsWidget(comment: state.comments[index]);
                },
              ),
              const SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.sp),
                child: AddCommentField(taskId: taskId),
              ),
            ],
          ),
        );
      }
    });
  }
}
