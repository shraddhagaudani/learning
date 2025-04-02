import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../utils/app_colors.dart';
import '../utils/app_images.dart';
import '../utils/app_text_style.dart';

class CommonWidget {}

class HBox extends StatelessWidget {
  final double? height;

  const HBox(this.height, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height);
  }
}

class WBox extends StatelessWidget {
  final double? width;

  const WBox(this.width, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width);
  }
}

class CommonButton extends StatelessWidget {
  final Function()? onPressed;
  final String textVal;
  final double? btnHeight;
  final double? btnWidth;
  final double? btnRadius;
  final double? textFontSize;
  final TextStyle? style;
  final Widget? child;
  final Color? backgroundColor;
  final LinearGradient? gradient;

  const CommonButton({
    super.key,
    this.onPressed,
    required this.textVal,
    this.style,
    this.btnRadius,
    this.btnHeight,
    this.btnWidth,
    this.child,
    this.textFontSize,
    this.backgroundColor,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed ?? () {},
      child: Container(
        height: btnHeight,
        width: btnWidth,
        padding: EdgeInsets.symmetric(vertical: Get.height * 0.02, horizontal: Get.width * 0.05),
        decoration: BoxDecoration(
          gradient: gradient ??
              (backgroundColor != null
                  ? null
                  : LinearGradient(
                      begin: const FractionalOffset(0.0, 1.0),
                      end: const FractionalOffset(1.0, 0.5),
                      stops: const [0.0, 0.8],
                      colors: AppColors.appGreenGradientColor,
                    )),
          color: backgroundColor,
          borderRadius: BorderRadius.circular(btnRadius ?? 100),
        ),
        child: Center(
          child: Text(
            textVal,
            style: style ??
                AppTextStyle.regularTextStyle.copyWith(
                  fontSize: textFontSize ?? 14,
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ),
    );
  }
}

class TextFField extends StatelessWidget {
  final String? hintText;
  final Widget? prefixIcon;
  final String? initialValue;
  final String? errorText;
  final IconData? icon;
  final bool? readOnly;
  final bool? obscureText;
  final bool? enabled;
  final Function()? onTap;
  final Function(String)? onChanged;
  final Function(String?)? onSaved;
  final Function()? onEditingComplete;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final Color? suffixIconColor;
  final Color? fillColor;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final int? maxLength;
  final int? maxLine;
  final TextInputAction? textInputAction;
  final bool? isBorderNone;
  final TextStyle? style;
  final InputBorder? border;
  final InputBorder? focusBoarder;
  final InputBorder? disableBoarder;
  final InputBorder? enableBoarder;
  final AutovalidateMode? autoValidateMode;

  const TextFField({
    this.hintText,
    this.maxLine,
    this.prefixIcon,
    this.initialValue,
    this.readOnly,
    this.onTap,
    this.controller,
    this.icon,
    this.enabled,
    this.errorText,
    this.focusNode,
    this.inputFormatters,
    this.keyboardType,
    this.maxLength,
    this.obscureText,
    this.onChanged,
    this.fillColor,
    this.onSaved,
    this.onEditingComplete,
    this.textInputAction,
    this.suffixIcon,
    this.suffixIconColor,
    this.validator,
    this.isBorderNone,
    this.style,
    this.border,
    this.focusBoarder,
    this.disableBoarder,
    this.enableBoarder,
    this.autoValidateMode,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: maxLength,
      focusNode: focusNode,
      enabled: enabled,
      maxLines: maxLine ?? 1,
      autovalidateMode: autoValidateMode,
      keyboardType: keyboardType,
      readOnly: readOnly ?? false,
      initialValue: initialValue,
      style: style ??
          AppTextStyle.regularTextStyle.copyWith(
            color: AppColors.textBlackColor,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
      controller: controller,
      onChanged: onChanged,
      onTap: onTap,
      inputFormatters: inputFormatters,
      onEditingComplete: onEditingComplete,
      obscureText: obscureText ?? false,
      validator: validator,
      onSaved: onSaved,
      obscuringCharacter: "*",
      textInputAction: textInputAction,
      onTapOutside: (event) {
        FocusScope.of(context).unfocus();
      },
      decoration: InputDecoration(
        counterText: "",
        filled: true,
        fillColor: fillColor ?? AppColors.fillColor,
        errorText: errorText,
        contentPadding: EdgeInsets.symmetric(
          vertical: Get.height * 0.012,
          horizontal: isBorderNone ?? false ? 0 : Get.width * 0.04,
        ),
        hintText: hintText,
        hintStyle: AppTextStyle.regularTextStyle.copyWith(color: AppColors.greyColor, fontSize: 12),
        border: border ??
            (isBorderNone ?? false
                ? InputBorder.none
                : OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.borderColor),
                  )),
        disabledBorder: disableBoarder ??
            (isBorderNone ?? false
                ? InputBorder.none
                : OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.borderColor),
                  )),
        enabledBorder: enableBoarder ??
            (isBorderNone ?? false
                ? InputBorder.none
                : OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.borderColor),
                  )),
        focusedBorder: focusBoarder ??
            (isBorderNone ?? false
                ? InputBorder.none
                : OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.borderColor),
                  )),
        errorBorder: isBorderNone ?? false
            ? InputBorder.none
            : OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(width: 1, color: AppColors.redColor),
              ),
        focusedErrorBorder: isBorderNone ?? false
            ? InputBorder.none
            : OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(width: 1.5, color: AppColors.redColor),
              ),
        errorStyle: AppTextStyle.regularTextStyle.copyWith(color: AppColors.redColor, fontSize: 12),
        prefixIcon: prefixIcon,
        prefixIconColor: AppColors.greyColor,
        prefixIconConstraints: BoxConstraints(
          maxHeight: Get.height * 0.04,
          maxWidth: Get.width * 0.14,
          minWidth: Get.width * 0.12,
        ),
        suffixIcon: suffixIcon,
        suffixIconColor: suffixIconColor,
        suffixIconConstraints: BoxConstraints(
          maxHeight: Get.height * 0.04,
          maxWidth: Get.width * 0.14,
          minWidth: Get.width * 0.12,
        ),
      ),
    );
  }
}

typedef ImageWidgetBuilder = Widget Function(BuildContext context, ImageProvider imageProvider);

class CustomCachedNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final List<double>? filterMatrix;
  final FilterQuality? filterQuality;
  final String? cacheKey;
  final Color? containerColor;

  const CustomCachedNetworkImage({
    required this.imageUrl,
    this.width,
    this.height,
    this.fit,
    this.placeholder,
    this.errorWidget,
    this.filterMatrix,
    this.filterQuality,
    this.cacheKey,
    this.containerColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (!_isValidImageFormat(imageUrl)) {
      return _buildErrorWidget();
    }

    return ColorFiltered(
      colorFilter: filterMatrix != null ? ColorFilter.matrix(filterMatrix!) : const ColorFilter.mode(Colors.transparent, BlendMode.color),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit ?? BoxFit.cover,
        filterQuality: filterQuality ?? FilterQuality.high,
        fadeInDuration: Duration.zero,
        fadeOutDuration: Duration.zero,
        cacheKey: cacheKey ?? imageUrl,
        placeholder: (context, url) => _buildPlaceholder(),
        errorWidget: (context, url, error) => _buildErrorWidget(),
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            color: containerColor ?? Colors.transparent,
            image: DecorationImage(
              image: imageProvider,
              fit: fit ?? BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  /// **Valid Image Format Check**
  bool _isValidImageFormat(String url) {
    final validExtensions = ['jpg', 'jpeg', 'webp', 'png'];
    final extension = url.split('.').last.toLowerCase();
    return validExtensions.contains(extension);
  }

  /// **Loading Placeholder (No Flickering)**
  Widget _buildPlaceholder() {
    return placeholder ??
        Stack(
          alignment: Alignment.center,
          children: [
            Shimmer.fromColors(
              baseColor: Colors.grey[800]!,
              highlightColor: Colors.grey[600]!,
              child: Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  color: Colors.grey[700]!,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            Icon(
              Icons.photo_camera,
              size: 50,
              color: Colors.white,
            ),
          ],
        );
  }

  /// **Error Widget**
  Widget _buildErrorWidget() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[700],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(child: Icon(Icons.error, color: Colors.red)),
    );
  }
}

class CustomFileImage extends StatelessWidget {
  final String imagePath;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final Color? containerColor;

  const CustomFileImage({
    required this.imagePath,
    this.width,
    this.height,
    this.fit,
    this.placeholder,
    this.errorWidget,
    this.containerColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Check if the file exists, otherwise display error widget
    final file = File(imagePath);
    if (!file.existsSync()) {
      return _buildErrorWidget();
    }

    return _buildImage(file);
  }

  // **Loading Placeholder (No Flickering)**
  Widget _buildPlaceholder() {
    return placeholder ??
        Shimmer.fromColors(
          baseColor: Colors.grey[800]!,
          highlightColor: Colors.grey[600]!,
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: Colors.grey[700]!,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
  }

  // **Error Widget**
  Widget _buildErrorWidget() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[700],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(child: Icon(Icons.error, color: Colors.red)),
    );
  }

  // **Image Widget**
  _buildImage(File imageFile) {
    return Image.file(
      imageFile,
      width: width,
      height: height,
      fit: fit ?? BoxFit.cover,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (frame == null && !wasSynchronouslyLoaded) {
          return _buildPlaceholder(); // Show loading shimmer while loading
        }
        return child;
      },
      errorBuilder: (context, error, stackTrace) {
        // Return error widget if there's any error in loading the image
        return GestureDetector(
          onTap: () {
            // Optional: Handle retry logic here
          },
          child: Container(
            alignment: Alignment.center,
            color: Colors.grey[200],
            child: const Icon(
              Icons.error,
              color: Colors.red,
            ),
          ),
        );
      },
    );
  }
}

class CommonBackButton extends StatelessWidget {
  final double? width;
  final double? height;
  final Function()? onTap;

  const CommonBackButton({
    Key? key,
    this.width,
    this.height,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double buttonWidth = width ?? Get.width * 0.1;
    final double buttonHeight = height ?? Get.height * 0.05;

    return GestureDetector(
      onTap: onTap ?? () => Get.back(),
      child: Container(
        height: buttonHeight,
        width: buttonWidth,
        decoration: BoxDecoration(
          color: AppColors.whiteColor.withOpacity( 0.1),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: SvgPicture.asset(
          AppImage.leftIC,
          height: buttonHeight * 0.4,
          width: buttonWidth * 0.4,
        ),
      ),
    );
  }
}
