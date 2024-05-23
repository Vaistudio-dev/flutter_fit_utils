import 'package:flutter_fit_utils/flutter_fit_utils.dart';

/// Extension of the [num] type.
extension FitNumExtension on num {
  /// Creates a [Model] from a [num].
  /// Encapsulates the data inside model->data->"data".
  Model toModel({String id = "", String userId = ""}) => Model(
    id: id,
    userId: userId,
    data: {
      "data": this,
    },
  );
}

/// Creates a [num] from a [Model].
/// If unsucessful, will return [-1].
num numFromModel(Model model) => num.parse(model.data["data"]?.toString() ?? "-1");
