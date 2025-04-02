import 'dart:convert';

ImageUploadModel imageUploadModelFromJson(String str) => ImageUploadModel.fromJson(json.decode(str));

String imageUploadModelToJson(ImageUploadModel data) => json.encode(data.toJson());

class ImageUploadModel {
  int? status;
  String? message;
  Data? data;
  Error? error;

  ImageUploadModel({
    this.status,
    this.message,
    this.data,
    this.error,
  });

  ImageUploadModel copyWith({
    int? status,
    String? message,
    Data? data,
    Error? error,
  }) =>
      ImageUploadModel(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
        error: error ?? this.error,
      );

  factory ImageUploadModel.fromJson(Map<String, dynamic> json) => ImageUploadModel(
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
  List<String>? urls;

  Data({
    this.urls,
  });

  Data copyWith({
    List<String>? urls,
  }) =>
      Data(
        urls: urls ?? this.urls,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    urls: json["urls"] == null ? [] : List<String>.from(json["urls"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "urls": urls != null ? List<dynamic>.from(urls!.map((x) => x)) : [],
  };
}

class Error {
  Error();

  factory Error.fromRawJson(String str) => Error.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Error.fromJson(Map<String, dynamic> json) => Error();

  Map<String, dynamic> toJson() => {};
}
