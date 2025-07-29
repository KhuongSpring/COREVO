import 'package:equatable/equatable.dart';

// Events
abstract class HealthInfoEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class UpdateGender extends HealthInfoEvent {
  final String gender;
  UpdateGender(this.gender);
  @override
  List<Object?> get props => [gender];
}

class UpdateAge extends HealthInfoEvent {
  final int age;
  UpdateAge(this.age);
  @override
  List<Object?> get props => [age];
}

class UpdateHeight extends HealthInfoEvent {
  final int height;
  UpdateHeight(this.height);
  @override
  List<Object?> get props => [height];
}

class UpdateWeight extends HealthInfoEvent {
  final double weight;
  UpdateWeight(this.weight);
  @override
  List<Object?> get props => [weight];
}

class UpdateActivityLevel extends HealthInfoEvent {
  final String activityLevel;
  UpdateActivityLevel(this.activityLevel);
  @override
  List<Object?> get props => [activityLevel];
}

class NextStep extends HealthInfoEvent {}

class PreviousStep extends HealthInfoEvent {}

class SubmitHealthInfo extends HealthInfoEvent {}
