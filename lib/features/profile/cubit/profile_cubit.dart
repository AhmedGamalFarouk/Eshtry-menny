import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repositories/profile_repository.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _profileRepository;

  ProfileCubit({ProfileRepository? repository})
      : _profileRepository = repository ?? ProfileRepositoryImpl(),
        super(ProfileInitial()) {
    loadProfile();
  }

  Future<void> loadProfile() async {
    emit(ProfileLoading());
    try {
      final profile = await _profileRepository.getProfile();
      final orders = await _profileRepository.getOrders(profile.id);
      emit(ProfileLoaded(profile: profile, orders: orders));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> refresh() async {
    await loadProfile();
  }
}
