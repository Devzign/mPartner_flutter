import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../../utils/app_colors.dart';
import '../../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../../utils/localdata/language_constants.dart';
import '../../../../help_and_support/help_and_support.dart';

class HelpAndSupportWidget extends StatelessWidget {
  const HelpAndSupportWidget({super.key});

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
    DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
    DisplayMethods(context: context).getVariablePixelWidth();
    double variableTextMultipier =
    DisplayMethods(context: context).getTextFontMultiplier();

    return Container(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            icon: Icon(
              Icons.help_outline_sharp,
              color: AppColors.lumiBluePrimary,
              size: 18,
            ),
            onPressed: () => {},
          ),
          TextButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.zero),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HelpAndSupport()),
                );
              },
              child: Text(
                translation(context).helpAndSupport,
                style: GoogleFonts.poppins(
                  color: AppColors.lumiBluePrimary,
                  fontSize: 14 * variableTextMultipier,
                  fontWeight: FontWeight.w500,
                  height: 0.20,
                  letterSpacing: 0.10,
                ),
              )
          ),
        ],
      ),
    );
  }
}

