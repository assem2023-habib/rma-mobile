import 'package:equatable/equatable.dart';

class EmployeeEntity extends Equatable {
  final int id;
  final int userId;
  final int branchId;
  final String status;
  final String userName;
  final String userEmail;
  final String branchName;

  const EmployeeEntity({
    required this.id,
    required this.userId,
    required this.branchId,
    required this.status,
    required this.userName,
    required this.userEmail,
    required this.branchName,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        branchId,
        status,
        userName,
        userEmail,
        branchName,
      ];
}
