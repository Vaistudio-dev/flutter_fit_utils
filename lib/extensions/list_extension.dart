import 'package:flutter_fit_utils/flutter_fit_utils.dart';

/// Extension of the [List<Modelable>] type.
/// Encapsulates the data inside model->data->"data".
extension FitListExtension<T extends Modelable> on List<T> {
  Model toModel({String id = "", String userId = ""}) => Model(
    id: id,
    userId: userId,
    data: {
      "data": [
        for (final data in this)
          data.toModel().toJson(),
      ],
    },
  );

  /// Creates a [List<Modelable>] from a [Model].
  /// If unsucessful, will return an empty list.
  List<T> fromModel(Model model, T Function(Model) fromModelFactory) => (model.data["data"] as List<dynamic>).map((e) => fromModelFactory(Model.fromJson(e as Map<String, dynamic>))).toList();
}
