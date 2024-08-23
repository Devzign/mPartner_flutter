import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../../presentation/widgets/common_button.dart';
import '../../../../../../presentation/widgets/common_divider.dart';
import '../../../../../../presentation/widgets/verticalspace/vertical_space.dart';
import '../../../../../../utils/app_colors.dart';
import '../../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';
import '../../../../../utils/routes/app_routes.dart';
import '../../../../utils/solar_app_constants.dart';

void commonSubmitSuccessBottomsheet(BuildContext context, String title,String submitId, String typeValue) {
  double variablePixelHeight = DisplayMethods(context: context).getVariablePixelHeight();
  double variablePixelWidth = DisplayMethods(context: context).getVariablePixelWidth();
  double pixelMultiplier = DisplayMethods(context: context).getPixelMultiplier();
  double textFontMultiplier = DisplayMethods(context: context).getTextFontMultiplier();

  String submittedText="";

  if(typeValue==SolarAppConstants.online){
    submittedText=translation(context).hasBeenSentForOnline;
  }
  else if (typeValue==SolarAppConstants.onsite){
    submittedText=translation(context).hasBeenSentForOnsite;
  }
  else {
    submittedText=translation(context).hasBeenSentForEndToEnd;
  }

  showModalBottomSheet(
    context: context,
    enableDrag:false,
    isDismissible: false,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(25.0 * pixelMultiplier),
      ),
    ),
    builder: (context) {
      return WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Wrap(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                  8 * variablePixelWidth,
                  8 * variablePixelHeight,
                  8 * variablePixelWidth,
                  8 * variablePixelHeight,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const VerticalSpace(height: 40),
                    Padding(
                      padding: EdgeInsets.only(left: 16 * variablePixelWidth),
                      child: Text(
                        title,
                        style: GoogleFonts.poppins(
                          color: AppColors.titleColor,
                          fontSize: 20 * textFontMultiplier,
                          fontWeight: FontWeight.w600,
                          height: 0.06,
                          letterSpacing: 0.50,
                        ),
                      ),
                    ),
                    const VerticalSpace(height: 16),
                    Padding(
                      padding: EdgeInsets.only(left: 16 * pixelMultiplier),
                      child: const CustomDivider(color: AppColors.dividerColor),
                    ),
                    const VerticalSpace(height: 16),
                    Padding(
                      padding: EdgeInsets.only(
                        right: 24 * variablePixelWidth,
                        left: 16 * variablePixelWidth,
                      ),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "${translation(context).theRequest} ",
                              style: TextStyle(
                                color: AppColors.darkGrey,
                                fontSize: 16 * textFontMultiplier,
                                fontWeight: FontWeight.w400,
                                height: 1.5,
                                letterSpacing: 0.10,
                              ),
                            ),
                            TextSpan(
                              text: submitId,
                              style: TextStyle(
                                color: AppColors.darkGrey,
                                fontSize: 16 * textFontMultiplier,
                                fontWeight: FontWeight.w700,
                                // Making this part bold
                                letterSpacing: 0.10,
                              ),
                            ),
                            TextSpan(
                               text: " $submittedText",
                              style: TextStyle(
                                color: AppColors.darkGrey,
                                fontSize: 16 * textFontMultiplier,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const VerticalSpace(height: 24),
                    CommonButton(
                      containerHeight: 52*variablePixelHeight,
                      onPressed: () {
                        if(typeValue==SolarAppConstants.online){
                          Navigator.of(context).popUntil(ModalRoute.withName(AppRoutes.onlineGuidanceDashboard));
                        }
                        else if (typeValue==SolarAppConstants.onsite){
                          Navigator.of(context).popUntil(ModalRoute.withName(AppRoutes.onsiteGuidanceDashboard));
                        }
                        else {
                          Navigator.of(context).popUntil(ModalRoute.withName(AppRoutes.endToEndDeploymentDashboard));
                        }
                      },
                      isEnabled: true,
                      buttonText: translation(context).done,
                      containerBackgroundColor: AppColors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
