
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Reusability/utils/app_colors.dart';
import '../../../../Reusability/utils/app_images.dart';
import '../../../../Reusability/utils/app_text_style.dart';
import '../../../../Reusability/widgets/common_widget.dart';
import '../../../../model/getAll_category_model.dart';
import '../../ai_detail/views/ai_animator_view.dart';

class FilterListView extends StatelessWidget {
  final List<FilterCategory> filterCategory;
  final FilterCategory selectedCategory;

  const FilterListView({
    Key? key,
    required this.filterCategory,
    required this.selectedCategory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        children: [
          // Background Gradient Image
          Image.asset(
            AppImage.appBarGradient2,
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
          // Overlay for the body content
          Positioned(
            top: Get.height * 0.13,
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
          // Main Body Section with Filters
          Positioned(
            top: Get.height * 0.146,
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
                padding: EdgeInsets.symmetric(vertical: Get.height * 0.01),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                    ),
                    child: Column(
                      children: [
                        _buildBody(),
                      ],
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

  // **Top Bar**
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
          SizedBox(width: 20),
          Expanded(
            child: Text(
              selectedCategory.id ?? 'Category',
              style: AppTextStyle.regularTextStyle.copyWith(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  // **Main Body with Filter Grid**
  Widget _buildBody() {
    if (selectedCategory.filters == null || selectedCategory.filters!.isEmpty) {
      return _buildNoDataView();
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 4 / 5,
      ),
      itemCount: selectedCategory.filters?.length ?? 0,
      itemBuilder: (context, index) {
        var filter = selectedCategory.filters?[index];
        return _buildFilterCard(filter);
      },
    );
  }

  // **No Data View when no filters are available**
  Widget _buildNoDataView() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          "No filters available.",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  // **Filter Card with Image**
  Widget _buildFilterCard(Filter? filter) {
    return GestureDetector(
      onTap: () {
        if (filter == null) return;
        debugPrint("Filter ID :${filter.id}\n"
            "Filter Name :${filter.name ?? ''}\n"
            "Filter Image :${filter.image}\ninitial index :${selectedCategory.filters?.indexOf(filter) ?? 0}");
        Get.to(
          () => AiAnimatorView(
            imageUrl: filter.image ?? '',
            filterName: filter.name ?? 'No Name',
            filterCategory: filterCategory,
            selectedCategory: selectedCategory,
            filterID: filter.id ?? '',
            initialIndex: selectedCategory.filters?.indexOf(filter) ?? 0,
          ),
          transition: Transition.noTransition,
          duration: const Duration(milliseconds: 0),
        );
      },
      child: Card(
        elevation: 4,
        color: Colors.white10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: _buildCachedImage(filter?.image),
        ),
      ),
    );
  }

  // **Cached Network Image with Placeholder & Error Handling**
  Widget _buildCachedImage(String? imageUrl) {
    return CustomCachedNetworkImage(
      imageUrl: imageUrl ?? '',
      width: Get.width,
      height: Get.height,
      fit: BoxFit.cover,
    );
  }
}
