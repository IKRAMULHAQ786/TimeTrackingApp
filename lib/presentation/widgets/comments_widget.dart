import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:time_tracking_to_do/core/utils/helpers.dart';
import 'package:time_tracking_to_do/domain/entities/comment_entity.dart';

class CommentsWidget extends StatelessWidget {
  final CommentEntity comment;

  const CommentsWidget({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            comment.content,
            style: TextStyle(fontSize: 10.sp),
          ),
          Align(
              alignment: Alignment.bottomRight,
              child: Text(
                formatDateTime(comment.postedAt ?? DateTime.now()),
                style: const TextStyle(fontSize: 10),
              )),
          const Divider(
            height: 5,
          )
        ],
      ),
    );
  }
}
