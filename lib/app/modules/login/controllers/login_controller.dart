import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as dio;

import '../../../../Reusability/utils/app_constants.dart';
import '../../../../Reusability/utils/app_strings.dart';
import '../../../../Reusability/utils/network_dio/network_dio.dart';
import '../../../../main.dart';
import '../../../../model/login_model.dart';
import '../helper/aes_helper.dart';

class LoginController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final CommonTextMessages commonTextMessages = CommonTextMessages();

  final FocusNode emailFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();

  TextEditingController passwordC = TextEditingController();
  TextEditingController emailC = TextEditingController();

  RxBool isAutoValidate = false.obs;
  RxBool isHide = true.obs;
  var rememberMe = false.obs; //switch
  var isLoading = false.obs; // Observable for loading state
  RxString errMsg = ''.obs; //error msg texformfield
  final focusNodePhoneNumber = FocusNode();
  final widgetKey = List.generate(4, (index) => GlobalKey());
  var message = "".obs; //login api responses

  final box = GetStorage();
  final ScrollController scrollController = ScrollController();
  final NetworkDioHttp networkDioHttp = NetworkDioHttp();

  @override
  void onInit() {
    super.onInit();
    loadRememberedUser(); // Load saved login info if Remember Me was enabled
    //getFCMToken();
  }

  Token() {
    String? token = box.read("token");
    if (token != null) {
      print("Stored Token: $token");
    } else {
      print("No token found. User must log in.");
    }
  }

  //pass toggle
  togglePass() {
    isHide.value = !isHide.value;
  }
  
  // Load Saved Login Data
  void loadRememberedUser() {
    Token();
    if (box.read("rememberMe") == true) {
      emailC.text = box.read("email") ?? "";
      // companyController.selectedCompany.value = box.read("companyName") ?? "";
      passwordC.text = box.read("password") ?? "";
      rememberMe.value = true;
    }
  }

  // Future<LoginResponseModel?> login({
  //   required String email,
  //   required String password,
  // }) async {
  //   try {
  //     final bodyData = {
  //       "email": emailC.text,
  //       "password": passwordC.text,
  //     };
  //
  //     final response = await networkDioHttp.postRequest(
  //       url: ApiAppConstants.apiEndPoint+ApiAppConstants.login,
  //       isHeader: false,
  //       isBody: true,
  //       bodyData: bodyData,
  //     );
  //
  //     if (response?.statusCode == 200) {
  //       print("ResponseData:$response?.data");
  //       return LoginResponseModel.fromJson(response?.data);
  //     } else {
  //       print("Unexpected status code: ${response?.statusCode}");
  //       return null;
  //     }
  //   } on DioException catch (e) {
  //     print("Dio login error: ${e.message}");
  //     return null;
  //   }
  // }

  // Future<void> login({
  //   required String email,
  //   required String password,
  // }) async {
  //   try {
  //     isLoading.value = true;
  //     dio.FormData data = dio.FormData.fromMap({
  //       'email': email,
  //       'password': password,
  //     });
  //
  //     final response = await networkDioHttp.uploadMediaRequest(
  //       url: ApiAppConstants.apiEndPoint + ApiAppConstants.login,
  //       isHeader: false,
  //       name: "login",
  //       formData: data,
  //       isBearer: false,
  //     );
  //
  //     if (response?.statusCode == 200) {
  //       LoginResponseModel loginResponseModel = LoginResponseModel.fromJson(response?.data);
  //
  //       if (loginResponseModel.status == true) {
  //         isLoading.value = false;
  //         // navigate to next screen
  //       } else {
  //         print("Login Response Error:${loginResponseModel.message}");
  //       }
  //
  //       print("Login Response $loginResponseModel");
  //     } else {
  //       print("Unexpected status code: ${response?.statusCode}");
  //       return null;
  //     }
  //   } catch (e, stackTrace) {
  //     log("Error uploading image: $e\n$stackTrace");
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;

      // Create a JSON object with email and password
      final credentialsJson = jsonEncode({
        'email': email,
        'password': password,
      });

      // Encrypt the whole JSON string
      final encryptedData = AESHelper.encryptText(credentialsJson);

      // Wrap into FormData with a single `data` field
      dio.FormData formData = dio.FormData.fromMap({
        'data': encryptedData,
      });

      final response = await networkDioHttp.uploadMediaRequest(
        url: ApiAppConstants.apiEndPoint + ApiAppConstants.login,
        isHeader: false,
        name: "login",
        formData: formData,
        isBearer: false,
      );

      if (response?.statusCode == 200 && response?.data != null) {
        print("Function call");
        print("🔐 Encrypted Response: ${response?.data}");

        // LoginResponseModel loginResponseModel = LoginResponseModel.fromJson(response?.data);
        final decryptedResponse = AESHelper.decryptText(response?.data);
        if (decryptedResponse.isEmpty) {
          throw Exception("Decryption failed or response is empty.");
        }
        print("🔓 Decrypted Response: $decryptedResponse");

        final Map<String, dynamic> jsonResponse = jsonDecode(decryptedResponse);
        print("✅ Parsed JSON: $jsonResponse");


        if (jsonResponse['status'] == true) {
          LoginResponseModel responseModel = LoginResponseModel.fromJson(jsonResponse);
          print("✅ Parsed responseModel: $responseModel");

          logger.i("User-Email: ${responseModel.data.user.email}");
          logger.i("User-token: ${responseModel.data.user.token}");
          logger.i("User-Id: ${responseModel.data.user.id}");

          // Success logic (e.g., save token, navigate, etc.)
        } else {
          print("❌ Login failed: ${jsonResponse['message']}");
        }

        // if (loginResponseModel.status == true) {
        //   isLoading.value = false;
        //   // Success: Navigate or store token
        // } else {
        //   print("Login Response Error: ${loginResponseModel.message}");
        // }
      } else {
        print("Unexpected status code: ${response?.statusCode}");
      }
    } catch (e, stackTrace) {
      log("Login error: $e\n$stackTrace");
    } finally {
      isLoading.value = false;
    }
  }

  late String btoken = box.read("token");


  //on SignIn Button tap
  Future<void> onLogInButtonPressed() async {
    isAutoValidate.value = true;
    FocusScopeNode currentFocus = FocusScope.of(Get.context!);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    if (formKey.currentState!.validate()) {
      try {
        // Perform login logic here (API call, Firebase auth, etc.)
        await login(
          email: emailC.text,
          password: passwordC.text,
        );

        //executiveController.fetchExecutiveData(); //executive data
      } catch (e) {
        Get.snackbar("Error", "Login failed. Please try again");
      }
      // isLoading.value = false;
    }
  }

  //clear filed data
  void clearVariable() {
    isAutoValidate.value = false;
    emailC.clear();
    passwordC.clear();
    update();
  }

  //phone format set
  String? phoneFormat(String value) {
    return value.replaceAll(")", "").replaceAll("(", "").replaceAll("-", "").replaceAll(" ", "");
  }

  @override
  void dispose() {
    emailFocus.dispose();
    passwordFocus.dispose();
    scrollController.dispose();
    super.dispose();
  }

  /// **Handle Errors & Show Toast**
  void _handleError(String message) {
    print("Error is: $message");
    // isGeneratingImageLoading.value = false;
    // isUploadingImageLoading.value = false;
    // CustomSnackBar.showCustomToast(
    //   toastType: ToastType.error,
    //   message: message,
    // );
    Get.back();
  }
}
