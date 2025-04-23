part of 'dashboard_bloc.dart';

@immutable
sealed class DashboardEvent {}

class DashboardInitialData extends DashboardEvent {
  final String id;

  DashboardInitialData({required this.id});
}
