
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../Reusability/widgets/permission_dialog.dart';

class HomeController extends GetxController {
  RxInt currentIndex = RxInt(0);

  final ScrollController scrollController = ScrollController();
  RxBool showScrollToTopButton = false.obs;

  @override
  void onInit() {

    requestPermissions();
    super.onInit();
  }



  Future<void> requestPermissions() async {
    // Request camera permission
    var cameraStatus = await Permission.camera.request();
    if (cameraStatus.isGranted) {
      debugPrint("Camera permission granted");
    } else {
      debugPrint("Camera permission denied");
    }

    // Delay before requesting storage permission
    Future.delayed(Duration(milliseconds: 500), () async {
      var storageStatus = await Permission.storage.request();
      if (storageStatus.isGranted) {
        debugPrint("Storage permission granted");
      } else {
        debugPrint("Storage permission denied");
      }

      // Request Manage External Storage permission
      // if (await Permission.manageExternalStorage.isGranted) {
      //   debugPrint("Manage External Storage permission granted");
      // } else {
      //   if (await Permission.manageExternalStorage.isDenied) {
      //     debugPrint("Manage External Storage permission denied");
      //
      //     // Show the dialog if the permission is denied
      //     if (!await Permission.manageExternalStorage.isPermanentlyDenied) {
      //       // showPermissionDialog(permissionType: 'Manage External Storage');
      //     }
      //   }
      //
      //   // Check if permanently denied
      //   if (await Permission.manageExternalStorage.isPermanentlyDenied) {
      //     debugPrint("Manage External Storage permission permanently denied. Please enable it from settings.");
      //   }
      // }

      // Handle Camera Permission Denied
      if (cameraStatus.isDenied && !cameraStatus.isPermanentlyDenied) {
        debugPrint("Requesting Camera permission dialog...");
        showPermissionDialog(permissionType: 'Camera');
      }

      // Handle Storage Permission Denied
      if (storageStatus.isDenied && !storageStatus.isPermanentlyDenied) {
        debugPrint("Requesting Storage permission dialog...");
        // showPermissionDialog(permissionType: 'Storage');
      }

      // Handle Permanent Denial of Storage Permission
      if (storageStatus.isPermanentlyDenied) {
        debugPrint("Storage permission permanently denied. Please enable it from settings.");
      }

      // Handle Permanent Denial of Manage External Storage Permission
      // if (await Permission.manageExternalStorage.isPermanentlyDenied) {
      //   debugPrint("Manage External Storage permission permanently denied. Please enable it from settings.");
      // }
    });
  }

//permission dialog
  showPermissionDialog({required String permissionType}) {
    Get.dialog(
      PermissionDialog(
        permissionType: permissionType,
        onSettingPressed: () {
          Get.back();
          openAppSettings();
        },
      ),
    );
  }

  onTopScroll() {
    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}
