import 'package:get/get.dart';

import '../controllers/crop_image_controller.dart';

class CropImageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CropImageController>(
          () => CropImageController(),
    );
  }
}