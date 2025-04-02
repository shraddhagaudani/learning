
import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/app_text_style.dart';

class OptionsCard extends StatelessWidget {
  final bool index;
  final String title;
  final VoidCallback onTap;
  final EdgeInsetsGeometry? padding;
  final double? fontSize;

  const OptionsCard({
    super.key,
    required this.index,
    required this.onTap,
    required this.title,
    required this.padding,
    this.fontSize,

  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: index ? AppColors.black45 : Colors.white10,
          borderRadius: BorderRadius.circular(100),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: AppTextStyle.regularTextStyle.copyWith(
            fontSize: fontSize ?? 14,
            fontWeight: index ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
