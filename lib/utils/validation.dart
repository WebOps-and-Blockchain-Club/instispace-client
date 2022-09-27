import 'package:validators/validators.dart';

bool isValidEmail(String email) {
  return isEmail(email) &&
      email.split("@")[0].length <= 64 &&
      email.split("@")[1].length <= 255;
}

bool isValidRoll(String roll) {
  return RegExp(r'\b([a-zA-Z]{2,2}[0-9]{2,2}[a-zA-Z][0-9]{3,3})\b')
      .hasMatch(roll);
}

bool isValidNumber(String number) {
  return RegExp(
          r'((\+*)((0[ -]*)*|((91 )*))((\d{12})+|(\d{10})+))|\d{5}([- ]*)\d{6}')
      .hasMatch(number);
}

bool isValidUrl(String string) {
  return isURL(string.trim().toLowerCase()) && string.length <= 1000;
}
