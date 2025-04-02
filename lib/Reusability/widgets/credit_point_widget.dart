
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/modules/splash/controllers/splash_controller.dart';
import '../utils/app_colors.dart';
import '../utils/app_images.dart';
import '../utils/app_text_style.dart';
import 'common_widget.dart';

class CreditPointWidget extends StatelessWidget {
  const CreditPointWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.black45,
        borderRadius: BorderRadius.all(Radius.circular(100)),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 4.5, bottom: 4.5, left: 4.5, right: 9),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AppImage.starImage,width: Get.width * 0.035,height: Get.height * 0.018,),
            WBox(Get.width * 0.008),
            Obx(() {
              String creditPoints = Get.find<SplashController>().creditPoint.value.data?.creditPoints.toString() ?? '0';
              return Text(
                creditPoints,
                style: AppTextStyle.regularTextStyle.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
