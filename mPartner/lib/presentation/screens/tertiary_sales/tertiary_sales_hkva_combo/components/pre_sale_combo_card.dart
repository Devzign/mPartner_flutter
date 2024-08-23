import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../state/contoller/user_data_controller.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';
import '../../../../widgets/verticalspace/vertical_space.dart';

class PreSaleComboCard extends StatelessWidget {
  String productType, serialNumber, productName, remark, status;
  int coins, cashback; 
  bool showCoinsAndCash;
  PreSaleComboCard(
      {super.key,
      required this.productType,
      required this.serialNumber,
      required this.productName,
      required this.remark,
      required this.status,
      required this.coins,
      required this.cashback,
      required this.showCoinsAndCash});
  formatProductTypeString(String str) {
    if (str.contains(":")) {
      return str.replaceAll(":", " ");
    } else if (str.contains("-")) {
      return str.split("-")[0];
    } else {
      return str;
    }
  }

  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double r = DisplayMethods(context: context).getPixelMultiplier();
    double f = DisplayMethods(context: context).getTextFontMultiplier();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          formatProductTypeString(productType),
          style: GoogleFonts.poppins(
            color: AppColors.darkGreyText,
            fontSize: 16 * f,
            fontWeight: FontWeight.w600,
          ),
        ),
        VerticalSpace(height: 12),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16 * w, vertical: 16 * h),
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1 * r, color: AppColors.lightGrey2),
              borderRadius: BorderRadius.circular(10 * r),
            ),
          ),
          child: ComboCard(
              serialNumber: serialNumber,
              productName: productName,
              remark: remark,
              status: status,
              coins: coins,
              cashback: cashback,
              showCoinsAndCash: showCoinsAndCash,),
        ),
        VerticalSpace(height: 12),
      ],
    );
  }
}

class RowWithTwoElements extends StatelessWidget {
  const RowWithTwoElements({
    required this.widget1,
    required this.widget2,
    super.key,
  });
  final Widget widget1, widget2;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(child: widget1),
        Flexible(child: widget2),
      ],
    );
  }
}

class LineOneComboCard extends StatelessWidget {
  LineOneComboCard(
      {super.key,
      required this.text,
      required this.coins,
      required this.cashback,
      required this.showCoins,
      required this.showCoinsAndCash,
      required this.status});
  String text;
  int coins, cashback;
  bool showCoins;
  bool showCoinsAndCash;
  String status;

  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double r = DisplayMethods(context: context).getPixelMultiplier();
    double f = DisplayMethods(context: context).getTextFontMultiplier();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          text,
          style: GoogleFonts.poppins(
            color: AppColors.darkGrey,
            fontSize: 14 * f,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.10 * w,
          ),
        ),
        Status(
          status: status.toLowerCase(),
        ),
      ],
    );
  }
}

class ComboCard extends StatelessWidget {
  String serialNumber, productName, remark, status;
  UserDataController controller = Get.find();
  int coins, cashback;
  bool showCoinsAndCash;
  ComboCard({
    super.key,
    required this.serialNumber,
    required this.productName,
    required this.remark,
    required this.status,
    required this.coins,
    required this.cashback,
    required this.showCoinsAndCash,
  });

  @override
  Widget build(BuildContext context) {
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    var style1 = GoogleFonts.poppins(
      color: AppColors.grayText,
      fontSize: 12 * f,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.10 * w,
    );
    var style2 = GoogleFonts.poppins(
      color: AppColors.darkGrey,
      fontSize: 12 * f,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.10 * w,
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LineOneComboCard(
          text: serialNumber,
          coins: coins,
          cashback: cashback,
          showCoins: controller.userType == "DEALER" ? true : false,
          showCoinsAndCash: showCoinsAndCash,
          status: status,
        ),
        VerticalSpace(height: 12),
        RowWithTwoElements(
          widget1: Text(
            translation(context).modelName,
            style: style1,
          ),
          widget2: Text(
            (productName=='')?'-':productName,
            style: style2,
          ),
        ),
        Visibility(
          visible: remark.isNotEmpty,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                translation(context).remark,
                style: style1,
              ),
              remark.isNotEmpty
                  ? Text(
                      remark,
                      style: style2,
                    )
                  : Container(),
            ],
          ),
        )
      ],
    );
  }
}
class Status extends StatelessWidget {
  const Status({
    super.key,
    this.iconSize = 16,
    this.fontSize = 12,
    this.horizontalSpace = 6,
    required this.status,
  });

  final String status;
  final double fontSize, iconSize, horizontalSpace;

  @override
  Widget build(BuildContext context) {
    double r = DisplayMethods(context: context).getPixelMultiplier();
    double w= DisplayMethods(context: context).getVariablePixelWidth();
    double h= DisplayMethods(context: context).getVariablePixelHeight();
    double f= DisplayMethods(context: context).getTextFontMultiplier();
    String iconAsset;
    String labelText;
    Color labelColor;

    switch (status) {
      case 'accepted':
        iconAsset = 'assets/mpartner/check_circle.svg';
        labelText = 'Accepted';
        labelColor = AppColors.successGreen;
        break;
      case 'pending':
        iconAsset =
            'assets/mpartner/error.svg'; 
        labelText = 'Pending';
        labelColor =
            AppColors.goldCoin; 
        break;
      case 'rejected':
        iconAsset =
            'assets/mpartner/cancel.svg'; 
        labelText = 'Rejected';
        labelColor =
            AppColors.errorRed; 
        break;
      default:
        iconAsset =
            'assets/mpartner/error.svg';
        labelText = 'Pending';
        labelColor =
            AppColors.goldCoin; 
        break;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          iconAsset,
          width: iconSize * f,
          height: iconSize * f,
        ),
      ],
    );
  }
}
