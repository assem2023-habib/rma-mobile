import '../../domain/entities/branch_entity.dart';

class BranchModel extends BranchEntity {
  const BranchModel({
    required super.id,
    required super.branchName,
    required super.cityId,
    super.address,
    super.phone,
    super.cityName,
    super.countryName,
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) {
    String? cityName;
    String? countryName;

    if (json['city'] != null) {
      cityName = json['city']['name'];
      if (json['city']['country'] != null) {
        countryName = json['city']['country']['name'];
      }
    }

    return BranchModel(
      id: json['id'],
      branchName: json['branch_name'] ?? json['name'] ?? '',
      cityId: json['city_id'] ?? 0,
      address: json['address'],
      phone: json['phone'],
      cityName: cityName,
      countryName: countryName,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'branch_name': branchName,
      'city_id': cityId,
      'address': address,
      'phone': phone,
    };
  }
}
