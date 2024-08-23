import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';

class commonSelectionButton extends StatelessWidget {
  const commonSelectionButton({
    super.key,
    required this.flex,
    required this.myState,
    required this.icon,
    required this.label,
    required this.modalBody,
    this.hide = false,
  });

  final bool hide;
  final String myState, label;
  final int flex;
  final IconData icon;
  final Widget modalBody;

  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();

    return hide == true
        ? Container()
        : Flexible(
            flex: flex,
            child: InkWell(
              onTap: () => {
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
                    constraints: BoxConstraints(maxHeight: 600 * h),
                    builder: (BuildContext context) {
                      return Container(child: modalBody);
                    }),
              },
              child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 10 * f, bottom: 0 * r),
                    child: Center(
                      child: Container(
                        // height: 48 * h,
                        padding: EdgeInsets.only(right: 8 * r),
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
                          padding: EdgeInsets.fromLTRB(16 * w, 4 * f, 0, 4 * f),
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
                                    fontSize: 14 * f,
                                    fontWeight: FontWeight.w400,
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
                          
                          letterSpacing: 0.40 * w,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
  }
}
