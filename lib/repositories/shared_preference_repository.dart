import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../flutter_fit_utils.dart';

/// Implementation of [Repository]. Manages data inside a [SharedPreference] collection.
class SharedPreferenceRepository implements Repository {
  late SharedPreferences _prefs;
  bool _initialized = false;

  /// Tag of the collection to manage.
  final String tag;

  final List<Model> _models = [];

  /// Creates a new [SharedPreferenceRepository].
  SharedPreferenceRepository({required this.tag});

  @override
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    _readRaw();

    _initialized = true;
  }

  void _readRaw() {
    final String? encodedData = _prefs.getString(tag);

    if (encodedData == null) {
      return;
    }

    final List<Map<String, dynamic>> models =
        List<Map<String, dynamic>>.from(jsonDecode(encodedData));
    for (final model in models) {
      _models.add(Model(
          id: model[Model.idKey],
          userId: model[Model.userIdKey] ?? "",
          data: model[Model.dataKey] as Map<String, dynamic>));
    }
  }

  void _writeRaw() {
    _prefs.remove(tag);

    _prefs.setString(
        tag,
        jsonEncode([
          for (final model in _models) model.toJson(),
        ]));
  }

  void _checkInitializationStatus() {
    if (!_initialized) {
      initialize();
    }
  }

  @override
  Future<Model> get(String id) async {
    _checkInitializationStatus();
    return _models.firstWhere((element) => element.id == id);
  }

  @override
  Future<List<Model>> getAll(
      {String? userId,
      Where? where,
      String? orderBy,
      bool descending = true}) async {
    _checkInitializationStatus();

    List<Model> correspondingUserModels = List.from(_models
        .where((element) => userId == null || element.userId! == userId)
        .toList());

    return correspondingUserModels;
  }

  @override
  Future<void> clear({String? userId}) async {
    _checkInitializationStatus();

    _models
        .removeWhere((element) => userId == null || element.userId! == userId);
    _writeRaw();
  }

  @override
  Future<int> count({String? userId, Where? where}) async {
    _checkInitializationStatus();
    return _models.length;
  }

  @override
  Future<Model> create({String? wantedId}) async {
    _checkInitializationStatus();

    final String uniqueId = wantedId ?? _models.hashCode.toString();

    final Model newModel = Model(id: uniqueId);
    _models.add(newModel);
    _writeRaw();

    return newModel;
  }

  @override
  Future<void> delete(Model item) async {
    _checkInitializationStatus();

    _models.removeWhere((element) => element.id == item.id);
    _writeRaw();
  }

  @override
  Future<void> deleteWhere(Where where) async {
    throw UnimplementedError();
  }

  @override
  Future<void> update(Model item) async {
    _checkInitializationStatus();

    _models[_models.indexOf(
        _models.firstWhere((element) => element.id == item.id))] = item;
    _writeRaw();
  }
}
