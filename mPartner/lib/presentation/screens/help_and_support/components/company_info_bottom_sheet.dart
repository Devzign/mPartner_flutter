import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../widgets/common_divider.dart';
import '../../../widgets/verticalspace/vertical_space.dart';
import 'common_details_widget.dart';

void showCompanyInfoBottomSheet(BuildContext context, double variablePixelWidth, double variablePixelHeight, double pixelMultiplier, double textFontMultiplier, Map<String, dynamic> contactDetail) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(25.0 * pixelMultiplier),
      ),
    ),
    builder: (context) =>
        Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Wrap(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(8 * variablePixelWidth, 8 * variablePixelHeight, 8 * variablePixelWidth, 8 * variablePixelHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const VerticalSpace(height: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Center(
                        child: Container(
                          height: 5 * variablePixelHeight,
                          width: 50 * variablePixelWidth,
                          decoration: BoxDecoration(
                            color: AppColors.dividerGreyColor,
                            borderRadius: BorderRadius.circular(
                                12 * pixelMultiplier),
                          ),
                        ),
                      ),
                    ),
                    const VerticalSpace(height: 10),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.close,
                        color: AppColors.black,
                        size: 28 * pixelMultiplier,
                      ),
                    ),
                    const VerticalSpace(height: 20),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 16.0 * variablePixelWidth),
                      child: Text(
                        translation(context).companyInfo,
                        style: GoogleFonts.poppins(
                          color: AppColors.titleColor,
                          fontSize: 20 * textFontMultiplier,
                          fontWeight: FontWeight.w600,
                          height: 0.06 * variablePixelHeight,
                          letterSpacing: 0.50 * variablePixelWidth,
                        ),
                      ),
                    ),
                    const VerticalSpace(height: 16),
                    Padding(
                      padding: EdgeInsets.only(left: 16 * variablePixelWidth),
                      child: const CustomDivider(color: AppColors.dividerColor),
                    ),
                    const VerticalSpace(height: 16),
                    CommonDetailWidget(icon: Icons.location_on_outlined, text: 'Address: ${contactDetail['address'] ?? ''}'),
                    const VerticalSpace(height: 24),
                    CommonDetailWidget(
                        iconAssetPath: 'assets/mpartner/Homepage_Assets/consumer_emi_icon.png',
                        text: contactDetail['sales_support_phoneno']??''),
                    const VerticalSpace(height: 24),
                    CommonDetailWidget(icon: Icons.call_outlined,
                        text: contactDetail['phoneno'] ?? ''),
                    const VerticalSpace(height: 24),
                    CommonDetailWidget(icon: Icons.email_outlined,
                        text:  contactDetail['email'] ?? ''),
                    const VerticalSpace(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
  );
}
