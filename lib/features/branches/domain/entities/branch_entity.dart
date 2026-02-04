import 'package:equatable/equatable.dart';

class BranchEntity extends Equatable {
  final int id;
  final String branchName;
  final int cityId;
  final String? address;
  final String? phone;
  final String? cityName;
  final String? countryName;

  const BranchEntity({
    required this.id,
    required this.branchName,
    required this.cityId,
    this.address,
    this.phone,
    this.cityName,
    this.countryName,
  });

  @override
  List<Object?> get props => [
        id,
        branchName,
        cityId,
        address,
        phone,
        cityName,
        countryName,
      ];
}
