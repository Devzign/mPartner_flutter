import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../widgets/horizontalspace/horizontal_space.dart';
import '../../../widgets/rupee_with_sign_widget.dart';
import '../../../widgets/rupee_with_sign_widget_with_decimal.dart';
import '../../../widgets/verticalspace/vertical_space.dart';

import '../../../../utils/localdata/language_constants.dart';

class TransferAmountCardGST extends StatelessWidget {
  const TransferAmountCardGST(
      {required this.transferAmount,
      required this.gstDeductionAmount,
      required this.gstDeductionPercentage,
      required this.grossAmountAfterGstDeduction,
      required this.tdsDeduction,
      required this.tdsDeductionPercentage,
      required this.netTransferAmount});

  final double transferAmount;
  final double gstDeductionAmount;
  final double gstDeductionPercentage;
  final double grossAmountAfterGstDeduction;
  final double tdsDeduction;
  final double tdsDeductionPercentage;
  final double netTransferAmount;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double pixelMultiplier = DisplayMethods(context: context).getPixelMultiplier();
    double textMultiplier = DisplayMethods(context: context).getTextFontMultiplier();

    return Padding(
      padding: EdgeInsets.only(
        left: 24 * variablePixelWidth,
        right: 24 * variablePixelWidth,
        top: 16 * (screenHeight / 852),
      ),
      child: Card(
        elevation: 0,
        shadowColor: AppColors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0 * pixelMultiplier),
        ),
        color: AppColors.grey97,
        child: Padding(
          padding: EdgeInsets.all(12.0 * pixelMultiplier),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                translation(context).transferAmount,
                style: GoogleFonts.poppins(
                  fontSize: 16 * textMultiplier,
                  height: 20 / 16,
                  color: AppColors.darkGreyText,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const VerticalSpace(height: 4),
              Divider(
                thickness: 1 * pixelMultiplier,
                color: AppColors.lightGrey2,
              ),
              const VerticalSpace(height: 4),
              Row(
                children: [
                  Text(
                    translation(context).transferAmount,
                    style: GoogleFonts.poppins(
                      fontSize: 12 * textMultiplier,
                      height: 18 / 12,
                      color: AppColors.darkGreyText,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    alignment: Alignment.centerRight,
                    child: 
                    RupeeWithSignWidgetWithDecimal(
                      cash: transferAmount,
                      color: AppColors.darkGreyText,
                      size: 14,
                      weight: FontWeight.w500,
                      width: screenWidth,
                    ),
                  ),
                ],
              ),
              const VerticalSpace(height: 8),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            translation(context).noGstCertificate,
                            style: GoogleFonts.poppins(
                              fontSize: 12 * textMultiplier,
                              height: 18 / 12,
                              color: AppColors.darkGreyText,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const HorizontalSpace(width: 8),
                          GestureDetector(
                            onTap: () {},
                            child: Text(
                              translation(context).updateGST,
                              style: GoogleFonts.poppins(
                                fontSize: 12 * textMultiplier,
                                decoration: TextDecoration.underline,
                                height: 24 / 12,
                                letterSpacing: 0.5,
                                color: AppColors.lumiBluePrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        alignment: Alignment.centerRight,
                        child: 
                        RupeeWithSignWidgetWithDecimal(
                          showSign: true,
                          signText: '-',
                          cash: gstDeductionAmount,
                          color: AppColors.errorRed,
                          size: 14,
                          weight: FontWeight.w500,
                          width: screenWidth,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      '(@${gstDeductionPercentage.toStringAsFixed(0)}% ${translation(context).ofTransferAmount})',
                      style: GoogleFonts.poppins(
                        fontSize: 12 * textMultiplier,
                        height: 20 / 12,
                        color: AppColors.grayText,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
              const VerticalSpace(height: 8),
              Row(
                children: [
                  Text(
                    translation(context).grossAmountAfterDeduction,
                    style: GoogleFonts.poppins(
                      fontSize: 12 * textMultiplier,
                      height: 18 / 12,
                      color: AppColors.darkGreyText,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    alignment: Alignment.centerRight,
                    child: 
                    RupeeWithSignWidgetWithDecimal(
                          cash: grossAmountAfterGstDeduction,
                          color: AppColors.darkGreyText,
                          size: 14,
                          weight: FontWeight.w500,
                          width: screenWidth,
                        ),
                  ),
                ],
              ),
              const VerticalSpace(height: 8),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        translation(context).applicableTds,
                        style: GoogleFonts.poppins(
                          fontSize: 12 * textMultiplier,
                          height: 18 / 12,
                          color: AppColors.darkGreyText,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        alignment: Alignment.centerRight,
                        child: 
                        RupeeWithSignWidgetWithDecimal(
                          showSign: true,
                          signText: '-',
                          cash: tdsDeduction,
                          color: AppColors.errorRed,
                          size: 14,
                          weight: FontWeight.w500,
                          width: screenWidth,
                        ),),
                    ],
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      '(@${tdsDeductionPercentage.toStringAsFixed(0)}% ${translation(context).ofGrossAmountAfterDeduction})',
                      style: GoogleFonts.poppins(
                        fontSize: 12 * textMultiplier,
                        height: 20 / 12,
                        color: AppColors.grayText,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
              const VerticalSpace(height: 4),
              Divider(
                thickness: 1 * pixelMultiplier,
                color: AppColors.lightGrey2,
              ),
              const VerticalSpace(height: 4),
              Row(
                children: [
                  Text(
                    translation(context).netTransferAmount,
                    style: GoogleFonts.poppins(
                      fontSize: 14 * textMultiplier,
                      height: 21 / 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkGreyText,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    alignment: Alignment.centerRight,
                    child: 
                    RupeeWithSignWidgetWithDecimal(
                          cash: netTransferAmount,
                          color: AppColors.darkText2,
                          size: 14,
                          weight: FontWeight.w500,
                          width: screenWidth,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TransferAmountCardWithoutGST extends StatelessWidget {
  const TransferAmountCardWithoutGST(
      {required this.transferAmount,
      required this.tdsDeduction,
      required this.tdsDeductionPercentage,
      required this.netTransferAmount});

  final double transferAmount;
  final double tdsDeduction;
  final double tdsDeductionPercentage;
  final double netTransferAmount;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double pixelMultiplier = DisplayMethods(context: context).getPixelMultiplier();
    double textMultiplier = DisplayMethods(context: context).getTextFontMultiplier();
    
    return Padding(
      padding: EdgeInsets.only(
        left: 20 * variablePixelWidth,
        right: 20 * variablePixelWidth,
        top: 16 * (screenHeight / 852),
      ),
      child: Card(
        elevation: 0,
        shadowColor: AppColors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0 * pixelMultiplier),
        ),
        color: AppColors.grey97,
        child: Padding(
          padding: EdgeInsets.all(12.0 * variablePixelWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                translation(context).transferAmount,
                style: GoogleFonts.poppins(
                  fontSize: 16 * textMultiplier,
                  height: 20 / 16,
                  color: AppColors.darkGreyText,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const VerticalSpace(height: 4),
              Divider(
                thickness: 1 * pixelMultiplier,
                color: AppColors.lightGrey2,
              ),
              const VerticalSpace(height: 4),
              Row(
                children: [
                  Text(
                    translation(context).transferAmount,
                    style: GoogleFonts.poppins(
                      fontSize: 12 * textMultiplier,
                      height: 18 / 12,
                      color: AppColors.darkGreyText,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    alignment: Alignment.centerRight,
                    child:
                        RupeeWithSignWidgetWithDecimal(
                          cash: transferAmount,
                          color: AppColors.darkGreyText,
                          size: 14,
                          weight: FontWeight.w500,
                          width: screenWidth,
                        ),
                  ),
                ],
              ),
              const VerticalSpace(height: 8),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        translation(context).applicableTds,
                        style: GoogleFonts.poppins(
                          fontSize: 12 * textMultiplier,
                          height: 18 / 12,
                          color: AppColors.darkGreyText,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        alignment: Alignment.centerRight,
                        child: 
                        RupeeWithSignWidgetWithDecimal(
                          cash: tdsDeduction,
                          color: AppColors.errorRed,
                          size: 14,
                          weight: FontWeight.w500,
                          width: screenWidth,
                          showSign: true,
                          signText: '-',
                        ),
                      ),
                    ],
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      '(@${tdsDeductionPercentage.toStringAsFixed(0)}% ${translation(context).ofTransferAmount})',
                      style: GoogleFonts.poppins(
                        fontSize: 12 * textMultiplier,
                        height: 20 / 12,
                        color: AppColors.grayText,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
              const VerticalSpace(height: 4),
              Divider(
                thickness: 1 * pixelMultiplier,
                color: AppColors.lightGrey2,
              ),
              const VerticalSpace(height: 4),
              Row(
                children: [
                  Text(
                    translation(context).netTransferAmount,
                    style: GoogleFonts.poppins(
                      fontSize: 14 * textMultiplier,
                      height: 21 / 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkGreyText,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    alignment: Alignment.centerRight,
                    child: 
                    RupeeWithSignWidgetWithDecimal(
                          cash: netTransferAmount,
                          color: AppColors.darkText2,
                          size: 14,
                          weight: FontWeight.w600,
                          width: screenWidth,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
