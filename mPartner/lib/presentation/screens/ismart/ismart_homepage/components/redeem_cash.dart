import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../state/contoller/cash_redemption_options_controller.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';
import 'redeem_chip.dart';

class RedeemCashWidget extends StatefulWidget {
  const RedeemCashWidget({super.key});

  @override
  State<RedeemCashWidget> createState() => _RedeemCashWidgetState();
}

class _RedeemCashWidgetState extends State<RedeemCashWidget> {
  CashRedemptionOptionsController cashRedemptionOptionsController = Get.find();

  @override
  void initState() {
    super.initState();
    if(!cashRedemptionOptionsController.isLoading && cashRedemptionOptionsController.iconURLs.isEmpty) {
      cashRedemptionOptionsController.fetchCashRedemptionOptions();
    }
  }

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double pixelMultiplier =
        DisplayMethods(context: context).getPixelMultiplier();
    return SafeArea(
      top: false,
      child: GetBuilder<CashRedemptionOptionsController>(
        builder: (_) {
          if (cashRedemptionOptionsController.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (cashRedemptionOptionsController.error.isNotEmpty) {
            return Center(
              child: Text(
                'Error: ${cashRedemptionOptionsController.error}',
                style: const TextStyle(color: AppColors.errorRed),
              ),
            );
          } else {
            final bool isDataEmpty =
                cashRedemptionOptionsController.iconURLs.isEmpty;
            if (isDataEmpty) {
              return Container(
                child: Center(
                  child: Text(translation(context).dataNotFound),
                ),
              );
            } else {
              return Container(
                padding: EdgeInsets.only(
                    top: 4 * variablePixelHeight,
                    bottom: 8 * variablePixelHeight),
                width: double.infinity,
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  shadows: [
                    BoxShadow(
                      color: AppColors.boxShadow,
                      blurRadius: 12 * pixelMultiplier,
                      offset: const Offset(0, 2),
                      spreadRadius: 1,
                    )
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    cashRedemptionOptionsController.iconURLs.length,
                    (index) {
                      return RedeemChipWidget(
                        iconUrl:
                            cashRedemptionOptionsController.iconURLs[index] ?? "",
                        text:
                            cashRedemptionOptionsController.iconKeys[index] ?? "",
                      );
                    },
                  ),
                ),
              );
            }
          }
        }
      ),
    );
  }
}
