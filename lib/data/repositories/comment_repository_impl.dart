import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:time_tracking_to_do/core/utils/constants.dart';
import 'package:time_tracking_to_do/data/data_sources/remote/todoist_api_service.dart';
import 'package:time_tracking_to_do/data/mapper/comment_mapper.dart';
import 'package:time_tracking_to_do/data/models/comment_model.dart';
import 'package:time_tracking_to_do/domain/entities/comment_entity.dart';
import 'package:time_tracking_to_do/domain/repositories/comment_repository.dart';

/// Implementation of the `CommentRepo` interface.
class CommentRepoImpl implements CommentRepo {
  final ApiService apiService;

  /// Constructor to initialize the repository with an API service.
  ///
  /// The [apiService] is used to make HTTP requests for fetching and sending comments.
  ///
  /// Example usage:
  /// ```dart
  /// final commentRepo = CommentRepoImpl(apiService: apiService);
  /// ```
  CommentRepoImpl({required this.apiService});

  /// Fetches a list of comments for a specific task.
  ///
  /// This method makes a GET request to fetch the comments for a given [taskId].
  /// It returns an [Either] object containing either a failure response with an error message
  /// or a success response with a list of [CommentEntity].
  ///
  /// [taskId] The ID of the task for which comments need to be fetched.
  ///
  /// Returns:
  /// - [Left] containing an error message if the request fails.
  /// - [Right] containing a list of [CommentEntity] if the request succeeds.
  @override
  Future<Either<Map<String, dynamic>, List<CommentEntity>>> fetchComments(
      String taskId) async {
    try {
      final response =
          await apiService.getRequest(ApiEndpoints.getComment(taskId));
      return response.fold(
        (failure) => Left({'message': failure.message}),
        (success) {
          List<CommentEntity> comments = (json.decode(success.body) as List)
              .map((commentJson) =>
                  Comment.fromJson(commentJson).toEntity())
              .toList();
          return Right(comments);
        },
      );
    } catch (e) {
      return Left({'message': e.toString()});
    }
  }

  /// Sends a new comment for a task.
  ///
  /// This method makes a POST request to create a new comment with the given [commentData].
  /// It returns an [Either] object containing either a failure response with an error message
  /// or a success response with the created [CommentEntity].
  ///
  /// [commentData] The data for the new comment to be sent.
  ///
  /// Returns:
  /// - [Left] containing an error message if the request fails.
  /// - [Right] containing the created [CommentEntity] if the request succeeds.
  @override
  Future<Either<Map<String, dynamic>, CommentEntity>> sendComment(
      Map<String, dynamic> commentData) async {
    try {
      final response =
          await apiService.postRequest(ApiEndpoints.createComment, commentData);
      return response.fold(
        (failure) => Left({'message': failure.message}),
        (success) {
          final comment =
              Comment.fromJson(json.decode(success.body)).toEntity();
          return Right(comment);
        },
      );
    } catch (e) {
      return Left({'message': e.toString()});
    }
  }
}
