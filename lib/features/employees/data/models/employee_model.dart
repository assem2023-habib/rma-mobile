import '../../domain/entities/employee_entity.dart';

class EmployeeModel extends EmployeeEntity {
  const EmployeeModel({
    required super.id,
    required super.userId,
    required super.branchId,
    required super.status,
    required super.userName,
    required super.userEmail,
    required super.branchName,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>;
    final branch = json['branch'] as Map<String, dynamic>;
    
    return EmployeeModel(
      id: json['id'],
      userId: json['user_id'],
      branchId: json['branch_id'],
      status: json['status'],
      userName: user['name'],
      userEmail: user['email'],
      branchName: branch['branch_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'branch_id': branchId,
      'status': status,
    };
  }
}
