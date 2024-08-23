import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/displaymethods/display_methods.dart';
import '../../../utils/localdata/language_constants.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/headers/back_button_header_widget.dart';
import '../../widgets/verticalspace/vertical_space.dart';
import '../userprofile/user_profile_widget.dart';

class CustomerNotPartOfJourney extends StatelessWidget {
  const CustomerNotPartOfJourney({super.key, required this.message});
  final String message;
  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double r = DisplayMethods(context: context).getPixelMultiplier();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      translation(context).accessDenied,
                      style: GoogleFonts.poppins(
                        color: AppColors.darkText2,
                        fontSize: 18 * f,
                        fontWeight: FontWeight.w600,
                        height: 27 / 18,
                      ),
                    ),
                    VerticalSpace(height: 12),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: AppColors.darkGreyText,
                        fontSize: 14 * f,
                        fontWeight: FontWeight.w400,
                        height: 21 / 14,
                        letterSpacing: 0.10,
                      ),
                    )
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PrimaryButton(
                      buttonText: translation(context).okIUnderstand,
                      buttonHeight: 48,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      isEnabled: true),
                ],
              ),
              VerticalSpace(height: 32),
            ]),
      ),
    );
  }
}
