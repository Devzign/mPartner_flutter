import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/localdata/language_constants.dart';

class AcceptButton extends StatefulWidget {
  final bool isEnabled;
  final VoidCallback onPressed;

  const AcceptButton({
    required this.isEnabled,
    required this.onPressed,
    super.key,
  });

  @override
  _AcceptButtonState createState() => _AcceptButtonState();
}

class _AcceptButtonState extends State<AcceptButton> {
  @override

  Widget build(BuildContext context) {
    double variableTextMultiplier = DisplayMethods(context: context).getTextFontMultiplier();
    double variablePixelMultiplier = DisplayMethods(context: context).getPixelMultiplier();

    return ElevatedButton(
      onPressed: widget.isEnabled ? () => widget.onPressed() : null,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25 * variablePixelMultiplier),
        ),
        backgroundColor: widget.isEnabled
            ? AppColors.lumiBluePrimary
            : AppColors.lightWhite2,
        disabledBackgroundColor: AppColors.lightWhite2,
        minimumSize: const Size(double.infinity, 50),
      ),
      child: Text(
        maxLines: 1,
        translation(context).acceptAndProceed,
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(
          fontSize: 15 * variableTextMultiplier,
          fontWeight: FontWeight.normal,
          color: AppColors.lightWhite,
        ),
      ),
    );

    // return CommonButton(
    //   onPressed: widget.onPressed,
    //   backGroundColor: widget.isEnabled
    //       ? AppColors.lumiBluePrimary
    //       : AppColors.lightWhite2,
    //   textColor: AppColors.lightWhite,
    //   isEnabled: widget.isEnabled,
    //   buttonText: "Accept & proceed",
    //   containerBackgroundColor: AppColors.lightWhite1,
    // );
  }
}
