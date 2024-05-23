import '../flutter_fit_utils.dart';

/// Extension of the [List<Modelable>] type.
extension FitModelableExtension on List<Modelable> {
  /// Replace the first [Modelable] in a list that has the same id as [model].
  /// [model] is inserted at the same index than the previous element.
  ///
  /// If [addIfMissing] is true, [model] will be added at the end of the list, if the list has no [Modelable] with the same id.
  ///
  /// Returns [true] if the list contained an element with the same id as [model].
  bool replace(Modelable model, {bool addIfMissing = true}) {
    bool wasInList = true;

    final index = indexWhere((element) => element.id == model.id);

    if (index != -1) {
      wasInList = false;

      removeAt(index);
      insert(index, model);
    } else if (addIfMissing) {
      add(model);
    }

    return wasInList;
  }
}
