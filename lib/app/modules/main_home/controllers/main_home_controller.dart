
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../home/views/home_view.dart';
import '../../project/views/project_view.dart';
import '../../setting/views/setting_view.dart';

class MainHomeController extends GetxController {
  RxInt currentIndex = 0.obs;
  final List<Widget> pages = [HomeView(), ProjectView(), SettingView(),];

  Future<void> onTabTapped(int index) async {
    currentIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
  }
}
