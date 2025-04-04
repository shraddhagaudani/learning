import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/static_decoration.dart';

class ButtonWidget extends StatelessWidget {
  final Widget? child;
  final String data;
  final void Function()? onTap;

  const ButtonWidget({
    super.key,
    this.child,
    required this.data,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: width * 0.900,
        padding: padding15,
        decoration: BoxDecoration(
          color: AppColors.black10,
          borderRadius: circular10BorderRadius,
        ),
        child: Text(
          data,
          style: TextStyle(
            color: AppColors.blackColor,
            fontSize: 18,
            fontWeight: fontWeightbold,
          ),
        ),
      ),
    );
  }
}

class CircularProgressButtonWidget extends StatelessWidget {
  final Widget? child;

  final void Function()? onTap;

  const CircularProgressButtonWidget({super.key, this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      alignment: Alignment.center,
      width: width * 0.900,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: circular10BorderRadius,
      ),
      child: CircularProgressIndicator(
        color: AppColors.blackColor,
      ),
    );
  }
}

TextStyle headertextStyle = TextStyle(
  color: AppColors.blackColor,
  fontWeight: fontWeight500,
  fontSize: 16,
);

TextStyle titletextStyle = TextStyle(
  color: AppColors.blackColor,
  fontWeight: fontWeightbold,
  fontSize: 30,
);
TextStyle buttontitletextStyle = TextStyle(
  color: AppColors.whiteColor,
  fontWeight: fontWeightbold,
  fontSize: 28,
);
