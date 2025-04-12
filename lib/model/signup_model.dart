// To parse this JSON data, do
//
//     final signInModel = signInModelFromJson(jsonString);

import 'dart:convert';



class SignupResponseModel {
  bool status;
  Data data;
  String message;

  SignupResponseModel({
    required this.status,
    required this.data,
    required this.message,
  });

  factory SignupResponseModel.fromJson(Map<String, dynamic> json) => SignupResponseModel(
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
  String firstName;
  String lastName;
  String email;
  dynamic profilePicture;
  bool emailVerified;
  String type;
  dynamic deviceToken;
  dynamic deviceType;
  dynamic versionCode;
  dynamic versionNumber;
  dynamic osVersion;
  String id;
  String token;

  User({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.profilePicture,
    required this.emailVerified,
    required this.type,
    required this.deviceToken,
    required this.deviceType,
    required this.versionCode,
    required this.versionNumber,
    required this.osVersion,
    required this.id,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    firstName: json["first_name"],
    lastName: json["last_name"],
    email: json["email"],
    profilePicture: json["profile_picture"],
    emailVerified: json["email_verified"],
    type: json["type"],
    deviceToken: json["device_token"],
    deviceType: json["device_type"],
    versionCode: json["version_code"],
    versionNumber: json["version_number"],
    osVersion: json["os_version"],
    id: json["_id"],
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "first_name": firstName,
    "last_name": lastName,
    "email": email,
    "profile_picture": profilePicture,
    "email_verified": emailVerified,
    "type": type,
    "device_token": deviceToken,
    "device_type": deviceType,
    "version_code": versionCode,
    "version_number": versionNumber,
    "os_version": osVersion,
    "_id": id,
    "token": token,
  };
}
