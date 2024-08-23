import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/routes/app_routes.dart';

class Heading extends StatelessWidget {
  const Heading({
    super.key,
    required this.heading,
  });
  final String heading;

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double r = DisplayMethods(context: context).getPixelMultiplier();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    return Padding(
      padding: EdgeInsets.fromLTRB(
          10 * variablePixelWidth, 0, 20 * variablePixelWidth, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
              icon: Icon(
                Icons.close,
                size: 24 * f,
              ),
              onPressed: () => {
                    Navigator.of(context)
                        .popUntil(ModalRoute.withName(AppRoutes.registerSales)),
                    Navigator.of(context).pop(),
              }),
          Text(
            heading,
            style: GoogleFonts.poppins(
              color: AppColors.bottomSheetHeaderTextColor,
              fontSize: 22 * f,
              height: 24 / 22,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
