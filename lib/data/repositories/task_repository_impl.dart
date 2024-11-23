import 'dart:convert';
import 'package:time_tracking_to_do/core/utils/constants.dart';
import 'package:time_tracking_to_do/data/data_sources/remote/todoist_api_service.dart';
import 'package:time_tracking_to_do/data/mapper/task_mapper.dart';
import 'package:time_tracking_to_do/domain/entities/task.dart';
import 'package:time_tracking_to_do/domain/repositories/task_repository.dart';
import 'package:time_tracking_to_do/data/models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final ApiService apiService;

  TaskRepositoryImpl({required this.apiService});

  /// The `getTasks` method fetches a list of tasks from the API by making a GET request
  /// to the `ApiEndpoints.getTask` endpoint. It processes the response and returns a
  /// list of `TaskEntity` objects.
  ///
  /// If the request is successful, the response body is decoded and converted into a
  /// list of `TaskEntity` objects using the `TaskModel.fromJson` method.
  ///
  /// Throws an exception if the request fails or if an error occurs.
  @override
  Future<List<TaskEntity>> getTasks() async {
    final response = await apiService.getRequest(ApiEndpoints.getTask);
    return response.fold(
      (failure) => throw Exception(failure.message),
      (success) => (json.decode(success.body) as List)
          .map((taskJson) => TaskModel.fromJson(taskJson).toEntity())
          .toList(),
    );
  }

  /// The `addTask` method sends a POST request to the API to create a new task.
  /// It sends the task data in JSON format, which is generated using the `TaskModel.fromEntity`
  /// method. The task is added to the backend through the `ApiEndpoints.createTask` endpoint.
  ///
  /// If the request is successful, no value is returned. If the request fails, an exception is thrown.
  @override
  Future<void> addTask(TaskEntity task) async {
    final response = await apiService.postRequest(
      ApiEndpoints.createTask,
      TaskModel.fromEntity(task).toJson(),
    );
    response.fold(
      (failure) => throw Exception(failure.message),
      (success) => null,
    );
  }

  /// The `updateTask` method sends a POST request to the API to update an existing task.
  /// It takes a `TaskEntity` object, converts it to JSON using the `TaskModel.fromEntity` method,
  /// and sends it to the `ApiEndpoints.updateTask` endpoint with the task's ID.
  ///
  /// If the request is successful, no value is returned. If the request fails, an exception is thrown.
  @override
  Future<void> updateTask(TaskEntity task) async {
    final response = await apiService.postRequest(
      ApiEndpoints.updateTask(task.id!),
      TaskModel.fromEntity(task).toJson(),
    );
    response.fold(
      (failure) => throw Exception(failure.message),
      (success) => null,
    );
  }

  /// The `moveTask` method sends a POST request to the API to update a task's status.
  /// It takes a `taskId` and a `newStatus` and updates the task's labels (representing the status)
  /// by passing a new label via the API's `updateTask` endpoint.
  ///
  /// If the request is successful, no value is returned. If the request fails, an exception is thrown.
  @override
  Future<void> moveTask(String taskId, String newStatus) async {
    final response = await apiService.postRequest(
      ApiEndpoints.updateTask(taskId),
      {
        'labels': [newStatus]
      }, // Update status as a label
    );
    response.fold(
      (failure) => throw Exception(failure.message),
      (success) => null,
    );
  }

  /// The `deleteTask` method sends a DELETE request to the API to remove a task.
  /// It takes a `taskId` and deletes the corresponding task from the backend via the
  /// `ApiEndpoints.deleteTask` endpoint.
  ///
  /// If the request is successful, no value is returned. If the request fails, an exception is thrown.
  @override
  Future<void> deleteTask(String taskId) async {
    final response =
        await apiService.deleteRequest(ApiEndpoints.deleteTask(taskId));
    response.fold(
      (failure) => throw Exception(failure.message),
      (success) => null,
    );
  }
}
