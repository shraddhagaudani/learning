
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/app_colors.dart';
import '../utils/app_text_style.dart';
import 'common_widget.dart';

class PermissionDialog extends StatelessWidget {
  final String permissionType;
  final dynamic Function()? onSettingPressed;

  const PermissionDialog({
    super.key,
    required this.permissionType,
    this.onSettingPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.textBlackColor.withAlpha( 0.1.toInt()),

                spreadRadius: 2,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "$permissionType Permission Required",
                  style:  AppTextStyle.regularTextStyle.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textBlackColor,
                  ),
                ),
                HBox(8),
                Text(
                  "This app requires $permissionType permission to work properly. Please grant it in Settings.",
                  style:  AppTextStyle.regularTextStyle.copyWith(
                    fontSize: 14,
                    color: AppColors.textBlackColor,
                  ),
                ),
                HBox(25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CommonButton(
                      textVal: "Go to Settings",
                      onPressed: onSettingPressed,
                    ),
                    WBox(8),
                    CommonButton(
                      textVal: "Cancel",
                      onPressed: () {
                        Get.back();
                      },
                      backgroundColor: AppColors.textLightGrey,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
