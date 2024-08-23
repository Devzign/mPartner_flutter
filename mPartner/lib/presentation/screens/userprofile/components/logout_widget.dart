import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../network/api_constants.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../state/clear_states.dart';
import '../../../../state/contoller/auth_contoller.dart';
import '../../../../state/contoller/user_data_controller.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../../utils/requests.dart';
import '../../../../utils/routes/app_routes.dart';
import '../../../widgets/common_button.dart';
import '../../../widgets/common_divider.dart';
import '../../../widgets/verticalspace/vertical_space.dart';

String status = '';
late Map<String, dynamic> responseLogout;



void showLogoutBottomSheet(BuildContext context) {
  double variablePixelHeight =
      DisplayMethods(context: context).getVariablePixelHeight();
  double variablePixelWidth =
      DisplayMethods(context: context).getVariablePixelWidth();
  double pixelMultiplier =
      DisplayMethods(context: context).getPixelMultiplier();
  double textFontMultiplier =
      DisplayMethods(context: context).getTextFontMultiplier();

  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(25.0 * pixelMultiplier),
      ),
    ),
    builder: (context) {
      return Wrap(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(8 * variablePixelWidth,
                8 * variablePixelHeight, 8 * variablePixelWidth, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Center(
                    child: Container(
                      height: 5 * variablePixelHeight,
                      width: 50 * variablePixelWidth,
                      decoration: BoxDecoration(
                        color: AppColors.dividerGreyColor,
                        borderRadius:
                            BorderRadius.circular(12 * pixelMultiplier),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.close,
                    color: AppColors.black,
                  ),
                ),
                const VerticalSpace(height: 20),
                Padding(
                  padding: EdgeInsets.only(left: 16.0 * variablePixelWidth),
                  child: Text(
                    translation(context).loggingOut,
                    style: GoogleFonts.poppins(
                      color: AppColors.titleColor,
                      fontSize: 20 * textFontMultiplier,
                      fontWeight: FontWeight.w600,
                      height: 0.06 * variablePixelHeight,
                      letterSpacing: 0.50 * variablePixelWidth,
                    ),
                  ),
                ),
                const VerticalSpace(height: 10),
                Padding(
                    padding: EdgeInsets.only(
                        left: 16 * variablePixelWidth,
                        top: 16 * variablePixelHeight),
                    child: const CustomDivider(color: AppColors.dividerColor)),
                const VerticalSpace(height: 25),
                Padding(
                  padding: EdgeInsets.only(left: 16 * variablePixelWidth),
                  child: Text(
                    translation(context).areYouSureYouWantToLogOut,
                    style: GoogleFonts.poppins(
                      color: AppColors.darkGreyText,
                      fontSize: 16 * textFontMultiplier,
                      fontWeight: FontWeight.w600,
                      height: 0.09 * variablePixelHeight,
                      letterSpacing: 0.10 * variablePixelWidth,
                    ),
                  ),
                ),
                const VerticalSpace(height: 32),
                CommonButton(
                  onPressed: () {
                    Requests.sendLogoutPostRequest();
                    clearStates();
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.login,
                      (Route<dynamic> route) => false,
                    );
                  },
                  isEnabled: true,
                  buttonText: translation(context).yes,
                  backGroundColor: AppColors.exceedRed,
                  textColor: AppColors.lightWhite,
                  defaultButton: true,
                  containerBackgroundColor: AppColors.white,
                ),
                const VerticalSpace(height: 10),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the bottom sheet
                    },
                    child: Text(
                      translation(context).noIAmNot,
                      style: GoogleFonts.poppins(
                        color: AppColors.lumiBluePrimary,
                        fontSize: 16 * textFontMultiplier,
                        fontWeight: FontWeight.w500,
                        height: 0.09 * variablePixelHeight,
                        letterSpacing: 0.10 * variablePixelWidth,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                const VerticalSpace(height: 44),
              ],
            ),
          ),
        ],
      );
    },
  );
}


Future<dynamic> show_delete(BuildContext context) {
  double variablePixelHeight =
  DisplayMethods(context: context).getVariablePixelHeight();
  double variablePixelWidth =
  DisplayMethods(context: context).getVariablePixelWidth();
  double pixelMultiplier =
  DisplayMethods(context: context).getPixelMultiplier();
  double textFontMultiplier =
  DisplayMethods(context: context).getTextFontMultiplier();

 return showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(25.0 * pixelMultiplier),
      ),
    ),
    builder: (context) {
      return Wrap(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(8 * variablePixelWidth,
                8 * variablePixelHeight, 8 * variablePixelWidth, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Center(
                    child: Container(
                      height: 5 * variablePixelHeight,
                      width: 50 * variablePixelWidth,
                      decoration: BoxDecoration(
                        color: AppColors.dividerGreyColor,
                        borderRadius:
                        BorderRadius.circular(12 * pixelMultiplier),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.close,
                    color: AppColors.black,
                  ),
                ),
                const VerticalSpace(height: 20),
                Padding(
                  padding: EdgeInsets.only(left: 16.0 * variablePixelWidth),
                  child: Text(
                    translation(context).delete,
                    style: GoogleFonts.poppins(
                      color: AppColors.titleColor,
                      fontSize: 20 * textFontMultiplier,
                      fontWeight: FontWeight.w600,
                      height: 0.06 * variablePixelHeight,
                      letterSpacing: 0.50 * variablePixelWidth,
                    ),
                  ),
                ),
                const VerticalSpace(height: 10),
                Padding(
                    padding: EdgeInsets.only(
                        left: 16 * variablePixelWidth,
                        top: 16 * variablePixelHeight),
                    child: const CustomDivider(color: AppColors.dividerColor)),
                const VerticalSpace(height: 25),
                Padding(
                  padding: EdgeInsets.only(left: 16 * variablePixelWidth),
                  child: Text(
                    translation(context).sureAccountDelete,
                    style: GoogleFonts.poppins(
                      color: AppColors.darkGreyText,
                      fontSize: 16 * textFontMultiplier,
                      fontWeight: FontWeight.w600,
                      height: 0.09 * variablePixelHeight,
                      letterSpacing: 0.10 * variablePixelWidth,
                    ),
                  ),
                ),
                const VerticalSpace(height: 32),
                CommonButton(
                  onPressed: () {
                    Navigator.pop(context,true);
                    // Requests.sendLogoutPostRequest();
                    // clearStates();
                    // Navigator.pushNamedAndRemoveUntil(
                    //   context,
                    //   AppRoutes.login,
                    //       (Route<dynamic> route) => false,
                    // );
                  },
                  isEnabled: true,
                  buttonText: translation(context).yes,
                  backGroundColor: AppColors.exceedRed,
                  textColor: AppColors.lightWhite,
                  defaultButton: true,
                  containerBackgroundColor: AppColors.white,
                ),


                const VerticalSpace(height: 44),
              ],
            ),
          ),
        ],
      );
    },
  );
}

Future<dynamic> showDeleteMessage(BuildContext context, String message) {
  double variablePixelHeight =
  DisplayMethods(context: context).getVariablePixelHeight();
  double variablePixelWidth =
  DisplayMethods(context: context).getVariablePixelWidth();
  double pixelMultiplier =
  DisplayMethods(context: context).getPixelMultiplier();
  double textFontMultiplier =
  DisplayMethods(context: context).getTextFontMultiplier();

  return showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(25.0 * pixelMultiplier),
      ),
    ),
    builder: (context) {
      return Wrap(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(8 * variablePixelWidth,
                8 * variablePixelHeight, 8 * variablePixelWidth, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Center(
                    child: Container(
                      height: 5 * variablePixelHeight,
                      width: 50 * variablePixelWidth,
                      decoration: BoxDecoration(
                        color: AppColors.dividerGreyColor,
                        borderRadius:
                        BorderRadius.circular(12 * pixelMultiplier),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.close,
                    color: AppColors.black,
                  ),
                ),
                const VerticalSpace(height: 20),
                Padding(
                  padding: EdgeInsets.only(left: 16.0 * variablePixelWidth),
                  child: Text(
                    translation(context).delete,
                    style: GoogleFonts.poppins(
                      color: AppColors.titleColor,
                      fontSize: 20 * textFontMultiplier,
                      fontWeight: FontWeight.w600,
                      height: 0.06 * variablePixelHeight,
                      letterSpacing: 0.50 * variablePixelWidth,
                    ),
                  ),
                ),
                const VerticalSpace(height: 10),
                Padding(
                    padding: EdgeInsets.only(
                        left: 16 * variablePixelWidth,
                        top: 16 * variablePixelHeight),
                    child: const CustomDivider(color: AppColors.dividerColor)),
                const VerticalSpace(height: 25),
                Padding(
                  padding: EdgeInsets.only(left: 16 * variablePixelWidth),
                  child: Text(
                    message,
                    style: GoogleFonts.poppins(
                      color: AppColors.darkGreyText,
                      fontSize: 16 * textFontMultiplier,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.10 * variablePixelWidth,
                    ),
                  ),
                ),
                const VerticalSpace(height: 32),
                CommonButton(
                  onPressed: () {
                    Navigator.pop(context,true);
                    // Requests.sendLogoutPostRequest();
                    // clearStates();
                    // Navigator.pushNamedAndRemoveUntil(
                    //   context,
                    //   AppRoutes.login,
                    //       (Route<dynamic> route) => false,
                    // );
                  },
                  isEnabled: true,
                  buttonText: translation(context).done,
                  backGroundColor: AppColors.exceedRed,
                  textColor: AppColors.lightWhite,
                  defaultButton: true,
                  containerBackgroundColor: AppColors.white,
                ),


                const VerticalSpace(height: 44),
              ],
            ),
          ),
        ],
      );
    },
  );
}





