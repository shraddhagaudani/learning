

import 'dart:convert';

class LoginResponseModel {
  final bool status;
  final DataModel data;
  final String message;

  LoginResponseModel({
    required this.status,
    required this.data,
    required this.message,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      status: json['status'],
      data: DataModel.fromJson(json['data']),
      message: json['message'],
    );
  }
}

class DataModel {
  final UserModel user;

  DataModel({required this.user});

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(user: UserModel.fromJson(json['user']));
  }
}

class UserModel {
  final String id;
  final String firstName;
  final String lastName; // yes
  final String email;
  final String? profilePicture;
  final String? bio;
  final bool emailVerified;
  final int dailyLimit;
  final String type;
  final String? deviceToken;
  final String? deviceType;
  final String? buildName;
  final String? buildNumber;
  final String? osVersion;
  final String token;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.profilePicture,
    required this.bio,
    required this.emailVerified,
    required this.dailyLimit,
    required this.type,
    this.deviceToken,
    this.deviceType,
    this.buildName,
    this.buildNumber,
    this.osVersion,
    required this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      profilePicture: json['profile_picture'],
      bio: json['bio'],
      emailVerified: json['email_verified'],
      dailyLimit: json['daily_limit'],
      type: json['type'],
      deviceToken: json['device_token'],
      deviceType: json['device_type'],
      buildName: json['build_name'],
      buildNumber: json['build_number'],
      osVersion: json['os_version'],
      token: json['token'],
    );
  }
}
