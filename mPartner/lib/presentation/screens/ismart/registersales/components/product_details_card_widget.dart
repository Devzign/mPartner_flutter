import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../state/contoller/user_data_controller.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';
import '../../../../widgets/coin_with_image_widget.dart';
import '../../../../widgets/rupee_with_sign_widget.dart';
import '../uimodels/product_details.dart';

class ProductDetailsCardWidget extends StatelessWidget {
  final ProductDetails productDetails;

  const ProductDetailsCardWidget({
    Key? key,
    required this.productDetails,
  }) : super(key: key);

  Widget _buildStatusWidget(status, context){

    double variablePixelHeight =
    DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
    DisplayMethods(context: context).getVariablePixelWidth();
    double variablePixelMultiplier =
    DisplayMethods(context: context).getPixelMultiplier();
    double variableFontMultiplier =
    DisplayMethods(context: context).getTextFontMultiplier();

    String iconPath;
    String text;
    Color color;

    switch (status.toLowerCase()) {
      case 'accepted':
        iconPath = "assets/mpartner/ismart/ic_accepted.svg";
        text = translation(context).accepted;
        color = AppColors.successGreen;
        break;
      case 'pending':
        iconPath = "assets/mpartner/ismart/ic_pending.svg";
        text = translation(context).pending;
        color = AppColors.pendingYellow;
        break;
      case 'rejected':
        iconPath = "assets/mpartner/ismart/ic_cancel.svg";
        text = translation(context).rejected;
        color = AppColors.errorRed;
        break;
      default:
        iconPath = "assets/mpartner/ic_icon_placeholder.svg";
        text = 'Unknown';
        color = AppColors.grayText;
    }

    return Container(
      constraints: BoxConstraints(maxHeight: 60 * variablePixelHeight),
      child: Row(
      children: [
        SvgPicture.asset(iconPath, height: 16 * variablePixelHeight,
          width: 16 * variablePixelWidth,),
        SizedBox(width: 4 * variablePixelWidth),
        Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 13.33 * variableFontMultiplier,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    ),);
  }

  @override
  Widget build(BuildContext context) {

     double variablePixelHeight =
    DisplayMethods(context: context).getVariablePixelHeight();
     double variablePixelWidth =
    DisplayMethods(context: context).getVariablePixelWidth();
     double variablePixelMultiplier =
    DisplayMethods(context: context).getPixelMultiplier();
     double variableTextMultiplier =
     DisplayMethods(context: context).getTextFontMultiplier();
     UserDataController controller = Get.find();

    return Wrap(children: [
      Container(
        decoration: BoxDecoration(
            color: AppColors.lightWhite1,
            borderRadius: BorderRadius.circular(12 * variablePixelMultiplier),
            border: Border.all(color: AppColors.white_234, width: 1)
        ),
        margin: EdgeInsets.symmetric(horizontal: 24 * variablePixelWidth),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical:16 * variablePixelMultiplier,
          horizontal: 16*variablePixelWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    productDetails.serialNoCount,
                    style: GoogleFonts.poppins(
                      fontSize: 14 * variableTextMultiplier,
                      color: AppColors.blackText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      productDetails.coinPoint!=null && controller.userType=='DEALER'? Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 2 * variablePixelHeight,
                          horizontal: 12 * variablePixelWidth),
                      decoration: BoxDecoration(
                        color: AppColors.goldCoinLight,
                        borderRadius: BorderRadius.circular(20 * variablePixelMultiplier),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CoinWithImageWidget(
                            coin: double.parse(
                                productDetails.coinPoint.toString().replaceAll(',', '')),
                            color: AppColors.goldCoin,
                            width: 220,
                            weight: FontWeight.w500,
                            size: 14,
                          )
                        ],
                      ),):SizedBox(),
                    SizedBox(width: 10 * variablePixelWidth,),
                    Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 2 * variablePixelHeight, horizontal: 10 * variablePixelWidth),
                      decoration: BoxDecoration(
                        color: AppColors.lumiLight4,
                        borderRadius: BorderRadius.circular(20 * variablePixelMultiplier),
                      ),
                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          RupeeWithSignWidget(
                            cash: double.parse(
                                productDetails.wrsPoint.toString().replaceAll(',', '')),
                            color: AppColors.lumiBluePrimary,
                            width: 220,
                            weight: FontWeight.w500,
                            size: 14,
                          )
                        ],
                      ),)
                  ],)
                ],
              ),
              SizedBox(height: 12 * variablePixelHeight),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    translation(context).modelName,
                    style: GoogleFonts.poppins(
                      fontSize: 12 * variableTextMultiplier,
                      height: 16/12,
                      fontStyle: FontStyle.normal,
                      color: AppColors.grayText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Container(
                    width: 180*variablePixelWidth,
                    alignment: Alignment.topRight,
                    child: Text(
                      (productDetails.productName=='')?'-':productDetails.productName,
                      softWrap: true,
                      textAlign: TextAlign.right,
                      style: GoogleFonts.poppins(
                        color: AppColors.darkGreyText,
                        fontSize: 12 * variableTextMultiplier,
                        height: 20/12,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 8 * variablePixelHeight),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    translation(context).status,
                    style: GoogleFonts.poppins(
                      fontSize: 12 * variableTextMultiplier,
                      height: 16/12,
                      fontStyle: FontStyle.normal,
                      color: AppColors.grayText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  _buildStatusWidget(productDetails.status, context),
                ],
              ),
              SizedBox(height: 8 * variablePixelHeight),
              (productDetails.remark.isNotEmpty &&
                  productDetails.remark!=null) ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    translation(context).remark,
                    style: GoogleFonts.poppins(
                      fontSize: 12 * variableTextMultiplier,
                      color: AppColors.grayText,
                      height: 16/12,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    productDetails.remark,                    
                    style: GoogleFonts.poppins(
                      fontSize: 12 * variableTextMultiplier,
                      color: AppColors.darkGreyText,
                      height: 20/12,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ): const SizedBox()
            ],
          ),
        ),
      )
    ],);
  }
}
