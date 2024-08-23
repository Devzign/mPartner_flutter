import 'package:flutter/material.dart';

import '../../../presentation/screens/ismart/ismart_homepage/components/subsection_header.dart';
import '../../../presentation/screens/report_management/report_type_container.dart';
import '../../../presentation/screens/userprofile/user_profile_widget.dart';
import '../../../presentation/widgets/headers/back_button_header_widget.dart';
import '../../../presentation/widgets/verticalspace/vertical_space.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/displaymethods/display_methods.dart';
import '../../../utils/localdata/language_constants.dart';
import '../common/heading_solar.dart';
import 'banking_partners/banking_partners.dart';
import 'existing_leads/existing_leads.dart';

class FinancingOptions extends StatelessWidget {
  const FinancingOptions({super.key});

  @override
  Widget build(BuildContext context) {
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double h = DisplayMethods(context: context).getVariablePixelHeight();

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.lightWhite1,
        body: SafeArea(
            child: Column(
          children: [
            HeadingSolar(
                heading: translation(context).finance,
                onPressed: () {
                  Navigator.pop(context);
                }
            ),
            UserProfileWidget(
              top: 8 * h,
            ),
            const VerticalSpace(height: 4),
            SubsectionHeader(
                sectionHeader: translation(context).financingOptions),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24 * w),
              child: Column(
                children: [
                  ReportTypeContainer(
                    reportType: translation(context).financingRequests,
                    reportDesc: translation(context).residentialAndCommercial,
                    route: const ExistingLeads(),
                  ),
                  ReportTypeContainer(
                    reportType: translation(context).bankingPartners,
                    reportDesc: translation(context).viewAllBanking,
                    route: const BankingPartners(),
                  ),
                ],
              ),
            )
          ],
        )),
      ),
    );
  }
}
