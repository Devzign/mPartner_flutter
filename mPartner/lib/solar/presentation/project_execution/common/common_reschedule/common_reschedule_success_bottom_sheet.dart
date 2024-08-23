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

void commonRescheduleSubmitSuccessBottomsheet(BuildContext context, String title,String responseMessage, String? isFrom, String typeValue) {
  double variablePixelHeight = DisplayMethods(context: context).getVariablePixelHeight();
  double variablePixelWidth = DisplayMethods(context: context).getVariablePixelWidth();
  double pixelMultiplier = DisplayMethods(context: context).getPixelMultiplier();
  double textFontMultiplier = DisplayMethods(context: context).getTextFontMultiplier();

  showModalBottomSheet(
    context: context,
    isDismissible: false,
    enableDrag:false,
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
                              //text: 'The request ',
                              text:(responseMessage.isNotEmpty)?responseMessage:translation(context).reschedulesuccessMessage,
                              style: TextStyle(
                                color: AppColors.darkGrey,
                                fontSize: 16 * textFontMultiplier,
                                fontWeight: FontWeight.w400,
                                height: 1.5,
                                letterSpacing: 0.10,
                              ),
                            ),
                            TextSpan(
                              //text: 'SC2402FN100000',
                              text: '',
                              style: TextStyle(
                                color: AppColors.darkGrey,
                                fontSize: 16 * textFontMultiplier,
                                fontWeight: FontWeight.w700,
                                // Making this part bold
                                letterSpacing: 0.10,
                              ),
                            ),
                            TextSpan(
                              text: '',
                             // text: ' has been sent for verification and approval.',
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
                        if((responseMessage.isEmpty)) {
                          if(isFrom==SolarAppConstants.fromNotificationActiveTab){
                            Navigator.of(context).popUntil(ModalRoute.withName(AppRoutes.notificationHome));
                          }
                          else if(isFrom==SolarAppConstants.fromDashboard){
                            if(typeValue==SolarAppConstants.online){
                              Navigator.of(context).popUntil(ModalRoute.withName(AppRoutes.onlineGuidanceDashboard));
                            }
                            else if (typeValue==SolarAppConstants.onsite){
                              Navigator.of(context).popUntil(ModalRoute.withName(AppRoutes.onsiteGuidanceDashboard));
                            }
                            else {
                              Navigator.of(context).popUntil(ModalRoute.withName(AppRoutes.endToEndDeploymentDashboard));
                            }
                          //  Navigator.of(context).popUntil(ModalRoute.withName(AppRoutes.peDashboard));
                          }
                          else{
                            Navigator.pushReplacementNamed(context,  AppRoutes.homepage);
                          }
                        }
                        else{
                          Navigator.of(context).pop();
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
