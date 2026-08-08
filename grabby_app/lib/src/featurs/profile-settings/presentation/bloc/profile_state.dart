part of 'profile_bloc.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final ProfileData profileData;
  ProfileLoaded(this.profileData);
}

class ProfileUpdateSuccess extends ProfileState {
  final String message;
  ProfileUpdateSuccess([this.message = 'Profile updated successfully']);
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}
