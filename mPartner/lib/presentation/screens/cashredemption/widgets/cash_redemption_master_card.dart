import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../widgets/dot_horizontal_divider.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../widgets/rupee_with_sign_widget.dart';
import '../../../widgets/verticalspace/vertical_space.dart';

class CashRedemptionMasterCard extends StatelessWidget {
  final String state;
  final String amount;
  final String redeemstatus;
  final String message;
  final String transactionDate;
  final String transactionId;
  final String transactionMode;

  const CashRedemptionMasterCard(
      {super.key,
      required this.state,
      required this.transactionMode,
      required this.amount,
      required this.redeemstatus,
      required this.message,
      required this.transactionDate,
      required this.transactionId});

  String getImagePath(String status) {
    switch (status) {
      case 'Successful':
        return "assets/mpartner/success.svg";
      case 'Failure':
        return "assets/mpartner/rejected.svg";
      case 'Failed':
        return "assets/mpartner/rejected.svg";
      case 'Pending':
        return "assets/mpartner/pending.svg";
      default:
        return "assets/mpartner/ic_icon_placeholder.svg";
    }
  }

  String getImgBanner(String moduleName) {
    switch (moduleName) {
      case 'Paytm':
        return "assets/mpartner/ic_paytm.png";
      case 'UPI':
        return "assets/mpartner/ic_upi.png";
      case 'PineLab':
        return "assets/mpartner/ic_pinelab.png";
      default:
        return "assets/mpartner/ic_icon_placeholder.png";
    }
  }

  // String formatPinelabDate(String date) {
  //   return DateFormat(AppConstants.cashCoinDateFormatWithTime).format(
  //       DateFormat('d MMMM y, H:mm')
  //           .parse(date.replaceAll(RegExp(r' PM| AM'), '')));
  // }

  String getStateMessage(BuildContext context, String status){
    switch (status) {
      case 'Successful':
        return translation(context).successful;
      case 'Failure':
        return translation(context).failed;
      case 'Pending':
        return translation(context).pending;
      case 'Failed':
        return translation(context).failed;
      default:
        return translation(context).pending;
    }
  }

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
    return Stack(children: [
      Container(
        decoration: BoxDecoration(
          color: AppColors.lightWhite1,
          borderRadius: BorderRadius.circular(10.0 * pixelMultiplier),
          border: Border.all(
            color: AppColors.lightGrey1,
            width: 1.0 * pixelMultiplier,
          ),
        ),
        margin: EdgeInsets.only(
            top: 8 * variablePixelHeight,
            bottom: 24 * variablePixelHeight,
            left: 24 * variablePixelWidth,
            right: 24 * variablePixelHeight),
        child: Padding(
          padding: EdgeInsets.all(16 * pixelMultiplier),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  SvgPicture.asset(getImagePath(state)),
                  VerticalSpace(height: 12),
                  Text('${translation(context).transaction} ${getStateMessage(context, state)}!',
                      style: GoogleFonts.poppins(
                        color: AppColors.blackTextHeading,
                        fontSize: textFontMultiplier * 24,
                        fontWeight: FontWeight.w600,
                      )),
                  VerticalSpace(height: 16),
                  Text(
                    message,
                    style: GoogleFonts.poppins(
                      color: AppColors.blackText,
                      fontSize: textFontMultiplier * 14,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              SizedBox(height: variablePixelHeight * 16),
              (state == 'Successful')
                  ? Container(
                  decoration: BoxDecoration(
                    color: AppColors.lumiLight4,
                    borderRadius: BorderRadius.circular(10.0 * pixelMultiplier),
                  ),
                  padding: EdgeInsets.only(
                      left: 16 * variablePixelWidth,
                      right: 16 * variablePixelWidth,
                      top: 8 * variablePixelHeight,
                      bottom: 8 * variablePixelHeight),
                  child: Column(
                    children: [
                      RupeeWithSignWidget(
                        cash: double.tryParse(amount)?? 0,
                        color: AppColors.lumiBluePrimary,
                        size: 16,
                        weight: FontWeight.w600,
                        width: double.infinity,
                      ),
                      Text(
                        redeemstatus,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: AppColors.lumiBluePrimary,
                          fontSize: 14 * textFontMultiplier,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.10,
                        ),
                      ),
                    ],
                ),
              ):  Container(
                decoration: BoxDecoration(
                  color: AppColors.lumiLight4,
                  borderRadius: BorderRadius.circular(10.0 * pixelMultiplier),
                ),
                padding: EdgeInsets.only(
                    left: 16 * variablePixelWidth,
                    right: 16 * variablePixelWidth,
                    top: 8 * variablePixelHeight,
                    bottom: 8 * variablePixelHeight),
                child: RupeeWithSignWidget(
                  cash: double.tryParse(amount)?? 0,
                  color: AppColors.lumiBluePrimary,
                  size: 16,
                  weight: FontWeight.w600,
                  width: double.infinity,
                ),
              ),
              const VerticalSpace(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    child: Align(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${translation(context).transactionDate}: ',
                                style: GoogleFonts.poppins(
                                  color: AppColors.darkGreyText,
                                  fontSize: 12 * textFontMultiplier,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.10,
                                ),
                              ),
                              Flexible(
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: transactionDate,
                                        style: GoogleFonts.poppins(
                                          color: AppColors.blackText,
                                          fontSize: 12 * textFontMultiplier,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 0.10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const VerticalSpace(height: 8),
                  SizedBox(
                    child: Align(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${translation(context).transactionId}: ',
                                style: GoogleFonts.poppins(
                                  color: AppColors.darkGreyText,
                                  fontSize: 12 * textFontMultiplier,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.10,
                                ),
                              ),
                              Flexible(
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: transactionId,
                                        style: GoogleFonts.poppins(
                                          color: AppColors.blackText,
                                          fontSize: 12 * textFontMultiplier,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 0.10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const VerticalSpace(height: 35),
                  const DotHorizontalDivider(color: AppColors.grayText),
                  const VerticalSpace(height: 35),
                  Column(
                    children: [
                      Text(
                        translation(context).exploreMoreOptionsToRedeem,
                        style: GoogleFonts.poppins(
                          color: AppColors.darkGreyText,
                          fontSize: 14 * textFontMultiplier,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const VerticalSpace(height: 15),
                      Container(
                        width: 297 * variablePixelWidth,
                        height: 114 * variablePixelHeight,
                        decoration: ShapeDecoration(
                          image: DecorationImage(
                            image: AssetImage(getImgBanner(
                                transactionMode)),
                            fit: BoxFit.cover,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12 * pixelMultiplier),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      )
    ]);
  }
}
