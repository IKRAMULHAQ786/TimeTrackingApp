import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:time_tracking_to_do/core/errors/failure.dart';
import 'package:time_tracking_to_do/core/utils/constants.dart';

class ApiService {
  final String baseUrl = ApiEndpoints.baseUrl;
  final String token = ApiEndpoints.token;

  /// GET request
  Future<Either<Failure, http.Response>> getRequest(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return Right(response);
      } else {
        return Left(
            ServerFailure('Failed with status code: ${response.statusCode}'));
      }
    } catch (e) {
      return Left(NetworkFailure('Failed to fetch data: $e'));
    }
  }

  /// POST request use for update and for create
  Future<Either<Failure, http.Response>> postRequest(
      String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl$endpoint');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        // log(response.body.toString());
        return Right(response);
      } else {
        return Left(
            ServerFailure('Failed with status code: ${response.statusCode}'));
      }
    } catch (e) {
      return Left(NetworkFailure('Failed to post data: $e'));
    }
  }

  /// DELETE request
  Future<Either<Failure, http.Response>> deleteRequest(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    try {
      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return Right(response);
      } else {
        return Left(
            ServerFailure('Failed with status code: ${response.statusCode}'));
      }
    } catch (e) {
      return Left(NetworkFailure('Failed to delete data: $e'));
    }
  }
}
