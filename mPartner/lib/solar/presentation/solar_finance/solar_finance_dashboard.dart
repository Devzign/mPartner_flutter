import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../presentation/screens/home/widgets/section_headings.dart';
import '../../../presentation/screens/userprofile/user_profile_widget.dart';
import '../../../presentation/widgets/headers/back_button_header_widget.dart';
import '../../../presentation/widgets/verticalspace/vertical_space.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/displaymethods/display_methods.dart';
import '../../../utils/localdata/language_constants.dart';
import '../../state/controller/finance_requests_lists_controller.dart';
import '../../state/controller/solar_finance_dashboard_controller.dart';
import '../../utils/solar_app_constants.dart';
import '../common/dashboard/dashboard.dart';
import '../common/heading_solar.dart';
import '../common/help_support_widget.dart';
import 'existing_leads/existing_leads.dart';
import 'financing_options.dart';
import 'solar_finance_request/solar_finance_request_form.dart';

class SolarFinanceDashboard extends StatefulWidget {
  const SolarFinanceDashboard({super.key});

  @override
  State<SolarFinanceDashboard> createState() => _SolarFinanceDashboardState();
}

class _SolarFinanceDashboardState extends State<SolarFinanceDashboard> {
  SolarFinanceDashboardController solarFinanceDashboardController = Get.find();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      solarFinanceDashboardController.fetchFinancingRequests();
    });
  }

  @override
  Widget build(BuildContext context) {
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double r = DisplayMethods(context: context).getPixelMultiplier();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    FinanceRequestsListController financeRequestsListController = Get.find();
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
                heading: translation(context).finance,
                onPressed: () {
                  Navigator.pop(context);
                }),
            UserProfileWidget(
              top: 8 * h,
            ),
            const VerticalSpace(height: 4),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24 * w),
              child: Column(children: [
                SectionHeading(
                  text: translation(context).finance,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FinancingOptions()));
                  },
                ),
                const VerticalSpace(height: 16),
                Obx(() {
                  if (solarFinanceDashboardController.isLoading.value) {
                    return const CircularProgressIndicator();
                  } else if (solarFinanceDashboardController.error.isNotEmpty) {
                    return Container();
                  } else {
                    return SolarDashboard(
                      oneByThreePeice: DashboardDataPeice(
                          integerColor: AppColors.lumiBluePrimary,
                          value: solarFinanceDashboardController
                              .enquiryCount.value,
                          label: translation(context).totalEnquiry,
                          onCardClick: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ExistingLeads()));
                          }),
                      firstOneByOnePeice: DashboardDataPeice(
                          integerColor: AppColors.successGreen,
                          value: solarFinanceDashboardController
                              .approvedCount.value,
                          label: translation(context).approved,
                          onCardClick: () {
                            financeRequestsListController.financeStatusSelected
                                .value = SolarAppConstants.approved;
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ExistingLeads()));
                          }),
                      secondOneByOnePeice: DashboardDataPeice(
                          integerColor: AppColors.inProgressColor,
                          value: solarFinanceDashboardController
                              .inProgressCount.value,
                          label: translation(context).inProgress,
                          onCardClick: () {
                            financeRequestsListController.financeStatusSelected
                                .value = SolarAppConstants.inProgress;
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const ExistingLeads()));
                          }),
                      thirdOneByOnePeice: DashboardDataPeice(
                          integerColor: AppColors.errorRed,
                          value: solarFinanceDashboardController
                              .rejectedCount.value,
                          label: translation(context).rejected,
                          onCardClick: () {
                            financeRequestsListController.financeStatusSelected
                                .value = SolarAppConstants.rejected;
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ExistingLeads()));
                          }),
                    );
                  }
                }),
                VerticalSpace(height: 36),
                Center(
                  child: SizedBox(
                    height: 56 * h,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const SolarFinanceRequestForm()));
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.lumiBluePrimary,
                          textStyle: GoogleFonts.poppins(
                              fontSize: 14 * f, fontWeight: FontWeight.w500)),
                      child: Text(
                        translation(context).raiseFinanceRequest,
                        style: GoogleFonts.poppins(
                            color: AppColors.white_234,
                            fontSize: 14 * f,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
              ]),
            ),
            Spacer(),
            HelpSupportWidget(
                previousRoute: SolarAppConstants.financeRouteName),
            VerticalSpace(height: 32)
          ],
        )),
      ),
    );
  }
}
