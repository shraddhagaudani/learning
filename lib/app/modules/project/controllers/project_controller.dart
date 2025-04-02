
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../Reusability/utils/app_constants.dart';
import '../../../../Reusability/utils/network_dio/network_dio.dart';
import '../../../../model/get_all_swap_image_model.dart';

class ProjectController extends GetxController {
  RxInt tabIndex = 0.obs;
  final NetworkDioHttp networkDioHttp = NetworkDioHttp();
  RxList<SwapImageDetail> allSwapImagesDetails = <SwapImageDetail>[].obs;
  RxMap<String, List<SwapImageDetail>> categorizedImages = <String, List<SwapImageDetail>>{}.obs;
  RxList<String> categories = <String>[].obs;
  RxList<String> selectedImages = <String>[].obs;

  late RefreshController swapImageRefreshController;
  RxBool isSwapImageLoading = false.obs;

  RxBool isDataLoaded = false.obs; // Prevents blank blink

  @override
  void onInit() {
    super.onInit();
    tabIndex.value = 0; // Default to "All" tab
    selectedImages.clear();
    swapImageRefreshController = RefreshController(initialRefresh: false);
    getAllSwapImage();
  }

  void selectImage(String imageUrl) {
    if (selectedImages.isNotEmpty && selectedImages.first == imageUrl) {
      selectedImages.clear();
    } else {
      selectedImages.clear();
      selectedImages.add(imageUrl);
    }
  }

  void clearSelectedImages() {
    selectedImages.clear();
  }

  void changeTabIndex(int index) {
    tabIndex.value = index;
  }

  Future<void> getAllSwapImage() async {
    isSwapImageLoading.value = true;
    try {
      final response = await networkDioHttp.getRequest(
        url: ApiAppConstants.apiEndPoint + ApiAppConstants.faceSwapGetAllImage,
        isHeader: true,
        name: "GET_ALL_SWAP_IMAGE",
        isBearer: false,
      );

      if (response != null && response.statusCode == 200) {
        GetAllFaceSwapImageModel faceSwapImageResponse = GetAllFaceSwapImageModel.fromJson(response.data);
        allSwapImagesDetails.clear();
        categorizedImages.clear();
        categories.clear();

        // Ensure "All" is always the first category
        categories.add("All");

        if (faceSwapImageResponse.data != null) {
          for (var item in faceSwapImageResponse.data!) {
            if (item.status == "completed" && item.generatedImage != null && item.subcategoryId?.name != null) {
              String categoryName = item.subcategoryId!.name!;

              categorizedImages.putIfAbsent("All", () => []);
              categorizedImages["All"]!.add(item);

              if (!categories.contains(categoryName)) {
                categories.add(categoryName);
              }

              categorizedImages.putIfAbsent(categoryName, () => []);
              categorizedImages[categoryName]!.add(item);
            }
          }

          // Remove the "All" category if there's no data for it
          if (categorizedImages["All"]!.isEmpty) {
            categories.remove("All");
            categorizedImages.remove("All");
          }
        }

        // Refresh data
        categorizedImages.refresh();
        categories.refresh();
        swapImageRefreshController.refreshCompleted();
      } else {
        swapImageRefreshController.refreshFailed();
      }
    } catch (e) {
      swapImageRefreshController.refreshFailed();
    } finally {
      isSwapImageLoading.value = false;
      isDataLoaded.value = true;
    }
  }


  void updateCategoryImages(String category) {
    categorizedImages.refresh();
    categories.refresh();
  }
}
