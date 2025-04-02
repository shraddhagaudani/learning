
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../Reusability/utils/app_colors.dart';
import '../../../../Reusability/utils/app_images.dart';
import '../../../../Reusability/utils/app_text_style.dart';
import '../../../../Reusability/widgets/common_widget.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  OnboardingView({super.key});

  @override
  final controller = Get.put(OnboardingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        children: [
          // Background Image
          _buildBackgroundImage(),
          // PageView for Onboarding Screens
          PageView.builder(
            controller: controller.pageController,
            itemCount: controller.imageList.length,
            onPageChanged: (int index) {
              controller.currentPage.value = index;
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: Get.width * 0.02),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildOnboardingImage(index),
                    _buildOnboardingContent(),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Background Image Widget with error handling
  Widget _buildBackgroundImage() {
    return Image.asset(
      AppImage.onboardingImage,
      height: Get.height,
      width: Get.width,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Center(
          child: Icon(Icons.error, size: 50, color: AppColors.whiteColor),
        );
      },
    );
  }

  // Onboarding Image with error handling
  Widget _buildOnboardingImage(int index) {
    return Image.asset(
      controller.imageList[index],
      errorBuilder: (context, error, stackTrace) {
        return Center(
          child: Icon(Icons.error, size: 50, color: AppColors.whiteColor),
        );
      },
    );
  }

  // Onboarding Text Content with Obx to react to page changes
  Widget _buildOnboardingContent() {
    return Obx(() {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: Get.width * 0.04),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 35, vertical: 30),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha( 0.04.toInt()),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                controller.titleList[controller.currentPage.value],
                textAlign: TextAlign.center,
                style: AppTextStyle.regularTextStyle.copyWith(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              HBox(Get.height * 0.015),
              Text(
                controller.subTitleList[controller.currentPage.value],
                textAlign: TextAlign.center,
                style: AppTextStyle.regularTextStyle.copyWith(
                  fontSize: 15,
                  color: AppColors.whiteColor.withAlpha(0.5.toInt()),
                  height: Get.height * 0.0022,
                ),
              ),
              HBox(30),
              GestureDetector(
                onTap: () {
                  controller.goToNextPage();
                },
                child: Container(
                  height: Get.height * 0.09,
                  width: Get.width * 0.2,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      begin: FractionalOffset(0.0, 1.0),
                      end: FractionalOffset(1.0, 0.5),
                      stops: [0.0, 0.8],
                      colors: AppColors.appGreenGradientColor,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    AppImage.rightIC,
                    width: 20,
                    height: 20,
                    placeholderBuilder: (context) => Center(
                      child: CircularProgressIndicator(
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ),
                ),
              ),
              HBox(Get.height * 0.02),
            ],
          ),
        ),
      );
    });
  }
}
