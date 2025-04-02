
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Reusability/utils/app_colors.dart';
import '../../../../Reusability/utils/app_images.dart';
import '../../../../Reusability/utils/app_text_style.dart';
import '../../../../Reusability/widgets/common_widget.dart';
import '../../../../Reusability/widgets/custom_snack_bar.dart';
import '../../../../main.dart';
import '../../../../model/getAll_category_model.dart';
import '../../photo_details/views/photo_detail_view.dart';
import '../../photo_select/views/photo_select_view.dart';
import '../controllers/ai_animator_controller.dart';

class AiAnimatorView extends StatefulWidget {
  final String imageUrl;
  final String filterName;
  final List<FilterCategory> filterCategory;
  final FilterCategory selectedCategory;
  final String filterID;
  final int initialIndex;

  const AiAnimatorView({
    super.key,
    required this.imageUrl,
    required this.filterName,
    required this.filterCategory,
    required this.selectedCategory,
    required this.filterID,
    required this.initialIndex,
  });

  @override
  State<AiAnimatorView> createState() => _AiAnimatorViewState();
}

class _AiAnimatorViewState extends State<AiAnimatorView> with WidgetsBindingObserver {
  final AiAnimatorController controller = Get.put(AiAnimatorController());
  late int totalFilters;

  @override
  void initState() {
    super.initState();
    totalFilters = widget.selectedCategory.filters?.length ?? 0;
    controller.currentIndex.value = widget.initialIndex;
    WidgetsBinding.instance.addObserver(this);
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
      controller.onResumeUpdate(); // Update UI when navigating back
    }
  }

  @override
  Widget build(BuildContext context) {
    logger.i(
      "title : ${widget.filterName}\n"
      "imageUrl : ${widget.imageUrl}\n"
      "selectedCategory : ${widget.selectedCategory.id}",
    );
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: Stack(
          children: [
            Image.asset(
              AppImage.appBarGradient,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            Positioned(
              top: Get.height * 0.056,
              left: 0,
              right: 0,
              child: _buildTopBar(),
            ),
            Positioned(
              top: Get.height * 0.146,
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                child: Column(
                  children: [
                    _buildTopImageSection(),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor.withAlpha( 0.1.toInt()),
                          border: Border.all(color: Colors.white.withAlpha( 0.1.toInt()), width: 1),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          child: Obx(() {
                            int currentIndex = controller.currentIndex.value + 1;
                            return RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "$currentIndex",
                                    style: AppTextStyle.regularTextStyle.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  // Separator
                                  TextSpan(
                                    text: "/",
                                    style: AppTextStyle.regularTextStyle.copyWith(
                                      color: Colors.white.withAlpha( 0.7.toInt()),
                                    ),
                                  ),
                                  TextSpan(
                                    text: "$totalFilters",
                                    style: AppTextStyle.regularTextStyle.copyWith(
                                      color: Colors.white.withAlpha(0.7.toInt()),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              top: Get.height * 0.635,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  width: Get.width,
                  height: Get.height * 0.022,
                  decoration: BoxDecoration(
                    color: Color(0xFF020711).withAlpha(0.5.toInt()),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: Get.height * 0.65,
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
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Select face you want to swap",
                        style: AppTextStyle.regularTextStyle.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      HBox(20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: _buildImageSelectionSection(),
                          ),
                        ],
                      ),
                      HBox(20),
                      CommonButton(
                        textVal: "Continue",
                        onPressed: () {
                          if (controller.selectedImages.isEmpty) {
                            CustomSnackBar.showCustomToast(
                              toastType: ToastType.error,
                              message: "Please pick at least one image",
                            );
                          } else {
                            final selectedImage = controller.selectedImage.value;
                            logger.i("selectedImage: $selectedImage");
                            Get.to(
                              () => PhotoDetailsView(
                                imageUrl: '',
                                imagePath: selectedImage,
                                title: widget.filterName,
                                filterCategory: widget.filterCategory,
                                selectedCategory: widget.selectedCategory,
                                filterID: controller.filterID.value.isNotEmpty ? controller.filterID.value : widget.filterID,
                              ),
                              transition: Transition.noTransition,
                              duration: const Duration(milliseconds: 0),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // Refactor the image selection section
  Widget _buildImageSelectionSection() {
    return Obx(() {
      if (controller.selectedImages.isEmpty) {
        return Center(child: _buildAddButton());
      } else if (controller.selectedImages.length < 4) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...controller.selectedImages.map((imagePath) => _buildImageItem(imagePath)).toList(),
            _buildAddButton(),
          ],
        );
      } else {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ...controller.selectedImages.map((imagePath) => _buildImageItem(imagePath)).toList(),
              _buildAddButton(),
            ],
          ),
        );
      }
    });
  }

  Widget _buildAddButton() {
    return GestureDetector(
      onTap: () async {
        await Get.to(
          () => SelectPhotoView(
            filterName: widget.filterName,
          ),
          transition: Transition.noTransition,
          duration: const Duration(milliseconds: 0),
        );
      },
      child: Container(
        height: 70,
        width: 70,
        decoration: BoxDecoration(
          color: AppColors.whiteColor.withAlpha( 0.1.toInt()),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Icon(Icons.add, color: AppColors.whiteColor),
      ),
    );
  }

  Widget _buildImageItem(String imagePath) {
    bool isSelected = controller.selectedImage.value == imagePath;

    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              controller.selectedImage.value = imagePath;
            },
            child: Container(
              width: Get.width * 0.17,
              height: Get.height * 0.078,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: isSelected
                    ? LinearGradient(
                        colors: AppColors.appGreenGradientColor,
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                      )
                    : null,
              ),
              child: Padding(
                padding: const EdgeInsets.all(3),
                child: ClipOval(
                  child: CustomFileImage(
                    imagePath: imagePath,
                    width: Get.width * 0.17,
                    height: Get.height * 0.078,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopImageSection() {
    return ClipRRect(
      child: CarouselSlider(
        items: widget.selectedCategory.filters?.map((item) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CustomCachedNetworkImage(
                imageUrl: item.image ?? '',
                width: Get.width,
                height: Get.height,
                fit: BoxFit.cover,
                cacheKey: item.image ?? '',
              ),
            ),
          );
        }).toList(),
        carouselController: controller.carouselController,
        options: CarouselOptions(
          initialPage: widget.initialIndex,
          scrollPhysics: const BouncingScrollPhysics(),
          aspectRatio: 1.12,
          viewportFraction: 0.65,
          enlargeCenterPage: true,
          enableInfiniteScroll: false,
          enlargeStrategy: CenterPageEnlargeStrategy.zoom,
          padEnds: true,
          onPageChanged: (index, reason) {
            controller.currentIndex.value = index;
            var currentFilter = widget.selectedCategory.filters?[index];
            if (currentFilter != null) {
              controller.filterID.value = currentFilter.id ?? '';
              logger.i(
                "Current Filter Data: ID: ${currentFilter.id}\n"
                "Name: ${currentFilter.name}\nImage: ${currentFilter.image}",
              );
            }
          },
        ),
      ),
    );
  }

  /// **Top Bar**
  Container _buildTopBar() {
    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          CommonBackButton(
            width: Get.width * 0.1,
            height: Get.height * 0.05,
          ),
          WBox(20),
          Expanded(
            child: Text(
              widget.filterName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyle.regularTextStyle.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//remove Image
// Positioned(
//   top: 0,
//   right: 0,
//   child: IconButton(
//     onPressed: () => controller.removeImage(imagePath),
//     icon: Icon(Icons.close, color: Colors.white),
//   ),
// ),
