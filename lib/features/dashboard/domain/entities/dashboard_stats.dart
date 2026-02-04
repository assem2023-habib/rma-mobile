import 'package:equatable/equatable.dart';

class DashboardStats extends Equatable {
  final int usersCount;
  final int totalParcels;
  final Map<String, int> parcelsByStatus;
  final int ratesCount;
  final int branchesCount;
  final int shipmentsCount;
  final int trucksCount;
  final int employeesCount;
  final int countriesCount;
  final int citiesCount;

  const DashboardStats({
    required this.usersCount,
    required this.totalParcels,
    required this.parcelsByStatus,
    required this.ratesCount,
    required this.branchesCount,
    required this.shipmentsCount,
    required this.trucksCount,
    required this.employeesCount,
    required this.countriesCount,
    required this.citiesCount,
  });

  @override
  List<Object?> get props => [
    usersCount,
    totalParcels,
    parcelsByStatus,
    ratesCount,
    branchesCount,
    shipmentsCount,
    trucksCount,
    employeesCount,
    countriesCount,
    citiesCount,
  ];
}
