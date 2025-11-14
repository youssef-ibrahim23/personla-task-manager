import 'package:dio/dio.dart';
import 'package:personal_task/core/network/api_exceptions.dart';

class APIServices {
  final Dio _dioClient = Dio();

  Future<dynamic> get(String endPoint , [Map<String , dynamic>? query]) async {
    try {
      final response = await _dioClient.get(endPoint , queryParameters: query);
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Request failed with status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      return APIExceptions.handleError(e);
    }
  }
}
