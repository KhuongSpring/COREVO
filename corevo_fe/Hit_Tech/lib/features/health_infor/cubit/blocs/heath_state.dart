import 'package:equatable/equatable.dart';

// States
abstract class HealthInfoState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HealthInfoInitial extends HealthInfoState {}

class HealthInfoLoading extends HealthInfoState {}

class HealthInfoFormState extends HealthInfoState {
  final String? gender;
  final int? age;
  final int? height;
  final double? weight;
  final String? activityLevel;
  final int currentStep;

  HealthInfoFormState({
    this.gender,
    this.age,
    this.height,
    this.weight,
    this.activityLevel,
    this.currentStep = 0,
  });

  HealthInfoFormState copyWith({
    String? gender,
    int? age,
    int? height,
    double? weight,
    String? activityLevel,
    int? currentStep,
  }) {
    return HealthInfoFormState(
      gender: gender ?? this.gender,
      age: age ?? this.age,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      activityLevel: activityLevel ?? this.activityLevel,
      currentStep: currentStep ?? this.currentStep,
    );
  }

  bool get canProceedFromGender => gender != null;
  bool get canProceedFromAge => age != null;
  bool get canProceedFromHeight => height != null;
  bool get canProceedFromWeight => weight != null;
  bool get canSubmit {
    return gender != null &&
        gender!.isNotEmpty &&
        age != null &&
        age! > 0 &&
        height != null &&
        height! > 0 &&
        weight != null &&
        weight! > 0 &&
        activityLevel != null &&
        activityLevel!.isNotEmpty;
  }

  @override
  List<Object?> get props => [
    gender,
    age,
    height,
    weight,
    activityLevel,
    currentStep,
  ];
}

class HealthInfoSuccess extends HealthInfoState {}

class HealthInfoError extends HealthInfoState {
  final String message;
  HealthInfoError(this.message);
  @override
  List<Object?> get props => [message];
}
