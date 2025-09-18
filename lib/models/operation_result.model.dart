class OperationResult<T> {
  bool success;
  T? data;
  var errors;
  String? message;
  bool? checkAuth;
  String? errorCodeString;

  OperationResult(
      {this.success = false,
      this.data,
        this.errors,
      this.message,
      this.errorCodeString,
      this.checkAuth});
}
