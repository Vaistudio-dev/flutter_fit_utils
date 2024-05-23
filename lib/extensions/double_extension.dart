/// Extension of the [double] type.
extension FitDoubleExtension on double {
  /// Converts a [double] to a [String]. Only prints the decimals if there is any.
  String toBetterString({int decimals = 1}) {
    final String decimalPart = toString().split(".").last;
    if (decimalPart.split("").any((element) => element != "0")) {
      return toStringAsFixed(decimals);
    }

    return toStringAsFixed(0);
  }
}
