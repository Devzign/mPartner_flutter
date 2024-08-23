import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../presentation/widgets/common_button.dart';
import '../../../../../presentation/widgets/common_divider.dart';
import '../../../../../presentation/widgets/verticalspace/vertical_space.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';
import '../../../../../utils/routes/app_routes.dart';
import '../../../../state/controller/finance_request_list_commercial_controller.dart';
import '../../../../state/controller/finance_requests_lists_controller.dart';
import '../../../../state/controller/go_solar_count_details_controller.dart';
import '../../../../state/controller/solar_design_request_controller.dart';
import '../../../../state/controller/solar_finance_controller.dart';
import '../../../../state/controller/solar_finance_dashboard_controller.dart';
import '../../../../utils/solar_app_constants.dart';

void confirmationBottomSheet(BuildContext context, String title, String? requestId) {
  double variablePixelHeight = DisplayMethods(context: context).getVariablePixelHeight();
  double variablePixelWidth = DisplayMethods(context: context).getVariablePixelWidth();
  double pixelMultiplier = DisplayMethods(context: context).getPixelMultiplier();
  double textFontMultiplier = DisplayMethods(context: context).getTextFontMultiplier();
  SolarFinanceController solarFinanceController = Get.find();
  GoSolarCountDetailsController goSolarCountDetailsController = Get.find();
  SolarFinanceDashboardController solarFinanceDashboardController = Get.find();
  SolarDesignRequestController solarDesignRequestController = Get.find();
  FinanceRequestsListController financeRequestsListController = Get.find();
  FinanceRequestsListCommercialController financeRequestsListCommercialController = Get.find();
  showModalBottomSheet(
    context: context,
    isDismissible: false,
    enableDrag: false,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(25.0 * pixelMultiplier),
      ),
    ),
    builder: (context) {
      return WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Wrap(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                  8 * variablePixelWidth,
                  8 * variablePixelHeight,
                  8 * variablePixelWidth,
                  8 * variablePixelHeight,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const VerticalSpace(height: 40),
                    Padding(
                      padding: EdgeInsets.only(left: 16 * variablePixelWidth),
                      child: Text(
                        title,
                        style: GoogleFonts.poppins(
                          color: AppColors.titleColor,
                          fontSize: 20 * textFontMultiplier,
                          fontWeight: FontWeight.w600,
                          height: 0.06,
                          letterSpacing: 0.50,
                        ),
                      ),
                    ),
                    const VerticalSpace(height: 16),
                    Padding(
                      padding: EdgeInsets.only(left: 16 * pixelMultiplier),
                      child: const CustomDivider(color: AppColors.dividerColor),
                    ),
                    const VerticalSpace(height: 16),
                    Padding(
                      padding: EdgeInsets.only(
                        right: 24 * variablePixelWidth,
                        left: 16 * variablePixelWidth,
                      ),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${translation(context).theRequest} ',
                              style: TextStyle(
                                color: AppColors.darkGrey,
                                fontSize: 16 * textFontMultiplier,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.10,
                              ),
                            ),
                            TextSpan(
                              text: requestId,
                              style: TextStyle(
                                color: AppColors.darkGrey,
                                fontSize: 16 * textFontMultiplier,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.10,
                              ),
                            ),
                            TextSpan(
                              text: ' ${translation(context).hasBeenSentForVerificationAndApproval}',
                              style: TextStyle(
                                color: AppColors.darkGrey,
                                fontSize: 16 * textFontMultiplier,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const VerticalSpace(height: 24),
                    CommonButton(
                      onPressed: () async {
                        solarFinanceController.clearSolarFinanceController();
                        solarDesignRequestController.clearState();
                        await goSolarCountDetailsController.fetchGoSolarCountDetails();
                        await solarFinanceDashboardController.fetchFinancingRequests();
                        financeRequestsListController.clearFinanceRequestList();
                        financeRequestsListCommercialController.clearFinanceRequestList();
                         // Navigator.pop(context);
                         // Navigator.pop(context);
                         // Navigator.pop(context);
                        Navigator.popUntil(context, ModalRoute.withName(AppRoutes.solarFinancingDashboard));
                      },
                      isEnabled: true,
                      buttonText: translation(context).done,
                      containerBackgroundColor: AppColors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
