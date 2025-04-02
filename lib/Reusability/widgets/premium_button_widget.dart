
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../app/modules/premium/views/premium_view.dart';
import '../utils/app_colors.dart';
import '../utils/app_images.dart';
import '../utils/app_text_style.dart';
import 'common_widget.dart';

class PremiumButtonWidget extends StatelessWidget {
  const PremiumButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Get.width * 0.025,
      ),
      child: GestureDetector(
        onTap: () {
          Get.to(
            () => PremiumView(),
            transition: Transition.noTransition,
            duration: Duration(milliseconds: 0),
          );
        },
        child: Container(
          padding: EdgeInsets.only(top: 4.5, bottom: 4.5, left: 4.5, right: 9),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: const FractionalOffset(0.0, 1.0),
              end: const FractionalOffset(1.0, 0.5),
              stops: const [0.0, 0.9],
              colors: AppColors.appGreenGradientColor,
            ),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                AppImage.whiteStarIc,
                width: Get.width * 0.03,
                height: Get.height * 0.018,
                placeholderBuilder: (BuildContext context) {
                  return Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Icon(
                      Icons.error,
                      color: Colors.red,
                    ),
                  );
                },
              ),
              WBox(Get.width * 0.008),
              Text(
                "PRO",
                style: AppTextStyle.regularTextStyle.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
