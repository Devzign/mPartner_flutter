import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../presentation/screens/base_screen.dart';
import '../../../presentation/screens/network_management/dealer_electrician/components/heading_dealer.dart';
import '../../../presentation/screens/userprofile/user_profile_widget.dart';
import '../../../state/contoller/user_data_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/displaymethods/display_methods.dart';
import '../../../utils/localdata/language_constants.dart';
import '../../../utils/routes/app_routes.dart';
import '../../state/controller/ProjectExecutionFormController.dart';
import '../../utils/solar_app_constants.dart';
import '../common/heading_solar.dart';

class ProjectExecutionHomePage extends StatefulWidget {
  const ProjectExecutionHomePage({super.key});

  @override
  State<ProjectExecutionHomePage> createState() =>
      _ProjectExecutionHomePageState();
}

class _ProjectExecutionHomePageState
    extends BaseScreenState<ProjectExecutionHomePage> {
  UserDataController userController = Get.find();
  ProjectExecutionFormController projectExecutionFormController = Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget baseBody(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double textMultiplier =
        DisplayMethods(context: context).getVariablePixelWidth();
    double variablePixelMultiplier =
        DisplayMethods(context: context).getVariablePixelWidth();

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        //Navigator.pushNamed(context, AppRoutes.homepage);
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: Column(
            children: [
              HeadingSolar(
                heading: translation(context).installationText,
              ),
              UserProfileWidget(
                top: 8 * variablePixelHeight,
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(
                  left: 24 * variablePixelWidth,
                ),
                child: Text(
                  translation(context).selectPEType,
                  textAlign: TextAlign.left,
                  style: GoogleFonts.poppins(
                    color: AppColors.darkGreyText,
                    fontSize: 16 * textMultiplier,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.10,
                  ),
                ),
              ),
              SizedBox(
                height: 10 * variablePixelHeight,
              ),
          
          
          
          
          
              setCardDataWidget(translation(context).onlineGuidance,
                  translation(context).projectOnlineSupport, "", context, () {
                projectExecutionFormController.typeName.value =
                    translation(context).onlineGuidance;
                projectExecutionFormController.typeValue.value =
                    SolarAppConstants.online;
                Navigator.of(context).pushNamed(AppRoutes.onlineGuidanceDashboard);
              }, variablePixelMultiplier, variablePixelWidth, variablePixelHeight,
                  textMultiplier),
          
          
          
              setCardDataWidget(translation(context).onsiteGuidance,
                  translation(context).projectOnsiteSupport, "", context, () {
                projectExecutionFormController.typeName.value =
                    translation(context).onsiteGuidance;
                projectExecutionFormController.typeValue.value =
                    SolarAppConstants.onsite;
                Navigator.of(context).pushNamed(AppRoutes.onsiteGuidanceDashboard);
              }, variablePixelMultiplier, variablePixelWidth, variablePixelHeight,
                  textMultiplier),
          
              setCardDataWidget(translation(context).endToEndDeployment,
                  translation(context).projectEndtoEndSupport, "", context, () {
                projectExecutionFormController.typeName.value =
                    translation(context).endToEndDeployment;
                projectExecutionFormController.typeValue.value =
                    SolarAppConstants.endToEnd;
                Navigator.of(context).pushNamed(AppRoutes.endToEndDeploymentDashboard);
              }, variablePixelMultiplier, variablePixelWidth, variablePixelHeight,
                  textMultiplier),
            ],
          ),
        ),
      ),
    );
  }

  Widget setCardDataWidget(
      String title,
      String content,
      String countValue,
      BuildContext context,
      Function() onTab,
      double variablePixelMultiplier,
      double variablePixelWidth,
      double variablePixelHeight,
      double textMultiplier) {
    return GestureDetector(
      onTap: onTab,
      child: Container(
        margin: EdgeInsets.only(
            left: 24 * variablePixelWidth,
            right: 24 * variablePixelWidth,
            top: 6 * variablePixelHeight,
            bottom: 12 * variablePixelHeight),
        padding: EdgeInsets.only(
            right: 14 * variablePixelWidth,
            left: 14 * variablePixelWidth,
            top: 12 * variablePixelHeight,
            bottom: 12 * variablePixelHeight),
        alignment: Alignment.centerLeft,
        //height: variablePixelHeight * 86,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius:
              BorderRadius.all(Radius.circular(12 * variablePixelMultiplier)),
          border: Border.all(
              width: 1 * variablePixelWidth, color: AppColors.lightGrey2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: new Container(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    color: AppColors.black,
                    fontSize: 16 * textMultiplier,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 10 * variablePixelHeight,
                ),
                Text(
                  content,
                  style: GoogleFonts.poppins(
                    color: AppColors.grey,
                    fontSize: 12 * textMultiplier,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),)),
            Text(
              countValue,
              style: GoogleFonts.poppins(
                color: AppColors.lumiBluePrimary,
                fontSize: 28 * textMultiplier,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      ),
    );
  }
}
