
import 'package:get/get_navigation/src/routes/get_route.dart';

import '../app/modules/ai_detail/bindings/ai_animator_binding.dart';
import '../app/modules/ai_detail/views/ai_animator_view.dart';
import '../app/modules/crop_image/bindings/crop_image_binding.dart';
import '../app/modules/crop_image/views/crop_image_view.dart';
import '../app/modules/home/bindings/home_binding.dart';
import '../app/modules/home/views/home_view.dart';
import '../app/modules/main_home/bindings/home_binding.dart';
import '../app/modules/main_home/views/main_home_view.dart';
import '../app/modules/onboarding/bindings/onboarding_binding.dart';
import '../app/modules/onboarding/views/onboarding_view.dart';
import '../app/modules/photo_select/bindings/photo_select_binding.dart';
import '../app/modules/photo_select/views/photo_select_view.dart';
import '../app/modules/project/bindings/project_binding.dart';
import '../app/modules/project/views/project_view.dart';
import '../app/modules/setting/bindings/setting_binding.dart';
import '../app/modules/setting/views/setting_view.dart';
import '../app/modules/splash/bindings/splash_binding.dart';
import '../app/modules/splash/views/splash_view.dart';
import '../model/getAll_category_model.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  // ignore: constant_identifier_names
  static String initial = Routes.splash;

  static final routes = [
    GetPage(
      name: _Paths.splash,
      page: () => SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.onBoarding,
      page: () => OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: _Paths.home,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.mainHome,
      page: () => MainHomeView(),
      binding: MainHomeBinding(),
    ),
    GetPage(
      name: _Paths.aiAnimator,
      page: () => AiAnimatorView(
        imageUrl: '',
        filterName: '',
        filterCategory: List.empty(),
        selectedCategory: FilterCategory(),
        filterID: '',
        initialIndex: 0,
      ),
      binding: AiAnimatorBinding(),
    ),
    GetPage(
      name: _Paths.setting,
      page: () => SettingView(),
      binding: SettingBinding(),
    ),
    GetPage(
      name: _Paths.project,
      page: () => ProjectView(),
      binding: ProjectBinding(),
    ),
    GetPage(
      name: _Paths.aiDetails,
      page: () => AiAnimatorView(
        imageUrl: '',
        filterName: '',
        filterID: '',
        filterCategory: [],
        selectedCategory: FilterCategory(),
        initialIndex: 0,
      ),
      binding: AiAnimatorBinding(),
    ),
    GetPage(
      name: _Paths.project,
      page: () => CropImageView(
        filterTitle: '',
      ),
      binding: CropImageBinding(),
    ),
    GetPage(
      name: _Paths.selectPhotoView,
      page: () => SelectPhotoView(
        filterName: '',
      ),
      binding: PhotoSelectBinding(),
    ),
  ];
}
