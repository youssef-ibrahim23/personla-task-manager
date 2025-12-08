import 'package:dio/dio.dart';

class APIServices {
  final Dio _dioClient = Dio();

  Future<Map<String, dynamic>> get({
    required String endPoint,
    Map<String, dynamic>? queryParameters,
  }) async {
    print("API Request URL: $endPoint");
    print("Query Parameters: $queryParameters");

    try {
      final response = await _dioClient.get(
        endPoint,
        queryParameters: queryParameters,
        options: Options(
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      // Handle non-200 responses gracefully
      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        return response.data;
      } else {
        print(
          'API Error: Status ${response.statusCode}, Data: ${response.data}',
        );
        throw Exception(
          'Request failed with status: ${response.statusCode}, check endpoint or parameters',
        );
      }
    } on DioException catch (e) {
      print('Dio Exception: ${e.message}');
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      print('Unexpected Exception: $e');
      throw Exception('Unexpected error: $e');
    }
  }
}
