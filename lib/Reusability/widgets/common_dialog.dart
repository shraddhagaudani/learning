
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../utils/app_colors.dart';
import '../utils/app_images.dart';
import '../utils/app_text_style.dart';
import 'common_widget.dart';

class ConfirmationDialog extends StatefulWidget {
  final void Function() onTap;
  final void Function()? onCancel;

  final String title;
  final String subTitle;

  const ConfirmationDialog({
    super.key,
    required this.onTap,
    this.onCancel,
    required this.title,
    required this.subTitle,
  });

  @override
  State<ConfirmationDialog> createState() => _ConfirmationDialogState();
}

class _ConfirmationDialogState extends State<ConfirmationDialog> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        type: MaterialType.transparency,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  HBox(8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),
                      WBox(5),
                      Text(
                        widget.title,
                        style: AppTextStyle.regularTextStyle.copyWith(
                          color: AppColors.textBlackColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: widget.onCancel,
                        child: SizedBox(
                          width: Get.width * 0.075,
                          height: Get.height * 0.035,
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: SvgPicture.asset(
                              AppImage.closeIC,
                              colorFilter: ColorFilter.mode(AppColors.textBlackColor, BlendMode.srcIn),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  HBox(15),
                  Text(
                    widget.subTitle,
                    textAlign: TextAlign.center,
                    style: AppTextStyle.regularTextStyle.copyWith(
                      color: AppColors.textBlackColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  HBox(30),
                  Row(
                    children: [
                      Expanded(
                        child: CommonButton(
                          textVal: 'Yes',
                          onPressed: widget.onTap,
                        ),
                      ),
                      WBox(20),
                      Expanded(
                        child: CommonButton(
                          backgroundColor: AppColors.greyColor.withAlpha( 0.5 as int),
                          textVal: 'No',
                          onPressed: widget.onCancel,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
