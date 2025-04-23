part of 'buttonlogin_bloc.dart';

@immutable
sealed class ButtonloginEvent {}

class ButtonloginHit extends ButtonloginEvent {
  final String email;
  final String password;

  ButtonloginHit({required this.email, required this.password});
}
