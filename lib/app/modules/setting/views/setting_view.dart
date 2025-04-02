
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../Reusability/utils/app_colors.dart';
import '../../../../Reusability/utils/app_images.dart';
import '../../../../Reusability/utils/app_text_style.dart';
import '../../../../Reusability/widgets/common_widget.dart';
import '../../../../Reusability/widgets/rating_dialog.dart';
import '../../main_home/controllers/main_home_controller.dart';
import '../../premium/views/premium_view.dart';
import '../controllers/setting_controller.dart';
import 'language_view.dart';

class SettingView extends StatefulWidget {
  const SettingView({super.key});

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  final SettingController controller = Get.put(SettingController());
  final MainHomeController mainHomeController = Get.put(MainHomeController());

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(AssetImage(AppImage.premiumCard), context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        children: [
          Image.asset(
            AppImage.appBarGradient2,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Positioned(
            top: Get.height * 0.056,
            left: 0,
            right: 0,
            child: _buildTopBar(),
          ),
          Positioned(
            top: Get.height * 0.146,
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.textBlackColor,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPremiumCard(),
                    _buildSettingsList(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container _buildTopBar() {
    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          CommonBackButton(
            width: Get.width * 0.1,
            height: Get.height * 0.05,
            onTap: () {
              mainHomeController.currentIndex.value = 1;
            },
          ),
          WBox(20),
          Expanded(
            child: Text(
              "Settings",
              style: AppTextStyle.regularTextStyle.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// **Premium Upgrade Card**
  Widget _buildPremiumCard() {
    return GestureDetector(
      onTap: () {
        Get.to(
          () => const PremiumView(),
          transition: Transition.noTransition,
          duration: const Duration(milliseconds: 0),
        );
      },
      child: Container(
        width: Get.width,
        padding: EdgeInsets.symmetric(
          vertical: Get.width * 0.042,
          horizontal: Get.width * 0.02,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          image: DecorationImage(
            image: AssetImage(AppImage.premiumCard),
            fit: BoxFit.fitWidth,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
              child: _buildSvgImage(AppImage.whiteStarIc),
            ),
            Text(
              "Pro Upgrade to Premium",
              style: AppTextStyle.regularTextStyle.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.whiteColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// **Settings List**
  Widget _buildSettingsList() {
    return Column(
      children: [
        HBox(Get.height * 0.01),
        settingCard(
          title: "App Language",
          iconPath: AppImage.feedBackIc,
          onTap: () {
            Get.to(
              () => const LanguageView(),
              transition: Transition.noTransition,
              duration: const Duration(milliseconds: 0),
            );
          },
        ),
        settingCard(title: "Feedback", iconPath: AppImage.languageIc),
        settingCard(
          title: "Rate Us",
          iconPath: AppImage.rateUsIc,
          onTap: () async {
            int? stars = await Get.dialog(const RatingDialog());
            if (stars != null) {
              debugPrint('Selected rate stars: $stars');
            }
          },
        ),
        settingCard(
          title: "Share the App",
          iconPath: AppImage.shareIc,
          onTap: () async {
            try {
              await Share.share(
                "Check out this amazing app: https://play.google.com/store/apps/details?id=your.app.id",
              );
            } catch (e) {
              debugPrint("Error while sharing: $e");
            }
          },
        ),
        settingCard(title: "Terms of Use", iconPath: AppImage.termsOfUsIc),
        settingCard(title: "Privacy Policy", iconPath: AppImage.privacyPolicyIc),
      ],
    );
  }

  /// **Reusable Setting Card**
  Widget settingCard({required String iconPath, required String title, Function()? onTap}) {
    return GestureDetector(
      onTap: onTap ?? () {},
      child: Container(
        width: Get.width,
        margin: EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: AppColors.whiteColor.withAlpha( 0.1.toInt()),
        ),
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: Get.width * 0.042),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Get.width * 0.052),
                child: _buildSvgImage(iconPath),
              ),
              Text(
                title,
                style: AppTextStyle.regularTextStyle.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Spacer(),
              SvgPicture.asset(
                AppImage.rightIC,
                height: 15,
                width: 15,
              ),
              WBox(20),
            ],
          ),
        ),
      ),
    );
  }

  /// **SVG Image Loader with Error Handling**
  Widget _buildSvgImage(String assetPath) {
    return SvgPicture.asset(
      assetPath,
      width: 24,
      height: 24,
      placeholderBuilder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
      errorBuilder: (context, error, stackTrace) => const Icon(
        Icons.image_not_supported,
        color: Colors.white,
      ),
    );
  }
}
