import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../widgets/verticalspace/vertical_space.dart';

class QuickLinksCard extends StatelessWidget {
  final String imagePath;
  final String route;

  QuickLinksCard({
    Key? key,
    required this.imagePath,
    required this.route,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double pixelMultiplier =
        DisplayMethods(context: context).getPixelMultiplier();
    return GestureDetector(
      onTap: () {
        // Check if a route is provided before navigating
        if (route != null) {
          Navigator.pushNamed(context, route!);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: variablePixelWidth * 8),
        child: Column(
          children: [
            Container(
                height: 48 * variablePixelWidth,
                width: 48 * variablePixelWidth,
                child: SvgPicture.asset(
                  imagePath,
                  width: 48 * variablePixelWidth,
                  height: 48 * variablePixelWidth,
                )),
            const VerticalSpace(height: 12),
          ],
        ),
      ),
    );
  }
}

class QuicklinksText extends StatelessWidget {
  final String text;
  final String route;

  QuicklinksText({super.key, required this.text, required this.route});

  @override
  Widget build(BuildContext context) {
    double textMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();
    return GestureDetector(
      onTap: () {
        if (route != null) {
          Navigator.pushNamed(context, route);
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Text(
          text,
          softWrap: true,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            color: AppColors.blackText,
            fontSize: 14 * textMultiplier,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
