import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

TextStyle getAppFont(TextStyle textStyle) {
  return GoogleFonts.poppins(textStyle: textStyle);
}

class AppTextStyle {
  static TextStyle regularTextStyle = getAppFont(
    const TextStyle(
      fontSize: 14,
      fontFamily: "Poppins",
      fontWeight: FontWeight.w400,
      color: AppColors.whiteColor,
    ),
  );
  static TextStyle regularBlackTextStyle = getAppFont(
    const TextStyle(
      fontSize: 14,
      fontFamily: "Poppins",
      fontWeight: FontWeight.w400,
      color: AppColors.blackColor,
    ),
  );
  static TextStyle regularYellowTextStyle = getAppFont(
    const TextStyle(
      fontSize: 14,
      fontFamily: "Poppins",
      fontWeight: FontWeight.w400,
      color: AppColors.orangeColor,
    ),
  );
  static TextStyle BoldBlackTextStyle = getAppFont(
    const TextStyle(
      fontSize: 16,
      fontFamily: "Poppins",
      fontWeight: FontWeight.bold,
      color: AppColors.blackColor,
    ),
  );
}
