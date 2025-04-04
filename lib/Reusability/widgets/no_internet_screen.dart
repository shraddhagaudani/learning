
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/modules/main_home/views/main_home_view.dart';
import '../../app/modules/splash/views/splash_view.dart';
import '../../components/check_internet.dart';
import '../../main.dart';
import '../utils/app_colors.dart';
import '../utils/app_strings.dart';
import '../utils/app_text_style.dart';
import 'common_widget.dart';
import 'custom_snack_bar.dart';

class NoInterNetScreen extends StatefulWidget {
  const NoInterNetScreen({super.key});

  @override
  State<NoInterNetScreen> createState() => _NoInterNetScreenState();
}

class _NoInterNetScreenState extends State<NoInterNetScreen> {
  RxBool isButtonDisabled = false.obs;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: PopScope(
        canPop: false,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.wifi_off,
                size: screenHeight * 0.2,
                color: Colors.red,
              ),
              HBox(screenHeight * 0.020),
              Text(
                'No Internet Connection',
                style: AppTextStyle.regularTextStyle.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              HBox(screenHeight * 0.010),
              Text(
                'Please check your internet settings.',
                style: AppTextStyle.regularTextStyle.copyWith(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              ),
              HBox(Get.height * 0.05),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Get.width * 0.17),
                child: CommonButton(
                  textVal: "Try again",
                  onPressed: () {
                    if (isButtonDisabled.value == false) {
                      _handleTryAgain();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleTryAgain() async {
    final hasInternet = await checkInternet();

    if (hasInternet == true) {
      isButtonDisabled.value = true;

      String? userID = dataStorage.read(AppStrings.token);
      debugPrint("No internet screen userID: $userID");

      Future.delayed(const Duration(milliseconds: 50), () {
        if (mounted) {
          if (userID?.isNotEmpty ?? false) {
            Get.offAll(() => SplashView());
          } else {
            Get.offAll(() => MainHomeView());
          }
        }
      });
    } else {
      CustomSnackBar.showGetXSnackBar(toastType: ToastType.error, message: "No internet connection!!");
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
