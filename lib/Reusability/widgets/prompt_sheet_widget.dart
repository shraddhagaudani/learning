
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../utils/app_colors.dart';
import '../utils/app_images.dart';
import '../utils/app_text_style.dart';
import 'common_widget.dart';

class PromptBottomSheet extends StatelessWidget {
  final TextEditingController promptController;
  final GlobalKey<FormState> formKey;

  const PromptBottomSheet({super.key, required this.promptController, required this.formKey});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height * 0.33,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.textBlackColor,
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                HBox(Get.height * 0.02),
                Text(
                  "Enter Prompt",
                  style: AppTextStyle.regularTextStyle,
                ),
                const HBox(12),
                TextFField(
                  hintText: "Type here a detailed description of what you want to see in your video",
                  maxLine: 4,
                  controller: promptController,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.black45),
                  ),
                  enableBoarder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.black45),
                  ),
                  focusBoarder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.black45),
                  ),
                  fillColor: AppColors.backgroundColor,
                  textInputAction: TextInputAction.done,
                  style: AppTextStyle.regularTextStyle.copyWith(
                    color: AppColors.whiteColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  validator: (value) => value!.isNotEmpty ? null : "Please Enter prompt",
                ),
                HBox(20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Get.width * 0.1),
                  child: CommonButton(
                      textVal: "Next",
                      onPressed: () {
                        FocusScopeNode currentFocus = FocusScope.of(Get.context!);
                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }
                        if (formKey.currentState!.validate()) {
                          Get.back();
                        }
                      }),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: Container(
          transform: Matrix4.translationValues(0.0, -20, 0.0),
          decoration: BoxDecoration(
            color: AppColors.black45,
            shape: BoxShape.circle,
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: SvgPicture.asset(AppImage.closeIC),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
      ),
    );
  }
}
