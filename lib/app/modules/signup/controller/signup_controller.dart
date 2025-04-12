import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart' as dio;
import 'package:learning/model/signup_model.dart';
import '../../../../Reusability/utils/app_constants.dart';
import '../../../../Reusability/utils/app_strings.dart';
import '../../../../Reusability/utils/network_dio/network_dio.dart';
import '../../../../main.dart';
import '../../../../model/login_model.dart';
import '../../login/helper/aes_helper.dart';

class SignUpController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final CommonTextMessages commonTextMessages = CommonTextMessages();

  final FocusNode firstNameFocus = FocusNode();
  final FocusNode lastNameFocus = FocusNode();
  final FocusNode typeFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();

  TextEditingController firstnameC = TextEditingController();
  TextEditingController lastnameC = TextEditingController();
  TextEditingController typeC = TextEditingController();
  TextEditingController passwordC = TextEditingController();
  TextEditingController emailC = TextEditingController();

  RxBool isAutoValidate = false.obs;
  RxBool isHide = true.obs;
  var isLoading = false.obs; // Observable for loading state
  RxString errMsg = ''.obs; //error msg texformfield
  final widgetKey = List.generate(6, (index) => GlobalKey());
  final box = GetStorage();
  final ScrollController scrollController = ScrollController();
  final NetworkDioHttp networkDioHttp = NetworkDioHttp();

  //pass toggle
  togglePass() {
    isHide.value = !isHide.value;
  }

  Future<void> signUp({
    required String firstname,
    required String lastname,
    required String type,
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      // Create a JSON object with email and password
      final credentialsJson = jsonEncode({
        'first_name': firstname,
        'last_name': lastname,
        'type': type,
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
        url: ApiAppConstants.apiEndPoint + ApiAppConstants.signup,
        isHeader: false,
        name: "signup",
        formData: formData,
        isBearer: false,
      );

      if (response?.statusCode == 200 && response?.data != null) {
        print("signup Function call");
        print("🔐 Encrypted Response: ${response?.data}");

        final decryptedResponse = AESHelper.decryptText(response?.data);
        if (decryptedResponse.isEmpty) {
          throw Exception("Decryption failed or response is empty.");
        }
        print("🔓 Decrypted Response: $decryptedResponse");

        final Map<String, dynamic> jsonResponse = jsonDecode(decryptedResponse);
        print("✅ Parsed JSON: $jsonResponse");

        if (jsonResponse['status'] == true) {
          SignupResponseModel responseModel = SignupResponseModel.fromJson(jsonResponse);
          print("✅ Parsed responseModel: $responseModel");

          logger.i("User-Email: ${responseModel.data.user.email}");
          logger.i("User-token: ${responseModel.data.user.token}");
          logger.i("User-Id: ${responseModel.data.user.id}");
          logger.i("first-name: ${responseModel.data.user.firstName}");
          logger.i("last-name: ${responseModel.data.user.lastName}");

          print("✅ Signup success: ${jsonResponse['message']}");

          // Success logic (e.g., save token, navigate, etc.)
        } else {
          print(
            "❌ Signup failed: ${jsonResponse['message']}",
          );
        }
      } else {
        print(
          "Unexpected status code: ${response?.statusCode}",
        );
      }
    } catch (e, stackTrace) {
      log("Login error: $e\n$stackTrace");
    } finally {
      isLoading.value = false;
    }
  }

  late String btoken = box.read("token");

  //on SignIn Button tap
  Future<void> onSignUpButtonPressed() async {
    isAutoValidate.value = true;
    FocusScopeNode currentFocus = FocusScope.of(Get.context!);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    if (formKey.currentState!.validate()) {
      try {
        // Perform login logic here (API call, Firebase auth, etc.)
        await signUp(
          firstname: firstnameC.text,
          lastname: lastnameC.text,
          type: typeC.text,
          email: emailC.text,
          password: passwordC.text,
        );
        //executiveController.fetchExecutiveData(); //executive data
      } catch (e) {
        Get.snackbar("Error", "SignUp failed. Please try again");
      }
      // isLoading.value = false;
    }
  }

  //clear filed data
  void clearVariable() {
    isAutoValidate.value = false;
    firstnameC.clear();
    lastnameC.clear();
    typeC.clear();
    emailC.clear();
    passwordC.clear();
    update();
  }

  @override
  void dispose() {
    firstNameFocus.dispose();
    lastNameFocus.dispose();
    typeFocus.dispose();
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
