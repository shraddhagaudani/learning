import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:learning/Reusability/widgets/common_widget.dart';
import '../../../../Reusability/utils/app_colors.dart';
import '../../../../Reusability/utils/app_images.dart';
import '../../../../Reusability/utils/static_decoration.dart';
import '../../../../Reusability/widgets/button_widget.dart';
import '../../../../Reusability/widgets/textformfield_widget.dart';
import '../controllers/login_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _HomePageState();
}

class _HomePageState extends State<LoginPage> {
  final LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        return FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: AppColors.whiteColor,
          body: Stack(
            children: [
              Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10), // Adjust the radius as needed
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    // height: height * 0.5,
                  ),
                  Expanded(
                    child: Container(
                      color: AppColors.whiteColor,
                    ),
                  )
                ],
              ),
              // Main Content Overlapping Both Backgrounds
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 20, // Adjusts for keyboard
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: MediaQuery.of(context).size.height * 0.08),
                        Image.asset(
                          AppImage.appIcon,
                          fit: BoxFit.fill,
                          height: MediaQuery.of(context).size.height * 0.11,
                          width: MediaQuery.of(context).size.width * 0.21,
                        ),
                        HBox(50),
                        Text(
                          "Welcome back!",
                          style: TextStyle(
                            color: AppColors.blackColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        Text(
                          "Login to your account",
                          style: TextStyle(
                            color: AppColors.greyColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                        HBox(20),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.black10,
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                              BoxShadow(
                                color: AppColors.greyColor,
                                blurRadius: 4,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Form(
                                key: loginController.formKey,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 5, left: 5),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      //email:
                                      Obx(() {
                                        return MyTextField(
                                          focusNode: loginController.emailFocus,
                                          key: loginController.widgetKey[0],
                                          controller: loginController.emailC,
                                          autoValidateMode: (loginController.isAutoValidate.value)
                                              ? AutovalidateMode.onUserInteraction
                                              : AutovalidateMode.disabled,
                                          textFieldType:
                                              loginController.commonTextMessages.emailFormat,
                                          keyboardType: TextInputType.emailAddress,
                                          labelText: "Email",
                                          errorText: (loginController.errMsg.value.isNotEmpty &&
                                                  loginController.errMsg.value.contains("Email"))
                                              ? loginController.errMsg.value
                                              : null,
                                          validator: (value) {
                                            return loginController.validateEmailField(value);
                                          },
                                          textInputAction: TextInputAction.next,
                                        );
                                      }),
                                      HBox(15),
                                      Obx(
                                        () {
                                          return MyTextField(
                                            focusNode: loginController.passwordFocus,
                                            key: loginController.widgetKey[1],
                                            autoValidateMode: (loginController.isAutoValidate.value)
                                                ? AutovalidateMode.onUserInteraction
                                                : AutovalidateMode.disabled,
                                            controller: loginController.passwordC,
                                            obscureText: loginController.isHide.value,
                                            textInputAction: TextInputAction.done,
                                            errorText: (loginController.errMsg.value.isNotEmpty &&
                                                    loginController.errMsg.value
                                                        .toLowerCase()
                                                        .contains(
                                                          "password",
                                                        ))
                                                ? loginController.errMsg.value
                                                : null,
                                            textFieldType:
                                                loginController.commonTextMessages.passFormat,
                                            labelText: "Password",
                                            validator: (value) {
                                              return loginController.validatePasswordField(value);
                                            },
                                            onChanged: (p0) {
                                              loginController.errMsg.value = '';
                                            },
                                            suffixIcon: InkWell(
                                              onTap: loginController.togglePass,
                                              child: Icon(
                                                loginController.isHide.value
                                                    ? Icons.visibility_off
                                                    : Icons.remove_red_eye_outlined,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      // Remember Me Toggle
                                      HBox(35),
                                      Obx(() {
                                        return (loginController.isLoading.value)
                                            ? const CircularProgressButtonWidget()
                                            : Center(
                                                child: ButtonWidget(
                                                  onTap: () async {
                                                    FocusScope.of(context).unfocus();
                                                    await loginController.onLogInButtonPressed();
                                                  },
                                                  data: "Login",
                                                ),
                                              );
                                      }),
                                      /*SizedBox(
                                        height: height * 0.010,
                                      ),*/
                                      /*Obx(() => (!loginController.isLoading.value) ? Text(loginController.message.value,
                                      style: const TextStyle(color: Colors.red)) : Container()),*/
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: BottomAppBar(
            height: 50,
            shape: const CircularNotchedRectangle(),
            color: AppColors.whiteColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  //onTap: _launchURL,
                  child: Text(
                    "@2025 Imperial softtech. All rights reserved.",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: fontWeight600,
                      color: AppColors.blackColor,
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
