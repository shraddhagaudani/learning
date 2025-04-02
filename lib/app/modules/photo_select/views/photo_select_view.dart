
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../../Reusability/utils/app_colors.dart';
import '../../../../Reusability/utils/app_images.dart';
import '../../../../Reusability/utils/app_text_style.dart';
import '../../../../Reusability/widgets/common_widget.dart';
import '../../../../Reusability/widgets/custom_snack_bar.dart';
import '../../crop_image/views/crop_image_view.dart';
import '../controllers/photo_select_controller.dart';

class SelectPhotoView extends StatefulWidget {
  final String filterName;

  const SelectPhotoView({super.key, required this.filterName});

  @override
  State<SelectPhotoView> createState() => _SelectPhotoViewState();
}

class _SelectPhotoViewState extends State<SelectPhotoView> with WidgetsBindingObserver {
  final PhotoSelectController controller = Get.put(PhotoSelectController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (controller.albums.isEmpty) {
      controller.checkPermissions();
      controller.loadAlbums();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      controller.checkPermissions();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        children: [
          Positioned(top: 50, left: 0, right: 0, child: _buildTopBar(context)),
          Positioned(
            top: Get.height * 0.146,
            bottom: 0,
            left: 0,
            right: 0,
            child: Obx(
              () {
                if (controller.isAlbumsLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }

                if (controller.albums.isEmpty) {
                  return _buildEmptyState('No Albums', 'It seems there are no albums to display.');
                }

                if (controller.isPhotosLoading.value && controller.photos.isEmpty) {
                  return Center(child: CircularProgressIndicator());
                }

                if (controller.photos.isEmpty) {
                  return _buildEmptyState('No Photos', 'It seems there are no photos in this album.');
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: Get.width * 0.052,
                        ),
                        child: GridView.builder(
                            padding: EdgeInsets.zero,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                            ),
                            itemCount: controller.photos.length,
                            itemBuilder: (context, index) {
                              final asset = controller.photos[index];
                              final imageData = controller.imageCache[asset.id];

                              if (imageData != null) {
                                return GestureDetector(
                                  onTap: () async {
                                    if (imageData.lengthInBytes > 10 * 1024 * 1024) {
                                      CustomSnackBar.showCustomToast(
                                        toastType: ToastType.error,
                                        message: 'Image is too large! Please select a file smaller than 10MB.',
                                      );
                                      return;
                                    }

                                    // Check image resolution
                                    final image = await decodeImageFromList(imageData);
                                    if (image.width < 300 || image.height < 300) {
                                      CustomSnackBar.showCustomToast(
                                        toastType: ToastType.error,
                                        message: 'Image resolution is too low! Please upload an image of at least 300x300 pixels.',
                                      );
                                      return;
                                    }

                                    // If valid, proceed with actions
                                    XFile tempFile = await controller.convertUint8ListToXFile(imageData);
                                    Get.to(
                                        () => CropImageView(
                                              filterTitle: widget.filterName,
                                              cropImagePath: imageData,
                                            ),
                                        transition: Transition.noTransition,
                                        duration: Duration(milliseconds: 0));
                                    // Get.back(result: tempFile);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white10,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.memory(
                                        imageData,
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Center(
                                            child: Icon(Icons.error, color: Colors.red),
                                          );
                                        },
                                        filterQuality: FilterQuality.medium,
                                        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                                          if (wasSynchronouslyLoaded) {
                                            return child;
                                          }
                                          return AnimatedOpacity(
                                            opacity: frame == null ? 0 : 1,
                                            duration: const Duration(milliseconds: 300),
                                            child: child,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              }
                              return Container(
                                decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(10)),
                                child: const Center(child: CircularProgressIndicator()),
                              );
                            }),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: GestureDetector(
        onTap: () {
          controller.pickImageFromCamera(filterName: widget.filterName);
        },
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: FractionalOffset(0.0, 1.0),
              end: FractionalOffset(1.3, 0.8),
              stops: [0.0, 0.8],
              colors: AppColors.appGreenGradientColor,
            ),
          ),
          child: SvgPicture.asset(AppImage.aiPhotoIc),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CommonBackButton(
            width: Get.width * 0.1,
            height: Get.height * 0.05,
          ),
          Obx(
            () {
              if (controller.albums.isEmpty) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(color: AppColors.whiteColor.withAlpha(0.1.toInt()), borderRadius: BorderRadius.circular(40)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      hint: Text('No Albums Available', style: AppTextStyle.regularTextStyle),
                      icon: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: SvgPicture.asset(AppImage.arrowDownIC),
                      ),
                      onChanged: null,
                      items: [],
                    ),
                  ),
                );
              } else {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<AssetPathEntity>(
                      value: controller.albums.isNotEmpty ? controller.albums[controller.selectedIndex.value] : null,
                      dropdownColor: Colors.black,
                      style: AppTextStyle.regularTextStyle.copyWith(),
                      icon: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: SvgPicture.asset(AppImage.arrowDownIC),
                      ),
                      onChanged: (AssetPathEntity? newValue) {
                        if (newValue != null && controller.selectedIndex.value != controller.albums.indexOf(newValue)) {
                          controller.selectedIndex.value = controller.albums.indexOf(newValue);
                          controller.loadPhotosFromFolder(newValue);
                        }
                      },
                      items: controller.albums.map((AssetPathEntity album) {
                        return DropdownMenuItem<AssetPathEntity>(
                          value: album,
                          child: Text(album.name.isNotEmpty ? album.name : "Unknown", style: AppTextStyle.regularTextStyle),
                        );
                      }).toList(),
                    ),
                  ),
                );
              }
            },
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              height: Get.height * 0.06,
              width: Get.width * 0.1,
              decoration: BoxDecoration(
                color: AppColors.whiteColor.withAlpha( 0.1.toInt()),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: SvgPicture.asset(
                AppImage.infoIC,
                height: Get.height * 0.02,
                width: Get.height * 0.02,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String title, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            AppImage.noImage,
            height: Get.height * 0.1,
            width: Get.width * 0.25,
          ),
          HBox(Get.height * 0.04),
          Text(
            title,
            style: AppTextStyle.regularTextStyle.copyWith(fontSize: 24, fontWeight: FontWeight.w600),
          ),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTextStyle.regularTextStyle.copyWith(fontSize: 16, color: AppColors.textLightGrey, height: 1.8),
          ),
          HBox(Get.height * 0.04),
          if (controller.isPermissionDenied.value || controller.isPermissionPermanentlyDenied.value)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.width * 0.2),
              child: CommonButton(
                textVal: 'Grant Permission',
                onPressed: controller.openPermissionSettings,
              ),
            ),
        ],
      ),
    );
  }
}
