import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../screens/network_management/dealer_electrician/components/custom_calender.dart';
import '../verticalspace/vertical_space.dart';
import '../../../utils/app_colors.dart';

import '../../../../utils/displaymethods/display_methods.dart';

class MenuGridItemContainer extends StatelessWidget {
  const MenuGridItemContainer({
    super.key,
    required this.text,
    required this.myIcon,
    this.route = const Scaffold(),
  });

  final String text;
  final Widget route;
  final Widget myIcon;

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double r = DisplayMethods(context: context).getPixelMultiplier();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    return GestureDetector(
      onTap: () {
        if (route is! Scaffold) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => route),
          );
        }
      },
      child: Container(


        padding: EdgeInsets.fromLTRB(
            16 * variablePixelWidth,
            16 * variablePixelHeight,
            16 * variablePixelWidth,
            16 * variablePixelHeight),
        decoration: ShapeDecoration(
          
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: AppColors.white_234),
            borderRadius: BorderRadius.circular(12 * r),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            myIcon,
            const VerticalSpace(height: 12),
            Container(
              child: Text(
                text,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                style: GoogleFonts.poppins(
                  color: AppColors.darkText2,
                  fontSize: 14 * f,
                  height: 20 / 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.50,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class iconContainer extends StatelessWidget {
  iconContainer({super.key, required this.myIcon});
  final Widget myIcon;

  @override
  Widget build(BuildContext context) {
    double r = DisplayMethods(context: context).getPixelMultiplier();
    return Container(
      width: 40 * r,
      height: 40 * r,
      padding: EdgeInsets.all(8 * r),
      decoration: ShapeDecoration(
        color: AppColors.lumiLight4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50 * r),
        ),
      ),
      child: Center(
          child: Container(
        height: 24 * r,
        width: 24 * r,
        child: myIcon,
      )),
    );
  }
}
