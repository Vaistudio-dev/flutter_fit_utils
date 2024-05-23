import 'package:flutter/material.dart';

/// Extension of the [String] class.
extension FitStringExtension on String {
  /// Takes a [String] list, [list], and counts the exact matches to [this].
  /// Then, it appends the number of occurence found inside the list to [this].
  ///
  /// Ex:
  /// list: test, test1, test (1), test (2)
  /// this: test
  /// Output: test (3)
  String countExactMatchesAndAppend(List<String> list) {
    int count = 0;

    for (String item in list) {
      RegExp regex = RegExp("(\\b$this\\b\\s[()][0-9][()])");
      if (regex.hasMatch(item) || item == this) count++;
    }

    return count > 0 ? "$this ($count)" : this;
  }

  /// Returns [true] if the [String] contains at least one upper case caracter.
  bool containsCapitalLetter() {
    return characters.any((char) => char.toUpperCase() == char);
  }

  /// Returns [true] if the [String] containes at least one digit.
  bool containsNumber() {
    return characters.any((char) => "0123456789".contains(char));
  }

  /// Returns [true] if the [String] contains any of the following caracters: "!@#$%?&*()-+=^;,.'"\/¨{}[]¤<>°`~".
  bool containsSpecialChar() {
    return characters
        .any((char) => "!@#\$%?&*()-+=^;,.'\"\\/¨{}[]¤<>°`~".contains(char));
  }

  /// Returns the number inside a [String].
  double? extractNumberFromString() {
    final RegExp regExp = RegExp(r"[^\d.]+");
    final String numStr = replaceAll(regExp, "");
    return double.tryParse(numStr);
  }

  /// Returns [true] if a string is made up of only numbers.
  bool isStringNumeric() {
    final RegExp regExp = RegExp(r"[^\d.]+");
    final String numStr = replaceAll(regExp, "");
    return numStr.length == length;
  }

  /// Converts a [String] to a [bool].
  /// To return [true], the trimmed lowercase string must be "true".
  bool parseBool() => toLowerCase().trim() == "true";
}
