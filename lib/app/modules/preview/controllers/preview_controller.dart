import 'dart:io';


import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../Reusability/utils/process_indicator.dart';
import '../../../../Reusability/widgets/custom_snack_bar.dart';

class PreviewController extends GetxController {
  late Dio _dio;
  final RxDouble saveProgress = 0.0.obs;

  // final FlutterShareMe flutterShareMe = FlutterShareMe();
  @override
  void onInit() {
    // TODO: implement onInit
    _dio = Dio();
    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();

    _dio.close();
  }

  Future<void> saveImageGallery({required String imageType, required String imageUrl}) async {
    if (imageUrl.isEmpty) {
      CustomSnackBar.showCustomToast(toastType: ToastType.error, message: "Image URL is empty!");
      return;
    }

    try {
      final savePath = await _getSavePath(imageType: imageType);

      final response = await _dio.download(
        imageUrl,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            saveProgress.value = (received / total);
            update();
          }
        },
        options: Options(
          headers: {"Up-Scale": "false"},
        ),
      );

      if (response.statusCode == 200) {
        final file = File(savePath);
        if (file.existsSync()) {
          final imageBytes = await file.readAsBytes();
          img.Image? image = img.decodeImage(Uint8List.fromList(imageBytes));

          if (image != null) {
            await file.writeAsBytes(img.encodePng(image));
            // CustomSnackBar.showCustomToast(toastType: ToastType.success, message: "Download completed! Saved at $savePath");
            CustomSnackBar.showCustomToast(toastType: ToastType.success, message: "Your download is complete! The file has been saved.");
          }
        }
      } else {
        CustomSnackBar.showCustomToast(toastType: ToastType.error, message: "Save failed with status code: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Save failed: $e");
      CustomSnackBar.showCustomToast(toastType: ToastType.error, message: "Save failed: $e");
    }
  }

  Future<String> _getSavePath({String? imageType}) async {
    final directory = Directory('/storage/emulated/0/Download');

    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    String filePath = '';
    filePath = '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.$imageType';
    return filePath;
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


  // // Share to WhatsApp
  // Future<void> shareToWhatsApp({required String mediaUrl}) async {
  //   try {
  //     // Download the media file to a temporary directory
  //     final directory = await getTemporaryDirectory();
  //     String filePath = '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
  //
  //     final response = await _dio.get(mediaUrl, options: Options(responseType: ResponseType.bytes));
  //
  //     if (response.statusCode == 200) {
  //       final file = File(filePath);
  //       await file.writeAsBytes(response.data);
  //
  //       // Share the image to WhatsApp
  //       await flutterShareMe.shareToWhatsApp(imagePath: filePath, fileType: FileType.image, msg: 'Check out this image!');
  //       debugPrint('File shared successfully to WhatsApp: $filePath');
  //     } else {
  //       debugPrint("Error: Unable to download the file.");
  //     }
  //   } catch (e) {
  //     debugPrint("Error sharing to WhatsApp: $e");
  //   }
  // }
  //
  // // Share to Instagram
  // Future<void> shareToInstagram({required String mediaUrl}) async {
  //   try {
  //     // Download the media file to a temporary directory
  //     final directory = await getTemporaryDirectory();
  //     String filePath = '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
  //
  //     final response = await _dio.get(mediaUrl, options: Options(responseType: ResponseType.bytes));
  //
  //     if (response.statusCode == 200) {
  //       final file = File(filePath);
  //       await file.writeAsBytes(response.data);
  //
  //       // Share the image to Instagram
  //       await flutterShareMe.shareToInstagram(filePath: filePath, fileType: FileType.image);
  //       debugPrint('File shared successfully to Instagram: $filePath');
  //     } else {
  //       debugPrint("Error: Unable to download the file.");
  //     }
  //   } catch (e) {
  //     debugPrint("Error sharing to Instagram: $e");
  //   }
  // }
  //
  // // Share to Facebook
  // Future<void> shareToFacebook({required String mediaUrl}) async {
  //   try {
  //     // Share URL to Facebook with a message
  //     String message = "Check out this content!";
  //     await flutterShareMe.shareToFacebook(url: mediaUrl, msg: message);
  //     debugPrint('File shared successfully to Facebook');
  //   } catch (e) {
  //     debugPrint("Error sharing to Facebook: $e");
  //   }
  // }
}
