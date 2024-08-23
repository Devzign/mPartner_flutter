import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mpartner/presentation/widgets/horizontalspace/horizontal_space.dart';
import 'package:mpartner/utils/localdata/shared_preferences_util.dart';

import '../../../../state/contoller/user_data_controller.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../widgets/verticalspace/vertical_space.dart';

class DateTypesProductDetailWidget extends StatelessWidget {
  String primaryDate, secondaryDate, tertiaryDate;
  bool showPrimaryDate, showSecondaryDate, showTertiaryDate;
  DateTypesProductDetailWidget(
      {super.key,
      this.primaryDate = "",
      this.secondaryDate = "",
      this.tertiaryDate = "",
      this.showPrimaryDate = true,
      this.showSecondaryDate = true,
      this.showTertiaryDate = true});
  UserDataController userDataController = Get.find();

  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: [
        if(showPrimaryDate)
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                translation(context).productPrimaryDate,
                style: GoogleFonts.poppins(
                  color: AppColors.lightGreyBorder,
                  fontSize: 10 * f,
                  fontWeight: FontWeight.w400,
                ),
              ),
              VerticalSpace(height: 4),
              Text(
                primaryDate,
                style: GoogleFonts.poppins(
                  color: AppColors.lumiDarkBlack,
                  fontSize: 12 * f,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
          if(showPrimaryDate)
          HorizontalSpace(width: 4),
          if(showPrimaryDate)
          Container(
            height: 40 * h,
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 0.5,
                  strokeAlign: BorderSide.strokeAlignCenter,
                  color: AppColors.lightGrey2,
                ),
              ),
            ),
          ),
          if(showPrimaryDate)
          HorizontalSpace(width: 4),
        if(showSecondaryDate)
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              translation(context).productSecondaryDate,
              style: GoogleFonts.poppins(
                color: AppColors.lightGreyBorder,
                fontSize: 10 * f,
                fontWeight: FontWeight.w400,
              ),
            ),
            VerticalSpace(height: 4),
            Text(
              secondaryDate,
              style: GoogleFonts.poppins(
                color: AppColors.lumiDarkBlack,
                fontSize: 12 * f,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
        if(showSecondaryDate)
        HorizontalSpace(width: 4),
        if(showSecondaryDate)
        Container(
          height: 40 * h,
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 0.5,
                strokeAlign: BorderSide.strokeAlignCenter,
                color: AppColors.lightGrey2,
              ),
            ),
          ),
        ),
        if(showTertiaryDate)
        HorizontalSpace(width: 4),
        if(showTertiaryDate)
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              translation(context).productTertiaryDate,
              style: GoogleFonts.poppins(
                color: AppColors.lightGreyBorder,
                fontSize: 10 * f,
                fontWeight: FontWeight.w400,
              ),
            ),
            VerticalSpace(height: 4),
            Text(
              tertiaryDate,
              style: GoogleFonts.poppins(
                color: AppColors.lumiDarkBlack,
                fontSize: 12 * f,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        )
      ],
    );
  }
}
