import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../widgets/horizontalspace/horizontal_space.dart';

class CustomListTile extends StatelessWidget {
  final String name;
  final String phoneNo;
  final String designation;
  final VoidCallback onTapWhatsApp;
  final VoidCallback onTapCall;

  CustomListTile({
    required this.name,
    required this.phoneNo,
    required this.designation,
    required this.onTapWhatsApp,
    required this.onTapCall,
  });

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight = DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth = DisplayMethods(context: context).getVariablePixelWidth();
    double textFontMultiplier = DisplayMethods(context: context).getTextFontMultiplier();
    double pixelMultiplier = DisplayMethods(context: context).getPixelMultiplier();
    return  ListTile(
      title: Text(designation),
      titleTextStyle: GoogleFonts.poppins(
        color: AppColors.darkGreyText,
        fontSize: 12 * textFontMultiplier,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.50 * variablePixelWidth,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              name,
              style:  GoogleFonts.poppins(
                color: AppColors.darkText2,
                fontSize: 16 * textFontMultiplier,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.25 * variablePixelWidth,
              )
          ),
          Text(
               '$phoneNo' ?? '',
              style:  GoogleFonts.poppins(
                color: AppColors.darkGreyText,
                fontSize: 12 * textFontMultiplier,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.50 * variablePixelWidth,
              )
          ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: onTapWhatsApp,
            child: Container(
              width: 32 * variablePixelWidth,
              height: 32 * variablePixelHeight,
              child: Center(
                child: Image.asset('assets/mpartner/whats_app_logo.png',
                  width: 32 * variablePixelWidth,
                  height: 32 * variablePixelHeight,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          const HorizontalSpace(width: 24),
          InkWell(
            onTap: onTapCall,
            child: Container(
              width: 32 * variablePixelWidth,
              height: 32 * variablePixelHeight,
              padding: EdgeInsets.fromLTRB(8 * variablePixelWidth, 8 * variablePixelHeight, 8 * variablePixelWidth, 8 * variablePixelHeight),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4 * pixelMultiplier),
                color: AppColors.lumiBluePrimary,
              ),
              child: Center(
                child: Icon(Icons.call, size: 12 * pixelMultiplier, color: AppColors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
