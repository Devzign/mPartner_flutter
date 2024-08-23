import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/displaymethods/display_methods.dart';
import '../../../utils/routes/app_routes.dart';
import '../../utils/solar_app_constants.dart';


class HeadingSolar extends StatefulWidget {
  final String heading;
  final dynamic controller;
  final String? headingModule;
  final VoidCallback? onPressed;

  const HeadingSolar({
    required this.heading,
    this.headingModule,
    this.onPressed,
    super.key,
    this.controller
  });

  @override
  State<HeadingSolar> createState() => _HeadingSolarState();
}

class _HeadingSolarState extends State<HeadingSolar> {
  @override
  Widget build(BuildContext context) {
    final variablePixelMultiplier =
      DisplayMethods(context: context).getPixelMultiplier();
    final variableTextMultiplier =
      DisplayMethods(context: context).getTextFontMultiplier();
    final variablePixelWidth =
      DisplayMethods(context: context).getVariablePixelWidth();
    final variablePixelHeight =
      DisplayMethods(context: context).getVariablePixelHeight();

    return Padding(
      padding: EdgeInsets.only(
          left: 14 * variablePixelWidth,
          top: 24 * variablePixelHeight),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back_outlined,
              color: AppColors.iconColor,
              size: 24 * variablePixelMultiplier,
            ),
            onPressed: (){
              if (widget.onPressed !=null) {
                widget.onPressed!();
              } else {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                } else if (widget.headingModule == SolarAppConstants.financeRouteName) {
                  Navigator.of(context).pushReplacementNamed(AppRoutes.solarFinancingDashboard);
                } else if (widget.headingModule == SolarAppConstants.digitalDesRouteName) {
                  Navigator.of(context).pushReplacementNamed(AppRoutes.solarDigDesignDashboard);
                } else if (widget.headingModule == SolarAppConstants.physicalDesRouteName) {
                  Navigator.of(context).pushReplacementNamed(AppRoutes.solarPhyDesignDashboard);
                } else if (widget.headingModule == SolarAppConstants.peOnlineRouteName) {
                  Navigator.of(context).pushReplacementNamed(AppRoutes.onlineGuidanceDashboard);
                } else if (widget.headingModule == SolarAppConstants.peOnsiteRouteName) {
                  Navigator.of(context).pushReplacementNamed(AppRoutes.onsiteGuidanceDashboard);
                } else if (widget.headingModule ==  SolarAppConstants.peEndToEndRouteName) {
                  Navigator.of(context).pushReplacementNamed(AppRoutes.endToEndDeploymentDashboard);
                } else {
                  Navigator.of(context).pushReplacementNamed(AppRoutes.homepage);
                }
              }
            },
          ),
          Expanded(
            child: Text(
              widget.heading,
              softWrap: true,
              style: GoogleFonts.poppins(
                color: AppColors.iconColor,
                fontSize: AppConstants.FONT_SIZE_LARGE * variableTextMultiplier,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
