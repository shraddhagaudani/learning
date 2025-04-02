
import 'package:get/get.dart';

import '../controllers/photo_select_controller.dart';

class PhotoSelectBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PhotoSelectController>(
          () => PhotoSelectController(),
    );
  }
}