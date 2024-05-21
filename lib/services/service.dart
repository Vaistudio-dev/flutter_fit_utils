
import '../flutter_fit_utils.dart';

/// Manager service for data of type [T].
abstract base class Service<T extends Modelable> {
  /// Data repository.
  late final Repository repository;

  /// Id of the repository.
  final String repositoryId;

  /// Factory to create an instance of [T] from a [Model].
  T Function(Model) fromModelFactory;

  /// Creates a new [Service].
  Service(this.repositoryId, this.fromModelFactory);

  /// Creates a new entry in the repository.
  /// Returns the id of the new entry.
  Future<String> create(T item, {String? wantedId}) async {
    final Model raw = await repository.create(wantedId: wantedId);
    await repository.update(item.copyWith(id: raw.id).toModel());

    return raw.id;
  }

  /// Performs [repository.getAll()].
  Future<List<T>> getAll({String? userId, Where? where, String? orderBy, bool descending = true}) async {
    final List<Model> raw = await repository.getAll(userId: userId, where: where, orderBy: orderBy, descending: descending);
    return [
      for (final model in raw)
        fromModelFactory(model),
    ];
  }

  /// Performs [repository.get()].
  Future<T> get(String id) async {
    final Model raw = await repository.get(id);
    return fromModelFactory(raw);
  }

  /// Performs [repository.count()].
  Future<int> count({String? userId, Where? where}) => repository.count(userId: userId, where: where);

  /// Performs [repository.update()].
  Future<void> update(T item) => repository.update(item.toModel());

  /// Performs [repository.delete()].
  Future<void> delete(T item) => repository.delete(item.toModel());

  /// Performs [repository.deleteWhere()].
  Future<void> deleteWhere(Where where) => repository.deleteWhere(where);

  /// Performs [repository.clear()].
  Future<void> clear({String? userId}) => repository.clear(userId: userId);
}