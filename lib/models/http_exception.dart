class HttpException implements Exception {
  final String message;

  HttpException(this.message);

  @override
  String toString() {
    return message;
    // return super.toString(); // would yield an Instance of HttpExcetion
  }
}
