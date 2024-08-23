import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../state/contoller/dealer_wise_summary_controller.dart';
import '../../../../state/contoller/report_type_controller.dart';
import '../../../../state/contoller/user_data_controller.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/enums.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../widgets/headers/back_button_header_widget.dart';
import '../../../widgets/upcoming_feature.dart';
import '../../../widgets/verticalspace/vertical_space.dart';
import '../../ismart/ismart_homepage/components/subsection_header.dart';
import '../../userprofile/user_profile_widget.dart';
import '../report_type_container.dart';
import 'primary_report/primary_report_screen.dart';
import 'secondary_report/dealer/secondary_report_dealer_screen.dart';
import 'secondary_report/distributor/secondary_report_disty_screen.dart';
import 'tertiary_report/tertiary_report_screen.dart';

class SelectReportTypeWidget extends StatefulWidget {
  SelectReportTypeWidget({
    super.key,
  });

  @override
  State<SelectReportTypeWidget> createState() => _SelectReportTypeWidgetState();
}

class _SelectReportTypeWidgetState extends State<SelectReportTypeWidget> {
  UserDataController userDataController = Get.find();
  ReportTypeController reportTypeController = Get.find();
  DealerSummaryController dealerSummaryController = Get.find();
  UserTypes? userType;

  Future<void> getUserType() async {
    if (userDataController.userType == "DISTY") {
      setState(() {
        userType = UserTypes.Distributor;
      });
    }
    if (userDataController.userType == "DEALER") {
      setState(() {
        userType = UserTypes.Dealer;
      });
    }
    if (userDataController.userType == "Electrician") {
      setState(() {
        userType = UserTypes.Electrician;
      });
    }
  }

  Future<void> initializeUserType() async {
    await getUserType();
  }

  @override
  void initState() {
    setState(() {
      initializeUserType();
    });
    super.initState();
  }

  Widget returnRoute(String? reportType) {
    if (reportType == "Primary Report") {
      return PrimaryReportWidget();
    } else if (reportType == "Secondary Report" &&
        userType == UserTypes.Distributor) {
      return const SecondaryReportDistributor();
    } else if (reportType == "Secondary Report" &&
        userType == UserTypes.Dealer) {
      return const SecondaryReportDealer();
    } else if (reportType == "Tertiary Report") {
      return const TertiaryReportScreen();
    } else if (reportType == 'Intermediary Report') {
      return const UpcomingFeatureScreen();
    }
    return const Scaffold();
  }

  @override
  Widget build(BuildContext context) {
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        // if (widget.backToMenu == false) {
        //   Navigator.pushNamedAndRemoveUntil(
        //     context,
        //     AppRoutes.homepage,
        //     (Route<dynamic> route) => false,
        //   );
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.lightWhite1,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderWidgetWithBackButton(
                heading: translation(context).reportManagement,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              UserProfileWidget(),
              SubsectionHeader(
                  sectionHeader: translation(context).selectReportType),
              Expanded(
                child: Obx(() {
                  if (reportTypeController.isLoading.value) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (reportTypeController.error.isNotEmpty) {
                    return Center(
                      child: Text(
                        'Error: ${reportTypeController.error.value}',
                        style: TextStyle(color: AppColors.errorRed),
                      ),
                    );
                  } else {
                    final bool isDataEmpty =
                        reportTypeController.reportType.isEmpty;
                    if (isDataEmpty) {
                      return Container(
                        child: Center(
                          child: Text("No data to display"),
                        ),
                      );
                    } else {
                      print(reportTypeController.reportType);
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 24 * w),
                        child: ListView.builder(
                          itemCount: reportTypeController.reportType.length,
                          itemBuilder: (context, index) {
                            return (reportTypeController.reportType[index] ==
                                        'Primary Report' &&
                                    !userDataController.isPrimaryNumberLogin)
                                ? Container()
                                : ReportTypeContainer(
                                    reportType:
                                        reportTypeController.reportType[index],
                                    reportDesc:
                                        reportTypeController.description[index],
                                    route: returnRoute(
                                        reportTypeController.reportType[index]),
                                  );
                          },
                        ),
                      );
                    }
                  }
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
