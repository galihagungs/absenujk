part of 'buttonregister_bloc.dart';

@immutable
sealed class ButtonregisterState {}

final class ButtonregisterInitial extends ButtonregisterState {}

final class ButtonregisterLoading extends ButtonregisterState {}

final class ButtonregisterSuccess extends ButtonregisterState {
  final String message;
  ButtonregisterSuccess(this.message);
}

final class ButtonregisterError extends ButtonregisterState {
  final String message;
  ButtonregisterError(this.message);
}
