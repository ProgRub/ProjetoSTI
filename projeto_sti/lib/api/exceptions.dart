class LoginException implements Exception {
  String code = 'Error';

  LoginException([String code = 'Error']) {
    this.code = code;
  }
  @override
  String toString() {
    return code;
  }
}

class SignUpException implements Exception {
  String code = 'Error';

  SignUpException([String code = 'Error']) {
    this.code = code;
  }

  @override
  String toString() {
    return code;
  }
}
