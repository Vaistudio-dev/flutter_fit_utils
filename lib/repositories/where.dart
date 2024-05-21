class Where {
  final Object field;
  final Object? isEqualTo;
  final Object? isNotEqualTo;
  final Object? isLessThan;
  final Object? isGreaterThan;
  final Object? isLessThanOrEqualTo;
  final Object? isGreaterThanOrEqualTo;
  final Object? arrayContains;
  final Iterable<Object?>? arrayContainsAny;
  final Iterable<Object?>? whereIn;
  final Iterable<Object?>? whereNotIn;
  final bool? isNull;

  const Where(
    this.field, {
      this.isEqualTo,
      this.isNotEqualTo,
      this.isLessThan,
      this.isGreaterThan,
      this.isGreaterThanOrEqualTo,
      this.isLessThanOrEqualTo,
      this.arrayContains,
      this.arrayContainsAny,
      this.whereIn,
      this.whereNotIn,
      this.isNull,
    }
  );
}