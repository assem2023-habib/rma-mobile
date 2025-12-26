import 'package:equatable/equatable.dart';

class AuthorizationEntity extends Equatable {
  final String id;
  final String title;
  final String status;
  final DateTime date;
  final String description;

  const AuthorizationEntity({
    required this.id,
    required this.title,
    required this.status,
    required this.date,
    required this.description,
  });

  @override
  List<Object?> get props => [id, title, status, date, description];
}
