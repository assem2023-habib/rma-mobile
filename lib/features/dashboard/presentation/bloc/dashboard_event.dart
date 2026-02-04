import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

class GetDashboardStatsEvent extends DashboardEvent {
  final String? userType;

  const GetDashboardStatsEvent({this.userType});

  @override
  List<Object> get props => [userType ?? ''];
}
