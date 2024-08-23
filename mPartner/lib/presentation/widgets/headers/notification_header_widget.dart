import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/displaymethods/display_methods.dart';
import '../../../utils/localdata/language_constants.dart';
import '../../../utils/routes/app_routes.dart';

class HeadingNotificationWidget extends StatefulWidget {
  final bool isDynamic;
  final String title;

  const HeadingNotificationWidget(
      {super.key, required this.isDynamic, this.title = ""});

  @override
  State<HeadingNotificationWidget> createState() =>
      _HeadingNotificationWidgetState();
}

class _HeadingNotificationWidgetState extends State<HeadingNotificationWidget> {
  bool isNewMessagesPresent = false;
  String newMessageCount = "";

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double textFontMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();
    double pixelMultiplier =
        DisplayMethods(context: context).getPixelMultiplier();

    return Padding(
      padding: EdgeInsets.fromLTRB(
          !widget.isDynamic ? 0 : 14.0 * variablePixelWidth,
          32.0 * variablePixelHeight,
          0.0 * variablePixelWidth,
          0.0 * variablePixelHeight),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back_outlined,
              color: AppColors.iconColor,
              size: 24 * pixelMultiplier,
            ),
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                Navigator.of(context).pushReplacementNamed(AppRoutes.homepage);
              }
            },
          ),
          Expanded(
            child: Text(
              widget.isDynamic
                  ? widget.title
                  : translation(context).notifications,
              softWrap: true,
              style: GoogleFonts.poppins(
                color: AppColors.iconColor,
                fontSize: AppConstants.FONT_SIZE_LARGE * textFontMultiplier,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(
            width: 10 * variablePixelWidth,
          ),
          Container(
            decoration: isNewMessagesPresent
                ? BoxDecoration(
                    color: AppColors.lumiLight4,
                    borderRadius: BorderRadius.circular(100.0 * pixelMultiplier),
                  )
                : null,
            child: Center(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  8.0 * variablePixelWidth,
                  8.0 * variablePixelHeight,
                  8.0 * variablePixelWidth,
                  8.0 * variablePixelHeight,
                ),
                child: Text(
                  isNewMessagesPresent ? newMessageCount : '',
                  style: GoogleFonts.poppins(
                    color: AppColors.lumiBluePrimary,
                    fontSize: AppConstants.FONT_SIZE_SMALL * textFontMultiplier,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.50 * variablePixelWidth,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
