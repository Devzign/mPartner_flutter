import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../presentation/widgets/dot_horizontal_divider.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../widgets/coin_with_image_widget.dart';
import '../../../widgets/rupee_with_sign_widget.dart';

class TertiarySalesRegistrationMasterCard extends StatelessWidget {
  final String state;
  final String stateMsg;
  final String cashOrCoinHistory;
  final String data1;
  final String data2;
  final String data3;
  final String data4;
  final String data5;
  final String data6;
  final String data7;
  final String transactionType;
  final String? userType;
  final String serialNumber;
  final String productType;
  final String model;
  final String name;
  final String date;
  final String mobileNumber;
  final String registeredOn;

  const TertiarySalesRegistrationMasterCard({super.key, required this.state, required this.stateMsg, required this.cashOrCoinHistory, required this.data1, required this.data2, required this.data3, required this.transactionType, required this.data4, required this.data5, required this.data6, required this.data7, this.userType
    , required this.serialNumber, required this.productType,required this.model, required this.name, required this.date, required this.mobileNumber, required this.registeredOn
  });

  String getImagePath(String status) {
    switch (status) {
      case 'Success':
        return "assets/mpartner/success.svg";
      case 'Failure':
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
        return "assets/mpartner/ic_paytm.png";
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

    return Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.lightWhite1,
              borderRadius: BorderRadius.circular(10.0 * pixelMultiplier),
              border: Border.all(
                color: AppColors.lightGrey1,  // Adjust the color as needed
                width: 1.0 * variablePixelWidth,  // Adjust the width as needed
              ),
            ),
            margin: EdgeInsets.symmetric(
                vertical : 16 * variablePixelHeight,
                horizontal: 16 * variablePixelWidth),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical : 16 * variablePixelHeight,
                  horizontal: 16 * variablePixelWidth),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      SvgPicture.asset(getImagePath(state)),
                      SizedBox(height: variablePixelHeight*12),
                      Text(stateMsg, style: GoogleFonts.poppins(
                        color: AppColors.blackStatus,
                        fontSize: 24 * textFontMultiplier,
                        fontWeight: FontWeight.w600,
                      )),
                      SizedBox(height: variablePixelHeight*16),
                      Center(
                        child: Text(data1, style: GoogleFonts.poppins(
                          color: AppColors.darkText2,
                          fontSize: 14 * textFontMultiplier,
                          fontWeight: FontWeight.w400,
                        ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: variablePixelHeight*16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if(userType != null && userType == "DEALER")
                        Container(
                          width: data7 != "" ? variablePixelWidth * 151 : variablePixelWidth * 67,
                          decoration: BoxDecoration(
                            color: AppColors.goldCoinLight,
                            borderRadius: BorderRadius.circular(10.0 * pixelMultiplier),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical : 5 * variablePixelHeight,
                                horizontal: 5 * variablePixelWidth),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CoinWithImageWidget(
                                  coin: double.parse(data6),
                                  width: 140,
                                  weight: FontWeight.w600,
                                  size: 16,
                                  color: AppColors.goldCoin,
                                ),
                                if ( data7 != "")
                                Text(
                                  data7,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    color: AppColors.goldCoin,
                                    fontSize: 14 * textFontMultiplier,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      SizedBox(width: variablePixelWidth * 10),
                      //if( userType != null && userType == 'DISTY' )
                      Container(
                        width: data3 != "" ? variablePixelWidth * 151 : variablePixelWidth * 67,
                        decoration: BoxDecoration(
                          color: AppColors.lumiLight4,
                          borderRadius: BorderRadius.circular(10.0 * pixelMultiplier),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical : 5 * variablePixelHeight,
                              horizontal: 5 * variablePixelWidth),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RupeeWithSignWidget(
                                  cash: double.parse(data2),
                                  color: AppColors.lumiBluePrimary,
                                  size: 16,
                                  weight: FontWeight.w600,
                                  width: 140
                              ),
                              if (data3 != "")
                              Text(
                                data3,
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
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: variablePixelHeight * 20),
                  if (data4 != "")
                  Center(
                    child: Text(
                      "${translation(context).remark}: $data4",
                      style: GoogleFonts.poppins(
                        color: AppColors.darkText2,
                        fontSize: 14 * textFontMultiplier,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: variablePixelHeight * 12),
                  Container(
                    width: variablePixelWidth*180,
                    decoration: BoxDecoration(
                      color: AppColors.lumiLight5,
                      borderRadius: BorderRadius.circular(100.0 * pixelMultiplier),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical : 10 * variablePixelHeight,
                          horizontal: 10 * variablePixelWidth),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                data5,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  color: AppColors.lumiBluePrimary,
                                  fontSize: 10 * textFontMultiplier,
                                  fontWeight: FontWeight.w500,
                                  height: 0.16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: variablePixelHeight * 20,),
                  const DotHorizontalDivider(color: AppColors.grayText),
                  SizedBox(height: variablePixelHeight * 30,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              productType,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color: AppColors.darkGreyText,
                                fontSize: 12 * textFontMultiplier,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.10,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 2 * variablePixelWidth),
                            width: 5 * variablePixelWidth,
                            height: 5 * variablePixelHeight,
                            decoration: const ShapeDecoration(
                              color: AppColors.lightGreyOval,
                              shape: OvalBorder(),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              model,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color: AppColors.darkGreyText,
                                fontSize: 12 * textFontMultiplier,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.10,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 2 * variablePixelWidth),
                            width: 5 * variablePixelWidth,
                            height: 5 * variablePixelHeight,
                            decoration: const ShapeDecoration(
                              color: AppColors.lightGreyOval,
                              shape: OvalBorder(),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              serialNumber,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color: AppColors.darkGreyText,
                                fontSize: 12 * textFontMultiplier,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.10,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 25 * variablePixelHeight),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            translation(context).tertiarySaleToCustomer,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: AppColors.darkGreyText,
                              fontSize: 12 * textFontMultiplier,
                              fontWeight: FontWeight.w400,
                              height: 0.14,
                              letterSpacing: 0.10,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20 * variablePixelHeight),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            name,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: AppColors.darkText2,
                              fontSize: 12 * textFontMultiplier,
                              fontWeight: FontWeight.w500,
                              height: 0.14,
                              letterSpacing: 0.10,
                            ),
                          ),
                          SizedBox(width: variablePixelWidth * 2,),
                          Text(
                            ' (+91-$mobileNumber)',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: AppColors.darkText2,
                              fontSize: 12 * textFontMultiplier,
                              fontWeight: FontWeight.w500,
                              height: 0.14,
                              letterSpacing: 0.10,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20 * variablePixelHeight),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            translation(context).registeredOn,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: AppColors.darkGreyText,
                              fontSize: 12 * textFontMultiplier,
                              fontWeight: FontWeight.w400,
                              height: 0.14,
                              letterSpacing: 0.10,
                            ),
                          ),
                          SizedBox(width: variablePixelWidth * 5,),
                          Text(
                            registeredOn,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: AppColors.darkText2,
                              fontSize: 12 * textFontMultiplier,
                              fontWeight: FontWeight.w500,
                              height: 0.14,
                              letterSpacing: 0.10,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30 * variablePixelHeight),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ]
    );

  }
}