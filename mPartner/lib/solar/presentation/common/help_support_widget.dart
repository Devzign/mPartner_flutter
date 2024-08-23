import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../presentation/screens/help_and_support/help_and_support.dart';
import '../../../presentation/widgets/horizontalspace/horizontal_space.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/displaymethods/display_methods.dart';
import '../../../utils/localdata/language_constants.dart';
import '../../../utils/routes/app_routes.dart';

class HelpSupportWidget extends StatefulWidget {
  final String? previousRoute;

  const HelpSupportWidget({
    super.key,
    this.previousRoute,
  });

  @override
  State<HelpSupportWidget> createState() => _HelpSupportWidgetState();
}

class _HelpSupportWidgetState extends State<HelpSupportWidget> {
  @override
  Widget build(BuildContext context) {
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double r = DisplayMethods(context: context).getPixelMultiplier();
    double f = DisplayMethods(context: context).getTextFontMultiplier();

    return Container(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HelpAndSupport(previousRoute: widget.previousRoute,)));
          //Navigator.pushNamed(context, AppRoutes.helpAndSupport);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 18 * w,
              height: 18 * w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.lumiBluePrimary,
                  width: 1.5 * w,
                ),
              ),
              child: Center(
                child: Icon(Icons.question_mark_rounded,
                size: 14,
                color: AppColors.lumiBluePrimary,),
              ),
            ),
            HorizontalSpace(width: 4),
            Text(
              translation(context).helpAndSupport,
              style: GoogleFonts.poppins(
                  fontSize: 14 * f,
                  fontWeight: FontWeight.w500,
                  color: AppColors.lumiBluePrimary),
            )
          ],
        ),
      ),
    );
  }
}
