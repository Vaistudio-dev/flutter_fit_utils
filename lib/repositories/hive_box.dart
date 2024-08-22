import 'package:flutter_fit_utils/flutter_fit_utils.dart';
import 'package:hive/hive.dart';

/// Implementation of [Repository]. Manages data inside a Hive Box.
class HiveBox implements Repository {
  late Box _box;

  /// Id of the collection to manage.
  final String boxName;

  /// Creates a new [HiveBox].
  HiveBox({required this.boxName});

  @override
  Future<void> initialize() async {
    try {
      _box = await Hive.openBox(boxName);
    }
    on Exception {
      // Hive.init(path) has not been called.
    }
  }

  @override
  Future<Model> get(String id) async {
    final Map<String, dynamic> data = (_box.get(id) as Map<String, dynamic>);
    return Model(
        id: id, userId: data[Model.userIdKey], data: data[Model.dataKey]);
  }

  @override
  Future<List<Model>> getAll({String? userId, Where? where, String? orderBy, bool descending = true}) async {
    List<Model> data = _getAll();

    if (userId != null) {
      data = data.where((element) => element.userId == userId).toList();
    }

    if (where != null) {
      data = _filter(data, where);
    }

    if (orderBy != null) {
      final String field = orderBy.toString().split(".").last;
      data.sort((a, b) => a.data[field].toString().compareTo(b.data[field].toString()));
    }

    if (!descending) {
      data = data.reversed.toList();
    }

    return data;
  }

  @override
  Future<Model> create({String? wantedId}) async {
    final String uniqueId = wantedId ?? _box.values.hashCode.toString();
    final Model newModel = Model(id: uniqueId);

    _box.put(uniqueId, newModel.toJson());

    return newModel;
  }

  @override
  Future<void> update(Model item) async {
    _box.put(item.id, item.toJson());
  }

  @override
  Future<int> count({String? userId, Where? where}) async {
    return _box.values.length;
  }

  @override
  Future<void> delete(Model item) async {
    _box.delete(item.id);
  }

  @override
  Future<void> deleteWhere(Where where) async {
    List<Model> data = _filter(_getAll(), where);
    for (final d in data) {
      _box.delete(d.id);
    }
  }

  @override
  Future<void> clear({String? userId}) async {
    _box.clear();
  }

  List<Model> _getAll() => [
    for (final value in _box.values)
      Model(id: value[Model.idKey], userId: value[Model.userIdKey], data: value[Model.dataKey] as Map<String, dynamic>),
  ];

  List<Model> _filter(List<Model> data, Where where) {
    return data.where((element) {
      final String field = where.field.toString().split(".").last;

      if (!element.data.containsKey(field)) {
        return false;
      }

      if (where.isEqualTo != null && element.data[field] != where.isEqualTo) {
        return false;
      }

      if (where.isNotEqualTo != null && element.data[field] == where.isEqualTo) {
        return false;
      }

      if (where.arrayContainsAny != null && !where.arrayContainsAny!.contains(element.data[field])) {
        return false;
      }

      if (where.whereIn != null && !where.arrayContainsAny!.contains(element.data[field])) {
        return false;
      }

      if (where.whereNotIn != null && where.arrayContainsAny!.contains(element.data[field])) {
        return false;
      }

      if (where.arrayContains != null && !where.arrayContainsAny!.contains(element.data[field])) {
        return false;
      }

      if (where.isGreaterThan != null && element.data[field] <= where.isGreaterThan) {
        return false;
      }

      if (where.isGreaterThanOrEqualTo != null && element.data[field] < where.isGreaterThan) {
        return false;
      }

      if (where.isLessThan != null && element.data[field] >= where.isGreaterThan) {
        return false;
      }

      if (where.isLessThanOrEqualTo != null && element.data[field] > where.isGreaterThan) {
        return false;
      }

      return true;
    }).toList();
  }
}