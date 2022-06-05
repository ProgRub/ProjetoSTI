String? nameValidator(String? value) {
  final RegExp nameRegExp = RegExp(r"^[\p{L} ,.'-]*$",
      caseSensitive: false, unicode: true, dotAll: true);
  if (inputIsEmptyOrNull(value)) {
    return 'Please enter your name';
  } else if (!nameRegExp.hasMatch(value.toString())) {
    return 'Please enter a valid name';
  }
  return null;
}

String? ageValidator(String? value) {
  if (inputIsEmptyOrNull(value)) {
    return 'Please enter your age';
  } else if (!_isNumeric(value.toString())) {
    return 'Please enter a number';
  } else if (int.parse(value.toString()) < 0 ||
      int.parse(value.toString()) > 100) {
    return 'Age between 1 and 100';
  }
  return null;
}

bool _isNumeric(String str) {
  return int.tryParse(str) != null;
}

bool inputIsEmptyOrNull(value) => value == null || value.isEmpty;

String? passwordValidator(String? value) {
  if (inputIsEmptyOrNull(value)) {
    return 'Please enter your password';
  }
  return null;
}

String? emailValidator(String? value) {
  if (inputIsEmptyOrNull(value)) {
    return 'Please enter an email';
  } else if (!isValidEmail(value)) {
    return 'Please enter a valid email';
  }
  return null;
}

//JUST FOR TESTING!!!
bool userExists(email, password) =>
    email == "test@test.com" && password == "test";

bool isValidEmail(email) {
  return RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);
}
