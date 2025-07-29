import 'package:equatable/equatable.dart';
import '../model/user_profile_model.dart';

abstract class SettingState extends Equatable {
  const SettingState();

  @override
  List<Object?> get props => [];
}

class SettingInitial extends SettingState {}

class SettingLoading extends SettingState {}

class SettingLoaded extends SettingState {
  final UserProfileModel userProfile;

  const SettingLoaded({required this.userProfile});

  SettingLoaded copyWith({UserProfileModel? userProfile}) {
    return SettingLoaded(userProfile: userProfile ?? this.userProfile);
  }

  @override
  List<Object?> get props => [userProfile];
}

class SettingError extends SettingState {
  final String message;

  const SettingError({required this.message});

  @override
  List<Object?> get props => [message];
}

// Specific states for different operations
class SettingAvatarUploading extends SettingState {}

class SettingAvatarUploaded extends SettingState {
  final String avatarUrl;

  const SettingAvatarUploaded({required this.avatarUrl});

  @override
  List<Object?> get props => [avatarUrl];
}

class SettingProfileUpdating extends SettingState {}

class SettingProfileUpdated extends SettingState {
  final UserProfileModel updatedProfile;

  const SettingProfileUpdated({required this.updatedProfile});

  @override
  List<Object?> get props => [updatedProfile];
}

class SettingPersonalInfoUpdating extends SettingState {}

class SettingPersonalInfoUpdated extends SettingState {
  final String message;

  const SettingPersonalInfoUpdated({required this.message});

  @override
  List<Object?> get props => [message];
}

class SettingAccountDeleting extends SettingState {}

class SettingAccountDeleted extends SettingState {
  final String message;

  const SettingAccountDeleted({required this.message});

  @override
  List<Object?> get props => [message];
}
