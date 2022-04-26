class LoginException implements Exception {
  String _message = 'Error';

  LoginException([String message = 'Error']) {
    _message = message;
  }
  @override
  String toString() {
    return _message;
  }
}

class SignUpException implements Exception {
  String _message = 'Error';

  SignUpException([String message = 'Error']) {
    _message = message;
  }

  @override
  String toString() {
    return _message;
  }
}
