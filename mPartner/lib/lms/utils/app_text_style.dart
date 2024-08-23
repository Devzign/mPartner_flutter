

import 'dart:ui';

import 'package:google_fonts/google_fonts.dart';

import '../../utils/app_colors.dart';

class AppTextStyle{

  static  getStyle({Color? color,double? fontSize,FontWeight?fontWeight}){
    return GoogleFonts.poppins(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
    );
  }


}