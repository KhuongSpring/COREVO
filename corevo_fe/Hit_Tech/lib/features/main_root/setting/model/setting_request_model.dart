import 'package:equatable/equatable.dart';

class SettingRequest extends Equatable {
  final String? field;
  final dynamic value;

  const SettingRequest({
    this.field,
    this.value,
  });

  Map<String, dynamic> toJson() {
    return {
      if (field != null) 'field': field,
      if (value != null) 'value': value,
    };
  }

  @override
  List<Object?> get props => [field, value];
}

class UpdateProfileRequest extends Equatable {
  final String? username;
  final PersonalInformationRequest? personalInformation;
  final HealthInformationRequest? healthInformation;

  const UpdateProfileRequest({
    this.username,
    this.personalInformation,
    this.healthInformation,
  });

  Map<String, dynamic> toJson() {
    return {
      if (username != null) 'username': username,
      if (personalInformation != null) 'personalInformation': personalInformation?.toJson(),
      if (healthInformation != null) 'healthInformation': healthInformation?.toJson(),
    };
  }

  @override
  List<Object?> get props => [username, personalInformation, healthInformation];
}

class PersonalInformationRequest extends Equatable {
  final String? userName;
  final String? fullName;
  final String? email;
  final String? phoneNumber;
  final String? dateOfBirth;
  final String? nationality;

  const PersonalInformationRequest({
    this.userName,
    this.fullName,
    this.email,
    this.phoneNumber,
    this.dateOfBirth,
    this.nationality,
  });

  Map<String, dynamic> toJson() {
    return {
      if (userName != null) 'userName': userName,
      if (fullName != null) 'fullName': fullName,
      if (email != null) 'email': email,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      if (dateOfBirth != null) 'dateOfBirth': dateOfBirth,
      if (nationality != null) 'nationality': nationality,
    };
  }

  @override
  List<Object?> get props => [
        userName,
        fullName,
        email,
        phoneNumber,
        dateOfBirth,
        nationality,
      ];
}

class HealthInformationRequest extends Equatable {
  final String? gender;
  final double? height;
  final double? weight;
  final int? age;
  final String? activityLevel;

  const HealthInformationRequest({
    this.gender,
    this.height,
    this.weight,
    this.age,
    this.activityLevel,
  });

  Map<String, dynamic> toJson() {
    return {
      if (gender != null) 'gender': gender,
      if (height != null) 'height': height,
      if (weight != null) 'weight': weight,
      if (age != null) 'age': age,
      if (activityLevel != null) 'activityLevel': activityLevel,
    };
  }

  @override
  List<Object?> get props => [gender, height, weight, age, activityLevel];
}

class ApiResponse<T> extends Equatable {
  final String status;
  final String? message;
  final T? data;

  const ApiResponse({
    required this.status,
    this.message,
    this.data,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) {
    return ApiResponse<T>(
      status: json['status'] ?? '',
      message: json['message'],
      data: json['data'] != null && fromJsonT != null 
          ? fromJsonT(json['data']) 
          : json['data'],
    );
  }

  bool get isSuccess => status.toLowerCase() == 'success';

  @override
  List<Object?> get props => [status, message, data];
}
