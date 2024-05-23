import 'package:flutter_fit_utils/flutter_fit_utils.dart';

/// Extension of the [bool] type.
extension FitBoolExtension on bool {
  /// Creates a [Model] from a [bool].
  /// Encapsulates the data inside model->data->"data".
  Model toModel({String id = "", String userId = ""}) => Model(
        id: id,
        userId: userId,
        data: {
          "data": this,
        },
      );
}

/// Creates a [bool] from a [Model].
/// If unsucessful, will return [false].
bool boolFromModel(Model model) =>
    bool.parse(model.data["data"]?.toString() ?? "false");
