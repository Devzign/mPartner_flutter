import 'package:flutter/material.dart';

import '../../../../presentation/screens/userprofile/user_profile_widget.dart';
import '../../../../presentation/widgets/headers/back_button_header_widget.dart';
import '../../../../presentation/widgets/tab_widget.dart';
import '../../../../presentation/widgets/verticalspace/vertical_space.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../../utils/routes/app_routes.dart';
import '../../common/heading_solar.dart';
import 'customer_project_details.dart';
import 'tracking_tab.dart';

class ProjectDetailsPage extends StatefulWidget {
  bool isResidential, isCommercial;
  String projectId;

  ProjectDetailsPage({
    super.key,
    required this.projectId,
    this.isResidential = false,
    this.isCommercial = false,
  });

  @override
  State<ProjectDetailsPage> createState() => _ProjectDetailsPageState();
}

class _ProjectDetailsPageState extends State<ProjectDetailsPage> {

  @override
  Widget build(BuildContext context) {
    int initialIndex = 0;
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();

    List<TabData> tabs = [
      TabData(
          translation(context).details,
          CustomerProjectDetails(
            projectId: widget.projectId,
            isResidential: widget.isResidential,
            isCommercial: widget.isCommercial,
          )),
      TabData(
          translation(context).requestTracking,
          TrackingTab(
            projectId: widget.projectId,
          )),
    ];
    return WillPopScope(
      onWillPop: () async {
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        } else {
          Navigator.of(context).pushReplacementNamed(AppRoutes.homepage);
        }
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
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    } else {
                      Navigator.of(context)
                          .pushReplacementNamed(AppRoutes.homepage);
                    }
                  }
              ),
              UserProfileWidget(
                top: 8 * h,
              ),
              TabWidget(initialIndex: initialIndex, tabs: tabs),
            ],
          ),
        ),
      ),
    );
  }
}
