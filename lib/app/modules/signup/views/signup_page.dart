import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:learning/app/modules/signup/controller/signup_controller.dart';

import '../../../../Reusability/utils/app_colors.dart';
import '../../../../Reusability/utils/app_images.dart';
import '../../../../Reusability/utils/app_text_style.dart';
import '../../../../Reusability/utils/static_decoration.dart';
import '../../../../Reusability/utils/validator.dart';
import '../../../../Reusability/widgets/button_widget.dart';
import '../../../../Reusability/widgets/common_widget.dart';
import '../../../../Reusability/widgets/textformfield_widget.dart';
import '../../../../routes/app_pages.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final SignUpController signUpController = Get.put(SignUpController());

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
                  ),
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
                        // Image.asset(
                        //   AppImage.appIcon,
                        //   fit: BoxFit.fill,
                        //   height: MediaQuery.of(context).size.height * 0.11,
                        //   width: MediaQuery.of(context).size.width * 0.21,
                        // ),
                        HBox(50),
                        Text("Create Account!", style: AppTextStyle.BoldBlackTextStyle),
                        Text(
                          "Sign-Up to your account",
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
                                color: AppColors.greyColor,
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
                              HBox(5),
                              Form(
                                key: signUpController.formKey,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 5, left: 5),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      //firstname:
                                      Obx(() {
                                        return MyTextField(
                                          focusNode: signUpController.firstNameFocus,
                                          key: signUpController.widgetKey[0],
                                          controller: signUpController.firstnameC,
                                          autoValidateMode: (signUpController.isAutoValidate.value)
                                              ? AutovalidateMode.onUserInteraction
                                              : AutovalidateMode.disabled,
                                          textFieldType:
                                              signUpController.commonTextMessages.firstnameFormat,
                                          keyboardType: TextInputType.text,
                                          labelText: "Firstname",
                                          errorText: (signUpController.errMsg.value.isNotEmpty &&
                                                  signUpController.errMsg.value
                                                      .contains("FirstName"))
                                              ? signUpController.errMsg.value
                                              : null,
                                          validator: (value) {
                                            return validateNameField(value);
                                          },
                                          textInputAction: TextInputAction.next,
                                        );
                                      }),
                                      HBox(15),
                                      //lastname:
                                      Obx(() {
                                        return MyTextField(
                                          focusNode: signUpController.lastNameFocus,
                                          key: signUpController.widgetKey[1],
                                          controller: signUpController.lastnameC,
                                          autoValidateMode: (signUpController.isAutoValidate.value)
                                              ? AutovalidateMode.onUserInteraction
                                              : AutovalidateMode.disabled,
                                          textFieldType:
                                              signUpController.commonTextMessages.firstnameFormat,
                                          keyboardType: TextInputType.text,
                                          labelText: "LastName",
                                          errorText: (signUpController.errMsg.value.isNotEmpty &&
                                                  signUpController.errMsg.value
                                                      .contains("LastName"))
                                              ? signUpController.errMsg.value
                                              : null,
                                          validator: (value) {
                                            return validateNameField(value);
                                          },
                                          textInputAction: TextInputAction.next,
                                        );
                                      }),
                                      HBox(15),

                                      //type:
                                      Obx(() {
                                        return MyTextField(
                                          focusNode: signUpController.typeFocus,
                                          key: signUpController.widgetKey[2],
                                          controller: signUpController.typeC,
                                          autoValidateMode: (signUpController.isAutoValidate.value)
                                              ? AutovalidateMode.onUserInteraction
                                              : AutovalidateMode.disabled,
                                          textFieldType:
                                          signUpController.commonTextMessages.textFormat,
                                          keyboardType: TextInputType.text,
                                          labelText: "Type",
                                          errorText: (signUpController.errMsg.value.isNotEmpty &&
                                              signUpController.errMsg.value
                                                  .contains("Type"))
                                              ? signUpController.errMsg.value
                                              : null,
                                          validator: (value) {
                                            return validateNameField(value);
                                          },
                                          textInputAction: TextInputAction.next,
                                        );
                                      }),
                                      HBox(15),

                                      //email:
                                      Obx(() {
                                        return MyTextField(
                                          focusNode: signUpController.emailFocus,
                                          key: signUpController.widgetKey[3],
                                          controller: signUpController.emailC,
                                          autoValidateMode: (signUpController.isAutoValidate.value)
                                              ? AutovalidateMode.onUserInteraction
                                              : AutovalidateMode.disabled,
                                          textFieldType:
                                              signUpController.commonTextMessages.emailFormat,
                                          keyboardType: TextInputType.emailAddress,
                                          labelText: "Email",
                                          errorText: (signUpController.errMsg.value.isNotEmpty &&
                                                  signUpController.errMsg.value.contains("Email"))
                                              ? signUpController.errMsg.value
                                              : null,
                                          validator: (value) {
                                            return validateEmailField(value);
                                          },
                                          textInputAction: TextInputAction.next,
                                        );
                                      }),
                                      HBox(15),
                                      Obx(
                                        () {
                                          return MyTextField(
                                            focusNode: signUpController.passwordFocus,
                                            key: signUpController.widgetKey[4],
                                            autoValidateMode:
                                                (signUpController.isAutoValidate.value)
                                                    ? AutovalidateMode.onUserInteraction
                                                    : AutovalidateMode.disabled,
                                            controller: signUpController.passwordC,
                                            obscureText: signUpController.isHide.value,
                                            textInputAction: TextInputAction.done,
                                            errorText: (signUpController.errMsg.value.isNotEmpty &&
                                                    signUpController.errMsg.value
                                                        .toLowerCase()
                                                        .contains(
                                                          "password",
                                                        ))
                                                ? signUpController.errMsg.value
                                                : null,
                                            textFieldType:
                                                signUpController.commonTextMessages.passFormat,
                                            labelText: "Password",
                                            validator: (value) {
                                              return validatePasswordField(value);
                                            },
                                            onChanged: (p0) {
                                              signUpController.errMsg.value = '';
                                            },
                                            suffixIcon: InkWell(
                                              onTap: signUpController.togglePass,
                                              child: Icon(
                                                signUpController.isHide.value
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
                                        return (signUpController.isLoading.value)
                                            ? const CircularProgressButtonWidget()
                                            : Center(
                                                child: ButtonWidget(
                                                  onTap: () async {
                                                    FocusScope.of(context).unfocus();
                                                    await signUpController.onSignUpButtonPressed();
                                                  },
                                                  data: "Signup",
                                                ),
                                              );
                                      }),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        HBox(20),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Center(
                            child: RichText(
                              text: TextSpan(
                                  text: 'Already have an account?',
                                  style: AppTextStyle.regularBlackTextStyle,
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: ' Login',
                                        style: AppTextStyle.regularYellowTextStyle,
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Get.toNamed(
                                                Routes.loginPage); // navigate to desired screen
                                          })
                                  ]),
                            ),
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
