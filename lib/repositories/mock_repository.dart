import '../flutter_fit_utils.dart';

/// Mock repository for testing.
class MockRepository extends Repository {
  @override
  Future<void> clear({String? userId}) async {}

  @override
  Future<int> count({String? userId, Where? where}) async {
    return 0;
  }

  @override
  Future<Model> create({String? wantedId}) async {
    return const Model(id: "id");
  }

  @override
  Future<void> delete(Model item) async {}

  @override
  Future<void> deleteWhere(Where where) async {}

  @override
  Future<Model> get(String id) async {
    return const Model(id: "id");
  }

  @override
  Future<List<Model>> getAll({String? userId, Where? where, String? orderBy, bool descending = true}) async {
    return [];
  }

  @override
  Future<void> initialize() async {}

  @override
  Future<void> update(Model item) async {}
}
