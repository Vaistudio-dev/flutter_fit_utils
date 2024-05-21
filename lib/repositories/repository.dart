import '../flutter_fit_utils.dart';
import 'index.dart';

/// Base data repository.
/// Can perform the basic CRUD operations.
abstract class Repository {
  /// Initialize the repository.
  Future<void> initialize();

  /// Creates a new entry in the repository.
  Future<Model> create({String? wantedId});
  /// Updates an entry in the repository.
  Future<void> update(Model item);

  /// Returns all the entries in the repository.
  /// If [userId] is not null, the results will have the same user id.
  /// If [where] is not null, the results will be compliant to the where clause.
  Future<List<Model>> getAll({String? userId, Where? where, String? orderBy, bool descending = true});
  
  /// Returns the entry with the specified [id].
  Future<Model> get(String id);

  /// Returns the number of entries in the repository.
  Future<int> count({String? userId, Where? where});

  /// Deletes an entry in the repository.
  Future<void> delete(Model item);

  /// Deletes all the entries that are compliant to the [where] clause.
  Future<void> deleteWhere(Where where);

  /// Deletes all the entries of the repository.
  /// If [userId] is not null, the only enties that will be deleted will have the same user id.
  Future<void> clear({String? userId});
}