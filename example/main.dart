import 'package:flutter_fit_utils/flutter_fit_utils.dart';

Future<void> main() async {
  // Create a service.
  final Service service = SharedPreferenceService("users", User.fromModel);

  const User newUser = User(name: "User", id: "1", userId: "u_1");

  // Write to your repository.
  await service.create(newUser);

  // Read from your repository.
  await service.getAll();
}

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