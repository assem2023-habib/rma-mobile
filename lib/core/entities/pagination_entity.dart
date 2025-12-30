import 'package:equatable/equatable.dart';

class Pagination<T> extends Equatable {
  final List<T> data;
  final int currentPage;
  final int lastPage;
  final int total;
  final int perPage;

  const Pagination({
    required this.data,
    required this.currentPage,
    required this.lastPage,
    required this.total,
    required this.perPage,
  });

  @override
  List<Object?> get props => [data, currentPage, lastPage, total, perPage];
}
