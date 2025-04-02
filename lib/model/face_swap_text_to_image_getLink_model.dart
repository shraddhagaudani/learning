// To parse this JSON data, do
//
//     final faceSwapTextToImageGetLinkModel = faceSwapTextToImageGetLinkModelFromJson(jsonString);

import 'dart:convert';

FaceSwapTextToImageGetLinkModel faceSwapTextToImageGetLinkModelFromJson(String str) => FaceSwapTextToImageGetLinkModel.fromJson(json.decode(str));

String faceSwapTextToImageGetLinkModelToJson(FaceSwapTextToImageGetLinkModel data) => json.encode(data.toJson());

class FaceSwapTextToImageGetLinkModel {
  bool? success;
  String? message;
  String? imageDetails;

  FaceSwapTextToImageGetLinkModel({
    this.success,
    this.message,
    this.imageDetails,
  });

  FaceSwapTextToImageGetLinkModel copyWith({
    bool? success,
    String? message,
    String? imageDetails,
  }) =>
      FaceSwapTextToImageGetLinkModel(
        success: success ?? this.success,
        message: message ?? this.message,
        imageDetails: imageDetails ?? this.imageDetails,
      );

  factory FaceSwapTextToImageGetLinkModel.fromJson(Map<String, dynamic> json) => FaceSwapTextToImageGetLinkModel(
    success: json["success"],
    message: json["message"],
    imageDetails: json["imageDetails"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "imageDetails": imageDetails,
  };
}
