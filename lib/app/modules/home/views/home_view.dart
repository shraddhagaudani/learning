
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../Reusability/utils/app_colors.dart';
import '../../../../Reusability/utils/app_images.dart';
import '../../../../Reusability/utils/app_text_style.dart';
import '../../../../Reusability/widgets/common_widget.dart';
import '../../../../Reusability/widgets/credit_point_widget.dart';
import '../../../../Reusability/widgets/premium_button_widget.dart';
import '../../../../main.dart';
import '../../ai_detail/views/ai_animator_view.dart';
import '../../main_home/controllers/main_home_controller.dart';
import '../../splash/controllers/splash_controller.dart';
import '../controllers/home_controller.dart';
import 'filter_listview.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with WidgetsBindingObserver, TickerProviderStateMixin {
  final MainHomeController mainHomeController = Get.put(MainHomeController());
  SplashController splashController = Get.find<SplashController>();
  HomeController controller = Get.find<HomeController>();
  late AnimationController _animationController;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _offsetAnimation = Tween<Offset>(begin: const Offset(0, 1), end: const Offset(0, 0)).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    controller.scrollController.addListener(() {
      if (controller.scrollController.offset >= Get.height * 0.8) {
        if (!controller.showScrollToTopButton.value) {
          controller.showScrollToTopButton.value = true;
          _animationController.forward();
        }
      } else {
        if (controller.showScrollToTopButton.value) {
          controller.showScrollToTopButton.value = false;
          _animationController.reverse();
        }
      }
    });
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
      controller.showScrollToTopButton.value = false;
      _animationController.reverse();
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
          _buildAppBar(),
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
                  color: Color(0xFF020711).withAlpha( 0.5.toInt()),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
              ),
            ),
          ),
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
              child: Obx(() {
                if (splashController.filterCategory.isEmpty) {
                  return _buildNoDataView();
                }

                return Stack(
                  children: [
                    SingleChildScrollView(
                      controller: controller.scrollController,
                      padding: EdgeInsets.only(bottom: Get.height * 0.01),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...splashController.filterCategory.map(
                            (category) => _buildCategorySection(category),
                          ),
                        ],
                      ),
                    ),
                    if (controller.showScrollToTopButton.value)
                      Positioned(
                        bottom: Get.height * 0.1,
                        right: Get.width * 0.04,
                        child: SlideTransition(
                          position: _offsetAnimation,
                          child: AnimatedOpacity(
                            opacity: controller.showScrollToTopButton.value ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 300),
                            child: GestureDetector(
                              onTap: controller.onTopScroll,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: FractionalOffset(0.0, 1.0),
                                    end: FractionalOffset(1.0, 0.5),
                                    stops: [0.0, 0.8],
                                    colors: AppColors.appGreenGradientColor,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Icon(
                                    Icons.arrow_upward,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  /// **App Bar**
  AppBar _buildAppBar() {
    return AppBar(
      toolbarHeight: 60,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      title: Text(
        "Ai Face Swap",
        style: AppTextStyle.regularTextStyle.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        CreditPointWidget(),
        PremiumButtonWidget(),
        GestureDetector(
          onTap: () {
            mainHomeController.currentIndex.value = 1;
          },
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.whiteColor.withAlpha(1.toInt()),
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SvgPicture.asset(
                AppImage.profileIC,
              ),
            ),
          ),
        ),
        WBox(Get.width * 0.035),
      ],
    );
  }

  /// **No Data View**
  Widget _buildNoDataView() {
    return Center(
      child: Text(
        'No data available',
        style: AppTextStyle.regularTextStyle.copyWith(
          fontSize: 16,
          color: AppColors.whiteColor,
        ),
      ),
    );
  }

  /// **Category Section**
  Widget _buildCategorySection(var category) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCategoryHeader(category),
          HBox(15),
          _buildFilterList(category),
        ],
      ),
    );
  }

  /// **Category Header**
  Widget _buildCategoryHeader(var category) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            category.id ?? '',
            style: AppTextStyle.regularTextStyle.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          GestureDetector(
            onTap: () => _navigateToFilterList(category),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white.withAlpha(.1.toInt()), width: 1),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Row(
                  children: [
                    Text(
                      "More",
                      style: AppTextStyle.regularTextStyle.copyWith(fontWeight: FontWeight.w400, fontSize: 12),
                    ),
                    WBox(5),
                    SvgPicture.asset(AppImage.rightIC),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  /// **Filter List**
  Widget _buildFilterList(var category) {
    double screenWidth = MediaQuery.of(context).size.width;
    double filterWidth = screenWidth / 3.1;
    double filterHeight = filterWidth * 1.4;

    int itemCount = (category.filters?.length ?? 0) > 5 ? 5 : category.filters?.length ?? 0;

    return SizedBox(
      height: filterHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: itemCount,
        itemBuilder: (context, index) {
          var filter = category.filters?[index];

          return Padding(
            padding: EdgeInsets.only(
              left: index == 0 ? 16 : 10,
              right: index == itemCount - 1 ? 16 : 0,
            ),
            child: GestureDetector(
              onTap: () {
                debugPrint("Filter ID :${filter.id}\nFilter Name :${filter.name ?? ''}\nFilter Image :${filter.image}");
                _navigateToAiAnimator(filter, category);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CustomCachedNetworkImage(
                  imageUrl: filter?.image ?? '',
                  width: filterWidth,
                  height: filterHeight,
                  fit: BoxFit.cover,
                  cacheKey: filter?.image,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// **Navigation**
  void _navigateToFilterList(var category) {
    Get.to(
      () => FilterListView(
        filterCategory: splashController.filterCategory,
        selectedCategory: category,
      ),
      transition: Transition.noTransition,
      duration: Duration(milliseconds: 0),
    );
  }

  void _navigateToAiAnimator(var filter, var category) {
    logger.i(
      "ImageUrl ${filter?.image ?? ''}\n"
      "Filter Name ${filter?.name ?? ''}\n"
      "Filter ID ${filter?.id ?? ''}\n"
      "Category ID ${category.id ?? ''}\n"
      "initial index :${category.filters?.indexOf(filter) ?? 0}",
    );
    Get.to(
      () => AiAnimatorView(
        imageUrl: filter?.image ?? '',
        filterName: category?.id ?? '',
        filterCategory: splashController.filterCategory,
        selectedCategory: category,
        filterID: filter?.id ?? '',
        initialIndex: category.filters?.indexOf(filter) ?? 0,
      ),
      transition: Transition.noTransition,
      duration: Duration(milliseconds: 0),
    );
  }
}
