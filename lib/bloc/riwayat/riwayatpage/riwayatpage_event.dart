part of 'riwayatpage_bloc.dart';

@immutable
sealed class RiwayatpageEvent {}

class RiwayatpageInitialEvent extends RiwayatpageEvent {}

class RiwayatFilter extends RiwayatpageEvent {
  final DateTime filter;

  RiwayatFilter({required this.filter});
}
