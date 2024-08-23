import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/displaymethods/display_methods.dart';
import 'horizontalspace/horizontal_space.dart';

class Status extends StatelessWidget {
  const Status({
    super.key,
    this.iconSize = 16,
    this.fontSize = 12,
    this.horizontalSpace = 6,
    required this.status,
  });

  final String status;
  final double fontSize, iconSize, horizontalSpace;

  @override
  Widget build(BuildContext context) {
    double r = DisplayMethods(context: context).getPixelMultiplier();
    double w= DisplayMethods(context: context).getVariablePixelWidth();
    double h= DisplayMethods(context: context).getVariablePixelHeight();
    double f= DisplayMethods(context: context).getTextFontMultiplier();
    // Define variables for icon and text based on status
    String iconAsset;
    String labelText;
    Color labelColor;

    switch (status) {
      case 'accepted':
        iconAsset = 'assets/mpartner/check_circle.svg';
        labelText = 'Accepted';
        labelColor = AppColors.successGreen;
        break;
      case 'pending':
        iconAsset =
            'assets/mpartner/error.svg'; // Adjust with the actual asset for pending
        labelText = 'Pending';
        labelColor =
            AppColors.goldCoin; // Adjust with the desired color for pending
        break;
      case 'rejected':
        iconAsset =
            'assets/mpartner/cancel.svg'; // Adjust with the actual asset for rejected
        labelText = 'Rejected';
        labelColor =
            AppColors.errorRed; // Adjust with the desired color for rejected
        break;
      default:
        iconAsset =
            'assets/mpartner/error.svg'; // Adjust with the actual asset for pending
        labelText = 'Pending';
        labelColor =
            AppColors.goldCoin; // Adjust with the desired color for pending
        break;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          iconAsset,
          width: iconSize * r,
          height: iconSize * r,
        ),
        HorizontalSpace(width: horizontalSpace),
        Text(
          labelText,
          style: GoogleFonts.poppins(
            color: labelColor,
            fontSize: fontSize * f,
            fontWeight: FontWeight.w600,
          ),
        )
      ],
    );
  }
}
