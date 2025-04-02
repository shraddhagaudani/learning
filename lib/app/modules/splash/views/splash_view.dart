import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Reusability/utils/app_colors.dart';
import '../../../../Reusability/utils/app_images.dart';
import '../../../../Reusability/utils/app_text_style.dart';
import '../../../../Reusability/widgets/common_widget.dart';
import '../controllers/splash_controller.dart';


class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  final controller = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Container(
        height: Get.height,
        width: Get.width,
        alignment: Alignment.center,
        color: AppColors.backgroundColor,
        child: Stack(
          children: [
            _buildSplashImage(),
            _buildContent(context),
          ],
        ),
      ),
    );
  }

  /// **Splash Image (with error handling)**
  Widget _buildSplashImage() {
    return Image.asset(
      AppImage.splashImage,
      height: Get.height,
      width: Get.width,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        // Show error icon instead of text
        return Center(
          child: Icon(Icons.error, color: AppColors.whiteColor, size: 50),
        );
      },
    );
  }

  /// **Content with Logo, Text, and Loading Indicator**
  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Get.width * 0.08),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          HBox(MediaQuery.of(context).padding.top + Get.height * 0.015),
          _buildAppIcon(),
          HBox(Get.height * 0.075),
          _buildTitleText(),
          HBox(Get.height * 0.025),
          _buildSubtitleText(),
          HBox(Get.height * 0.075),
          CustomLoadingIndicator(),
          HBox(MediaQuery.of(context).padding.bottom + Get.height * 0.08),
        ],
      ),
    );
  }

  /// **App Icon**
  Widget _buildAppIcon() {
    return Image.asset(
      AppImage.appIcon,
      height: 120,
      width: 120,
      errorBuilder: (context, error, stackTrace) {
        return Icon(Icons.error, color: AppColors.whiteColor, size: 120);
      },
    );
  }

  /// **Main Title**
  Widget _buildTitleText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 70),
      child: Text(
        "Dress Lookify: AI Photo Editor & Art",
        textAlign: TextAlign.center,
        style: AppTextStyle.regularTextStyle.copyWith(
          fontSize: 24,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  /// **Subtitle Text**
  Widget _buildSubtitleText() {
    return Text(
      "Transform Your Look with AI Magic!",
      textAlign: TextAlign.center,
      style: AppTextStyle.regularTextStyle.copyWith(
        fontSize: 12,
        color: AppColors.whiteColor.withAlpha( 0.5.toInt()),
        height: Get.height * 0.0022,
      ),
    );
  }
}

/// **Custom Loading Indicator (Animation)**
class CustomLoadingIndicator extends StatefulWidget {
  const CustomLoadingIndicator({super.key});

  @override
  CustomLoadingIndicatorState createState() => CustomLoadingIndicatorState();
}

class CustomLoadingIndicatorState extends State<CustomLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: _controller.value * 2 * pi,
          child: SizedBox(
            width: 40,
            height: 40,
            child: CustomPaint(painter: LoadingPainter()),
          ),
        );
      },
    );
  }
}

/// **Loading Painter (for custom rotation animation)**
class LoadingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..shader = SweepGradient(
        startAngle: 0,
        endAngle: 2 * pi,
        colors: [
          Colors.white,
          Colors.white.withAlpha( 0.0.toInt()),
        ],
        stops: [0.0, 0.8],
      ).createShader(Rect.fromCircle(center: size.center(Offset.zero), radius: size.width / 2))
      ..strokeWidth = Get.width * 0.015
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawArc(rect, -pi / 2, 2 * pi, false, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
