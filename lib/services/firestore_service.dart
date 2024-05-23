import '../flutter_fit_utils.dart';

/// Service for managing a [FirestoreCollection] repository.
final class FirestoreService<T extends Modelable> extends Service<T> {
  FirestoreService(super.repositoryId, super.fromModelFactory,
      {Function(Model, bool)? onDocUpdate}) {
    super.repository = FirestoreCollection(
        collectionId: repositoryId, onDocUpdate: onDocUpdate);
  }
}
