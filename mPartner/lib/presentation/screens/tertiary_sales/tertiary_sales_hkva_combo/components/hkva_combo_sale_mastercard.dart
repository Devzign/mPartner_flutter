import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../state/contoller/tertiary_sales_combo_controller.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import 'package:dotted_line/dotted_line.dart';

import '../../../../../utils/localdata/language_constants.dart';
import '../../../../widgets/coin_with_image_widget.dart';
import '../../../../widgets/rupee_with_sign_widget.dart';

class HkvaComboMastercard extends StatelessWidget {
  final String status;
  final String statusMsg;
  final String creditInfo;
  final String cash;
  final String cashStatus;
  final String remark;
  final String otpStatus;
  final String coin;
  final String coinStatus;
  final String transactionType;
  final String? userType;
  final String serialNumber;
  final String productType;
  final String model;
  final String name;
  final String date;
  final String mobileNumber;

  const HkvaComboMastercard(
      {super.key,
      required this.status,
      required this.statusMsg,
      required this.creditInfo,
      required this.cash,
      required this.cashStatus,
      required this.transactionType,
      required this.remark,
      required this.otpStatus,
      required this.coin,
      required this.coinStatus,
      this.userType,
      required this.serialNumber,
      required this.productType,
      required this.model,
      required this.name,
      required this.date,
      required this.mobileNumber});

  String getImagePath(String status) {
    switch (status) {
      case 'Accepted':
        return "assets/mpartner/success.svg";
      case 'Rejected':
        return "assets/mpartner/rejected.svg";
      case 'Pending':
        return "assets/mpartner/pending.svg";
      default:
        return "assets/mpartner/ic_icon_placeholder.svg";
    }
  }

  @override
  Widget build(BuildContext context) {
    TertiarySalesHKVAcombo salecontroller = Get.find();
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
            width: 1.0,
          ),
        ),
        margin: EdgeInsets.all(16 * variablePixelWidth),
        child: Padding(
          padding: EdgeInsets.all(16 * variablePixelWidth),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  SvgPicture.asset(getImagePath(status)),
                  SizedBox(height: variablePixelHeight * 12),
                  Text('$statusMsg!',
                      style: GoogleFonts.poppins(
                        color: AppColors.blackStatus,
                        fontSize: 24 * textFontMultiplier,
                        fontWeight: FontWeight.w600,
                      )),
                  SizedBox(height: variablePixelHeight * 16),
                  Center(
                    child: Text(
                      creditInfo,
                      style: GoogleFonts.poppins(
                        color: AppColors.darkText2,
                        fontSize: 14 * textFontMultiplier,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              SizedBox(height: variablePixelHeight * 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (userType != null && userType == "DEALER")
                    Container(
                      padding: EdgeInsets.fromLTRB(
                          10 * variablePixelWidth,
                          8 * variablePixelHeight,
                          10 * variablePixelWidth,
                          8 * variablePixelHeight),
                      decoration: BoxDecoration(
                        color: AppColors.goldCoinLight,
                        borderRadius:
                            BorderRadius.circular(10.0 * pixelMultiplier),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CoinWithImageWidget(
                              coin: double.tryParse(coin.replaceAll(",", "")) ??
                                  0,
                              color: AppColors.goldCoin,
                              size: 16,
                              weight: FontWeight.w600,
                              width: double.infinity),
                          (coinStatus.isEmpty)
                              ? Container()
                              : SizedBox(height: 8 * variablePixelHeight),
                          (coinStatus.isEmpty)
                              ? Container()
                              : Text(
                                  coinStatus,
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
                  SizedBox(width: variablePixelWidth * 10),
                  if (userType != null)
                    Container(
                      padding: EdgeInsets.fromLTRB(
                          10 * variablePixelWidth,
                          8 * variablePixelHeight,
                          10 * variablePixelWidth,
                          8 * variablePixelHeight),
                      decoration: BoxDecoration(
                        color: AppColors.lumiLight4,
                        borderRadius:
                            BorderRadius.circular(10.0 * pixelMultiplier),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RupeeWithSignWidget(
                              cash: double.tryParse(cash) ?? 0,
                              color: AppColors.lumiBluePrimary,
                              size: 16,
                              weight: FontWeight.w600,
                              width: double.infinity),
                          (cashStatus.isEmpty)
                              ? Container()
                              : SizedBox(height: 8 * variablePixelHeight),
                          (cashStatus.isEmpty)
                              ? Container()
                              : Text(
                                  cashStatus,
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
                ],
              ),
              SizedBox(height: variablePixelHeight * 20),
              if(remark.isNotEmpty && remark!='')
              Center(
                child: Text(
                  "${translation(context).remark}: $remark",
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
                width: variablePixelWidth * 180,
                height: variablePixelHeight * 30,
                decoration: BoxDecoration(
                  color: AppColors.lumiLight5,
                  borderRadius: BorderRadius.circular(100.0 * pixelMultiplier),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            otpStatus,
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
              SizedBox(
                height: variablePixelHeight * 20,
              ),
              const DottedLine(dashColor: Colors.black),
              //Divider(color: Colors.grey),
              SizedBox(
                height: variablePixelHeight * 30,
              ),
              Container(
                //padding: EdgeInsets.symmetric(horizontal: 8 * variablePixelWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex:2,
                          child: Text(
                            (productType=='')?'-':productType,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: AppColors.darkGreyText,
                              fontSize: 12 * textFontMultiplier,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.10,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: variablePixelWidth * 5,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2 * variablePixelWidth),
                          width: 5 * variablePixelWidth,
                          height: 5 * variablePixelHeight,
                          decoration: const ShapeDecoration(
                            color: AppColors.lightGreyOval,
                            shape: OvalBorder(),
                          ),
                        ),
                        SizedBox(
                          width: variablePixelWidth * 5,
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            (model=='')?'-':model,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: AppColors.darkGreyText,
                              fontSize: 12 * textFontMultiplier,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.10,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: variablePixelWidth * 5,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2 * variablePixelWidth),
                          width: 5 * variablePixelWidth,
                          height: 5 * variablePixelHeight,
                          decoration: const ShapeDecoration(
                            color: AppColors.lightGreyOval,
                            shape: OvalBorder(),
                          ),
                        ),
                        SizedBox(
                          width: variablePixelWidth * 5,
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            (serialNumber=='')?'-':serialNumber,
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
                        SizedBox(
                          width: variablePixelWidth * 2,
                        ),
                        Text(
                          '(${mobileNumber})',
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
                        SizedBox(
                          width: variablePixelWidth * 2,
                        ),
                        Text(
                          date,
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
              ),
            ],
          ),
        ),
      ),
    ]);
  }
}
