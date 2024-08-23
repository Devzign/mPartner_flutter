import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../presentation/screens/userprofile/user_profile_widget.dart';
import '../../../../presentation/widgets/common_button.dart';
import '../../../../presentation/widgets/headers/back_button_header_widget.dart';
import '../../../../presentation/widgets/horizontalspace/horizontal_space.dart';
import '../../../../presentation/widgets/verticalspace/vertical_space.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../state/controller/finance_request_list_commercial_controller.dart';
import '../../../state/controller/finance_requests_lists_controller.dart';
import '../../../utils/solar_app_constants.dart';
import '../../common/heading_solar.dart';

class FinanceStatusFilter extends StatefulWidget {
  final Function(bool) onFilterApplied;

  const FinanceStatusFilter({super.key, required this.onFilterApplied});

  @override
  State<FinanceStatusFilter> createState() => _FinanceStatusFilterState();
}

class _FinanceStatusFilterState extends State<FinanceStatusFilter> {
  bool showFinanceStatusOptions = true;
  FinanceRequestsListController financeRequestsListController = Get.find();
  String statusValues = "";

  @override
  void initState() {
    super.initState();
    statusValues = financeRequestsListController.financeStatusSelected.value;
  }

  @override
  Widget build(BuildContext context) {
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    FinanceRequestsListCommercialController
        financeRequestsListCommercialController = Get.find();
    return Scaffold(
      backgroundColor: AppColors.lightWhite1,
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          return true;
        },
        child: SafeArea(
            child: Column(
          children: [
            HeadingSolar(
                heading: translation(context).filter,
                onPressed: () {
                  Navigator.pop(context);
                }
            ),
            UserProfileWidget(
              top: 8 * h,
            ),
            const VerticalSpace(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24 * w),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        showFinanceStatusOptions = !showFinanceStatusOptions;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          translation(context).financeStatus,
                          style: GoogleFonts.poppins(
                            color: AppColors.blackText,
                            fontSize: 16 * f,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.10,
                          ),
                        ),
                        showFinanceStatusOptions
                            ? const Icon(Icons.keyboard_arrow_up)
                            : const Icon(Icons.keyboard_arrow_down),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: showFinanceStatusOptions,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        buildStatusCheckbox(SolarAppConstants.approved,
                            translation(context).approved),
                        buildStatusCheckbox(SolarAppConstants.inProgress,
                            translation(context).inProgress),
                        buildStatusCheckbox(SolarAppConstants.rejected,
                            translation(context).rejected),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24 * w),
              child: Row(children: [
                Expanded(
                  child: CommonButton(
                    backGroundColor: AppColors.lightWhite1,
                    textColor: statusValues.isNotEmpty
                        ? AppColors.lumiBluePrimary
                        : AppColors.grayText,
                    onPressed: () {
                      setState(() {
                        widget.onFilterApplied(false);
                      });
                      financeRequestsListController.resetFilter();
                      financeRequestsListCommercialController
                          .clearFinanceRequestList();
                      if (statusValues.isNotEmpty) {
                        financeRequestsListCommercialController
                            .fetchFinanceRequestsList(
                                SolarAppConstants.commercialCategory,
                                financeRequestsListCommercialController
                                    .pageNumberCommercial,
                                SolarAppConstants.pageSize,
                                searchString: financeRequestsListController
                                    .searchStringFinance.value);
                        financeRequestsListController.fetchFinanceRequestsList(
                            SolarAppConstants.residentialCategory,
                            financeRequestsListController.pageNumberResidential,
                            SolarAppConstants.pageSize,
                            searchString: financeRequestsListController
                                .searchStringFinance.value);
                        financeRequestsListController
                            .financeStatusSelected.value = "";
                        Navigator.pop(context);
                      }
                    },
                    isEnabled: true,
                    buttonText: translation(context).reset,
                    containerBackgroundColor: AppColors.lightWhite1,
                    containerHeight: 48 * h,
                    withContainer: false,
                  ),
                ),
                HorizontalSpace(width: 8),
                Expanded(
                  child: CommonButton(
                    onPressed: () {
                      setState(() {
                        widget.onFilterApplied(true);
                      });
                      financeRequestsListController.residentialRequestsList
                          .clear();
                      financeRequestsListController.pageNumberResidential = 1;
                      financeRequestsListCommercialController
                          .commercialRequestsList
                          .clear();
                      financeRequestsListCommercialController
                          .pageNumberCommercial = 1;
                      financeRequestsListController
                          .financeStatusSelected.value = statusValues;
                      financeRequestsListCommercialController
                          .fetchFinanceRequestsList(
                              SolarAppConstants.commercialCategory,
                              financeRequestsListCommercialController
                                  .pageNumberCommercial,
                              SolarAppConstants.pageSize,
                              filterStatus: statusValues,
                              searchString: financeRequestsListController
                                  .searchStringFinance.value);
                      financeRequestsListController.fetchFinanceRequestsList(
                          SolarAppConstants.residentialCategory,
                          financeRequestsListController.pageNumberResidential,
                          SolarAppConstants.pageSize,
                          filterStatus: statusValues,
                          searchString: financeRequestsListController
                              .searchStringFinance.value);
                      Navigator.pop(context);
                    },
                    isEnabled: statusValues.isNotEmpty,
                    buttonText: translation(context).apply,
                    containerBackgroundColor: AppColors.lightWhite1,
                    containerHeight: 48 * h,
                    withContainer: false,
                  ),
                )
              ]),
            ),
            VerticalSpace(height: 40)
          ],
        )),
      ),
    );
  }

  Widget buildStatusCheckbox(String status, String label) {
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    bool isChecked = statusValues.contains(status);

    return GestureDetector(
      onTap: () {
        setState(() {
          isChecked = !isChecked;
          if (isChecked) {
            statusValues = (statusValues ?? '') +
                (statusValues.isNotEmpty ? ',' : '') +
                status;
          } else {
            statusValues = statusValues
                    ?.split(',')
                    ?.where((s) => s != status)
                    ?.join(',') ??
                '';
          }
        });
      },
      child: Row(
        children: [
          Checkbox(
            tristate: false,
            value: isChecked,
            onChanged: (bool? value) {
              setState(() {
                if (value != null) {
                  isChecked = value; // Update isChecked
                  if (isChecked) {
                    statusValues = (statusValues ?? '') +
                        (statusValues.isNotEmpty ? ',' : '') +
                        status;
                  } else {
                    statusValues = statusValues
                            ?.split(',')
                            ?.where((s) => s != status)
                            ?.join(',') ??
                        '';
                  }
                }
              });
            },
            activeColor: AppColors.lumiBluePrimary,
          ),
          Text(
            label,
            style: GoogleFonts.poppins(
              color: AppColors.darkGreyText,
              fontSize: 16 * f,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
