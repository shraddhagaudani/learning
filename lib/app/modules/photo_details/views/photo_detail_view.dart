import 'dart:io';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../Reusability/utils/app_colors.dart';
import '../../../../Reusability/utils/app_images.dart';
import '../../../../Reusability/utils/app_text_style.dart';
import '../../../../Reusability/widgets/common_widget.dart';
import '../../../../Reusability/widgets/custom_snack_bar.dart';
import '../../../../main.dart';
import '../../../../model/getAll_category_model.dart';
import '../../ai_detail/controllers/ai_animator_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../image_generation/views/image_generate_view.dart';
import '../../main_home/controllers/main_home_controller.dart';
import '../../photo_select/controllers/photo_select_controller.dart';
import '../../splash/controllers/splash_controller.dart';
import '../controllers/photo_detail_controller.dart';

class PhotoDetailsView extends StatefulWidget {
  final String imageUrl;
  final String? imagePath;
  final String? title;
  final List<FilterCategory> filterCategory;
  final FilterCategory? selectedCategory;
  final String filterID;

  const PhotoDetailsView({
    super.key,
    required this.imageUrl,
    this.imagePath,
    this.title,
    required this.filterCategory,
    required this.selectedCategory,
    required this.filterID,
  });

  @override
  State<PhotoDetailsView> createState() => _PhotoDetailsViewState();
}

class _PhotoDetailsViewState extends State<PhotoDetailsView> {
  final aiAnimatorController = Get.find<AiAnimatorController>();
  late PhotoSelectController photoSelectController;
  final mainHomeController = Get.find<MainHomeController>();
  final HomeController homeController = Get.find<HomeController>();
  final SplashController splashController = Get.find<SplashController>();

  late PhotoDetailController controller;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    photoSelectController = Get.put(PhotoSelectController());
    controller = Get.put(PhotoDetailController(imageUrl: widget.imageUrl));

    controller.tabIndex.value = 0;
    controller.isGenerationConfirmed.value = false;

    controller.selectedSubcategoryId.value = widget.selectedCategory?.id ?? (widget.filterCategory.isNotEmpty ? widget.filterCategory.first.id ?? '' : '');

    _handleInitialFilterShow();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  Future<void> _handleInitialFilterShow() async {
    try {
      var selectedFilter = widget.filterCategory
          .firstWhere((category) => category.id == controller.selectedSubcategoryId.value, orElse: () => FilterCategory())
          .filters
          ?.firstWhere((filter) => filter.id == widget.filterID, orElse: () => Filter());

      if (selectedFilter != null) {
        controller.selectedFilterId.value = selectedFilter.id ?? '';
        controller.selectedCategoryId.value = controller.selectedSubcategoryId.value ?? '';
        controller.selectedFilterImage.value = selectedFilter.image ?? '';

        // Get.to(
        //   () => ImageGenerateView(
        //     imagePath: widget.imagePath ?? '',
        //     filterImage: selectedFilter.image ?? '',
        //     title: widget.title ?? '',
        //   ),
        //   transition: Transition.noTransition,
        // );
      }
    } catch (e) {
      debugPrint('Error in _handleInitialFilterShow: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    logger.i("filter Category length: ${widget.filterCategory.length}\nselected Category: ${widget.selectedCategory?.id ?? 'No ID'}");
    logger.i("Image Path: ${widget.imagePath}");
    return WillPopScope(
      onWillPop: () {
        Get.dialog(
          showDiscardDialog(
            onDiscardPressed: () {
              aiAnimatorController.generatedImageUrl.value = '';
              mainHomeController.currentIndex.value = 0;
              Get.until((route) => route.isFirst);
              Get.back();
            },
            onCancelPressed: () {
              Get.back();
            },
          ),
          barrierColor: Colors.transparent,
        );

        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              AppImage.appBarGradient,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            Positioned(
              top: Get.height * 0.055,
              left: 0,
              right: 0,
              child: _buildTopBar(),
            ),
            Positioned(
              top: Get.height * 0.15,
              height: Get.height * 0.55,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Container(
                  width: Get.width,
                  height: Get.height,
                  decoration: BoxDecoration(
                    color: Color(0xFF020711).withAlpha( 0.5.toInt()),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: Obx(() {
                    return aiAnimatorController.generatedImageUrl.value.isNotEmpty && controller.isGenerationConfirmed.value ? _buildGeneratedImage() : _buildImageWidget();
                  }),
                ),
              ),
            ),
            Positioned(
              top: Get.height * 0.65,
              left: Get.width * 0.4,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: FileImage(File(widget.imagePath ?? '')),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            begin: FractionalOffset(0.0, 1.0),
                            end: FractionalOffset(1.0, 0.5),
                            stops: [0.0, 0.8],
                            colors: AppColors.appGreenGradientColor,
                          ),
                        ),
                        child: SvgPicture.asset(AppImage.compareIC),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.textBlackColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Obx(() {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (controller.selectedSubcategoryId.value != null && widget.filterCategory.isNotEmpty) {
                      int selectedIndex = widget.filterCategory.indexWhere(
                        (category) => category.id == controller.selectedSubcategoryId.value,
                      );

                      if (selectedIndex != -1) {
                        double scrollToPosition = selectedIndex * (Get.width * 0.25 + 8);
                        double maxScroll = _scrollController.position.maxScrollExtent;
                        _scrollController.animateTo(
                          scrollToPosition > maxScroll ? maxScroll : scrollToPosition,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    }
                  });

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          controller: _scrollController,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: Get.width * 0.024,
                              vertical: Get.height * 0.01,
                            ),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white10,
                                      shape: BoxShape.circle,
                                    ),
                                    child: SvgPicture.asset(AppImage.gridAppIC),
                                  ),
                                ),
                                WBox(5),
                                Row(
                                  children: widget.filterCategory.map((item) {
                                    return GestureDetector(
                                      onTap: () {
                                        controller.selectedSubcategoryId.value = item.id ?? '';
                                      },
                                      child: Obx(() {
                                        return Container(
                                          decoration: BoxDecoration(
                                            color: controller.selectedSubcategoryId.value == item.id ? AppColors.black45 : Colors.white10,
                                            borderRadius: BorderRadius.circular(100),
                                          ),
                                          margin: const EdgeInsets.symmetric(horizontal: 5),
                                          padding: EdgeInsets.symmetric(
                                            vertical: Get.height * 0.01,
                                            horizontal: Get.width * 0.05,
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            item.id ?? item.id?.capitalizeFirst ?? '',
                                            style: AppTextStyle.regularTextStyle.copyWith(
                                              fontSize: 12,
                                              fontWeight: controller.selectedSubcategoryId.value == item.id ? FontWeight.w700 : FontWeight.w400,
                                              color: AppColors.whiteColor,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        );
                                      }),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Obx(() {
                        String? selectedSubcategoryId = controller.selectedSubcategoryId.value;
                        var category = widget.filterCategory.firstWhere(
                          (cat) => cat.id == selectedSubcategoryId,
                          orElse: () => FilterCategory(id: '', filters: []),
                        );

                        if (category.filters == null || category.filters!.isEmpty) {
                          return const SizedBox.shrink();
                        }

                        return Container(
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Container(
                                  width: 50,
                                  height: Get.height * 0.17,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), color: Colors.white10),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: <Widget>[
                                      Positioned(
                                        top: Get.height * 0.07,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Transform.rotate(
                                                angle: 90.00000250447808 * (-math.pi / 180),
                                                child: Text(
                                                  'Custom',
                                                  textAlign: TextAlign.left,
                                                  style: AppTextStyle.regularTextStyle,
                                                ),
                                              ),
                                              SizedBox(height: 30),
                                              SvgPicture.asset(
                                                AppImage.addIC,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Container(
                                    decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(10)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: List.generate(
                                          category.filters?.length ?? 0,
                                          (filterIndex) {
                                            var filter = category.filters?[filterIndex];
                                            bool isSelected = controller.selectedFilterId.value == filter?.id && controller.selectedCategoryId.value == selectedSubcategoryId;

                                            return GestureDetector(
                                              onTap: () async {
                                                if (splashController.creditPoint.value.data?.creditPoints == 0) {
                                                  CustomSnackBar.showCustomToast(
                                                    toastType: ToastType.error,
                                                    message: 'Insufficient credit points',
                                                  );
                                                  return;
                                                }

                                                if (aiAnimatorController.generatedImageUrl.value.isNotEmpty) {

                                                  if (controller.selectedFilterId.value != filter?.id) {
                                                    controller.selectedFilterId.value = filter?.id ?? '';
                                                    controller.selectedCategoryId.value = selectedSubcategoryId ?? '';
                                                    logger.w("selected Filter ID :${filter?.id}");
                                                    controller.selectedFilterImage.value = filter?.image ?? '';

                                                    Get.to(
                                                      () => ImageGenerateView(
                                                        imagePath: widget.imagePath ?? '',
                                                        filterImage: filter?.image ?? '',
                                                        title: '',
                                                      ),
                                                      transition: Transition.noTransition,
                                                    );
                                                  }
                                                } else {
                                                  if (controller.selectedFilterId.value != filter?.id) {
                                                    controller.selectedFilterId.value = filter?.id ?? '';
                                                    controller.selectedCategoryId.value = selectedSubcategoryId ?? '';
                                                    logger.w("selected Filter ID :${filter?.id}");
                                                    controller.selectedFilterImage.value = filter?.image ?? '';
                                                    Get.to(
                                                      () => ImageGenerateView(
                                                        imagePath: widget.imagePath ?? '',
                                                        filterImage: filter?.image ?? '',
                                                        title: '',
                                                      ),
                                                      transition: Transition.noTransition,
                                                    );
                                                  }
                                                }
                                              },
                                              child: Container(
                                                margin: EdgeInsets.symmetric(horizontal: 3),
                                                decoration: BoxDecoration(
                                                  gradient: isSelected
                                                      ? LinearGradient(
                                                          colors: AppColors.appGreenGradientColor,
                                                          begin: FractionalOffset(0.0, 1.0),
                                                          end: FractionalOffset(1.0, 0.6),
                                                          stops: [0.0, 0.8],
                                                        )
                                                      : null,
                                                  borderRadius: BorderRadius.circular(14),
                                                ),
                                                child: Stack(
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.all(3),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white.withAlpha(.1.toInt()),
                                                        borderRadius: BorderRadius.circular(14),
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(10),
                                                        child: CustomCachedNetworkImage(
                                                          imageUrl: filter?.image ?? '',
                                                          height: Get.height * 0.14,
                                                          width: Get.width * 0.22,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                    if (isSelected)
                                                      Positioned(
                                                        bottom: 5,
                                                        right: 5,
                                                        child: Container(
                                                          width: Get.width * 0.06,
                                                          height: Get.height * 0.027,
                                                          decoration: BoxDecoration(
                                                            shape: BoxShape.circle,
                                                            color: AppColors.whiteColor,
                                                            gradient: isSelected
                                                                ? LinearGradient(
                                                                    colors: AppColors.appGreenGradientColor,
                                                                    begin: Alignment.topLeft,
                                                                    end: Alignment.bottomRight,
                                                                  )
                                                                : null,
                                                          ),
                                                          child: Center(
                                                            child: Icon(
                                                              Icons.check,
                                                              color: AppColors.whiteColor,
                                                              size: 16,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  );
                }),
              ),
            ),
            downloadProgressWidget(),
          ],
        ),
      ),
    );
  }

  /// **App Bar**
  Container _buildTopBar() {
    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CommonBackButton(
            width: Get.width * 0.1,
            height: Get.height * 0.05,
            onTap: () {
              Get.dialog(
                showDiscardDialog(
                  onDiscardPressed: () {
                    aiAnimatorController.generatedImageUrl.value = '';
                    mainHomeController.currentIndex.value = 0;
                    Get.until((route) => route.isFirst);
                    Get.back();
                  },
                  onCancelPressed: () {
                    Get.back();
                  },
                ),
                barrierColor: Colors.transparent,
              );
            },
          ),
          GestureDetector(
            onTap: () async {},
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.black10.withAlpha( .1.toInt()),
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SvgPicture.asset(
                    AppImage.downloadIC,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  // Function to handle image widget display
  Widget _buildImageWidget() {
    return GestureDetector(
      child: SizedBox(
        height: Get.height,
        width: Get.width,
        child: controller.selectedFilterImage.value.isNotEmpty
            ? ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: customNetworkImageWidget(
                  imageUrl: controller.selectedFilterImage.value,
                  fit: BoxFit.fill,
                ),
              )
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Image customNetworkImageWidget({imageUrl, BoxFit? fit}) {
    return Image.network(
      imageUrl,
      width: Get.width,
      height: Get.height,
      fit: fit ?? BoxFit.contain,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        } else {
          return SizedBox(
            width: Get.width,
            height: Get.height,
            child: Center(
              child: CircularProgressIndicator(
                color: AppColors.whiteColor,
              ),
            ),
          );
        }
      },
    );
  }

// Generated Image Display
  Widget _buildGeneratedImage() {
    return GestureDetector(
      onLongPress: () {
        controller.isLongPressed.value = true;
      },
      onLongPressUp: () {
        controller.isLongPressed.value = false;
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          RepaintBoundary(
            key: controller.repaintBoundaryKey,
            child: Obx(() {
              String imageUrl = controller.isLongPressed.value ? controller.selectedFilterImage.value : aiAnimatorController.generatedImageUrl.value;
              return AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CustomCachedNetworkImage(
                    key: ValueKey(imageUrl),
                    imageUrl: imageUrl,
                    fit: BoxFit.fill,
                    height: Get.height,
                    width: Get.width,
                    placeholder: Center(
                      child: SizedBox(
                        height: Get.height * 0.03,
                        width: Get.width * 0.06,
                        child: const CircularProgressIndicator(),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget downloadProgressWidget() {
    return Obx(() {
      if (controller.downloadProgress.value > 0.0 && controller.downloadProgress.value < 1.0) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Downloading...",
                        style: AppTextStyle.regularTextStyle.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textBlackColor,
                        ),
                      ),
                      Text(
                        "${(controller.downloadProgress.value * 100).toStringAsFixed(2)}%",
                        style: AppTextStyle.regularTextStyle.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textBlackColor,
                        ),
                      ),
                    ],
                  ),
                  HBox(Get.height * 0.02),
                  LinearProgressIndicator(
                    value: controller.downloadProgress.value,
                    backgroundColor: AppColors.greyColor,
                    color: Colors.blue,
                  ),
                ],
              ),
            ),
          ),
        );
      } else {
        return SizedBox.shrink();
      }
    });
  }

  Widget showDiscardDialog({dynamic Function()? onDiscardPressed, required void Function()? onCancelPressed}) {
    return GestureDetector(
      onTap: () => Get.back(),
      child: Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              color: Colors.black.withAlpha(0.3.toInt()),
            ),
          ),
          // Dialog content
          Center(
            child: GestureDetector(
              onTap: () {},
              child: Material(
                type: MaterialType.transparency,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    height: Get.height * 0.7,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: Get.width,
                            decoration: BoxDecoration(
                              color: AppColors.textBlackColor,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(40),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    AppImage.discard,
                                    height: 120,
                                    width: 120,
                                  ),
                                  const SizedBox(height: 25),
                                  Text(
                                    "Discard photo",
                                    style: AppTextStyle.regularTextStyle.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 25),
                                  Text(
                                    "The current changes will not be saved.",
                                    textAlign: TextAlign.center,
                                    style: AppTextStyle.regularTextStyle.copyWith(),
                                  ),
                                  const SizedBox(height: 25),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: CommonButton(
                                          textVal: 'Discard',
                                          onPressed: onDiscardPressed,
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: onCancelPressed,
                                          style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(30),
                                              side: const BorderSide(color: Color(0xFF00B488), width: 2),
                                            ),
                                            backgroundColor: const Color(0xFF00B488).withAlpha( 0.1.toInt()),
                                            shadowColor: Colors.transparent,
                                            elevation: 0,
                                          ),
                                          child: const Text(
                                            "Cancel",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              color: const Color(0xff1b2029),
                              child: Center(
                                child: Text(
                                  "Ads",
                                  style: AppTextStyle.regularTextStyle.copyWith(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
