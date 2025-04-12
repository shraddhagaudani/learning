//check validation for name field value
String? validateNameField(String? value) {
  if (value!.isEmpty) {
    return "Please enter your  name";
  } else if (value.length < 4) {
    return "Name must be 4 character long";
  }
  return null;
}

String? validatePasswordField(String? value) {
  if (value!.isEmpty) {
    return "Please enter your password";
  } else {
    return null;
  }
}

//check validation for field value
String? validateString(String value, String type) {
  if (value.isEmpty) {
    return "$type is required";
  }
  return null;
}

//check validation for email field value
String? validateEmailField(String? value) {
  RegExp emailValid =
  RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  if (value == null || value.isEmpty) {
    return "Please enter your email address";
  } else if (!emailValid.hasMatch(value)) {
    return "Please provide a valid email address";
  }
  return null;
}