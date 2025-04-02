// To parse this JSON data, do
//
//     final faceSwapTextToImageCreateModel = faceSwapTextToImageCreateModelFromJson(jsonString);

import 'dart:convert';

FaceSwapTextToImageCreateModel faceSwapTextToImageCreateModelFromJson(String str) => FaceSwapTextToImageCreateModel.fromJson(json.decode(str));

String faceSwapTextToImageCreateModelToJson(FaceSwapTextToImageCreateModel data) => json.encode(data.toJson());

class FaceSwapTextToImageCreateModel {
  bool? success;
  String? message;
  String? jobId;

  FaceSwapTextToImageCreateModel({
    this.success,
    this.message,
    this.jobId,
  });

  FaceSwapTextToImageCreateModel copyWith({
    bool? success,
    String? message,
    String? jobId,
  }) =>
      FaceSwapTextToImageCreateModel(
        success: success ?? this.success,
        message: message ?? this.message,
        jobId: jobId ?? this.jobId,
      );

  factory FaceSwapTextToImageCreateModel.fromJson(Map<String, dynamic> json) => FaceSwapTextToImageCreateModel(
    success: json["success"],
    message: json["message"],
    jobId: json["jobId"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "jobId": jobId,
  };
}
