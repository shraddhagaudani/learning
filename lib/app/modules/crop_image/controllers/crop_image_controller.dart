import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:crop_image/crop_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:path_provider/path_provider.dart';

import '../../ai_detail/controllers/ai_animator_controller.dart';

class CropImageController extends GetxController {
  RxBool isCropViewShow = false.obs;
  RxDouble progressValue = 0.0.obs;
  RxBool isHumanFaceDetected = false.obs;
  RxBool isDetectionComplete = false.obs;
  RxBool isProcessing = false.obs;
  RxList<Face> detectedFaces = <Face>[].obs;
  RxDouble imageAspectRatio = 0.8.obs;

  final cropController = CropController(
    defaultCrop: const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9),
  );

  final AiAnimatorController aiAnimatorController = Get.find<AiAnimatorController>();
  late Timer _timer;

  @override
  void onInit() {
    super.onInit();
    _startProgressAnimation();
  }

  void _startProgressAnimation() {
    const duration = Duration(milliseconds: 100);
    const maxProgress = 1.0;

    _timer = Timer.periodic(duration, (timer) {
      if (progressValue.value < maxProgress && !isHumanFaceDetected.value && !isDetectionComplete.value) {
        progressValue.value += 0.05;
      } else {
        timer.cancel();
        isCropViewShow.value = true;
      }
    });
  }

  Future<void> calculateImageAspectRatio(Uint8List imageBytes) async {
    final codec = await ui.instantiateImageCodec(imageBytes);
    final frame = await codec.getNextFrame();
    final width = frame.image.width;
    final height = frame.image.height;

    imageAspectRatio.value = width / height;
  }

  Future<void> detectFaces(Uint8List imageBytes) async {
    if (imageBytes.isEmpty) return;

    final inputImage = InputImage.fromFilePath(await _saveImageLocally(imageBytes));
    final faceDetector = FaceDetector(options: FaceDetectorOptions(performanceMode: FaceDetectorMode.accurate));
    final List<Face> faces = await faceDetector.processImage(inputImage);

    detectedFaces.value = faces;
    isHumanFaceDetected.value = faces.isNotEmpty;
    progressValue.value = isHumanFaceDetected.value ? 1.0 : progressValue.value;

    if (!isHumanFaceDetected.value) {
      if (!isHumanFaceDetected.value) {
        isDetectionComplete.value = true;
      }
    }

    faceDetector.close();
  }

  Future<String> _saveImageLocally(Uint8List imageBytes) async {
    final directory = await getTemporaryDirectory();
    final filePath = '${directory.path}/temp_image.png';
    final file = File(filePath);
    await file.writeAsBytes(imageBytes);
    return filePath;
  }

  @override
  void onClose() {
    _timer.cancel();
    super.onClose();
  }
}
