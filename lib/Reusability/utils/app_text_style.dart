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
}
