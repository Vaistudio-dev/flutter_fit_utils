import 'package:cloud_firestore/cloud_firestore.dart';
import '../flutter_fit_utils.dart';

/// Implementation of [Repository]. Manages data inside a Firebase Firestore collection.
class FirestoreCollection implements Repository {
  late final FirebaseFirestore _db;

  /// Id of the collection to manage.
  final String collectionId;

  /// Callback for real time updates.
  final Function(Model, bool)? onDocUpdate;

  late final CollectionReference _collectionReference =
      _db.collection(collectionId);

  final List<DocumentReference<Object?>> _listenedDocs = [];
  final List<Query<Object?>> _listenedQueries = [];

  /// Creates a new [FirestoreCollection].
  FirestoreCollection({required this.collectionId, this.onDocUpdate}) {
    try {
      _db = FirebaseFirestore.instance;
      _db.collection(collectionId);
    } on Exception {
      // The most probable cause is that Firebase.initializeApp() has not been called at this point.
    }
  }

  @override
  Future<void> initialize() async {}

  void _handleDocRealTimeUpdate(DocumentReference<Object?> doc) {
    if (onDocUpdate == null || _listenedDocs.contains(doc)) {
      return;
    }

    _listenedDocs.add(doc);
    doc.snapshots().listen((event) {
      final Object? raw = event.data();
      final Map<String, dynamic> data =
          raw != null ? (raw as Map<String, dynamic>) : {};

      onDocUpdate!(
          Model(
              id: event.id,
              userId: data[Model.userIdKey] ?? "",
              data: data[Model.dataKey] ?? {}),
          event.exists);
    });
  }

  void _handleQueryRealTimeUpdate(Query<Object?> query) {
    if (onDocUpdate == null || _listenedQueries.contains(query)) {
      return;
    }

    _listenedQueries.add(query);
    query.snapshots().listen((event) {
      for (final change in event.docChanges) {
        final Object? raw = change.doc.data();
        final Map<String, dynamic> data =
            raw != null ? (raw as Map<String, dynamic>) : {};

        onDocUpdate!(
            Model(
                id: change.doc.id,
                userId: data[Model.userIdKey] ?? "",
                data: data[Model.dataKey] ?? {}),
            change.newIndex != -1);
      }
    });
  }

  @override
  Future<Model> get(String id) {
    _handleDocRealTimeUpdate(_collectionReference.doc(id));

    return _collectionReference.doc(id).get().then((value) {
      final Map<String, dynamic> data = (value.data() as Map<String, dynamic>);
      return Model(
          id: id, userId: data[Model.userIdKey], data: data[Model.dataKey]);
    });
  }

  @override
  Future<List<Model>> getAll(
      {String? userId, Where? where, String? orderBy, bool descending = true}) {
    var query = userId != null
        ? _collectionReference.where(Model.userIdKey, isEqualTo: userId)
        : _collectionReference;

    if (where != null) {
      query = query.where(
        where.field,
        isEqualTo: where.isEqualTo,
        isNotEqualTo: where.isNotEqualTo,
        isLessThan: where.isLessThan,
        isGreaterThan: where.isGreaterThan,
        isLessThanOrEqualTo: where.isLessThanOrEqualTo,
        isGreaterThanOrEqualTo: where.isGreaterThanOrEqualTo,
        arrayContains: where.arrayContains,
        arrayContainsAny: where.arrayContainsAny,
        whereIn: where.whereIn,
        whereNotIn: where.whereNotIn,
        isNull: where.isNull,
      );
    }

    if (orderBy != null) {
      query = query.orderBy(orderBy, descending: descending);
    }

    _handleQueryRealTimeUpdate(query);

    return query.get().then((value) {
      final List<Model> models = [];
      for (final doc in value.docs) {
        final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        models.add(Model(
            id: data[Model.idKey],
            userId: data[Model.userIdKey] ?? "",
            data: data[Model.dataKey] as Map<String, dynamic>));
      }
      return models;
    });
  }

  @override
  Future<Model> create({String? wantedId}) async {
    final DocumentReference docReference = _collectionReference.doc(wantedId);
    final Model model = Model(id: docReference.id);

    await docReference.set(model.data);
    _handleDocRealTimeUpdate(docReference);
    return model;
  }

  @override
  Future<void> update(Model item) async {
    await _collectionReference.doc(item.id).set(item.toJson());
  }

  @override
  Future<int> count({String? userId, Where? where}) async {
    var query = userId != null
        ? _collectionReference.where(Model.userIdKey, isEqualTo: userId)
        : _collectionReference;

    if (where != null) {
      query = query.where(
        where.field,
        isEqualTo: where.isEqualTo,
        isNotEqualTo: where.isNotEqualTo,
        isLessThan: where.isLessThan,
        isGreaterThan: where.isGreaterThan,
        isLessThanOrEqualTo: where.isLessThanOrEqualTo,
        isGreaterThanOrEqualTo: where.isGreaterThanOrEqualTo,
        arrayContains: where.arrayContains,
        arrayContainsAny: where.arrayContainsAny,
        whereIn: where.whereIn,
        whereNotIn: where.whereNotIn,
        isNull: where.isNull,
      );
    }

    return query.count().get().then((value) => value.count ?? 0);
  }

  @override
  Future<void> delete(Model item) async {
    await _collectionReference.doc(item.id).delete();
  }

  @override
  Future<void> deleteWhere(Where where) async {
    var query = _collectionReference.where(
      where.field,
      isEqualTo: where.isEqualTo,
      isNotEqualTo: where.isNotEqualTo,
      isLessThan: where.isLessThan,
      isGreaterThan: where.isGreaterThan,
      isLessThanOrEqualTo: where.isLessThanOrEqualTo,
      isGreaterThanOrEqualTo: where.isGreaterThanOrEqualTo,
      arrayContains: where.arrayContains,
      arrayContainsAny: where.arrayContainsAny,
      whereIn: where.whereIn,
      whereNotIn: where.whereNotIn,
      isNull: where.isNull,
    );

    return query.get().then((value) {
      for (final doc in value.docs) {
        doc.reference.delete();
      }
    });
  }

  @override
  Future<void> clear({String? userId}) async {
    final query = userId != null
        ? _collectionReference.where(Model.userIdKey, isEqualTo: userId)
        : _collectionReference;
    await query.get().then((value) async {
      for (final doc in value.docs) {
        await _collectionReference.doc(doc.id).delete();
      }
    });
  }
}
