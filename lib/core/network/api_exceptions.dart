import 'package:personal_task/core/network/api_error.dart';
import 'package:dio/dio.dart';

class APIExceptions {
  static APIError handleError(DioException dioError) {
    try {
      switch (dioError.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return APIError(message: 'Connection timed out. Please check your internet connection.');
        case DioExceptionType.badResponse:

          final statusCode = dioError.response?.statusCode;
          String message = 'Request failed';
          if (dioError.response?.data != null) {
            final data = dioError.response!.data;

            if (data is Map && data['message'] != null) {
              message = data['message'].toString();
            } else if (data is String) {
              message = data;
            } else {
              message = data.toString();
            }
          } else if (dioError.message != null) {
            message = dioError.message!;
          } else {
            message = 'Received invalid status code: $statusCode';
          }

          return APIError(message: message, statusCode: statusCode);
        case DioExceptionType.cancel:
          return APIError(message: 'Request to server was cancelled.');
        case DioExceptionType.badCertificate:
          return APIError(message: 'Bad certificate.');
        case DioExceptionType.unknown:
        default:
          return APIError(message: 'Something went wrong. Please try again later.');
      }
    } catch (e) {
      return APIError(message: 'Unexpected error while handling API exception: $e');
    }
  }
}
