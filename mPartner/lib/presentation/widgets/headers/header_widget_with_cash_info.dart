import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../state/contoller/cash_summary_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/displaymethods/display_methods.dart';
import '../../../utils/localdata/language_constants.dart';
import '../../../utils/routes/app_routes.dart';
import '../../screens/ismart/ismart_homepage/ismart_homepage.dart';
import '../common_confirmation_alert.dart';
import '../rupee_with_sign_widget.dart';

class HeaderWidgetWithCashInfo extends StatelessWidget {
  const HeaderWidgetWithCashInfo({
    super.key,
    required this.heading,
    required this.icon,
    this.onPressBack,
  });

  final String heading;
  final Icon icon;
  final Function()? onPressBack;

  @override
  Widget build(BuildContext context) {
    CashSummaryController cashSummaryController = Get.find();

    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double pixelMultiplier =
        DisplayMethods(context: context).getPixelMultiplier();
    double textMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();

    return Padding(
      padding: EdgeInsets.fromLTRB(14 * variablePixelWidth,
          24 * variablePixelHeight, 20 * variablePixelWidth, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
            icon: icon,
            onPressed: onPressBack ??
                () async {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return CommonConfirmationAlert(
                            confirmationText1: translation(context)
                                .goingBackWillRestartProcess,
                            confirmationText2:
                                translation(context).areYouSureYouWantToLeave,
                            onPressedYes: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute<void>(
                                    builder: (BuildContext context) =>
                                        const IsmartHomepage()),
                                ModalRoute.withName(AppRoutes.ismartHomepage),
                              );
                            });
                      });
                },
          ),
          Text(
            heading,
            style: GoogleFonts.poppins(
              color: AppColors.iconColor,
              fontSize: AppConstants.FONT_SIZE_LARGE * textMultiplier,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Container(
            alignment: Alignment.center,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.fromLTRB(
                      8 * variablePixelWidth,
                      4 * variablePixelHeight,
                      8 * variablePixelWidth,
                      4 * variablePixelHeight),
                  minimumSize: Size.zero,
                  elevation: 0,
                  backgroundColor: AppColors.lumiLight4,
                  foregroundColor: AppColors.lumiBluePrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(100.0 * pixelMultiplier),
                  ),
                ),
                onPressed: () {},
                child: Row(
                  children: [
                    GetBuilder<CashSummaryController>(
                      builder: (_) {
                        int availableCash =
                            int.tryParse(cashSummaryController.availableCash) ??
                                0;
                        return RupeeWithSignWidget(
                          cash: double.parse(availableCash.toString()),
                          color: AppColors.lumiBluePrimary,
                          size: 12,
                          weight: FontWeight.w500,
                          width: double.infinity,
                        );
                      },
                    ),
                    Text(
                      " ${translation(context).available}",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 12 * textMultiplier,
                      ),
                    )
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
