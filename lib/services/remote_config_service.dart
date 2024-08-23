import 'package:flutter_fit_utils/flutter_fit_utils.dart';

/// Service for managing a [RemoteConfigRepository].
final class RemoteConfigService<T extends Modelable> extends Service<T> {
  RemoteConfigService(super.repositoryId, super.fromModelFactory) {
    super.repository = RemoteConfigRepository(parameterId: repositoryId);
  }
}
