import 'model.dart';

/// Interface that can transform a class into a [Model].
abstract class Modelable {
  /// Model's id.
  final String id;

  /// The model's user id.
  final String userId;

  /// True if the model is marked as invalid, and it's data should be ignored.
  final bool invalid;

  /// Creates a new modelable instance.
  const Modelable({this.id = "", this.userId = "", this.invalid = false});

  /// Creates a new instance and marks it as invalid.
  const Modelable.invalid()
      : id = "",
        userId = "",
        invalid = true;

  /// Creates an instance from a [Model].
  Modelable.fromModel(Model model)
      : id = model.id,
        userId = model.userId ?? "",
        invalid = false;

  /// Converts the instance to a [Model].
  Model toModel();

  /// Shortcut to convert directly to json.
  /// Handy for stuff like json_serializable.
  Map<String, dynamic> toJson() => toModel().toJson();

  /// Copies an instance with the possibility of overriding certain fields.
  Modelable copyWith({String? id, String? userId, bool? invalid = false});
}
