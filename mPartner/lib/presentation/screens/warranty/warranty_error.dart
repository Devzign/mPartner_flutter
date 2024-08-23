import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_string.dart';
import '../../../utils/localdata/language_constants.dart';
import '../userprofile/user_profile_widget.dart';
import 'warranty_manual.dart';
import '../../widgets/headers/back_button_header_widget.dart';
import '../../widgets/verticalspace/vertical_space.dart';

import '../../../../utils/displaymethods/display_methods.dart';

class WarrantyError extends StatelessWidget {
  WarrantyError({
    super.key,
    required this.showManualWarrantyButton,
    required this.message,
  });

  final bool showManualWarrantyButton;
  final String message;

  @override
  Widget build(BuildContext context) {
    //

    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              VerticalSpace(height: 170),
              SvgPicture.asset('assets/mpartner/warning.svg'),
              VerticalSpace(height: 8),
              Text(
                message,
                style: GoogleFonts.poppins(
                  color: AppColors.darkGrey,
                  fontSize: 16 * variablePixelHeight,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
              VerticalSpace(height: 6),
              showManualWarrantyButton
                  ? InkWell(
                      onTap: () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WarrantyManual())),
                      },
                      child: Container(
                        height: 40 * variablePixelHeight,
                        child: Center(
                          child: Text(
                            translation(context).checkSerialNumber,
                            style: GoogleFonts.poppins(
                              color: AppColors.lumiBluePrimary,
                              fontSize: 14 * variablePixelHeight,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.10,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    )
                  : Container(),
            ],
          )
        ],
      )),
    );
  }
}
