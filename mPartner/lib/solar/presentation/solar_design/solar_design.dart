import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../presentation/screens/base_screen.dart';
import '../../../presentation/screens/userprofile/user_profile_widget.dart';
import '../../../state/contoller/user_data_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/displaymethods/display_methods.dart';
import '../../../utils/enums.dart';
import '../../../utils/localdata/language_constants.dart';
import '../../../utils/routes/app_routes.dart';
import '../../state/controller/solar_design_request_controller.dart';
import '../common/heading_solar.dart';
import 'digital_survey_dashboard.dart';


class SolarDesignHomePage extends StatefulWidget {
  const SolarDesignHomePage({super.key});

  @override
  State<SolarDesignHomePage> createState() => _SolarDesignHomePageState();
}

class _SolarDesignHomePageState extends BaseScreenState<SolarDesignHomePage> {
  UserDataController userController = Get.find();

  @override
  void initState() {
    super.initState();
    SolarDesignRequestController solarDesignRequestController = Get.find();
    solarDesignRequestController.solutionTypeListDesign.clear();
    solarDesignRequestController.getSolutionTypes(SolutionTypes.SolarDesignSolutionType.name);
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
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: Column(
            children: [
              HeadingSolar(
                heading: translation(context).solutionDesigning,
              ),
              UserProfileWidget(
                top: 8 * variablePixelHeight,
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(
                  left: 24 * variablePixelWidth,),
                child: Text(
                  translation(context).selectDesignType,
                  textAlign: TextAlign.left,
                  style: GoogleFonts.poppins(
                    color: AppColors.darkGreyText,
                    fontSize: 16 * textMultiplier,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.10,
                  ),
                ),
              ),
              SizedBox(height: 10*variablePixelHeight,),
              setCardDataWidget(translation(context).digitalDesigning, translation(context).designLayoutAndBos, "",context,(){
                Navigator.pushNamed(context, AppRoutes.solarDigDesignDashboard);
                  // Navigator.push(
                  //   context,
                  //  MaterialPageRoute(
                  //       builder: (context) =>
                  //       const DeigitalSurveyDashboardPage(isDigOrPhy: true,)));
              },variablePixelMultiplier,variablePixelWidth,variablePixelHeight,textMultiplier),
              setCardDataWidget(translation(context).physicalVisitAndDesigning, translation(context).physicaldesignLayoutAndBos, "",context,(){
                Navigator.pushNamed(context, AppRoutes.solarPhyDesignDashboard);
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) =>
                //         const DeigitalSurveyDashboardPage(isDigOrPhy: false,)));
              },variablePixelMultiplier,variablePixelWidth,variablePixelHeight,textMultiplier),
            ],
          ),
        ),

      ),
    );
  }

  Widget setCardDataWidget(String title, String content, String countValue, BuildContext context,  Function() onTab, double variablePixelMultiplier, double variablePixelWidth, double variablePixelHeight, double textMultiplier) {
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
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius:
          BorderRadius.all(Radius.circular(12 * variablePixelMultiplier)),
          border: Border.all(
              width: 1 * variablePixelWidth, color: AppColors.lightGrey2),
        ),
        child:

        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            ),
          ],
        ),
      ),
    );
  }

}



