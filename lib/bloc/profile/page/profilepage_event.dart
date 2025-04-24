part of 'profilepage_bloc.dart';

@immutable
sealed class ProfilepageEvent {}

class ProfilepageInitialEvent extends ProfilepageEvent {}

class ProfilepageEditEvent extends ProfilepageEvent {
  final UserModel user;

  ProfilepageEditEvent({required this.user});
}

class ProfilepageSaveEvent extends ProfilepageEvent {
  final String name;
  final String email;

  ProfilepageSaveEvent({required this.name, required this.email});
}
