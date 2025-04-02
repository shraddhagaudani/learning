import 'dart:async';
import 'dart:io';


import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mobile_device_identifier/mobile_device_identifier.dart';

import '../../../../Reusability/utils/app_constants.dart';
import '../../../../Reusability/utils/app_strings.dart';
import '../../../../Reusability/utils/network_dio/network_dio.dart';
import '../../../../main.dart';
import '../../../../model/credit_point.dart';
import '../../../../model/device_model.dart';
import '../../../../model/getAll_category_model.dart';
import '../../../../routes/app_pages.dart';

class SplashController extends GetxController {
  final NetworkDioHttp networkDioHttp = NetworkDioHttp();
  final mobileDeviceIdentifierPlugin = MobileDeviceIdentifier();
  RxBool isLoading = false.obs;
  Rx<CreditPointModel> creditPoint = CreditPointModel().obs;
  RxList<FilterCategory> filterCategory = <FilterCategory>[].obs;

  @override
  void onInit() {
    super.onInit();
    getCreditPoint();
    getAllSubCategoryFilter();
    bool isOnboardingCompleted = dataStorage.read(AppStrings.isSignedUp) ?? false;
    if (isOnboardingCompleted) {
      Timer(const Duration(seconds: 4), () {
        Get.offAllNamed(
          Routes.mainHome,
        );
      });
    } else {
      Timer(const Duration(seconds: 4), () {
        Get.offAllNamed(
          Routes.onBoarding,
        );
      });
    }

    String? token = dataStorage.read(AppStrings.token);
    String? deviceId = dataStorage.read(AppStrings.deviceId);
    if (token != null && token.isNotEmpty) {
      debugPrint("Token already exists: $token");
      debugPrint("DeviceID: $deviceId");
      return;
    }

    getDeviceIdPlugin().then((deviceId) async {
      if (deviceId == null) {
        deviceId = await mobileDeviceIdentifierPlugin.getDeviceId();
        dataStorage.write(AppStrings.deviceId, deviceId);
        dataStorage.remove(AppStrings.isSignedUp);
      }

      signUp(deviceId ?? '');
    });
  }

  Future<void> signUp(String deviceId) async {
    try {
      final bodyData = {
        "deviceId": deviceId,
      };

      // Make the POST request
      final response = await networkDioHttp.postRequest(
        url: ApiAppConstants.loginSignup,
        isHeader: false,
        isBody: true,
        bodyData: bodyData,
        name: "LOGIN_SIGNUP",
      );

      if (response != null && response.statusCode == 200) {
        DeviceModel deviceModel = DeviceModel.fromJson(response.data);

        if (deviceModel.status == 200 && deviceModel.data != null) {
          dataStorage.write(AppStrings.token, deviceModel.data?.token);
          debugPrint("Device Token: ${deviceModel.data?.token}");

          dataStorage.write(AppStrings.isSignedUp, true);
        } else {
          debugPrint("Error: Invalid data or status in response.");
        }
      } else {
        debugPrint("Error: Failed to get valid response, status code: ${response?.statusCode}");
      }
    } catch (error) {
      debugPrint("Error fetching signUp: $error");
    }
  }

  Future<String?> getDeviceIdPlugin() async {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        String? deviceId = dataStorage.read(AppStrings.deviceId);

        bool isSignedUp = dataStorage.read(AppStrings.isSignedUp) ?? false;

        if (deviceId == null || !isSignedUp) {
          deviceId = await mobileDeviceIdentifierPlugin.getDeviceId() ?? 'Unknown platform version';
          await dataStorage.write(AppStrings.deviceId, deviceId);

          await dataStorage.remove(AppStrings.isSignedUp);
        }

        return deviceId;
      } else {
        return null;
      }
    } catch (e) {
      logger.e("Error fetching device ID: $e");
      return DateTime.now().millisecondsSinceEpoch.toString();
    }
  }

  Future<void> getAllSubCategoryFilter() async {
    isLoading.value = true;

    try {
      var response = await NetworkDioHttp().getRequest(
        url: ApiAppConstants.apiEndPoint + ApiAppConstants.getAllFilterDirect,
        isHeader: true,
        name: "GET_ALL_FILTER_DIRECT",
        isBearer: false,
      );

      if (response != null && response.statusCode == 200) {
        GetAllCategoryModel getAllCategoryModel = GetAllCategoryModel.fromJson(response.data);

        filterCategory.value = getAllCategoryModel.data ?? [];
      }
    } catch (e, t) {
      debugPrint(" --- CATCH --- $e $t");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getCreditPoint() async {
    try {
      var response = await NetworkDioHttp().getRequest(
        url: ApiAppConstants.apiEndPoint + ApiAppConstants.getCreditPoint,
        isHeader: true,
        name: "GET_CREDIT_POINT",
        isBearer: false,
      );

      if (response != null && response.statusCode == 200) {
        CreditPointModel creditData = CreditPointModel.fromJson(response.data);

        creditPoint.value = creditData;

        debugPrint("Credit Points: ${creditPoint.value.data?.creditPoints}");
      }
    } catch (e, t) {
      // Loader.hide();
      debugPrint(" --- CATCH Credit Points ERROR--- $e $t");
    }
  }
}
