import 'package:time_tracking_to_do/data/models/comment_model.dart';

abstract class CommentEvent {
  const CommentEvent();
}

class FetchComments extends CommentEvent {
  final String taskId;

  const FetchComments(this.taskId);
}

class SendComment extends CommentEvent {
  final Comment comment;

  const SendComment(this.comment);
}
