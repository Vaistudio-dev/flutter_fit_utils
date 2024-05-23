A flutter package to easily manage data in and out of repositories.
This package is the core of it's environement. To know about other packages related to flutter_fit_utils, see the diagram below.

![flutter_fit_utils relations](https://github.com/s0punk/flutter_fit_utils/assets/59456672/2747cb84-1c06-4c5a-9b45-8db18977ac77)

## Features

Use this package to:
- Get a uniform way of reading and writing data with Models.
- Create a repository and a service for your data with a single line of code.
- Get access to extensions for multiple flutter base classes.

Here are the supported repositories:
- Firebase Firestore
- Firebase Remote Config (Read Only)
- shared_preferences
- Firebase Storage (soon)

## Getting started

- Go inside your pubspec.yaml file
- Add this line under the dependencies:
```
    flutter_fit_utils: ^1.0.0
```
- Get dependencies
```
flutter pub get
```

## Usage

### Creating a model
Make a class Modelable so it can be managed by a service and sent to a repository. For example:
```dart
import 'package:flutter_fit_utils/flutter_fit_utils.dart';

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
```

### Managing your model with a service
You can create a service for your model with a single line of code:
```dart
import 'package:flutter_fit_utils/flutter_fit_utils.dart';

final Service<User> service = FirestoreService("my_user_collection", User.fromModel);
```

This example automatically uses a FirestoreCollection repository. In the case of FirestoreCollection, the only thing you have to do
is go to your Firebase project, and create a new collection "my_user_collection" in your database.

If you want more control over your service, you can also create a custom one:
```dart
import 'package:flutter_fit_utils/flutter_fit_utils.dart';

final class CustomUserService extends Service<User> {
  CustomUserService(super.repositoryId, super.fromModelFactory) {
    repository = FirestoreCollection(collectionId: repositoryId);
  }

  @override
  Future<List<UserData>> getAll({String? userId, Where? where, String? orderBy, bool descending = true}) async {
    // Implement your custom logic...
  }
}
```

Note that you can override any function of the base Service class.

## Additional information

Feel free to 