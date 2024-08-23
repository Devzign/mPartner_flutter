import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../state/contoller/user_data_controller.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_string.dart';
import '../../ismart/cash_coins_history/cash_coin_history_screen.dart';

class HeadingRedeemCash extends StatefulWidget {
  const HeadingRedeemCash({super.key});

  @override
  State<HeadingRedeemCash> createState() => _HeadingRedeemCashState();
}

class _HeadingRedeemCashState extends State<HeadingRedeemCash> {
  final UserDataController udc = Get.find();

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double textFontMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();
    double sizeMultiplier =
        DisplayMethods(context: context).getPixelMultiplier();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              child: SizedBox(
                height: 24 * variablePixelWidth,
                width: 24 * variablePixelWidth,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.arrow_back_outlined,
                    color: AppColors.titleColor,
                  ),
                  onPressed: () => {Navigator.pop(context)},
                ),
              ),
            ),
            SizedBox(
              width: 12 * variablePixelWidth,
            ),
            Text(
              'Redeem Cash',
              style: GoogleFonts.poppins(
                color: AppColors.titleColor,
                fontSize: 22 * textFontMultiplier,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: () {
            if (udc.isPrimaryNumberLogin) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CashCoinHistoryScreen(
                          cardType: FilterCashCoin.cashType)));
            }
          },
          child: Text(
            'History',
            style: GoogleFonts.poppins(
              color: AppColors.lumiBluePrimary,
              fontSize: 14 * textFontMultiplier,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
