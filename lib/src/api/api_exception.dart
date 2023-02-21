class ApiException implements Exception {
  final String? message;
  final int? code;

  ApiException(this.message, this.code);

  void printDetails() {
    print("ApiException code: ${this.code}");
    print("ApiException msg: ${this.message}");
  }
}