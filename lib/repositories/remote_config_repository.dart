import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';

import '../flutter_fit_utils.dart';

/// Implementation of [Repository]. Manages data inside a Firebase Remote Config parameter.
class RemoteConfigRepository implements Repository {
  /// App configuration.
  final FirebaseRemoteConfig config = FirebaseRemoteConfig.instance;

  /// Tag of the parameter to manage.
  final String parameterId;

  final List<Model> _models = [];

  /// Creates a new [RemoteConfigRepository].
  RemoteConfigRepository({required this.parameterId}) {
    readRaw();
  }

  @override
  Future<void> initialize() async {}

  /// Reads the value of the parameter.
  String readRaw() {
    final String encodedData = config.getString(parameterId);

    try {
      final List<Map<String, dynamic>> models = List<Map<String, dynamic>>.from(jsonDecode(encodedData));
      for (final model in models) {
        _models.add(Model(id: model[Model.idKey], userId: model[Model.userIdKey] ?? "", data: model[Model.dataKey] as Map<String, dynamic>));
      }
    }
    on Exception {
      // Invalid format.
    }

    return encodedData;
  }

  @override
  Future<Model> get(String id) async {
    return _models.firstWhere((element) => element.id == id);
  }

  @override
  Future<List<Model>> getAll({String? userId, Where? where, String? orderBy, bool descending = true}) async {
    List<Model> correspondingUserModels = List.from(_models.where((element) => userId == null || element.userId! == userId).toList());

    return correspondingUserModels;
  }

  @override
  Future<void> clear({String? userId}) async {
    throw UnimplementedError();
  }

  @override
  Future<int> count({String? userId, Where? where}) async {
    return _models.length;
  }

  @override
  Future<Model> create({String? wantedId}) async {
    return Model(id: wantedId ?? "");
  }

  @override
  Future<void> delete(Model item) async {
    throw UnimplementedError();
  }

  @override
  Future<void> update(Model item) async {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteWhere(Where where) async {
    throw UnimplementedError();
  }
}