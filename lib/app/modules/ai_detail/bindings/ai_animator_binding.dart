import 'package:get/get.dart';

import '../controllers/ai_animator_controller.dart';

class AiAnimatorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AiAnimatorController>(
          () => AiAnimatorController(),
    );
  }
}