import 'package:flutter_fit_utils/flutter_fit_utils.dart';

/// Extension on the [Map<String, dynamic>] type.
extension FitMapExtension on Map<String, dynamic> {
  /// Creates a [Model] from a [Map<String, dynamic>].
  Model toModel({String id = "", String userId = ""}) => Model(
        id: id,
        userId: userId,
        data: this,
      );
}
