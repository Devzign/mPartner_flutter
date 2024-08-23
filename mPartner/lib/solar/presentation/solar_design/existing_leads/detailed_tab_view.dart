import 'package:flutter/material.dart';

import '../../../../presentation/screens/userprofile/user_profile_widget.dart';
import '../../../../presentation/widgets/tab_widget.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../../utils/routes/app_routes.dart';
import '../../../utils/solar_app_constants.dart';
import '../../common/heading_solar.dart';
import 'detailed_view_card.dart';
import 'request_tracking_tab.dart';

class DetailedTabView extends StatefulWidget {
  final String projectId;
  final String categoryId;
  final bool isDigOrPhy;
  final String? isNavigatedFrom;

  const DetailedTabView({
    super.key,
    required this.projectId,
    required this.categoryId,
    required this.isDigOrPhy,
    this.isNavigatedFrom,
  });

  @override
  State<DetailedTabView> createState() => _DetailedTabViewState();
}

class _DetailedTabViewState extends State<DetailedTabView> {
  final int initialIndex = 0;
  List<TabData> tabs = [];

  @override
  Widget build(BuildContext context) {
    tabs = [
      TabData(
          translation(context).details,
          DetailedViewCard(
            projectId: widget.projectId,
            categoryId: widget.categoryId,
            isDigOrPhy: widget.isDigOrPhy,
            isNavigatedFrom: widget.isNavigatedFrom,
          )),
      TabData(
          translation(context).requestTracking,
          RequestTrackingTab(
            projectId: widget.projectId,
            categoryId: widget.categoryId,
            isDigOrPhy: widget.isDigOrPhy,
          )),
    ];

    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();

    return WillPopScope(
      onWillPop: () async {
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        } else {
          if (widget.isDigOrPhy) {
            Navigator.of(context)
                .pushReplacementNamed(AppRoutes.solarDigDesignDashboard);
          } else {
            Navigator.of(context)
                .pushReplacementNamed(AppRoutes.solarPhyDesignDashboard);
          }
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: Column(
            children: [
              HeadingSolar(
                heading: widget.isDigOrPhy
                    ? translation(context).digitalDesigning
                    : translation(context).physicalVisitAndDesigning,
                headingModule: widget.isDigOrPhy
                    ? SolarAppConstants.digitalDesRouteName
                    : SolarAppConstants.physicalDesRouteName,
              ),
              UserProfileWidget(
                top: 8 * h,
              ),
              SizedBox(
                height: 10 * h,
              ),
              TabWidget(
                initialIndex: initialIndex,
                tabs: tabs,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
