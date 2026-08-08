part of 'profile_bloc.dart';

abstract class ProfileEvent {}

class GetProfileEvent extends ProfileEvent {}

class UpdateProfileEvent extends ProfileEvent {
  final String name;
  final File? profileImage;
  final String? email;
  final String? phoneNumber;
  final String? shopName;
  final String? shopLicenseNumber;
  final String? contactEmail;
  final String? contactPhone;

  UpdateProfileEvent({
    required this.name,
    this.profileImage,
    this.email,
    this.phoneNumber,
    this.shopName,
    this.shopLicenseNumber,
    this.contactEmail,
    this.contactPhone,
  });
}

class GetStripeConnectOnboardingLinkEvent extends ProfileEvent {}

