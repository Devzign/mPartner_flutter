import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../state/contoller/coin_to_cashback_conversion_controller.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';
import '../../../../widgets/rupee_with_sign_widget.dart';
import '../../../../widgets/verticalspace/vertical_space.dart';
import 'conversion_rate.dart';

class CashbackDetailsCard extends StatefulWidget {
  CashbackDetailsCard({super.key});

  @override
  State<CashbackDetailsCard> createState() => _CashbackDetailsCardState();
}

class _CashbackDetailsCardState extends State<CashbackDetailsCard> {
  CoinToCashbackConversionController cashbackController = Get.find();

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double pixelMultipler =
        DisplayMethods(context: context).getPixelMultiplier();
    double textMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();

    return SafeArea(
        top: false,
        child: Obx(
          () => cashbackController.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                      vertical: 24 * variablePixelHeight,
                      horizontal: 12 * variablePixelWidth),
                  decoration: ShapeDecoration(
                    color: AppColors.grey97,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        translation(context).cashbackDetails,
                        style: GoogleFonts.poppins(
                          color: AppColors.darkGrey,
                          fontSize: 16 * textMultiplier,
                          fontWeight: FontWeight.w600,
                          height: 0.08 * variablePixelHeight,
                        ),
                      ),
                      const VerticalSpace(height: 24),
                      Container(
                        width: double.infinity,
                        decoration: const ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 1,
                              strokeAlign: BorderSide.strokeAlignCenter,
                              color: AppColors.white_234,
                            ),
                          ),
                        ),
                      ),
                      const VerticalSpace(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            translation(context).transferCoins,
                            style: GoogleFonts.poppins(
                              color: AppColors.darkGreyText,
                              fontSize: 12 * textMultiplier,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            (cashbackController
                                    .coinToCashbackConversion.value.finalCoins)
                                .toString(),
                            style: GoogleFonts.poppins(
                              color: AppColors.darkGreyText,
                              fontSize: 14 * textMultiplier,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                      const VerticalSpace(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            translation(context).applicableRate,
                            style: GoogleFonts.poppins(
                              color: AppColors.darkGreyText,
                              fontSize: 12 * textMultiplier,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            "₹ ${(cashbackController.coinToCashbackConversion.value.conversionRate).toString()} per coin",
                            style: GoogleFonts.poppins(
                              color: AppColors.darkGreyText,
                              fontSize: 14 * textMultiplier,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const VerticalSpace(height: 10),
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                              isScrollControlled: true,
                              useSafeArea: true,
                              enableDrag: false,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(28),
                                      topRight: Radius.circular(28))),
                              showDragHandle: true,
                              backgroundColor: Colors.white,
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  height: 160 * variablePixelHeight,
                                  width: double.infinity,
                                  padding: EdgeInsets.only(
                                      left: 24 * variablePixelWidth,
                                      right: 24 * variablePixelWidth,
                                      bottom: 16 * variablePixelHeight),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Icon(Icons.close)),
                                      const VerticalSpace(height: 24),
                                      Container(
                                        child: Text(
                                          translation(context)
                                              .coinsConversionRate,
                                          style: GoogleFonts.poppins(
                                            color: AppColors.titleColor,
                                            fontSize: 20 * textMultiplier,
                                            fontWeight: FontWeight.w600,
                                            height: 0.06 * variablePixelHeight,
                                            letterSpacing: 0.50,
                                          ),
                                        ),
                                      ),
                                      const VerticalSpace(height: 30),
                                      Container(
                                        width: double.infinity,
                                        decoration: const ShapeDecoration(
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                              width: 1,
                                              strokeAlign:
                                                  BorderSide.strokeAlignCenter,
                                              color: AppColors.dividerGreyColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const VerticalSpace(height: 30),
                                      for (int i = 0;
                                          i <
                                              cashbackController
                                                  .rateList!.length;
                                          i++)
                                        ConversionRateWidget(
                                            start: cashbackController
                                                    .rateList?[i]['rangeStart']
                                                    .toString() ??
                                                "",
                                            end: cashbackController.rateList?[i]
                                                        ['rangeEnd']
                                                    .toString() ??
                                                "",
                                            rate:
                                                cashbackController.rateList?[i]
                                                    ['conversionRate']),
                                    ],
                                  ),
                                );
                              });
                        },
                        child: Text(
                          translation(context).coinsConversionRate,
                          style: GoogleFonts.poppins(
                              color: AppColors.grayText,
                              fontSize: 10 * textMultiplier,
                              fontWeight: FontWeight.w500,
                              height: 0.40 * variablePixelHeight,
                              letterSpacing: 0.50,
                              decoration: TextDecoration.underline,
                              decorationColor: AppColors.grayText,
                              decorationStyle: TextDecorationStyle.dashed,
                              decorationThickness: 2.0 * variablePixelWidth),
                        ),
                      ),
                      const VerticalSpace(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            translation(context).totalCashReward,
                            style: GoogleFonts.poppins(
                              color: AppColors.darkGreyText,
                              fontSize: 14 * textMultiplier,
                              fontWeight: FontWeight.w600,
                              height: 0,
                            ),
                          ),
                          RupeeWithSignWidget(
                                      cash: double.parse(
                                          cashbackController.coinToCashbackConversion.value.totalCashReward.toString()),
                                      color: AppColors.blackText,
                                      size: 14,
                                      weight: FontWeight.w600,
                                      width: 160)
                        ],
                      )
                    ],
                  ),
                ),
        ));
  }
}
