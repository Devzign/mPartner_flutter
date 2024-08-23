import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';

class ProductWiseDetailHeader extends StatelessWidget {
  const ProductWiseDetailHeader({super.key});

  @override
  Widget build(BuildContext context) {
    double f = DisplayMethods(context: context).getTextFontMultiplier();
     return Text(
      "Product wise detail",
      textAlign: TextAlign.left,
      style: GoogleFonts.poppins(
        color: AppColors.darkText2,
        fontSize: 16 * f,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
