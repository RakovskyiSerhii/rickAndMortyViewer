class Failure {
  final _FailureType _failureType;
  final int _code;
  final String _message;

  const Failure(this._failureType, this._code, this._message);

  static Failure serverError() => Failure(_FailureType.SERVER_ERROR, 0, "");

  static Failure serverErrorWithDescription(int code, String message) =>
      Failure(_FailureType.SERVER_ERROR_WITH_DESCRIPTION, code, message);

  static Failure networkError() =>
      Failure(_FailureType.NETWORK_FAILURE, -1, "");

  bool isNetworkError() => _failureType == _FailureType.NETWORK_FAILURE;

  bool isServerError() => _failureType == _FailureType.SERVER_ERROR;

  bool isServerErrorWithDescription() =>
      _failureType == _FailureType.SERVER_ERROR_WITH_DESCRIPTION;

  String get message {
    return _message;
  }

  @override
  String toString() {
    return 'Failure{_failureType: $_failureType, _code: $_code, _message: $_message}';
  }
}

enum _FailureType {
  NETWORK_FAILURE,
  SERVER_ERROR,
  SERVER_ERROR_WITH_DESCRIPTION
}
