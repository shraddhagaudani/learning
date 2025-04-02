import 'dart:io';
import 'dart:typed_data';


import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../Reusability/utils/app_constants.dart';
import '../../../../Reusability/utils/app_strings.dart';
import '../../../../Reusability/utils/network_dio/network_dio.dart';
import '../../../../Reusability/utils/process_indicator.dart';
import '../../../../Reusability/widgets/custom_snack_bar.dart';
import '../../splash/controllers/splash_controller.dart';

class PhotoDetailController extends GetxController {
  final NetworkDioHttp networkDioHttp = NetworkDioHttp();
  final GlobalKey repaintBoundaryKey = GlobalKey();
  final formKey = GlobalKey<FormState>();
  late Dio _dio;
  TextEditingController promptController = TextEditingController();
  RxInt tabIndex = 0.obs;
  Rx<String?> selectedSubcategoryId = Rx<String?>(null);
  String? imageUrl;
  RxString selectedFilterId = ''.obs;
  RxString selectedCategoryId = ''.obs;
  RxString selectedFilterImage = ''.obs;
  final RxBool isLongPressed = false.obs;
  final RxBool isGenerationConfirmed = false.obs;
  final RxInt upScaleValue = 0.obs;
  final SplashController splashController = Get.find<SplashController>();
  final RxDouble downloadProgress = 0.0.obs;

  // Constructor
  PhotoDetailController({this.imageUrl});

  @override
  void onInit() {
    super.onInit();
    _dio = Dio();
  }

  @override
  void dispose() {
    super.dispose();
    _dio.close();
  }

  // Handle downloading image
  Future<void> downloadImage({required String imageType, String? imageUrl}) async {
    if (imageUrl == null) return;

    try {
      final upscaleResolution = upScaleValue.value == 0 ? 2048 : 4096;

      // Save image directly, without checking for filtered state
      final savePath = await _getDownloadPath(fileType: AppStrings.image, imageType: imageType);

      // Perform the download
      final response = await _dio.download(
        imageUrl,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            downloadProgress.value = (received / total);
            update();
          }
        },
        options: Options(
          headers: {"Up-Scale": upscaleResolution.toString()},
        ),
      );

      if (response.statusCode == 200) {
        final file = File(savePath);
        if (file.existsSync()) {
          final imageBytes = await file.readAsBytes();
          img.Image? image = img.decodeImage(Uint8List.fromList(imageBytes));

          if (image != null) {
            img.Image resizedImage = img.copyResize(image, width: upscaleResolution, height: upscaleResolution);

            await file.writeAsBytes(img.encodePng(resizedImage));

            CustomSnackBar.showCustomToast(toastType: ToastType.success, message: "Download completed! Saved at $savePath");
            debugPrint("Download completed! Saved at $savePath");

            // await _deductCreditScoreBasedOnUpScale();
          }
        }
      } else {
        debugPrint("Download failed with status code: ${response.statusCode}");
        CustomSnackBar.showCustomToast(toastType: ToastType.error, message: "Download failed with status code: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Download failed: $e");
      CustomSnackBar.showCustomToast(toastType: ToastType.error, message: "Download failed: $e");
    }
  }

  Future<void> shareMedia(String mediaUrl, String mediaType) async {
    try {
      Loader.show();
      final directory = await getTemporaryDirectory();
      String filePath = '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.$mediaType';

      final response = await _dio.get(mediaUrl, options: Options(responseType: ResponseType.bytes));
      Loader.hide();
      if (response.statusCode == 200) {
        Loader.hide();
        final file = File(filePath);
        await file.writeAsBytes(response.data);
        await Share.shareXFiles([XFile(filePath)], text: 'Check out this media!');
        debugPrint('File shared successfully: $filePath');
      } else {
        Loader.hide();
        debugPrint("Error: Unable to download the file.");
      }
    } catch (e) {
      Loader.hide();
      debugPrint("Error sharing media: $e");
    }
  }

  Future<String> _getDownloadPath({required String fileType, String? imageType}) async {
    final directory = Directory('/storage/emulated/0/Download');

    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    String filePath = '';

    filePath = '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.$imageType';

    return filePath;
  }

  Future<void> _deductCreditScoreBasedOnUpScale() async {
    int creditToDeduct = 0;

    if (upScaleValue.value == 0) {
      creditToDeduct = 1;
    } else if (upScaleValue.value == 1) {
      creditToDeduct = 2;
    } else {
      creditToDeduct = 3;
    }
    Loader.show();
    await deductCreditScore(creditScore: creditToDeduct);

    Loader.hide();
  }

  // Deduct  credit score upScaleValue
  Future<void> deductCreditScore({required int creditScore}) async {
    try {
      final bodyData = {
        "creditPoints": creditScore,
      };
      final response = await networkDioHttp.postRequest(
        url: "${ApiAppConstants.apiEndPoint}${ApiAppConstants.deductCreditPoint}",
        isHeader: true,
        isBody: true,
        bodyData: bodyData,
        name: "DEDUCT_CREDIT_POINT",
      );

      if (response != null && response.statusCode == 200 && response.data != null) {
        await splashController.getCreditPoint();
      } else {
        debugPrint("Failed to retrieve credit data.");
      }
    } catch (error) {
      CustomSnackBar.showCustomToast(
        toastType: ToastType.error,
        message: "Error fetching credit data: $error",
      );
      debugPrint("Error fetching credit: $error");
    }
  }
}
