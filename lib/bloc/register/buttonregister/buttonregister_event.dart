part of 'buttonregister_bloc.dart';

@immutable
sealed class ButtonregisterEvent {}

class ButtonregisterHit extends ButtonregisterEvent {
  final String name;
  final String email;
  final String password;

  ButtonregisterHit({
    required this.name,
    required this.email,
    required this.password,
  });
}
