// To parse this JSON data, do
//
//     final profileResponseModel = profileResponseModelFromJson(jsonString);

import 'dart:convert';

ProfileResponseModel profileResponseModelFromJson(String str) => ProfileResponseModel.fromJson(json.decode(str));

String profileResponseModelToJson(ProfileResponseModel data) => json.encode(data.toJson());

class ProfileResponseModel {
  bool status;
  Data data;
  String message;

  ProfileResponseModel({
    required this.status,
    required this.data,
    required this.message,
  });

  factory ProfileResponseModel.fromJson(Map<String, dynamic> json) => ProfileResponseModel(
    status: json["status"],
    data: Data.fromJson(json["data"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data.toJson(),
    "message": message,
  };
}

class Data {
  User user;

  Data({
    required this.user,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "user": user.toJson(),
  };
}

class User {
  String id;
  String firstName;
  String lastName;
  String email;
  dynamic profilePicture;
  bool emailVerified;
  bool status;
  String type;
  dynamic deviceToken;
  dynamic deviceType;
  dynamic versionCode;
  dynamic versionNumber;
  dynamic osVersion;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.profilePicture,
    required this.emailVerified,
    required this.status,
    required this.type,
    required this.deviceToken,
    required this.deviceType,
    required this.versionCode,
    required this.versionNumber,
    required this.osVersion,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["_id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    email: json["email"],
    profilePicture: json["profile_picture"],
    emailVerified: json["email_verified"],
    status: json["status"],
    type: json["type"],
    deviceToken: json["device_token"],
    deviceType: json["device_type"],
    versionCode: json["version_code"],
    versionNumber: json["version_number"],
    osVersion: json["os_version"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "first_name": firstName,
    "last_name": lastName,
    "email": email,
    "profile_picture": profilePicture,
    "email_verified": emailVerified,
    "status": status,
    "type": type,
    "device_token": deviceToken,
    "device_type": deviceType,
    "version_code": versionCode,
    "version_number": versionNumber,
    "os_version": osVersion,
  };
}
