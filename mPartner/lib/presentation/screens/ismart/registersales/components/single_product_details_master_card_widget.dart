import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../../../state/contoller/user_data_controller.dart';
import '../../../../../../utils/app_colors.dart';
import '../../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../../utils/localdata/language_constants.dart';
import '../../../../../utils/app_constants.dart';
import '../../../../widgets/coin_with_image_widget.dart';
import '../../../../widgets/rupee_with_sign_widget.dart';
import '../uimodels/customer_info.dart';
import '../uimodels/dealer_info.dart';
import '../uimodels/product_details.dart';
import 'dashed_line_painter.dart';

class SingleProductDetailsMasterCard extends StatelessWidget {
  final String stateMsg;
  final ProductDetails productDetails;
  final DealerInfo? dealerInfo;
  final CustomerInfo? customerInfo;
  final DateTime? registerDate;
  final String? saleTime;
  final String? saleType;
  final bool? isOTPVerified;

  const SingleProductDetailsMasterCard({
    super.key,
    required this.stateMsg,
    required this.productDetails,
    this.dealerInfo,
    this.customerInfo,
    this.registerDate,
    this.saleTime,
    required this.saleType,
    this.isOTPVerified,
  });

  String getImagePath(String status) {
    String iconPath = "";
    switch (status.toLowerCase()) {
      case 'accepted':
        iconPath = "assets/mpartner/success.svg";
        break;
      case 'pending':
        iconPath = "assets/mpartner/pending.svg";
        break;
      case 'rejected':
        iconPath = "assets/mpartner/rejected.svg";
        break;
      default:
        iconPath = "assets/mpartner/ic_icon_placeholder.svg";
    }
    return iconPath;
  }

  @override
  Widget build(BuildContext context) {
    String getCashText() {
      String cashType = "";
      switch (productDetails.status.toLowerCase()) {
        case 'accepted':
          cashType = translation(context).earned;
        case 'pending':
          cashType = translation(context).pending;
        case 'rejected':
          cashType = translation(context).rejected;
      }
      return cashType;
    }


    String getCoinText() {
      String coinType = "";
      switch (productDetails.status.toLowerCase()) {
        case 'accepted':
          coinType = translation(context).earned;
        case 'pending':
          coinType = translation(context).pending;
        case 'rejected':
          coinType = translation(context).rejected;
      }
      return coinType;
    }

    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double variableTextMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();
    double variablePixelMultiplier =
        DisplayMethods(context: context).getPixelMultiplier();
    UserDataController controller = Get.find();

    var saleDate = saleType == 'Tertiary'
        ? DateFormat('dd/MM/yyyy').parse(customerInfo!.saleDate)
        : registerDate!;

    String getSaleToDetails() {
      String saleTo = "";
      switch (saleType) {
        case 'Secondary':
          saleTo = translation(context).secondarySaleToDealer;
          break;
        case 'Tertiary':
          saleTo = translation(context).tertiarySaleToCustomer;
          break;
        case 'Intermediary':
          saleTo = translation(context).intermediarySaleToElectrician;
          break;
      }
      return saleTo;
    }

    String getTime(){
      String time = "";
      switch (saleType) {
        case 'Secondary':
          time = saleTime??"";
          break;
        case 'Tertiary':
          time = customerInfo?.saleTime??"";
          break;
        case 'Intermediary':
          time = saleTime??"";
          break;
      }

      return time;
    }

    String formatDate(String responseRegisteredOn){
    DateTime? originalRegisteredOn = (responseRegisteredOn != null)
      ? DateTime.parse(responseRegisteredOn!)?.toLocal()
      : null;
    String formattedRegisteredOn = (originalRegisteredOn != null)
      ? DateFormat(AppConstants.appDateFormatWithTime).format(originalRegisteredOn)
      : "Default Value";

    return formattedRegisteredOn;
  }


    return Stack(children: [
      Container(
        decoration: BoxDecoration(
          color: AppColors.lightWhite1,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            color: AppColors.lightGrey1, // Adjust the color as needed
            width: 1.0, // Adjust the width as needed
          ),
        ),
        margin: EdgeInsets.symmetric(horizontal: 24 * variablePixelWidth),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            24 * variablePixelWidth,
            32 * variablePixelHeight,
            24 * variablePixelWidth,
            16 * variablePixelHeight,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  SvgPicture.asset(getImagePath(productDetails.status)),
                  SizedBox(height: variablePixelHeight * 8),
                  Text("${productDetails.status}!",
                      style: GoogleFonts.poppins(
                        color: AppColors.blackTextHeading,
                        fontSize: variableTextMultiplier * 24,
                        fontWeight: FontWeight.w600,
                      )),
                  SizedBox(height: variablePixelHeight * 12),
                  Text(
                    stateMsg,
                    textAlign: TextAlign.center,
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                        color: AppColors.darkText2,
                        fontSize: 14 * variableTextMultiplier,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.5),
                  ),
                  SizedBox(height: variablePixelHeight * 16),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  (controller.userType=='DEALER')
                  ?Container(
                    padding: EdgeInsets.only(
                      top: 8 * variablePixelHeight,
                      bottom: 8 * variablePixelHeight,
                      left: 10 * variablePixelWidth,
                      right: 10 * variablePixelWidth
                    ),
                    //constraints: BoxConstraints(maxWidth: variablePixelWidth * 130),
                    //width: variablePixelWidth * 143,
                    //height: variablePixelHeight * 76,
                    decoration: BoxDecoration(
                      color: AppColors.goldCoinLight,
                      borderRadius:
                      BorderRadius.circular(10 * variablePixelMultiplier),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CoinWithImageWidget(
                          coin: double.tryParse(
                              productDetails.coinPoint.toString().replaceAll(',', ''))??0,
                          color: AppColors.goldCoin,
                          width: double.infinity,
                          weight: FontWeight.w600,
                          size: 16,
                        ),
                        (isOTPVerified==null || isOTPVerified==true)?
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            "${translation(context).coins} ${getCoinText()} ",
                            overflow: TextOverflow.visible,
                            textAlign: TextAlign.left,
                            softWrap: false,
                            style: GoogleFonts.poppins(
                              color: AppColors.goldCoin,
                              fontSize: 14 * variableTextMultiplier,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.1,
                            ),
                          ),
                        )
                        :Container(),
                      ],
                    ),
                  )
                  :Container(),
                  SizedBox(width: variablePixelWidth * 10),
                  Container(
                    padding: EdgeInsets.only(
                      top: 8 * variablePixelHeight,
                      bottom: 8 * variablePixelHeight,
                      left: 10 * variablePixelWidth,
                      right: 10 * variablePixelWidth
                    ),
                    //constraints: BoxConstraints(maxWidth: variablePixelWidth * 130),
                    //width: variablePixelWidth * 140,
                    //height: variablePixelHeight * 76,
                    decoration: BoxDecoration(
                      color: AppColors.lumiLight4,
                      borderRadius:
                          BorderRadius.circular(10 * variablePixelMultiplier),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RupeeWithSignWidget(
                          cash: double.tryParse(
                              productDetails.wrsPoint.toString().replaceAll(',', ''))??0,
                          color: AppColors.lumiBluePrimary,
                          width: double.infinity,
                          weight: FontWeight.w600,
                          size: 16,
                        ),
                        (isOTPVerified==null || isOTPVerified==true)?
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            "${translation(context).cash} ${getCashText()}",
                            overflow: TextOverflow.visible,
                            textAlign: TextAlign.left,
                            softWrap: false,
                            style: GoogleFonts.poppins(
                              color: AppColors.lumiBluePrimary,
                              fontSize: 14 * variableTextMultiplier,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.1,
                            ),
                          ),
                        )
                        : Container(),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: variablePixelHeight * 16),
              Container(
                child: Center(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: productDetails.remark != "",
                      child: Text(
                        '${translation(context).remark}: ${productDetails.remark}',
                        maxLines: null,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: AppColors.lumiDarkBlack,
                          fontSize: 12 * variableTextMultiplier,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.10,
                        ),
                      ),
                    ),
                    SizedBox(height: variablePixelHeight * 10),
                    Visibility(
                      visible: saleType == "Tertiary",
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: variablePixelWidth * 200,
                          height: variablePixelHeight * 30,
                          decoration: BoxDecoration(
                            color: AppColors.lumiLight5,
                            borderRadius: BorderRadius.circular(
                                100.0 * variablePixelMultiplier),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${translation(context).purchaseVerified} ${isOTPVerified != true ? '${translation(context).withoutText} OTP' : '${translation(context).withText} OTP'}',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  color: AppColors.lumiBluePrimary,
                                  fontSize: 10 * variableTextMultiplier,
                                  fontWeight: FontWeight.w500,
                                  height: 0.16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                )),
              ),
              SizedBox(
                height: variablePixelHeight * 30,
              ),
              CustomPaint(
                  painter: DashedLinePainter(),
                  child: Container(
                    height: 1,
                  )),
              SizedBox(
                height: variablePixelHeight * 30,
              ),
              Container(
                padding:
                    EdgeInsets.symmetric(vertical: 8 * variablePixelHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  (productDetails.productType=='')?'-':productDetails.productType,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    color: AppColors.darkGreyText,
                                    fontSize: 12 * variableTextMultiplier,
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
                                flex:2,
                                child: Text(
                                  (productDetails.modelName=='')?'-':productDetails.modelName,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    color: AppColors.darkGreyText,
                                    fontSize: 12 * variableTextMultiplier,
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
                                flex:3,
                                child: Text(
                                  (productDetails.serialNoCount=='')?'-':productDetails.serialNoCount,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    color: AppColors.darkGreyText,
                                    fontSize: 12 * variableTextMultiplier,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    SizedBox(
                      height: variablePixelHeight * 12,
                    ),
                    Text(
                      getSaleToDetails(),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: AppColors.darkGreyText,
                        fontSize: variableTextMultiplier * 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      height: variablePixelHeight * 4,
                    ),
                    saleType == 'Secondary'
                        ? Text(
                            '${dealerInfo?.dealerName} (${dealerInfo?.disCode})',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: AppColors.darkGreyText,
                              fontSize: variableTextMultiplier * 12,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        : Text(
                            '${customerInfo?.customerName} (+91-${customerInfo?.mobileNo})',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: AppColors.darkGreyText,
                              fontSize: variableTextMultiplier * 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                    SizedBox(
                      height: variablePixelHeight * 4,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                           "${translation(context).registeredOn} ",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: AppColors.darkGreyText,
                            fontSize: variableTextMultiplier * 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          formatDate(productDetails.registeredOn),
                          // " ${DateFormat(AppConstants.appDateFormat).format(saleDate).toString()}, ${getTime()}",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: AppColors.darkText2,
                            fontSize: variableTextMultiplier * 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    )
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
