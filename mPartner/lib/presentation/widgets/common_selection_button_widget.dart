import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/app_colors.dart';
import '../../utils/displaymethods/display_methods.dart';

class DropDownSelectionButtonWidget extends StatelessWidget {
  const DropDownSelectionButtonWidget({
    super.key,
    required this.flex,
    required this.myState,
    required this.icon,
    required this.label,
    required this.heightOfContainer,
    this.hide = false,
  });

  final bool hide;
  final String myState, label;
  final int flex;
  final IconData icon;
  final double heightOfContainer;

  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();

    return hide == true
        ? Container()
        : Stack(
            children: [
              Container(
                padding: EdgeInsets.only(top: 10 * f, bottom: 0),
                child: Center(
                  child: Container(
                    height: (heightOfContainer - 16) * h + 16 * f,
                    padding: EdgeInsets.only(right: 8 * w),
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            strokeAlign: BorderSide.strokeAlignCenter,
                            width: 1 * w,
                            color: AppColors.lumiBluePrimary),
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
                          Flexible(
                            flex: flex,
                            child: Text(
                              myState,
                              style: GoogleFonts.poppins(
                                color: AppColors.darkGreyText,
                                fontSize: 16 * f,
                                fontWeight: FontWeight.w400,
                                height: 24 / 16,
                                letterSpacing: 0.50 * w,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Icon(icon),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 16 * w,
                top: 2 * f,
                child: Container(
                  color: Colors.white,
                  child: Text(
                    label,
                    style: GoogleFonts.poppins(
                      color: AppColors.darkGrey,
                      fontSize: 12 * f,
                      fontWeight: FontWeight.w400,
                      height: 16 / 12,
                      letterSpacing: 0.40 * w,
                    ),
                  ),
                ),
              )
            ],
          );
  }
}
