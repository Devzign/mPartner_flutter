import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../widgets/verticalspace/vertical_space.dart';

class CommonBottomModal extends StatelessWidget {
  String modalLabelText;
  Widget body;
  CommonBottomModal({super.key, required this.modalLabelText, required this.body,});

  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24 * w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.close)),
            VerticalSpace(height: 12),
            Container(
              child: Text(
                modalLabelText,
                style: GoogleFonts.poppins(
                  color: AppColors.titleColor,
                  fontSize: 20 * f,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.50,
                ),
              ),
            ),
            VerticalSpace(height: 16),
            Container(
              width: double.infinity,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    strokeAlign: BorderSide.strokeAlignCenter,
                    color: AppColors.dividerGreyColor,
                  ),
                ),
              ),
            ),
            VerticalSpace(height: 20),
            body
          ],
        ),
      ),
    );
  }
}
