String validatePassword(String value) {
  if (value.isEmpty) {
    return "Please enter your password";
  } else if (value.length < 6) {
    return "Password must be greater than 5 characters";
  } else {
    return null;
  }
}

String validateEmail(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value))
    return 'Enter a valid email';
  else
    return null;
}

String validatePhone(String phone) {
  if (phone.length != 10) {
    return 'Phone number must be 10 digits (no space or hypen)';
  } else {
    return null;
  }
}
