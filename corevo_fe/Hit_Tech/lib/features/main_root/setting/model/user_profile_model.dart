import 'package:equatable/equatable.dart';

class UserProfileModel extends Equatable {
  final String? username;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? nationality;
  final String? address;
  final String? district;
  final PersonalInformation? personalInformation;
  final HealthInformation? healthInformation;

  const UserProfileModel({
    this.username,
    this.firstName,
    this.lastName,
    this.phone,
    this.nationality,
    this.address,
    this.district,
    this.personalInformation,
    this.healthInformation,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      username: json['username'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phone: json['phone'],
      nationality: json['nationality'],
      address: json['address'],
      district: json['district'],
      personalInformation: json['personalInformation'] != null
          ? PersonalInformation.fromJson(json['personalInformation'])
          : null,
      healthInformation: json['healthInformation'] != null
          ? HealthInformation.fromJson(json['healthInformation'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (username != null) 'username': username,
      if (firstName != null) 'firstName': firstName,
      if (lastName != null) 'lastName': lastName,
      if (phone != null) 'phone': phone,
      if (nationality != null) 'nationality': nationality,
      if (address != null) 'address': address,
      if (district != null) 'district': district,
      if (personalInformation != null)
        'personalInformation': personalInformation?.toJson(),
      if (healthInformation != null)
        'healthInformation': healthInformation?.toJson(),
    };
  }

  UserProfileModel copyWith({
    String? username,
    String? firstName,
    String? lastName,
    String? phone,
    String? nationality,
    String? address,
    String? district,
    PersonalInformation? personalInformation,
    HealthInformation? healthInformation,
  }) {
    return UserProfileModel(
      username: username ?? this.username,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      nationality: nationality ?? this.nationality,
      address: address ?? this.address,
      district: district ?? this.district,
      personalInformation: personalInformation ?? this.personalInformation,
      healthInformation: healthInformation ?? this.healthInformation,
    );
  }

  @override
  List<Object?> get props => [
    username,
    firstName,
    lastName,
    phone,
    nationality,
    address,
    district,
    personalInformation,
    healthInformation,
  ];
}

class PersonalInformation extends Equatable {
  final String? userName;
  final String? fullName;
  final String? email;
  final String? phoneNumber;
  final String? dateOfBirth;
  final String? nationality;

  const PersonalInformation({
    this.userName,
    this.fullName,
    this.email,
    this.phoneNumber,
    this.dateOfBirth,
    this.nationality,
  });

  factory PersonalInformation.fromJson(Map<String, dynamic> json) {
    return PersonalInformation(
      userName: json['userName'],
      fullName: json['fullName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      dateOfBirth: json['dateOfBirth'],
      nationality: json['nationality'],
    );
  }

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

  PersonalInformation copyWith({
    String? userName,
    String? fullName,
    String? email,
    String? phoneNumber,
    String? dateOfBirth,
    String? nationality,
  }) {
    return PersonalInformation(
      userName: userName ?? this.userName,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      nationality: nationality ?? this.nationality,
    );
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

class HealthInformation extends Equatable {
  final String? gender;
  final double? height;
  final double? weight;
  final int? age;
  final String? activityLevel;

  const HealthInformation({
    this.gender,
    this.height,
    this.weight,
    this.age,
    this.activityLevel,
  });

  factory HealthInformation.fromJson(Map<String, dynamic> json) {
    return HealthInformation(
      gender: json['gender'],
      height: json['height']?.toDouble(),
      weight: json['weight']?.toDouble(),
      age: json['age'],
      activityLevel: json['activityLevel'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (gender != null) 'gender': gender,
      if (height != null) 'height': height,
      if (weight != null) 'weight': weight,
      if (age != null) 'age': age,
      if (activityLevel != null) 'activityLevel': activityLevel,
    };
  }

  HealthInformation copyWith({
    String? gender,
    double? height,
    double? weight,
    int? age,
    String? activityLevel,
  }) {
    return HealthInformation(
      gender: gender ?? this.gender,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      age: age ?? this.age,
      activityLevel: activityLevel ?? this.activityLevel,
    );
  }

  @override
  List<Object?> get props => [gender, height, weight, age, activityLevel];
}
