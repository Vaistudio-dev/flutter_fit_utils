import 'package:flutter_fit_utils/flutter_fit_utils.dart';

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

  /// Creates a [Model] from a [double].
  /// Encapsulates the data inside model->data->"data".
  Model toModel({String id = "", String userId = ""}) => Model(
    id: id,
    userId: userId,
    data: {
      "data": this,
    },
  );
}

/// Creates a [double] from a [Model].
/// If unsucessful, will return [-1].
double doubleFromModel(Model model) => model.data["data"]?.toDouble() ?? -1;
