
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../utils/app_colors.dart';
import '../utils/app_images.dart';
import '../utils/app_text_style.dart';
import 'common_widget.dart';

class RatingDialog extends StatefulWidget {
  const RatingDialog({super.key});

  @override
  RatingDialogState createState() => RatingDialogState();
}

class RatingDialogState extends State<RatingDialog> {
  final RxInt stars = 0.obs;

  /// **Build Star Rating Widget**
  Widget _buildStar(int starCount) {
    return Obx(() => InkWell(
      onTap: () {
        stars.value = starCount;
      },
      child: Icon(
        Icons.star,
        size: 35,
        color: stars.value >= starCount ? Colors.orange : Colors.grey,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        type: MaterialType.transparency,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildDialogHeader(),
                  HBox(15),
                  _buildDialogDescription(),
                  HBox(15),
                  _buildStarRatingRow(),
                  HBox(30),
                  _buildActionButtons(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// **Dialog Header with Title & Close Button**
  Widget _buildDialogHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        Text(
          "Rate this app",
          style: AppTextStyle.regularTextStyle.copyWith(
            color: AppColors.textBlackColor,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () => Get.back(),
          child: SizedBox(
            width: Get.width * 0.075,
            height: Get.height * 0.035,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: SvgPicture.asset(
                AppImage.closeIC,
                colorFilter: ColorFilter.mode(AppColors.textBlackColor, BlendMode.srcIn),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// **Dialog Description**
  Widget _buildDialogDescription() {
    return Text(
      "If you enjoy using this app, we’d really appreciate it if you could take a moment to leave a review. It helps us a lot and won’t take more than a minute of your time!",
      textAlign: TextAlign.center,
      style: AppTextStyle.regularTextStyle.copyWith(
        color: AppColors.textBlackColor,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  /// **Star Rating Row**
  Widget _buildStarRatingRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(5, (index) => _buildStar(index + 1)),
    );
  }

  /// **Action Buttons (Submit & Cancel)**
  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: CommonButton(
            textVal: 'Submit',
            onPressed: () {
              Get.back(result: stars.value);
            },
          ),
        ),
        WBox(20),
        Expanded(
          child: CommonButton(
            backgroundColor: AppColors.greyColor.withAlpha(0.5.toInt()),
            textVal: 'Cancel',
            onPressed: () => Get.back(),
          ),
        ),
      ],
    );
  }
}
