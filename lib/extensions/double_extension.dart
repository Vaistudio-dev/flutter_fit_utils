import 'package:flutter_fit_utils/flutter_fit_utils.dart';

/// Extension of the [double] type.
extension FitDoubleExtension on double {
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
