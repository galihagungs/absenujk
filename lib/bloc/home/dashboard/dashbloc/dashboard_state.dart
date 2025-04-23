part of 'dashboard_bloc.dart';

@immutable
sealed class DashboardState {}

final class DashboardInitial extends DashboardState {}

final class DashboardLoading extends DashboardState {}

final class DashboardLoaded extends DashboardState {
  final UserModel user;
  final String currentAddress;
  final String currentLatLong;
  final double currentLat;
  final double currentLong;

  DashboardLoaded({
    required this.user,
    required this.currentAddress,
    required this.currentLatLong,
    required this.currentLat,
    required this.currentLong,
  });
}
