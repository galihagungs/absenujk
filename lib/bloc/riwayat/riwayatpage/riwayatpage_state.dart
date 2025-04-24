part of 'riwayatpage_bloc.dart';

@immutable
sealed class RiwayatpageState {}

final class RiwayatpageInitial extends RiwayatpageState {}

final class RiwayatpageLoading extends RiwayatpageState {}

final class RiwayatpageLoaded extends RiwayatpageState {
  final List<AbsenModel> listAbsen;

  RiwayatpageLoaded({required this.listAbsen});
}
