import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../../utils/routes/app_routes.dart';
import '../../../state/controller/go_solar_count_details_controller.dart';
import '../../project_execution/project_execution_home_page.dart';
import '../../solar_design/solar_design.dart';

class GoSolarHomeBodyWidget extends StatelessWidget {
  GoSolarCountDetailsController goSolarCountDetailsController = Get.find();

  GoSolarHomeBodyWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
    DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
    DisplayMethods(context: context).getVariablePixelWidth();
    var variablePixelMultiplier =
    DisplayMethods(context: context).getPixelMultiplier();
    double textMultiplier =
    DisplayMethods(context: context).getTextFontMultiplier();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        setCardDataWidget(
            translation(context).finance,
            translation(context).totalFinanceRequests,
            goSolarCountDetailsController.totalFinanceRequests.value.toString(),
            context, () {
          Navigator.pushNamed(context, AppRoutes.solarFinancingDashboard);
          //    Navigator.push(
          //        context,
          //        MaterialPageRoute(
          //            builder: (context) =>
          //            const SolarFinanceDashboard()));
        },
            variablePixelMultiplier,
            variablePixelWidth,
            variablePixelHeight,
            textMultiplier),
        setCardDataWidget(
            translation(context).solutionDesigning,
            translation(context).totalDesignRequests,
            goSolarCountDetailsController.totalDesignRequests.value.toString(),
            context, () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                  const SolarDesignHomePage()));
        },
            variablePixelMultiplier,
            variablePixelWidth,
            variablePixelHeight,
            textMultiplier),
        setCardDataWidget(
            translation(context).installationText,
            translation(context).totalInstallationRequestText,
            goSolarCountDetailsController.totalExecutionRequests.value
                .toString(),
            context, () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                  const ProjectExecutionHomePage()));
        },
            variablePixelMultiplier,
            variablePixelWidth,
            variablePixelHeight,
            textMultiplier),
      ],
    );
  }

  Widget setCardDataWidget(String title, String content, String countValue,
      BuildContext context, Function() onTab, double variablePixelMultiplier,
      double variablePixelWidth, double variablePixelHeight,
      double textMultiplier) {
    return GestureDetector(
      onTap: onTab,
      child: Container(
        margin: EdgeInsets.only(
            left: 24 * variablePixelWidth,
            right: 24 * variablePixelWidth,
            top: 10 * variablePixelHeight,
            bottom: 10 * variablePixelHeight),
        padding: EdgeInsets.only(
            right: 14 * variablePixelWidth,
            left: 14 * variablePixelWidth,
            top: 14 * variablePixelHeight,
            bottom: 14 * variablePixelHeight),
        alignment: Alignment.centerLeft,
        width: MediaQuery
            .of(context)
            .size
            .width,
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
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    color: AppColors.lumiBluePrimary,
                    fontSize: 16 * textMultiplier,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 10 * variablePixelHeight,
                ),
                Text(
                  content,
                  style: GoogleFonts.poppins(
                    color: AppColors.blackText,
                    fontSize: 12 * textMultiplier,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
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
