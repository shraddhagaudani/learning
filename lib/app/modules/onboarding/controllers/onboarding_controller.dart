
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../Reusability/utils/app_images.dart';
import '../../../../Reusability/utils/app_strings.dart';
import '../../../../main.dart';
import '../../../../routes/app_pages.dart';


class OnboardingController extends GetxController {
  final PageController pageController = PageController();

  RxInt currentPage = 0.obs;

  List imageList = [
    AppImage.onboarding1Image,
    AppImage.onboarding2Image,
    AppImage.onboarding3Image,
  ];

  List titleList = [
    "AI-Powered Avatar Customization",
    "Endless Styles & Creativity",
    "Personalize & Share Instantly",
  ];

  List subTitleList = [
    "Instantly create stunning avatars & outfits with AI.",
    "Experiment with trendy outfits, unique filters & artistic effects.",
    "Save, share & impress with your AI-enhanced look!",
  ];

  // Method to go to the next page
  void goToNextPage() {
    if (currentPage.value < imageList.length - 1) {
      currentPage.value++;
      pageController.animateToPage(currentPage.value, duration: Duration(milliseconds: 300), curve: Curves.ease);
    } else {
      dataStorage.write(AppStrings.isSignedUp, true);
      Get.offAllNamed(Routes.mainHome);
    }
    update();
  }

  // Method to go to the previous page (optional)
  void goToPreviousPage() {
    if (currentPage.value > 0) {
      currentPage.value--;
      pageController.animateToPage(currentPage.value, duration: Duration(milliseconds: 300), curve: Curves.ease);
    }
    update();
  }
}
