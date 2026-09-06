import '../data/models/user_order_model.dart';
import '../data/models/user_profile_model.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserProfileModel profile;
  final List<UserOrderModel> orders;

  ProfileLoaded({required this.profile, required this.orders});
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}
