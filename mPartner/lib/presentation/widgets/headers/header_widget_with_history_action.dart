import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/displaymethods/display_methods.dart';
import '../../../state/contoller/user_data_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/localdata/language_constants.dart';

class HeadingWithHistoryAction extends StatefulWidget {
  final String heading;
  final Function() onPressed;
  final Function() onHistoryPressed;

  const HeadingWithHistoryAction({
    required this.heading,
    required this.onPressed,
    required this.onHistoryPressed,
    super.key
  });

  @override
  State<HeadingWithHistoryAction> createState() => _HeadingWithHistoryActionState();
}

class _HeadingWithHistoryActionState extends State<HeadingWithHistoryAction> {
  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();

    final UserDataController udc = Get.find();

    return Padding(
      padding: EdgeInsets.fromLTRB(14.0 * w, 24.0 * h, 0.0, 0.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    Icons.arrow_back_outlined,
                    color:  AppColors.iconColor,
                    size: 24 * r,
                  ),
                  onPressed: () {
                    widget.onPressed();
                  }),
              FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  widget.heading,
                  style: GoogleFonts.poppins(
                      color:  AppColors.iconColor,
                      fontSize: AppConstants.FONT_SIZE_LARGE * f,
                      fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ]
          ),
          Padding(
            padding: EdgeInsets.only(right: 14.0 * w),
            child: TextButton(
              onPressed: () {
                widget.onHistoryPressed();
              },
              child: Text(
                translation(context).history,
                style: GoogleFonts.poppins(
                  color: AppColors.lumiBluePrimary,
                  fontSize: 14 * f,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
