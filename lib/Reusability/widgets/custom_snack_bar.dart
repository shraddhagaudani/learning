import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

enum ToastType { error, warning, success, info }

class CustomSnackBar {
  static void showGetXSnackBar({
    required ToastType? toastType,
    String? title,
    required String message,
    Widget? messageText,
    Duration duration = const Duration(seconds: 2),
    Color? backgroundColor,
    void Function(GetSnackBar)? onTap,
  }) {
    if (!Get.isSnackbarOpen) {
      debugPrint("SnackBar is not open, showing SnackBar...");
      Get.rawSnackbar(
        onTap: onTap,
        messageText: Text(message, style: const TextStyle(color: Colors.white)),
        snackPosition: SnackPosition.TOP,
        duration: duration,
        icon: Icon(
          toastType == ToastType.error
              ? Icons.error_outline
              : toastType == ToastType.warning
                  ? Icons.warning_amber_outlined
                  : toastType == ToastType.success
                      ? Icons.check_circle_outline
                      : Icons.info_outlined,
          color: Colors.white,
        ),
        backgroundColor: toastType == ToastType.error
            ? const Color(0xFFFF4A59)
            : toastType == ToastType.warning
                ? const Color(0xffFAE7C6)
                : toastType == ToastType.success
                    ? const Color(0xFF1AB656)
                    : Colors.blue.shade200,
        margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 15),
        animationDuration: const Duration(milliseconds: 700),
        borderRadius: 10,
      );
    }
  }

  static void showCustomToast({
    required ToastType? toastType,
    required String message,
    Duration duration = const Duration(seconds: 2),
  }) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: duration.inSeconds,
      backgroundColor: toastType == ToastType.error
          ? const Color(0xFFFF4A59)
          : toastType == ToastType.warning
              ? const Color(0xffFAE7C6)
              : toastType == ToastType.success
                  ? const Color(0xFF1AB656)
                  : Colors.blue.shade200,
      textColor: Colors.white,
    );
  }
}
