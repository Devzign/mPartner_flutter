import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/displaymethods/display_methods.dart';
import '../../../utils/localdata/language_constants.dart';
import 'help_support_widget.dart';

class SomethingWentWrongSolarScreen extends StatefulWidget {
  final VoidCallback onPressed;
  final String? previousRoute;

  const SomethingWentWrongSolarScreen({
    super.key,
    required this.onPressed,
    this.previousRoute,
  });


  @override
  State<SomethingWentWrongSolarScreen> createState() => _SomethingWentWrongSolarScreenState();
}

class _SomethingWentWrongSolarScreenState extends State<SomethingWentWrongSolarScreen> {
  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
    DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
    DisplayMethods(context: context).getVariablePixelWidth();
    return WillPopScope(
      onWillPop: () async {
        widget.onPressed();
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.white,
          body: Padding(
            padding: EdgeInsets.only(
                top: 24 * variablePixelHeight,
                left: 24 * variablePixelWidth,
                right: 24 * variablePixelWidth),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 24 * variablePixelHeight,
                    width: 24 * variablePixelWidth,
                    child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(
                          Icons.arrow_back_outlined,
                          color: AppColors.iconColor,
                        ),
                        onPressed: widget.onPressed),
                  ),
                  SomethingWentWrongWidget(previousRoute: widget.previousRoute)
                ]),
          ),
        ),
      ),
    );
  }

  Widget SomethingWentWrongWidget({String? previousRoute}){
    double variablePixelHeight =
    DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
    DisplayMethods(context: context).getVariablePixelWidth();
    double textFontMultiplier =
    DisplayMethods(context: context).getTextFontMultiplier();
    double pixelMultiplier =
    DisplayMethods(context: context).getPixelMultiplier();

    return Expanded(
      child: Center(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            26 * variablePixelWidth,
            26 * variablePixelWidth,
            26 * variablePixelWidth,
            40 * variablePixelWidth,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 50 * variablePixelHeight,
              ),
              Container(
                width: 266 * variablePixelWidth,
                height: 266 * variablePixelHeight,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12 * pixelMultiplier),
                  ),
                ),
                child: Lottie.asset(
                    'assets/mpartner/json_assets/img_something_went_wrong.json'),
              ),
              SizedBox(height: 12 * variablePixelHeight),
              Text(
                translation(context).somethingWentWrong,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: AppColors.darkText2,
                  fontSize: 18 * textFontMultiplier,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 12 * variablePixelHeight),
              Text(
                translation(context).experiencingSomeTechnicalDifficulties,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: AppColors.darkGreyText,
                  fontSize: 12 * textFontMultiplier,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: 180 * variablePixelHeight,
              ),
              HelpSupportWidget(previousRoute: previousRoute),
            ],
          ),
        ),
      ),
    );
  }
}
