import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../help_and_support/help_and_support.dart';

class HelpAndSupportWidget extends StatelessWidget {
  const HelpAndSupportWidget({super.key});

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double textFontMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();
    double pixelMultiplier =
        DisplayMethods(context: context).getPixelMultiplier();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          padding: EdgeInsets.zero,
          icon: Icon(
            Icons.help_outline_sharp,
            color: AppColors.lumiBluePrimary,
            size: 18 * pixelMultiplier,
          ),
          onPressed: () => {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HelpAndSupport()),
            ),
          },
          visualDensity: const VisualDensity(
            horizontal: VisualDensity.minimumDensity,
          ),
        ),
        TextButton(
            style: ButtonStyle(
              padding: MaterialStateProperty.all(EdgeInsets.zero),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const HelpAndSupport()),
              );
            },
            child: Text(
              translation(context).helpAndSupport,
              style: GoogleFonts.poppins(
                color: AppColors.lumiBluePrimary,
                fontSize: 14 * textFontMultiplier,
                fontWeight: FontWeight.w500,
                height: 0.20,
                letterSpacing: 0.10,
              ),
            )),
      ],
    );
  }
}
