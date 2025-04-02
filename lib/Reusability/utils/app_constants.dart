class ApiAppConstants {
  // Network Constants
  static const bool isLive = true;

  static const String localEndPoint = "http://192.168.29.87:8004/"; // Local
  static const String liveEndPoint = "https://aiapi.uniqcrafts.com/"; // Live

  // Base URL
  static String get apiEndPoint {
    return isLive ? liveEndPoint : localEndPoint;
  }

  static const String loginSignup = "user/loginSignup";
  static const String getImageLink = "upload/media";
  static const String getCreditPoint = "user/getPoints";
  static const String deductCreditPoint = "user/cutPoints";
  static const String faceSwapTextToImageCreate = "textToImage/faceSwap/create";
  static const String faceSwapTextToImageGetLink = "textToImage/faceSwap/getLink";
  static const String faceSwapGetAllImage = "textToImage/faceSwap/getAllImage";
  static const String faceSwapClothSwapCreate = "textToImage/clothSwap/create";
  static const String faceSwapClothImageLink = "textToImage/clothSwap/getLink";
  static const String getAllFilterDirect = "filter/getDirect";
}
