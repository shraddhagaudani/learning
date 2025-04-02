
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/app_colors.dart';
import '../utils/app_text_style.dart';

class CommonLinearCard extends StatefulWidget {
  final bool index;
  final String title;
  final VoidCallback onTap;

  const CommonLinearCard({
    super.key,
    required this.index,
    required this.title,
    required this.onTap,
  });

  @override
  State<CommonLinearCard> createState() => _CommonLinearCardState();
}

class _CommonLinearCardState extends State<CommonLinearCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: Get.height * 0.013, horizontal: Get.width * 0.04),
        decoration: BoxDecoration(
          color: widget.index ? null : AppColors.black45,
          gradient: widget.index
              ? LinearGradient(
                  begin: FractionalOffset(0.0, 1.0),
                  end: FractionalOffset(1.0, 0.5),
                  stops: [0.0, 0.8],
                  colors: AppColors.appGreenGradientColor,
                )
              : null,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(
          widget.title,
          style: AppTextStyle.regularTextStyle.copyWith(
            fontWeight: widget.index ? FontWeight.w700 : FontWeight.w400,
            overflow: TextOverflow.ellipsis,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
