import '../entities/pagination_entity.dart';

class PaginationModel<T> extends Pagination<T> {
  const PaginationModel({
    required super.data,
    required super.currentPage,
    required super.lastPage,
    required super.total,
    required super.perPage,
  });

  factory PaginationModel.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic> json) fromJsonT,
  ) {
    return PaginationModel(
      data: (json['data'] as List).map((item) => fromJsonT(item)).toList(),
      currentPage: json['current_page'],
      lastPage: json['last_page'],
      total: json['total'],
      perPage: json['per_page'],
    );
  }
}
