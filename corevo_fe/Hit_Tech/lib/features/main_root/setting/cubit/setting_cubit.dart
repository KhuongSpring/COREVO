import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/user_profile_model.dart';
import '../model/setting_request_model.dart';
import '../service/setting_service.dart';
import 'setting_state.dart';

class SettingCubit extends Cubit<SettingState> {
  final SettingService _settingService;

  SettingCubit({required SettingService settingService})
    : _settingService = settingService,
      super(SettingInitial());

  /// Load user profile
  Future<void> loadUserProfile() async {
    try {
      emit(SettingLoading());

      final userProfile = await _settingService.getUserProfile();

      emit(SettingLoaded(userProfile: userProfile));
    } catch (e) {
      emit(SettingError(message: e.toString()));
    }
  }

  /// Update user profile
  Future<void> updateProfile({
    String? username,
    PersonalInformationRequest? personalInfo,
    HealthInformationRequest? healthInfo,
  }) async {
    try {
      if (state is SettingLoaded) {
        emit(SettingProfileUpdating());

        final request = UpdateProfileRequest(
          username: username,
          personalInformation: personalInfo,
          healthInformation: healthInfo,
        );

        final response = await _settingService.updateProfile(request: request);

        if (response.isSuccess && response.data != null) {
          emit(SettingProfileUpdated(updatedProfile: response.data!));
          // Also update the loaded state with new profile
          emit(SettingLoaded(userProfile: response.data!));
        } else {
          emit(
            SettingError(
              message: response.message ?? 'Failed to update profile',
            ),
          );
        }
      }
    } catch (e) {
      emit(SettingError(message: e.toString()));
    }
  }

  /// Upload avatar
  Future<void> uploadAvatar({required File avatarFile}) async {
    try {
      emit(SettingAvatarUploading());

      final response = await _settingService.uploadAvatar(
        avatarFile: avatarFile,
      );

      if (response.isSuccess && response.data != null) {
        emit(SettingAvatarUploaded(avatarUrl: response.data!));

        // Reload profile to get updated avatar
        await loadUserProfile();
      } else {
        emit(
          SettingError(message: response.message ?? 'Failed to upload avatar'),
        );
      }
    } catch (e) {
      emit(SettingError(message: e.toString()));
    }
  }

  /// Update personal information
  Future<void> updatePersonalInformation({
    required PersonalInformationRequest request,
  }) async {
    try {
      emit(SettingPersonalInfoUpdating());

      final response = await _settingService.updatePersonalInformation(
        request: request,
      );

      if (response.isSuccess) {
        emit(
          SettingPersonalInfoUpdated(
            message:
                response.message ?? 'Personal information updated successfully',
          ),
        );

        // Reload profile to get updated information
        await loadUserProfile();
      } else {
        emit(
          SettingError(
            message:
                response.message ?? 'Failed to update personal information',
          ),
        );
      }
    } catch (e) {
      emit(SettingError(message: e.toString()));
    }
  }

  /// Update health information specifically
  Future<void> updateHealthInformation({
    String? gender,
    double? height,
    double? weight,
    int? age,
    String? activityLevel,
  }) async {
    final healthInfo = HealthInformationRequest(
      gender: gender,
      height: height,
      weight: weight,
      age: age,
      activityLevel: activityLevel,
    );

    await updateProfile(healthInfo: healthInfo);
  }

  /// Update personal info specifically
  Future<void> updatePersonalInfo({
    String? userName,
    String? fullName,
    String? email,
    String? phoneNumber,
    String? dateOfBirth,
    String? nationality,
  }) async {
    final personalInfo = PersonalInformationRequest(
      userName: userName,
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      dateOfBirth: dateOfBirth,
      nationality: nationality,
    );

    await updatePersonalInformation(request: personalInfo);
  }

  /// Upload avatar with file picker
  Future<void> uploadAvatarFromPicker({bool fromCamera = false}) async {
    try {
      // TODO: Implement file picker logic
      // For now, we'll just emit an error
      emit(SettingError(message: 'File picker not implemented yet'));
    } catch (e) {
      emit(SettingError(message: e.toString()));
    }
  }

  /// Delete user account
  Future<void> deleteUserAccount() async {
    try {
      emit(SettingAccountDeleting());

      final response = await _settingService.deleteMyAccount();

      if (response.isSuccess) {
        emit(
          SettingAccountDeleted(
            message: response.message ?? 'Account deleted successfully',
          ),
        );
      } else {
        emit(
          SettingError(message: response.message ?? 'Failed to delete account'),
        );
      }
    } catch (e) {
      emit(SettingError(message: e.toString()));
    }
  }

  /// Reset state to initial
  void resetState() {
    emit(SettingInitial());
  }

  /// Get current user profile if available
  UserProfileModel? get currentUserProfile {
    final currentState = state;
    if (currentState is SettingLoaded) {
      return currentState.userProfile;
    }
    return null;
  }
}
