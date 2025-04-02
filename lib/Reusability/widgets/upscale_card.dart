
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/app_colors.dart';
import '../utils/app_images.dart';
import '../utils/app_text_style.dart';
import 'common_widget.dart';

class UpScaleCard extends StatelessWidget {
  final VoidCallback onTap;
  final bool index;
  final String pixel;
  final String resolution;
  final String creditScore;

  const UpScaleCard({
    super.key,
    required this.onTap,
    required this.index,
    required this.pixel,
    required this.resolution,
    required this.creditScore,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: index ? AppColors.backgroundColor : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pixel,
                    style: AppTextStyle.regularTextStyle.copyWith(
                      fontSize: 16,
                    ),
                  ),
                  HBox(Get.height * 0.01),
                  Text(
                    resolution,
                    style: AppTextStyle.regularTextStyle.copyWith(
                      fontSize: 10,
                      color: AppColors.textLightGrey,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Image.asset(AppImage.starImage),
                  Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text(
                      creditScore,
                      style: AppTextStyle.regularTextStyle.copyWith(
                        fontSize: 16,
                        color: AppColors.textLightGrey,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
