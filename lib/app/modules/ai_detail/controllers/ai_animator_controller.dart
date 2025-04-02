import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../Reusability/utils/app_constants.dart';
import '../../../../Reusability/utils/network_dio/network_dio.dart';
import '../../../../Reusability/widgets/custom_snack_bar.dart';
import '../../../../main.dart';
import '../../../../model/faceSwap_textToImage_model.dart';
import '../../../../model/face_swap_text_to_image_getLink_model.dart';
import '../../../../model/image_upload_model.dart';
import '../../project/controllers/project_controller.dart';
import '../../splash/controllers/splash_controller.dart';

class AiAnimatorController extends GetxController {
  final ProjectController projectController = Get.find<ProjectController>();
  final NetworkDioHttp networkDioHttp = NetworkDioHttp();
  final SplashController splashController = Get.find<SplashController>();

  Rx<XFile> imagePath = XFile('').obs;
  RxBool isAutoValidate = false.obs;

  RxString generatedImageUrl = ''.obs;
  RxString filterID = ''.obs;

  // Separate loading states
  RxBool isUploadingImageLoading = false.obs;
  RxBool isGeneratingImageLoading = false.obs;

  RxInt currentIndex = RxInt(0);

  final CarouselSliderController carouselController = CarouselSliderController();

  RxList<String> selectedImages = <String>[].obs; // Stores all selected images
  RxString selectedImage = ''.obs; // Current selected image

  @override
  void onInit() {
    super.onInit();
    onResumeUpdate();
    ever(selectedImages, (_) {
      dataStorage.write('selectedImages', selectedImages.toList());
    });
  }

  // Add new image without replacing old ones
  void addImage(String imagePath) {
    if (!selectedImages.contains(imagePath)) {
      selectedImages.add(imagePath);
    }
    selectedImage.value = selectedImages.isNotEmpty ? selectedImages.last : '';
    dataStorage.write('selectedImages', selectedImages.toList());
    update();
  }

  void onResumeUpdate() {
    final storedImages = dataStorage.read<List<dynamic>>('selectedImages');
    if (storedImages != null) {
      selectedImages.clear();
      selectedImages.addAll(List<String>.from(storedImages));
      selectedImage.value = selectedImages.isNotEmpty ? selectedImages.first : '';
      update();
    }
  }

  void removeImage(String imagePath) {
    selectedImages.remove(imagePath);
    selectedImage.value = selectedImages.isNotEmpty ? selectedImages.first : '';
    dataStorage.write('selectedImages', selectedImages.toList());
    update();
  }

  @override
  void onReady() {
    super.onReady();
    onResumeUpdate();
  }

  /// **Upload Image & Get Link**
  Future<String?> getUploadImageLink({
    required String imagePath,
  }) async {
    if (imagePath.isEmpty) return null;

    File file = File(imagePath);
    isUploadingImageLoading.value = true;

    try {
      dio.FormData data = dio.FormData.fromMap({
        "image": await dio.MultipartFile.fromFile(file.path),
        "folderName": "user",
      });

      final response = await networkDioHttp.uploadMediaRequest(
        url: ApiAppConstants.apiEndPoint + ApiAppConstants.getImageLink,
        isHeader: true,
        name: "GET_IMAGE_LINK",
        formData: data,
        isBearer: true,
      );

      if (response?.statusCode == 200) {
        ImageUploadModel imageUploadModel = ImageUploadModel.fromJson(response?.data);
        return imageUploadModel.data?.urls?.first;
      }
      return null;
    } catch (e, stackTrace) {
      log("Error uploading image: $e\n$stackTrace");
      return null;
    } finally {
      isUploadingImageLoading.value = false;
    }
  }

  Future<void> faceSwapTextToImage({
    required String filterImage,
    required String userImage,
  }) async {
    try {
      isGeneratingImageLoading.value = true;

      final Map<String, dynamic> bodyData = {
        "filterImage": filterImage,
        "userImage": userImage,
        "usedCreditPoints": 1,
      };

      final response = await networkDioHttp.postRequest(
        url: ApiAppConstants.apiEndPoint + ApiAppConstants.faceSwapTextToImageCreate,
        isHeader: true,
        isBody: true,
        bodyData: bodyData,
        name: "FACE_SWAP_TEXT_TO_IMAGE",
      );

      // Stop loading animation after API call
      isGeneratingImageLoading.value = false;

      if (response != null) {
        FaceSwapTextToImageCreateModel textToImage = FaceSwapTextToImageCreateModel.fromJson(response.data);
        if (response.statusCode == 200 && textToImage.jobId != null) {
          // Proceed to get the images link
          faceSwapGetImagesLink(
            taskID: textToImage.jobId ?? '',
          );
        } else {
          // Handle case where no images are returned or if an error occurs
          debugPrint("No images data received.");
          CustomSnackBar.showCustomToast(
            toastType: ToastType.error,
            message: textToImage.message ?? 'Error generating image. Please try again later.',
          );
          // Ensure back navigation occurs only after error message is shown
          Future.delayed(Duration(seconds: 1), () {
            Get.back();
          });
        }
      } else {
        // If response is null or the request fails, show an error and navigate back
        debugPrint("Response was null");
        CustomSnackBar.showCustomToast(
          toastType: ToastType.error,
          message: 'Failed to generate image. Please try again later.',
        );
        Future.delayed(Duration(seconds: 1), () {
          Get.back();
        });
      }
    } catch (error) {
      // Handle any unexpected errors
      debugPrint("Error generating text to images: $error");

      // Make sure the loading state is updated
      isGeneratingImageLoading.value = false;
      CustomSnackBar.showCustomToast(
        toastType: ToastType.error,
        message: 'An error occurred while generating the image. Please try again later.',
      );

      // Ensure back navigation occurs after error message
      Future.delayed(Duration(seconds: 1), () {
        Get.back();
      });
    }
  }

  //get images link
  Future<void> faceSwapGetImagesLink({
    required String taskID,
  }) async {
    try {
      final bodyData = {
        "taskId": taskID,
      };

      isGeneratingImageLoading.value = true;

      bool isSuccess = false;

      while (!isSuccess) {
        final response = await networkDioHttp.postRequest(
          url: ApiAppConstants.apiEndPoint + ApiAppConstants.faceSwapTextToImageGetLink,
          isHeader: true,
          isBody: true,
          bodyData: bodyData,
          name: "FACE_SWAP_GET_IMAGES_LINK",
        );

        if (response != null && response.statusCode == 200) {
          FaceSwapTextToImageGetLinkModel getImagesModel = FaceSwapTextToImageGetLinkModel.fromJson(response.data);

          if (getImagesModel.success == true) {
            String? imageLinks = getImagesModel.imageDetails;
            await splashController.getCreditPoint();

            generatedImageUrl.value = imageLinks ?? '';
            isGeneratingImageLoading.value = false;
            isSuccess = true;
            projectController.getAllSwapImage();
          } else {
            debugPrint("Failed to fetch images. Retrying...");
            await Future.delayed(const Duration(seconds: 3));
          }
        } else {
          debugPrint("Error fetching image links: ${response?.data}");
          isSuccess = true;
        }
      }
    } catch (e) {
      debugPrint("Error getting image links: $e");

      isGeneratingImageLoading.value = false;
      _handleError("An unexpected error occurred.");
    }
  }

  /// **Handle Errors & Show Toast**
  void _handleError(String message) {
    isGeneratingImageLoading.value = false;
    isUploadingImageLoading.value = false;
    CustomSnackBar.showCustomToast(
      toastType: ToastType.error,
      message: message,
    );
    Get.back();
  }
}
