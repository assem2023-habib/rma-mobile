import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int id;
  final String userName;

  const UserEntity({
    required this.id,
    required this.userName,
  });

  @override
  List<Object?> get props => [id, userName];
}
