
import 'package:get/get.dart';

import '../controllers/image_generate_controller.dart';

class ImageGenerateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ImageGenerateController>(
          () => ImageGenerateController(),
    );
  }
}