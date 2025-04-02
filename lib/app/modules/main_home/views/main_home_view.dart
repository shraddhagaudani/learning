import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Reusability/utils/app_colors.dart';
import '../../../../Reusability/utils/app_strings.dart';
import '../../../../Reusability/widgets/common_dialog.dart';
import '../../../../main.dart';
import '../../home/controllers/home_controller.dart';
import '../../project/controllers/project_controller.dart';
import '../controllers/main_home_controller.dart';

class MainHomeView extends StatefulWidget {
  const MainHomeView({super.key});

  @override
  State<MainHomeView> createState() => _MainHomeViewState();
}

class _MainHomeViewState extends State<MainHomeView> {
  final MainHomeController controller = Get.put(MainHomeController());
  final ProjectController projectController = Get.put(ProjectController());
  final HomeController homeController = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    logger.i("Token :${dataStorage.read(AppStrings.token)}\n\nDeviceID :${dataStorage.read(AppStrings.deviceId)}");

    return Obx(() {
      return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          backgroundColor: AppColors.backgroundColor,
          body: controller.pages[controller.currentIndex.value],
        ),
      );
    });
  }

  /// **Handle Back Button (Exit Confirmation)**
  Future<bool> _onWillPop() async {
    if (controller.currentIndex.value == 0) {
      bool shouldExit = await Get.dialog(
        ConfirmationDialog(
          onTap: () => exit(0),
          onCancel: () => Get.back(),
          title: 'Confirm',
          subTitle: "Are you sure you want to close the app?",
        ),
      );
      return shouldExit;
    } else if (controller.currentIndex.value == 1) {
      controller.currentIndex.value = 0;
      return false;
    } else if (controller.currentIndex.value == 2) {
      controller.currentIndex.value = 1;
      return false;
    } else {
      return true;
    }
  }
}
