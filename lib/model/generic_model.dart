import '../flutter_fit_utils.dart';

class GenericModel extends Modelable {
  static const String _dataKey = "data";
  static const String _createdAtKey = "created_at";

  final Object data;
  final DateTime createdAt;

  GenericModel(this.data, {super.id, super.userId}) : createdAt = _getDate();

  const GenericModel.withDate(this.data, this.createdAt, {super.id, super.userId, super.invalid});

  GenericModel.fromModel(super.model) :
    data = model.data[_dataKey],
    createdAt = DateTime.parse(model.data[_createdAtKey].toString()),
    super.fromModel();

  static DateTime _getDate() {
    final DateTime now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  @override
  GenericModel copyWith({String? id, String? userId, bool? invalid, Object? data, DateTime? createdAt}) => GenericModel.withDate(
    data ?? this.data,
    createdAt ?? this.createdAt,
    id: id ?? this.id,
    userId: userId ?? this.userId,
    invalid: invalid ?? this.invalid,
  );

  @override
  Model toModel() => Model(
    id: id,
    userId: userId,
    data: {
      _dataKey: data,
      _createdAtKey: createdAt.toString(),
    },
  );
}