import 'package:flutter_fit_utils/flutter_fit_utils.dart';

/// Extension of the [int] type.
extension FitIntExtension on int {
  /// Creates a [Model] from an [int].
  /// Encapsulates the data inside model->data->"data".
  Model toModel({String id = "", String userId = ""}) => Model(
    id: id,
    userId: userId,
    data: {
      "data": this,
    },
  );
}

/// Creates an [int] from a [Model].
/// If unsucessful, will return [-1].
int intFromModel(Model model) => model.data["data"]?.toInt() ?? -1;
