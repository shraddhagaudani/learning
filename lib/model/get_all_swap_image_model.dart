import 'dart:convert';

// To parse this JSON data, do
//
//     final getAllFaceSwapImage = getAllFaceSwapImageFromJson(jsonString);

GetAllFaceSwapImageModel getAllFaceSwapImageFromJson(String str) => GetAllFaceSwapImageModel.fromJson(json.decode(str));

String getAllFaceSwapImageToJson(GetAllFaceSwapImageModel data) => json.encode(data.toJson());

class GetAllFaceSwapImageModel {
  int? status;
  String? message;
  List<SwapImageDetail>? data;
  Error? error;

  GetAllFaceSwapImageModel({
    this.status,
    this.message,
    this.data,
    this.error,
  });

  GetAllFaceSwapImageModel copyWith({
    int? status,
    String? message,
    List<SwapImageDetail>? data,
    Error? error,
  }) =>
      GetAllFaceSwapImageModel(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
        error: error ?? this.error,
      );

  factory GetAllFaceSwapImageModel.fromJson(Map<String, dynamic> json) => GetAllFaceSwapImageModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] != null ? List<SwapImageDetail>.from(json["data"]!.map((x) => SwapImageDetail.fromJson(x))) : [],
        error: json["error"] != null ? Error.fromJson(json["error"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data != null ? List<dynamic>.from(data!.map((x) => x.toJson())) : [],
        "error": error?.toJson(),
      };
}

class SwapImageDetail {
  String? id;
  String? status;
  String? type;
  SubcategoryId? subcategoryId;
  String? generatedImage;

  SwapImageDetail({
    this.id,
    this.status,
    this.type,
    this.subcategoryId,
    this.generatedImage,
  });

  SwapImageDetail copyWith({
    String? id,
    String? status,
    String? type,
    SubcategoryId? subcategoryId,
    String? generatedImage,
  }) =>
      SwapImageDetail(
        id: id ?? this.id,
        status: status ?? this.status,
        type: type ?? this.type,
        subcategoryId: subcategoryId ?? this.subcategoryId,
        generatedImage: generatedImage ?? this.generatedImage,
      );

  factory SwapImageDetail.fromJson(Map<String, dynamic> json) => SwapImageDetail(
        id: json["_id"],
        status: json["status"],
        type: json["type"],
        subcategoryId: json["subcategoryId"] != null ? SubcategoryId.fromJson(json["subcategoryId"]) : null,
        generatedImage: json["generatedImage"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "status": status,
        "type": type,
        "subcategoryId": subcategoryId?.toJson(),
        "generatedImage": generatedImage,
      };
}

class SubcategoryId {
  String? id;
  String? name;

  SubcategoryId({
    this.id,
    this.name,
  });

  SubcategoryId copyWith({
    String? id,
    String? name,
  }) =>
      SubcategoryId(
        id: id ?? this.id,
        name: name ?? this.name,
      );

  factory SubcategoryId.fromJson(Map<String, dynamic> json) => SubcategoryId(
        id: json["_id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
      };
}

class Error {
  Error();

  factory Error.fromJson(Map<String, dynamic> json) => Error();

  Map<String, dynamic> toJson() => {};
}
