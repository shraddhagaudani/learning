
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../Reusability/utils/app_colors.dart';
import '../../../../Reusability/utils/app_images.dart';
import '../../../../Reusability/utils/app_text_style.dart';
import '../../../../Reusability/widgets/common_widget.dart';
import '../../../../main.dart';
import '../../home/controllers/home_controller.dart';
import '../../main_home/controllers/main_home_controller.dart';
import '../controllers/preview_controller.dart';

class PreView extends StatefulWidget {
  final String url;

  const PreView({
    Key? key,
    required this.url,
  }) : super(key: key);

  @override
  PreViewState createState() => PreViewState();
}

class PreViewState extends State<PreView> with WidgetsBindingObserver {
  final PreviewController controller = Get.put(PreviewController());
  final MainHomeController mainHomeController = Get.find<MainHomeController>();
  final HomeController homeController = Get.find<HomeController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    homeController.showScrollToTopButton.value = false;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      homeController.showScrollToTopButton.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    logger.d("Image or video url: ${widget.url}");

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            AppImage.appBarGradient,
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
            top: Get.height * 0.2,
            height: Get.height * 0.55,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Container(
                width: Get.width,
                height: Get.height,
                decoration: BoxDecoration(
                  color: Color(0xFF020711).withAlpha(0.5.toInt()),
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: CustomCachedNetworkImage(
                        width: Get.width,
                        height: Get.height,
                        imageUrl: widget.url,
                        fit: BoxFit.fill,
                        containerColor: AppColors.backgroundColor,
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: GestureDetector(
                        onTap: () {
                          // Implement editing functionality
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.black10.withAlpha(0.1.toInt()),
                            shape: BoxShape.circle,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: SvgPicture.asset(AppImage.editIC),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: Get.height * 0.8,
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.textBlackColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Share result to",
                      style: AppTextStyle.regularTextStyle.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildSocialMediaButton(AppImage.downloadIC, () async {
                          await controller.saveImageGallery(imageType: "jpeg", imageUrl: widget.url);
                        }),
                        buildSocialMediaButton(AppImage.whatSAppIC, () async {
                          // await controller.shareToWhatsApp(mediaUrl: widget.url);
                        }),
                        buildSocialMediaButton(AppImage.faceBookIC, () async {
                          // await controller.shareToFacebook(mediaUrl: widget.url);
                        }),
                        buildSocialMediaButton(AppImage.instagramIC, () async {
                          // await controller.shareToInstagram(mediaUrl: widget.url);
                        }),
                        buildSocialMediaButton(AppImage.moreIC, () async {
                          await controller.shareMedia(widget.url, 'jpg');
                        }),
                      ],
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
          _buildSaveProgressWidget(),
        ],
      ),
    );
  }

  // Helper function to create social media share buttons
  Widget buildSocialMediaButton(String iconPath, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: AppColors.whiteColor.withAlpha( 0.1.toInt()),
          shape: BoxShape.circle,
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: SvgPicture.asset(iconPath),
        ),
      ),
    );
  }

  // Top bar UI
  Container _buildTopBar() {
    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          CommonBackButton(
            width: Get.width * 0.1,
            height: Get.height * 0.05,
          ),
          SizedBox(width: 20),
          Expanded(
            child: Text(
              "Save & Share",
              style: AppTextStyle.regularTextStyle.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Get.back();
              homeController.showScrollToTopButton.value = false;
              mainHomeController.currentIndex.value = 0;
            },
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.whiteColor.withAlpha( 0.1.toInt()),
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.5),
                child: SvgPicture.asset(AppImage.homeIc),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget that shows download progress
  Widget _buildSaveProgressWidget() {
    return Obx(() {
      if (controller.saveProgress.value > 0.0 && controller.saveProgress.value < 1.0) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Downloading...",
                        style: AppTextStyle.regularTextStyle.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textBlackColor,
                        ),
                      ),
                      Text(
                        "${(controller.saveProgress.value * 100).toStringAsFixed(2)}%",
                        style: AppTextStyle.regularTextStyle.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textBlackColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Get.height * 0.02),
                  LinearProgressIndicator(
                    value: controller.saveProgress.value,
                    backgroundColor: AppColors.greyColor,
                    color: Colors.blue,
                  ),
                ],
              ),
            ),
          ),
        );
      } else {
        return SizedBox.shrink();
      }
    });
  }
}
