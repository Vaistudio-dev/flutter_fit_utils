import '../flutter_fit_utils.dart';

final class HiveService<T extends Modelable> extends Service<T> {
  HiveService(super.repositoryId, super.fromModelFactory) {
    super.repository = HiveBox(boxName: repositoryId);
  }
}