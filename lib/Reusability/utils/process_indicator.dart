import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';

import 'app_colors.dart';

class Loader {
  static show() {
    final context = Get.context;
    if (context != null) {
      context.loaderOverlay.show(
        widgetBuilder: (progress) {
          return const MyLoader();
        },
      );
    } else {
      debugPrint('Error: Get.context is null');
    }
  }

  static hide() {
    final context = Get.context;
    if (context != null) {
      context.loaderOverlay.hide();
    } else {
      debugPrint('Error: Get.context is null');
    }
  }
}

class MyLoader extends StatelessWidget {
  const MyLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        strokeWidth: 3,
        color: AppColors.whiteColor,
      ),
    );
  }
}
