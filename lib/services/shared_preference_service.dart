import '../flutter_fit_utils.dart';

/// Service for managing a [SharedPreferenceRepository].
final class SharedPreferenceService<T extends Modelable> extends Service<T> {
  SharedPreferenceService(super.repositoryId, super.fromModelFactory) {
    super.repository = SharedPreferenceRepository(tag: repositoryId);
  }
}
