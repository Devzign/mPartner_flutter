import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/displaymethods/display_methods.dart';
import '../../../utils/app_colors.dart';

class CommonRadioListTile<T> extends StatelessWidget {
  const CommonRadioListTile({
    super.key,
    required this.label,
    required this.groupValue,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final T? groupValue;
  final T value;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();

    return GestureDetector(
      onTap: () {
        onChanged(value);
      },
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 8 * h, 24 * w, 8 * h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 20 * h,
              width: 20 * w,
              child: Radio<T>(
                activeColor: AppColors.lumiBluePrimary,
                value: value,
                groupValue: groupValue,
                onChanged: onChanged,
              ),
            ),
            SizedBox(
              width: 8 * w,
            ),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    color: AppColors.darkText2,
                    fontSize: 16 * f,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    height: 24 / 16,
                    letterSpacing: 0.50 * w,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
