import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import 'common_bottom_modal.dart';
import '../screens/secondary_report/distributor/user_list_filter.dart';

class DropDownButtonWidget extends StatelessWidget {
  String labelText, placeholdertext;
  IconData icon;
  Widget modalBody;
  Color textColor;
  bool isEnabled;
  DropDownButtonWidget(
      {super.key,
      required this.labelText,
      required this.placeholdertext,
      required this.icon,
      this.modalBody = const Scaffold(),
      this.textColor = AppColors.hintColor,
      this.isEnabled = true});

  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();

    return InkWell(
      onTap: () {
        if(isEnabled){
          showModalBottomSheet(
            isScrollControlled: true,
            useSafeArea: true,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28 * r),
                    topRight: Radius.circular(28 * r))),
            showDragHandle: true,
            backgroundColor: Colors.white,
            context: context,
            builder: (BuildContext ctx) {
              return Container(child: modalBody);
            });
        }
      },
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(top: 20 * r, bottom: 12 * r),
            child: Center(
              child: Container(
                height: 48 * h,
                padding: EdgeInsets.only(right: 8 * w),
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                        strokeAlign: BorderSide.strokeAlignCenter,
                        width: 0.25 * w,
                        color: AppColors.lightGrey1),
                    borderRadius: BorderRadius.circular(4 * r),
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.fromLTRB(16 * w, 4 * h, 0, 4 * h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        placeholdertext,
                        style: GoogleFonts.poppins(
                          color: textColor,
                          fontSize: 14 * f,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.50 * w,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Icon(
                        icon,
                        color: AppColors.hintColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 16 * w,
            top: 20 * h,
            child: Container(
              color: Colors.white,
              height: 10 * h,
              child: Text(
                labelText,
                style: GoogleFonts.poppins(
                  color: AppColors.darkGreyText,
                  fontSize: 12 * f,
                  fontWeight: FontWeight.w400,
                  height: 0.01 * h,
                  letterSpacing: 0.40 * w,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
