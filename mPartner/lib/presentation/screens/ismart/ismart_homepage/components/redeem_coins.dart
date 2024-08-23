import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../state/contoller/coin_redemption_options_controller.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import 'redeem_chip.dart';

class RedeemCoinsWidget extends StatefulWidget {
  const RedeemCoinsWidget({super.key});

  @override
  State<RedeemCoinsWidget> createState() => _RedeemCoinsWidgetState();
}

class _RedeemCoinsWidgetState extends State<RedeemCoinsWidget> {
  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    CoinRedemptionOptionsController coinRedemptionOptionsController =
        Get.find();

    return SafeArea(
      top: false,
      child: Obx(
        () => coinRedemptionOptionsController.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Container(
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
                  shadows: const [
                    BoxShadow(
                      color: AppColors.boxShadow,
                      blurRadius: 12,
                      offset: Offset(0, 2),
                      spreadRadius: 1,
                    )
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                      coinRedemptionOptionsController.iconURLs.length,
                      (index) {
                        return RedeemChipWidget(
                          iconUrl: coinRedemptionOptionsController.iconURLs[index] ?? "",
                          text: coinRedemptionOptionsController.iconKeys[index] ?? "",
                        );
                      },
                    ),
                ),
              ),
      ),
    );
  }
}
