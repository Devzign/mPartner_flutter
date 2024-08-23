import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';
import '../../../../../utils/routes/app_routes.dart';
import '../../../our_products/components/title_bottom_modal.dart';
import '../../../../widgets/buttons/primary_button.dart';
import '../../../../widgets/buttons/secondary_button.dart';
import '../../../../widgets/horizontalspace/horizontal_space.dart';
import '../../../../widgets/verticalspace/vertical_space.dart';
import '../../tertiary_sales.dart';

class QRScreenBackButton extends StatelessWidget {
  QRScreenBackButton({
    super.key,
    required this.resumeCamera,
  });
  Function resumeCamera;
  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();

    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();
    return Padding(
      padding: EdgeInsets.fromLTRB(24 * w, 0, 24 * w, 32 * w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 36 * h,
            child: Center(
              child: Opacity(
                opacity: 0.40,
                child: Container(
                  width: 32 * w,
                  height: 4 * h,
                  decoration: ShapeDecoration(
                    color: AppColors.bottomSheetDragHandleColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100 * r),
                    ),
                  ),
                ),
              ),
            ),
          ),
          titleBottomModal(
            onPressed: () =>
            {resumeCamera(), Navigator.pop(context)},
            title: translation(context).confirmationAlert,
          ),
          const VerticalSpace(height: 20),
          Text(
            translation(context).goingBackWillDelete,
            style: GoogleFonts.poppins(
              color: AppColors.darkGrey,
              fontSize: 14 * f,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.25 * w,
            ),
          ),
          const VerticalSpace(height: 4),
          Text(
            translation(context).sureToContinue,
            style: GoogleFonts.poppins(
              color: AppColors.darkGrey,
              fontSize: 16 * f,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.10 * w,
            ),
          ),
          const VerticalSpace(height: 20),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              SecondaryButton(
                buttonText: translation(context).no,
                onPressed: () => {
                  resumeCamera(),
                  Navigator.pop(context),
                },
                buttonHeight: 48,
                isEnabled: true,
              ),
              const HorizontalSpace(width: 16),
              PrimaryButton(
                buttonText: translation(context).yes,
                onPressed: () => {
                  // Navigator.pushAndRemoveUntil(
                  //   context,
                  //   MaterialPageRoute<void>(
                  //       builder: (BuildContext context) => TertiarySales()),
                  //   ModalRoute.withName(AppRoutes.tertiarySales),
                  // ),
                  Navigator.pop(context),
                  Navigator.pop(context),

                },
                buttonHeight: 48,
                isEnabled: true,
              ),
            ],
          )
        ],
      ),
    );
  }
}
