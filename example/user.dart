import 'package:flutter_fit_utils/model/model.dart';
import 'package:flutter_fit_utils/model/modelable.dart';

/// Example user class.
class User extends Modelable {
  static const String _nameKey = "name";

  /// User's last name.
  final String name;

  /// Creates a new user.
  const User({this.name = "", super.id, super.userId});

  /// Creates an invalid user.
  const User.invalid() : name = "", super.invalid();

  /// Creates a user from a [Model].
  User.fromModel(super.model) :
    name = model.data[_nameKey].toString(),
    super.fromModel();

  @override
  User copyWith({String? id, String? userId, String? name}) => User(
    name: name ?? this.name,
    id: id ?? this.id,
    userId: userId ?? this.userId,
  );

  @override
  Model toModel() => Model(
    id: id,
    userId: userId,
    data: {
      _nameKey: name,
    },
  );
}