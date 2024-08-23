import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/displaymethods/display_methods.dart';
import '../../widgets/verticalspace/vertical_space.dart';

class ReportTypeContainer extends StatelessWidget {
  String? reportType, reportDesc;
  final Widget route;
  ReportTypeContainer(
      {super.key, required this.reportType, required this.reportDesc, this.route = const Scaffold(),});
  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double textMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();
    double pixelMultiplier =
        DisplayMethods(context: context).getPixelMultiplier();

    return InkWell(
      onTap: () {
        if (route is! Scaffold) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => route),
          );
        }
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 12 * w, vertical: 10 * h),
        margin: EdgeInsets.only(top: 20 * h),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: AppColors.lightGrey2),
            borderRadius: BorderRadius.circular(12 * pixelMultiplier),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              reportType ?? "",
              style: GoogleFonts.poppins(
                color: AppColors.darkText2,
                fontSize: 16 * textMultiplier,
                fontWeight: FontWeight.w500,
              ),
            ),
            VerticalSpace(height: 10 * h),
            Text(
              reportDesc ?? "",
              style: GoogleFonts.poppins(
                color: AppColors.grayText,
                fontSize: 14 * textMultiplier,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
    );
  }
}
