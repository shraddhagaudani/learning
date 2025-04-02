class CreditPointModel {
  CreditPointModel({
    this.status,
    this.message,
    this.data,
    this.error,
  });

  final int? status;
  final String? message;
  final Data? data;
  final Error? error;

  CreditPointModel copyWith({
    int? status,
    String? message,
    Data? data,
    Error? error,
  }) {
    return CreditPointModel(
      status: status ?? this.status,
      message: message ?? this.message,
      data: data ?? this.data,
      error: error ?? this.error,
    );
  }

  factory CreditPointModel.fromJson(Map<String, dynamic> json) {
    return CreditPointModel(
      status: json["status"],
      message: json["message"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
      error: json["error"] == null ? null : Error.fromJson(json["error"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
        "error": error?.toJson(),
      };
}

class Data {
  Data({
    this.creditPoints,
  });

  final int? creditPoints;

  Data copyWith({
    int? creditPoints,
  }) {
    return Data(
      creditPoints: creditPoints ?? this.creditPoints,
    );
  }

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      creditPoints: json["creditPoints"],
    );
  }

  Map<String, dynamic> toJson() => {
        "creditPoints": creditPoints,
      };
}

class Error {
  Error({this.json});

  final Map<String, dynamic>? json;

  factory Error.fromJson(Map<String, dynamic> json) {
    return Error(
      json: json.isEmpty ? null : json,
    );
  }

  Map<String, dynamic> toJson() => json ?? {};
}
