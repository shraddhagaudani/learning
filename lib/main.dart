import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:logger/logger.dart';

import 'Reusability/utils/app_colors.dart';
import 'routes/app_pages.dart';

GetStorage dataStorage = GetStorage();
Logger logger = Logger();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize GetStorage
  await GetStorage.init();

  // Lock the device orientation to portrait
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Run the app
  runApp(
    GlobalLoaderOverlay(
      overlayColor: AppColors.transparent,
      child: GetMaterialApp(
        title: "AI App",
        debugShowCheckedModeBanner: false,
        initialRoute: AppPages.initial,
        getPages: AppPages.routes,
        theme: ThemeData(
          primaryColor: AppColors.primaryColor,
          colorScheme: const ColorScheme.light(primary: AppColors.primaryColor),
          buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
        ),
      ),
    ),
  );
}
