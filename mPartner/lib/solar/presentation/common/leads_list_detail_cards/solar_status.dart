import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/localdata/language_constants.dart';

class SolarStatus extends StatelessWidget {
  SolarStatus({
    super.key,
    this.iconSize = 16,
    this.fontSize = 12,
    this.horizontalSpace = 6,
    required this.status,
  });

  String status;
  double fontSize, iconSize, horizontalSpace;

  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();
    // Define variables for icon and text based on status
    String iconAsset;
    String labelText;
    Color labelColor;

    switch (status) {
      case 'accepted':
        iconAsset = 'assets/mpartner/check_circle.svg';
        labelText = translation(context).accepted;
        labelColor = AppColors.successGreen;
        break;
      case 'approved':
        iconAsset = 'assets/mpartner/check_circle.svg';
        labelText = translation(context).approved;
        labelColor = AppColors.successGreen;
        break;
      case 'rejected':
        iconAsset = 'assets/mpartner/cancel.svg';
        labelText = translation(context).rejected;
        labelColor = AppColors.errorRed;
        break;
      case 'shared':
        iconAsset = 'assets/mpartner/check_circle.svg';
        labelText = translation(context).designShared;
        labelColor = AppColors.successGreen;
        break;
      case 'pending':
        iconAsset = 'assets/solar/design_pending.svg';
        labelText = translation(context).designPending;
        labelColor = AppColors.yellowStar;
        break;
      case 'reassigned':
        iconAsset = 'assets/mpartner/cancel.svg';
        labelText =translation(context).designReassigned;
        labelColor = AppColors.orange;
        break;
      case 'resolved':
        iconAsset = 'assets/mpartner/check_circle.svg';
        labelText = translation(context).resolved;
        labelColor = AppColors.successGreen;
        break;
      case 'in-progress':
        iconAsset = 'assets/solar/design_pending.svg';
        labelText = translation(context).inProgress;
        labelColor = AppColors.yellowStar;
        break;
      case 'in progress':
        iconAsset = 'assets/solar/design_pending.svg';
        labelText = translation(context).inProgress;
        labelColor = AppColors.inProgressColor;
        break;
      case 'rescheduled':
        iconAsset = 'assets/mpartner/cancel.svg';
        labelText = translation(context).rescheduled;
        labelColor = AppColors.orange;
        break;


        var status = ["resolved","in-progress", "rescheduled"];

      default:
        iconAsset = 'assets/mpartner/error.svg';
        labelText = translation(context).pending;
        labelColor = AppColors.goldCoin;
        break;
    }

    bool isTruncated = TooltipHelper.isTextTruncated(
        labelText,
        GoogleFonts.poppins(
          color: labelColor,
          fontSize: fontSize * f,
          fontWeight: FontWeight.w600,
        ),
        w * 130
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        (status=="design pending" || status=="pending"|| status=="in-progress" || status == "in progress")
          ? SizedBox(
            width: (iconSize-2) * f,
            height: (iconSize-2) * f,
            child: SvgPicture.asset(
              iconAsset,
              width: (iconSize-2) * f,
              height: (iconSize-2) * f,
            ),
          )
          : SizedBox(
            width: iconSize * f,
            height: iconSize * f,
            child: SvgPicture.asset(
              iconAsset,
              width: iconSize * w,
              height: iconSize * h,
              color:  labelColor,
            ),
          ),
        if (!isTruncated)
         SizedBox(width: horizontalSpace),
        Container(
          child: isTruncated ?
          Tooltip(
            message: labelText,
            triggerMode: TooltipTriggerMode.tap,
            child: Container(
              width : 130 * w,
              child: Text(
                labelText,
                textAlign: TextAlign.end,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  color: labelColor,
                  fontSize: fontSize * f,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )
          : Text(
            labelText,
            textAlign: TextAlign.end,
            style: GoogleFonts.poppins(
              color: labelColor,
              fontSize: fontSize * f,
              fontWeight: FontWeight.w600,
            ),
          ),
        )
      ],
    );
  }
}

class TooltipHelper {
  static bool isTextTruncated(String text, TextStyle style, double maxWidth) {
    final textSpan = TextSpan(text: text, style: style);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      maxLines: 1,
    );
    textPainter.layout(maxWidth: maxWidth);
    return textPainter.didExceedMaxLines;
  }
}