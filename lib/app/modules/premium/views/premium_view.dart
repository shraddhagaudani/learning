
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../Reusability/utils/app_colors.dart';
import '../../../../Reusability/utils/app_images.dart';
import '../../../../Reusability/utils/app_strings.dart';
import '../../../../Reusability/utils/app_text_style.dart';
import '../../../../Reusability/widgets/common_widget.dart';
import '../controllers/premium_controller.dart';

class PremiumView extends StatefulWidget {
  const PremiumView({super.key});

  @override
  PremiumViewState createState() => PremiumViewState();
}

class PremiumViewState extends State<PremiumView> {
  final PremiumController controller = Get.put(PremiumController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        children: [
          Container(
            height: Get.height,
          ),
          Image.asset(
            AppImage.premiumImage,
            height: Get.height * 0.6,
            width: Get.width,
            fit: BoxFit.fill,
          ),

          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + Get.height * 0.025,
              right: Get.width * 0.02,
              left: Get.width * 0.05,
            ),
            child:   CommonBackButton(
              width: Get.width * 0.1,
              height: Get.height * 0.05,
            ),
          ),
          Positioned(
            bottom: 10,
            right: 0,
            left: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.width * 0.052),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: Get.height * 0.03,
                    width: Get.width * 0.15,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: FractionalOffset(0.0, 1.0),
                        end: FractionalOffset(1.0, 0.5),
                        stops: [0.0, 0.8],
                        colors: AppColors.appGreenGradientColor,
                      ),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          AppImage.whiteStarIc,
                          height: Get.height * 0.015,
                          width: Get.width * 0.03,
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
                  HBox(Get.height * 0.020),
                  Text(
                    "Pro Upgrade to Premium",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.regularTextStyle.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 26,
                    ),
                  ),
                  HBox(Get.height * 0.010),
                  planInformationRow(
                    text: 'Unlimited AI Video Animator Tools',
                    imagePath: AppImage.checkIc,
                  ),
                  planInformationRow(
                    text: 'Unlimited Create with AI',
                    imagePath: AppImage.checkIc,
                  ),
                  planInformationRow(
                    text: 'Best Image Editor',
                    imagePath: AppImage.checkIc,
                  ),
                  HBox(Get.height * 0.020),
                  Obx(() {
                    return premiumCard(
                      isChecked: controller.selectedPlan.value == AppStrings.weekly,
                      price: "170.00",
                      selectedPlan: AppStrings.weekly,
                      timeDuration: "week",
                      onTap: () {
                        controller.selectedPlan.value = AppStrings.weekly;
                      },
                    );
                  }),
                  Obx(() {
                    return premiumCard(
                      isChecked: controller.selectedPlan.value == AppStrings.monthly,
                      price: "330.00",
                      selectedPlan: AppStrings.monthly,
                      timeDuration: "month",
                      onTap: () {
                        controller.selectedPlan.value = AppStrings.monthly;
                      },
                    );
                  }),
                  Obx(() {
                    return premiumCard(
                      isChecked: controller.selectedPlan.value == AppStrings.yearly,
                      price: "2.100.00",
                      selectedPlan: AppStrings.yearly,
                      timeDuration: "year",
                      onTap: () {
                        controller.selectedPlan.value = AppStrings.yearly;
                      },
                    );
                  }),
                  HBox(Get.height * 0.017),
                  CommonButton(
                    btnWidth: Get.width,
                    textVal: "Continue",
                  ),
                  HBox(Get.height * 0.020),
                  Center(
                    child: Text(
                      "Renews automatically. Cancel anytime.",
                      textAlign: TextAlign.center,
                      style: AppTextStyle.regularTextStyle,
                    ),
                  ),
                  HBox(Get.height * 0.001),
                  Text.rich(
                    textAlign: TextAlign.center,
                    TextSpan(
                      text: "Restore Purchases  ∙  Terms of Use  ∙  Privacy Policy",
                      style: AppTextStyle.regularTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget premiumCard({
    required bool isChecked,
    required String price,
    required String timeDuration,
    required String selectedPlan,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          // gradient: isChecked
          //     ? LinearGradient(
          //      a   colors: AppColors.appGreenGradientColor,
          //         begin: FractionalOffset(0.0, 1.0),
          //         end: FractionalOffset(1.0, 0.6),
          //         stops: [0.0, 0.8],
          //       )
          //     : null,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          margin: EdgeInsets.all(2),
          padding: EdgeInsets.symmetric(vertical: Get.height * 0.023),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha( .1.toInt()),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: Get.width * 0.06,
                  height: Get.height * 0.027,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isChecked ? null : AppColors.backgroundColor,
                    gradient: isChecked
                        ? LinearGradient(
                            colors: AppColors.appGreenGradientColor,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                  ),
                  child: Center(
                    child: isChecked
                        ? Icon(
                            Icons.check,
                            color: AppColors.whiteColor,
                            size: 16,
                          )
                        : null,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: Get.width * 0.05),
                  child: Text(
                    selectedPlan,
                    style: AppTextStyle.regularTextStyle.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.whiteColor,
                    ),
                  ),
                ),
                Spacer(),
                Text.rich(
                  TextSpan(
                    text: "₹$price",
                    style: AppTextStyle.regularTextStyle.copyWith(color: AppColors.whiteColor),
                    children: [
                      TextSpan(
                        text: "/$timeDuration",
                        style: AppTextStyle.regularTextStyle.copyWith(
                          color: AppColors.textLightGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget planInformationRow({required String imagePath, required String text}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Get.height * 0.003),
      child: Row(
        children: [
          SvgPicture.asset(
            imagePath,
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
          Padding(
            padding: EdgeInsets.only(left: Get.width * 0.025),
            child: Text(
              text,
              style: AppTextStyle.regularTextStyle.copyWith(
                fontSize: 16,
                color: AppColors.textLightGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
