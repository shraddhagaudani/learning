import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../../Reusability/utils/app_strings.dart';

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

  //check validation for name field value
  String? validateNameField(String? value) {
    if (value!.isEmpty) {
      return "Please enter your full name";
    } else if (value.length < 4) {
      return "Name must be 4 character long";
    }
    return null;
  }

  String? validatePasswordField(String? value) {
    if (value!.isEmpty) {
      return "Please enter your password";
    } else {
      return null;
    }
  }

  //check validation for field value
  String? validateString(String value, String type) {
    if (value.isEmpty) {
      return "$type is required";
    }
    return null;
  }

//check validation for email field value
  String? validateEmailField(String? value) {
    RegExp emailValid =
        RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (value == null || value.isEmpty) {
      return "Please enter your email address";
    } else if (!emailValid.hasMatch(value)) {
      return "Please provide a valid email address";
    }
    return null;
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

  // API Login Function
  Future<void> login() async {
    try {
      isLoading.value = true;

      Map<String, String> requestData = {
        "email": emailC.text.trim(),
        "password": passwordC.text.trim(),
      };

      var url = Uri.parse("https://api.serviceworkfix.com/api/executive/login-executive");
      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestData),
      );

      print("Login response is:${response.body}");

      var data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["code"] == 1) {
        clearVariable();

        // Navigate to Home Screen (Example)
        // Get.offAllNamed(RoutesName.servicepage);
      } else {
        message.value = data["message"] ?? "Login failed.";
        Get.snackbar("Login Error", message.value);
      }
    } catch (e) {
      message.value = "Something went wrong. Please try again.";
      Get.snackbar("Error", message.value);
    } finally {
      isLoading.value = false;
    }
  }

  late String btoken = box.read("token");

  ///Api for logout
  Future<void> logoutApi() async {
    try {
      // callController.isLoading(true);
      Map<String, String> requestData = {"clientType": "app"};

      var url = Uri.parse("https://api.serviceworkfix.com/api/auth/logout");
      var response = await http.post(
        url,
        headers: {'authorization': 'Bearer $btoken', 'accept': 'application/json'},
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 204) {
        logout();
      } else {
        Get.snackbar("Error", "Logout Failed!");
      }
    } catch (e) {
      Get.snackbar("Error", message.value);
    } finally {}
    // callController.isLoading(false);
  }

  void logout() {
    // Get.offAllNamed(RoutesName.loginpage); // Redirect to login screen
    box.remove("token");
    box.remove("email");
    box.remove("password");
    box.remove("rememberMe");
    box.remove("fcmToken");
  }

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
        await login();

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
}
