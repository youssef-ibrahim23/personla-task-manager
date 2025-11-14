class APIError {
  final String? message;
  final int? statusCode;

  APIError({required this.message , this.statusCode});

  @override
  String toString() {
    return 'error is: $message with status code: $statusCode';
  }

}