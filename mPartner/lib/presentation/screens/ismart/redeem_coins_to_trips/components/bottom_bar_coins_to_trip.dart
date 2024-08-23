import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/utils.dart';
import '../../../../widgets/buttons/primary_button.dart';
import '../../../../widgets/coin_with_image_widget.dart';
import '../../../../widgets/horizontalspace/horizontal_space.dart';
import '../../../../widgets/verticalspace/vertical_space.dart';

class BottomBarCoinsToTrip extends StatelessWidget {
  const BottomBarCoinsToTrip(
      {super.key,
      required this.onButtonPressed,
      required this.buttonText,
      this.isButtonEnabled = true,
      this.coinCostPerPerson = 3500,
      this.numberOfTravellers = 3,
      this.showCoinsCost = true});
  final bool showCoinsCost;
  final int numberOfTravellers, coinCostPerPerson;
  final String buttonText;
  final onButtonPressed;
  final bool isButtonEnabled;

  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();
    return Container(
      padding: EdgeInsets.only(
        top: 16 * h,
        left: 24 * w,
        right: 24 * w,
        bottom: 32 * h,
      ),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: AppColors.lightGrey2),
          top: BorderSide(width: 1 * w, color: AppColors.lightGrey2),
          right: BorderSide(color: AppColors.lightGrey2),
          bottom: BorderSide(color: AppColors.lightGrey2),
        ),
      ),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Visibility(
              visible: showCoinsCost,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CoinWithImageWidget(
                          coin: double.tryParse("${coinCostPerPerson * numberOfTravellers}") ?? 0,
                          color: AppColors.lumiBluePrimary,
                          size: 20,
                          weight: FontWeight.w600,
                          width: 200),
                    ],
                  ),
                  VerticalSpace(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '${rupeeNoSign.format(coinCostPerPerson)}',
                              style: GoogleFonts.poppins(
                                color: AppColors.hintColor,
                                fontSize: 14 * f,
                                fontWeight: FontWeight.w500,
                                height: 20 / 14,
                              ),
                            ),
                            TextSpan(
                              text: ' X ',
                              style: GoogleFonts.poppins(
                                color: AppColors.hintColor,
                                fontSize: 12 * f,
                                fontWeight: FontWeight.w500,
                                height: 20 / 14,
                              ),
                            ),
                            TextSpan(
                              text: numberOfTravellers.toString(),
                              style: GoogleFonts.poppins(
                                color: AppColors.hintColor,
                                fontSize: 14 * f,
                                fontWeight: FontWeight.w500,
                                height: 20 / 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      HorizontalSpace(width: 4),
                      SizedBox(
                        width: 5 * w,
                        height: 12.5 * f,
                        child: SvgPicture.asset(
                          'assets/mpartner/Products_assets/boy.svg',
                          colorFilter: ColorFilter.mode(
                              AppColors.grayText, BlendMode.srcIn),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            Visibility(
              visible: showCoinsCost,
              replacement: PrimaryButton(
                  buttonText: buttonText,
                  buttonHeight: 48,
                  onPressed: onButtonPressed,
                  isEnabled: isButtonEnabled),
              child: Container(
                width: 206 * w,
                child: Row(children: [
                  PrimaryButton(
                      buttonText: buttonText,
                      buttonHeight: 48,
                      onPressed: onButtonPressed,
                      isEnabled: isButtonEnabled)
                ]),
              ),
            )
          ]),
    );
  }
}
