import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../Reusability/utils/app_colors.dart';
import '../../../../Reusability/utils/app_images.dart';
import '../../../../Reusability/utils/app_text_style.dart';
import '../../../../Reusability/widgets/common_widget.dart';
import '../../../../Reusability/widgets/custom_snack_bar.dart';
import '../../ai_detail/controllers/ai_animator_controller.dart';
import '../../photo_details/controllers/photo_detail_controller.dart';
import '../controllers/image_generate_controller.dart';

class ImageGenerateView extends StatefulWidget {
  final String filterImage;
  final String imagePath;
  final String title;

  const ImageGenerateView({
    super.key,
    required this.filterImage,
    required this.imagePath,
    required this.title,
  });

  @override
  State<ImageGenerateView> createState() => _ImageGenerateViewState();
}

class _ImageGenerateViewState extends State<ImageGenerateView> {
  late PhotoDetailController photoDetailController;
  late ImageGenerateController controller = Get.put(ImageGenerateController());
  late AiAnimatorController aiAnimatorController;
  late String currentImage;
  late Timer _timer;

  void _startImageSwapTimer() {
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      controller.currentImage.value = controller.currentImage.value == widget.imagePath ? widget.filterImage : widget.imagePath;
      debugPrint("Current Image: ${controller.currentImage.value}");
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    photoDetailController = Get.find<PhotoDetailController>();
    aiAnimatorController = Get.find<AiAnimatorController>();
    controller.currentImage.value = widget.imagePath;
    _startImageSwapTimer();
    loading();
  }

  Future<void> generateImage({
    required String imagePath,
    required String filterImage,
  }) async {
    try {
      String? image = await aiAnimatorController.getUploadImageLink(
        imagePath: imagePath,
      );

      if (image != null) {
        await aiAnimatorController.faceSwapTextToImage(
          userImage: image,
          filterImage: filterImage,
        );
        debugPrint("Image generated using text to image.");
      } else {
        Get.back();
        CustomSnackBar.showCustomToast(toastType: ToastType.error, message: "Failed to upload image.");
        debugPrint("Failed to get uploaded image.");
      }
    } catch (error) {
      debugPrint("Error during image generation: $error");
    }
  }

  loading() async {
    aiAnimatorController.isUploadingImageLoading.value = true;

    // Simulating the image upload progress
    for (double i = 0; i <= 1.0; i += 0.1) {
      await Future.delayed(Duration(milliseconds: 500));
      controller.progressValue.value = i; // Update progressValue
    }

    aiAnimatorController.isUploadingImageLoading.value = false;

    aiAnimatorController.isGeneratingImageLoading.value = true;

    // Simulating the image generation progress
    for (double i = 0; i <= 1.0; i += 0.1) {
      await Future.delayed(Duration(milliseconds: 500));
      controller.progressValue.value = i; // Update progressValue
    }

    aiAnimatorController.isGeneratingImageLoading.value = false;

    // Trigger success by updating generated image URL or similar state
    aiAnimatorController.generatedImageUrl.value = 'https://ai-faceswap-asset.s3.amazonaws.com/Profession/undefined/1743068017303-4.webp'; // Set the generated image URL
    photoDetailController.isGenerationConfirmed.value = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            top: Get.height * 0.15,
            left: 0,
            right: 0,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                width: Get.width,
                height: Get.height * 0.22,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Obx(() {
                  if (aiAnimatorController.isUploadingImageLoading.value) {
                    return _buildLoadingAnimation('Taking longer than usual...');
                  } else if (aiAnimatorController.isGeneratingImageLoading.value) {
                    return _buildLoadingAnimation('Taking longer than usual...');
                  }

                  if (aiAnimatorController.generatedImageUrl.value.isNotEmpty) {
                    if (!photoDetailController.isGenerationConfirmed.value) {
                      photoDetailController.isGenerationConfirmed.value = true;
                    }

                    return _buildSuccessMessage();
                  }

                  return SizedBox();
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // **App Bar**
  Container _buildTopBar() {
    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CommonBackButton(
            width: Get.width * 0.1,
            height: Get.height * 0.05,
          ),
          GestureDetector(
            onTap: () async {},
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.whiteColor.withAlpha( 0.1.toInt()),
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: SvgPicture.asset(
                  AppImage.downloadIC,
                  color: Colors.grey,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  // Loading animation widget
  Widget _buildLoadingAnimation(String message) {
    return Obx(() {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(70),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 220,
                width: 140,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: AppColors.whiteColor),
                ),
                alignment: Alignment.center,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: controller.currentImage.value.startsWith('http')
                          ? CustomCachedNetworkImage(
                              imageUrl: controller.currentImage.value,
                              height: Get.height,
                              width: Get.width,
                              fit: BoxFit.cover,
                            )
                          : (File(controller.currentImage.value).existsSync()
                              ? CustomFileImage(
                                  imagePath: controller.currentImage.value,
                                  height: Get.height,
                                  width: Get.width,
                                  fit: BoxFit.cover,
                                )
                              : const Icon(Icons.error, color: Colors.red)),
                    ),
                    Positioned(
                      child: SvgPicture.asset(
                        AppImage.photoToggleAnimation,
                        // animate: true,
                        // repeat: true,
                        fit: BoxFit.fill,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.error, color: Colors.red);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              LinearProgressIndicator(
                minHeight: 8,
                backgroundColor: Colors.white.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation(
                  Color.lerp(Color(0xFF00B488), Color(0xFF004E3B), controller.progressValue.value)!,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              const SizedBox(height: 60),
              Text(
                message,
                textAlign: TextAlign.center,
                style: AppTextStyle.regularTextStyle.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  // Success message widget
  Widget _buildSuccessMessage() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(70),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SvgPicture.asset(AppImage.successAnimationLottie),
            const HBox(40),
            Text(
              "Successfully Generated your AI image",
              textAlign: TextAlign.center,
              style: AppTextStyle.regularTextStyle.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
            // const HBox(40),
            // CommonButton(
            //   btnWidth: Get.width * 0.5,
            //   textVal: "View Generation",
            //   onPressed: () {
            //     Get.back();
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
