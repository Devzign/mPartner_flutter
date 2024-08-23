import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/displaymethods/display_methods.dart';
import '../../../utils/localdata/language_constants.dart';
import '../../widgets/horizontalspace/horizontal_space.dart';

class CommonRowTravelDocument extends StatelessWidget {
  final String label;
  final String status;
  final VoidCallback? onViewDetails;
  final VoidCallback? onUpload;

  const CommonRowTravelDocument({
    Key? key,
    required this.label,
    required this.status,
    this.onViewDetails,
    this.onUpload,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double variablePixelWidth = DisplayMethods(context: context).getVariablePixelWidth();
    double variablePixelHeight = DisplayMethods(context: context).getVariablePixelHeight();
    double textMultiplier = DisplayMethods(context: context).getTextFontMultiplier();
    Widget? iconWidget;
    switch (status.toLowerCase()) {
      case 'accepted':
        iconWidget = SvgPicture.asset(
          'assets/mpartner/ismart/ic_accepted.svg',
          width: 16 * variablePixelWidth,
          height: 16 * variablePixelHeight,
        );
        break;
      case 'rejected':
        iconWidget = SvgPicture.asset(
          'assets/mpartner/ismart/ic_cancel.svg',
          width: 16 * variablePixelWidth,
          height: 16 * variablePixelHeight,
        );
        break;
      case 'pending':
        iconWidget = SvgPicture.asset(
          'assets/mpartner/ismart/ic_pending.svg',
          width: 16 * variablePixelWidth,
          height: 16 * variablePixelHeight,
        );
        break;
      default:
        iconWidget = null;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(
                color: AppColors.darkGreyText,
                fontSize: 16 * textMultiplier,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.10,
              ),
            ),
            if (iconWidget != null) const HorizontalSpace(width: 4),
            if (iconWidget != null) GestureDetector(
              onTap: onViewDetails, // Call onViewDetails function when tapped
              child: iconWidget,
            ),
          ],
        ),
        GestureDetector(
          onTap: status.toLowerCase() == 'accepted' || status.toLowerCase() == 'pending' || status.toLowerCase() == 'rejected' ? onViewDetails : onUpload,
          child: Text(
            status.toLowerCase() == 'accepted' || status.toLowerCase() == 'pending' || status.toLowerCase() == 'rejected' ? translation(context).viewDetails : translation(context).upload,
            style: GoogleFonts.poppins(
              color: AppColors.lumiBluePrimary,
              fontSize: 14 * textMultiplier,
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.10,
            ),
          ),
        ),
      ],
    );
  }
}
