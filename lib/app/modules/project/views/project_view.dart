
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../Reusability/utils/app_colors.dart';
import '../../../../Reusability/utils/app_images.dart';
import '../../../../Reusability/utils/app_text_style.dart';
import '../../../../Reusability/widgets/common_widget.dart';
import '../../../../model/get_all_swap_image_model.dart';
import '../../ai_detail/controllers/ai_animator_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../main_home/controllers/main_home_controller.dart';
import '../../photo_select/controllers/photo_select_controller.dart';
import '../../preview/views/preview.dart';
import '../controllers/project_controller.dart';

class ProjectView extends StatefulWidget {
  const ProjectView({super.key});

  @override
  State<ProjectView> createState() => _ProjectViewState();
}

class _ProjectViewState extends State<ProjectView> with WidgetsBindingObserver {
  final ProjectController controller = Get.find<ProjectController>();
  final PhotoSelectController photoSelectController = Get.put(PhotoSelectController());
  final AiAnimatorController aiAnimatorController = Get.put(AiAnimatorController());
  final HomeController homeController = Get.find<HomeController>();
  final MainHomeController mainHomeController = Get.find<MainHomeController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    homeController.showScrollToTopButton.value = false;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      homeController.showScrollToTopButton.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        children: [
          Image.asset(
            AppImage.appBarGradient,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Positioned(top: Get.height * 0.056, left: 0, right: 0, child: _buildTopBar()),
          Positioned(
            top: Get.height * 0.146,
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.textBlackColor,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: Get.height * 0.01),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() => controller.categories.isNotEmpty
                        ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: controller.categories
                              .where((category) => controller.categorizedImages[category]?.isNotEmpty ?? false)
                              .map((category) {
                            return GestureDetector(
                              onTap: () {
                                controller.changeTabIndex(controller.categories.indexOf(category));
                                controller.updateCategoryImages(category);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                decoration: BoxDecoration(
                                  color: controller.tabIndex.value == controller.categories.indexOf(category)
                                      ? AppColors.whiteColor.withAlpha( 0.15.toInt())
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(category, style: AppTextStyle.regularTextStyle),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    )
                        : SizedBox.shrink()),

                    Expanded(
                      child: Obx(() {
                        if (!controller.isDataLoaded.value) {
                          return Center(child: CircularProgressIndicator());
                        }

                        String selectedCategory = controller.categories[controller.tabIndex.value];
                        List<SwapImageDetail> images = controller.categorizedImages[selectedCategory] ?? [];

                        return images.isNotEmpty
                            ? Padding(
                          padding: const EdgeInsets.all(10),
                          child: GridView.builder(
                            padding: EdgeInsets.zero,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 8.0,
                              mainAxisSpacing: 8.0,
                              childAspectRatio: 0.75,
                            ),
                            itemCount: images.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Get.to(
                                        () => PreView(url: images[index].generatedImage!),
                                    transition: Transition.noTransition,
                                    duration: Duration(milliseconds: 0),
                                  );
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CustomCachedNetworkImage(
                                    imageUrl: images[index].generatedImage!,
                                    fit: BoxFit.cover,
                                    cacheKey: images[index].generatedImage!,
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                            : _buildNoDataUI("No Projects yet", "There are no projects in your\nfolder as of now.");
                      }),
                    )

                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container _buildTopBar() {
    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          CommonBackButton(
            width: Get.width * 0.1,
            height: Get.height * 0.05,
            onTap: () {
              homeController.showScrollToTopButton.value = false;
              mainHomeController.currentIndex.value = 0;
            },
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              mainHomeController.currentIndex.value = 2;
            },
            child: Container(
              width: Get.width * 0.1,
              height: Get.height * 0.05,
              decoration: BoxDecoration(
                color: AppColors.whiteColor.withAlpha(0.1.toInt()),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.asset(
                  AppImage.settingIc,
                  width: 25,
                  height: 25,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildNoDataUI(String title, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            AppImage.noImage,
            height: Get.height * 0.1,
            width: Get.width * 0.25,
          ),
          SizedBox(height: Get.height * 0.04),
          Text(
            title,
            style: AppTextStyle.regularTextStyle.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTextStyle.regularTextStyle.copyWith(
              fontSize: 16,
              color: AppColors.textLightGrey,
              height: 1.8,
            ),
          ),
          SizedBox(height: Get.height * 0.04),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Get.width * 0.18),
            child: CommonButton(
              textVal: "Create a project",
              onPressed: () {
                homeController.showScrollToTopButton.value = false;
                mainHomeController.currentIndex.value = 0;
              },
            ),
          ),
        ],
      ),
    );
  }
}
