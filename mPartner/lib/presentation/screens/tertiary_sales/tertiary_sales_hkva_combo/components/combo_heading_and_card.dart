import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import 'combo_card.dart';
import '../../../../widgets/CommonCoins/coin_widget.dart';
import '../../../../widgets/cash_widget.dart';
import '../../../../widgets/horizontalspace/horizontal_space.dart';
import '../../../../widgets/verticalspace/vertical_space.dart';

class ComboHeadingAndCard extends StatelessWidget {
  String productType, serialNumber, productName, remark, status;
  int coins, cashback; 
  bool showCoinsAndCash;
  ComboHeadingAndCard(
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
      required this.showCoinsAndCash});
  String text;
  int coins, cashback;
  bool showCoins;
  bool showCoinsAndCash;

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
        if(showCoinsAndCash)
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            showCoins
                ? CoinWidget(
                    coins: coins,
                    iconSize: 12,
                    textSize: 12,
                  )
                : Container(),
            showCoins ? HorizontalSpace(width: 4) : Container(),
            CashWidget(cash: cashback),
          ],
        )
      ],
    );
  }
}
