import 'dart:convert';

DeviceModel deviceModelFromJson(String str) => DeviceModel.fromJson(json.decode(str));

String deviceModelToJson(DeviceModel data) => json.encode(data.toJson());

class DeviceModel {
  final int? status;
  final String? message;
  final Data? data;
  final Error? error;

  DeviceModel({
    this.status,
    this.message,
    this.data,
    this.error,
  });

  factory DeviceModel.fromJson(Map<String, dynamic> json) => DeviceModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        error: json["error"] == null ? null : Error.fromJson(json["error"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
        "error": error?.toJson(),
      };
}

class Data {
  final String? id;
  final String? deviceId;
  final String? token;

  Data({
    this.id,
    this.deviceId,
    this.token,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["_id"],
        deviceId: json["deviceId"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "deviceId": deviceId,
        "token": token,
      };
}

class Error {
  Error();

  factory Error.fromJson(Map<String, dynamic> json) => Error();

  Map<String, dynamic> toJson() => {};
}
