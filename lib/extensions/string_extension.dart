import 'package:flutter_fit_utils/flutter_fit_utils.dart';

/// Extension of the [String] class.
extension FitStringExtension on String {
  /// Creates a [Model] from a [String].
  /// Encapsulates the data inside model->data->"data".
  Model toModel({String id = "", String userId = ""}) => Model(
        id: id,
        userId: userId,
        data: {
          "data": this,
        },
      );
}

/// Creates a [String] from a [Model].
/// If unsucessful, will return an empty [String].
String stringFromModel(Model model) => model.data["data"]?.toString() ?? "";
