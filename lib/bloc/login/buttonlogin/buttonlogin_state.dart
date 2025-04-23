part of 'buttonlogin_bloc.dart';

@immutable
sealed class ButtonloginState {}

final class ButtonloginInitial extends ButtonloginState {}

final class ButtonloginLoading extends ButtonloginState {}

final class ButtonloginSuccess extends ButtonloginState {
  final String message;

  ButtonloginSuccess(this.message);
}

final class ButtonloginError extends ButtonloginState {
  final String error;

  ButtonloginError(this.error);
}
