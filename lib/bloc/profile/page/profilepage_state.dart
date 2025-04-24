part of 'profilepage_bloc.dart';

@immutable
sealed class ProfilepageState {}

final class ProfilepageInitial extends ProfilepageState {}

final class ProfilepageLoading extends ProfilepageState {}

final class ProfilepageLoaded extends ProfilepageState {
  final UserModel user;

  ProfilepageLoaded({required this.user});
}

final class ProfilepageEdit extends ProfilepageState {
  final UserModel user;

  ProfilepageEdit({required this.user});
}
