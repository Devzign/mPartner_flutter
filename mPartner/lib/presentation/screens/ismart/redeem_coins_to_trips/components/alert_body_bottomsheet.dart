import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_string.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';
import '../../../../widgets/buttons/primary_button.dart';
import '../../../../widgets/verticalspace/vertical_space.dart';
import '../../../our_products/components/title_bottom_modal.dart';

class AlertBodyBottomsheet extends StatelessWidget {
  AlertBodyBottomsheet({super.key, required this.message});
  String message;
  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();

    return Padding(
      padding: EdgeInsets.fromLTRB(24 * w, 4 * h, 24 * w, 32 * h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          titleBottomModal(
            title: translation(context).alert,
            onPressed: () => {},
            showButton: false,
          ),
          const VerticalSpace(height: 20),
          Text(
            message,
            style: GoogleFonts.poppins(
              color: AppColors.darkGrey,
              fontSize: 14 * f,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.10 * w,
            ),
          ),
          const VerticalSpace(height: 20),
          Row(
            children: [
              PrimaryButton(
                  buttonText: translation(context).okIUnderstand,
                  buttonHeight: 48,
                  onPressed: () => {Navigator.pop(context)},
                  isEnabled: true)
            ],
          )
        ],
      ),
    );
  }
}
