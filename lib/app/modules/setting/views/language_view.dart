
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Reusability/utils/app_colors.dart';
import '../../../../Reusability/utils/app_images.dart';
import '../../../../Reusability/utils/app_text_style.dart';

class LanguageView extends StatefulWidget {
  const LanguageView({super.key});

  @override
  State<LanguageView> createState() => _LanguageViewState();
}

class _LanguageViewState extends State<LanguageView> {
  final RxString selectedLanguage = 'hi'.obs;

  /// **List of Languages & Their Codes**
  final List<Map<String, String>> languages = [
    {"title": "हिंदी", "value": "hi"},
    {"title": "मराठी", "value": "mr"},
    {"title": "বাংলা", "value": "bn"},
    {"title": "ગુજરાતી", "value": "gu"},
    {"title": "اردو", "value": "ur"},
    {"title": "தமிழ்", "value": "ta"},
    {"title": "తెలుగు", "value": "te"},
    {"title": "മലയാളം", "value": "ml"},
    {"title": "ಕನ್ನಡ", "value": "kn"},
    {"title": "অসমীয়া", "value": "as"},
    {"title": "English", "value": "en"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: _buildAppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Get.width * 0.052),
        child: ListView.builder(
          itemCount: languages.length,
          itemBuilder: (context, index) {
            return _buildLanguageCard(
              title: languages[index]["title"]!,
              value: languages[index]["value"]!,
            );
          },
        ),
      ),
    );
  }

  /// **App Bar**
  AppBar _buildAppBar() {
    return AppBar(
      leading: GestureDetector(
        onTap: () => Get.back(),
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: SizedBox(
            width: Get.width * 0.075,
            height: Get.height * 0.035,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Image.asset(
                AppImage.backIcon,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
      surfaceTintColor: AppColors.transparent,
      centerTitle: true,
      title: Text(
        "Languages",
        style: AppTextStyle.regularTextStyle.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: AppColors.backgroundColor,
    );
  }

  /// **Language Selection Card**
  Widget _buildLanguageCard({required String title, required String value}) {
    return Obx(
      () => GestureDetector(
        onTap: () {
          selectedLanguage.value = value;
        },
        child: Container(
          width: Get.width,
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: AppColors.textBlackColor,
          ),
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: Get.width * 0.02),
            child: Row(
              children: [
                _buildRadio(value),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: AppTextStyle.regularTextStyle.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.whiteColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// **Custom Radio Button with Tap Handling**
  Widget _buildRadio(String value) {
    return Radio<String>(
      value: value,
      groupValue: selectedLanguage.value,
      activeColor: AppColors.whiteColor,
      onChanged: (String? newValue) {
        selectedLanguage.value = newValue!;
      },
    );
  }
}
