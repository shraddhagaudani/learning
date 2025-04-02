import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;


import 'package:crop_image/crop_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../Reusability/utils/app_colors.dart';
import '../../../../Reusability/utils/app_images.dart';
import '../../../../Reusability/utils/app_text_style.dart';
import '../../../../Reusability/widgets/common_widget.dart';
import '../../../../Reusability/widgets/custom_snack_bar.dart';
import '../controllers/crop_image_controller.dart';

class CropImageView extends StatelessWidget {
  final Uint8List? cropImagePath;
  final String filterTitle;

  const CropImageView({
    super.key,
    this.cropImagePath,
    required this.filterTitle,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CropImageController());

    if (cropImagePath != null) {
      controller.calculateImageAspectRatio(cropImagePath!);
      controller.detectFaces(cropImagePath!);
    }

    double squareSize = Get.width * 0.9;
    double adjustedHeight = squareSize * 1.4;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: Stack(
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
              top: Get.height * 0.15,
              left: (Get.width - squareSize) / 2,
              child: Center(
                child: Obx(() {
                  return Container(
                    height: adjustedHeight,
                    width: squareSize,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Stack(
                        children: [
                          controller.isCropViewShow.value
                              ? CropImage(
                                  controller: controller.cropController,
                                  image: Image.memory(
                                    cropImagePath!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                )
                              : Image.memory(
                                  cropImagePath!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                          _buildFaceDetectionOverlay(
                            squareSize,
                            adjustedHeight,
                            controller,
                          ),
                          if (!controller.isHumanFaceDetected.value && !controller.isDetectionComplete.value)
                            Positioned.fill(
                              child: Align(
                                alignment: Alignment.center,
                                child: SvgPicture.asset(
                                  AppImage.faceDetection,
                                  width: squareSize * 0.3,
                                  height: adjustedHeight * 0.3,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
            Positioned(
              top: Get.height * 0.785,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  width: Get.width,
                  height: Get.height * 0.022,
                  decoration: BoxDecoration(
                    color: Color(0xFF020711).withAlpha(0.5.toInt()),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: Get.height * 0.2,
                decoration: BoxDecoration(
                  color: AppColors.textBlackColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Obx(() {
                        return controller.isCropViewShow.value
                            ? Column(
                                children: [
                                  // Text(
                                  //   controller.isHumanFaceDetected.value ? "Human Face Detected" : "No Human Face Detected",
                                  //   style: TextStyle(
                                  //     fontSize: 16,
                                  //     fontWeight: FontWeight.bold,
                                  //     color: controller.isHumanFaceDetected.value ? Colors.green : Colors.red,
                                  //   ),
                                  // ),
                                  const SizedBox(height: 15),
                                  CommonButton(
                                    textVal: controller.isProcessing.value ? "Processing..." : "Continue",
                                    onPressed: controller.isProcessing.value
                                        ? null
                                        : () async {
                                            if (!controller.isHumanFaceDetected.value) {
                                              CustomSnackBar.showCustomToast(
                                                toastType: ToastType.error,
                                                message: "No human face detected. Please try again.",
                                              );
                                              return;
                                            }

                                            // Disable the button and show a loading state
                                            controller.isProcessing.value = true;

                                            // Proceed with cropping
                                            ui.Image croppedImage = await controller.cropController.croppedBitmap();
                                            final byteData = await croppedImage.toByteData(format: ui.ImageByteFormat.png);
                                            final buffer = byteData!.buffer.asUint8List();
                                            final directory = await getTemporaryDirectory();
                                            final filePath = '${directory.path}/cropped_image_${DateTime.now().millisecondsSinceEpoch}.png';
                                            await File(filePath).writeAsBytes(buffer);

                                            controller.aiAnimatorController.addImage(filePath);
                                            Get.back();
                                            Get.back();
                                          },
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  const Text(
                                    "Analyzing",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    "AI is analyzing face data in the photo...",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  LinearProgressIndicator(
                                    value: controller.progressValue.value,
                                    minHeight: 8,
                                    backgroundColor: Colors.white.withAlpha( 0.2.toInt()),
                                    valueColor: AlwaysStoppedAnimation(
                                      Color.lerp(Color(0xFF00B488), Color(0xFF004E3B), controller.progressValue.value)!,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),

                                ],
                              );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaceDetectionOverlay(double width, double height, CropImageController controller) {
    return Obx(() {
      return Stack(
        children: controller.detectedFaces.map((face) {
          final left = face.boundingBox.left * width;
          final top = face.boundingBox.top * height;
          final right = face.boundingBox.right * width;
          final bottom = face.boundingBox.bottom * height;

          return Positioned(
            left: left,
            top: top,
            width: right - left,
            height: bottom - top,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 2),
              ),
            ),
          );
        }).toList(),
      );
    });
  }

  Container _buildTopBar() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          CommonBackButton(
            width: Get.width * 0.1,
            height: Get.height * 0.05,
            onTap: () {
              Get.back();
            },
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Text(
              filterTitle,
              style: AppTextStyle.regularTextStyle.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
