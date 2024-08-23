import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../gem/presentation/gem_tender/gem_support_category.dart';
import '../../../../solar/presentation/go_solar/go_solar_home.dart';
import '../../../../solar/presentation/project_execution/project_execution_home_page.dart';
import '../../../../solar/presentation/solar_design/solar_design.dart';
import '../../../../state/contoller/app_setting_value_controller.dart';
import '../../../../state/contoller/homepage_banners_controller.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../../utils/routes/app_routes.dart';
import '../../../widgets/verticalspace/vertical_space.dart';
import '../../consumeremi/consumer_emi.dart';
import '../widgets/section_headings.dart';
import '../widgets/solar_category_card.dart';
import 'solar_banner_widget.dart';
import 'svgContainer.dart';

class GetSolarWidget extends StatefulWidget {
  const GetSolarWidget({super.key});

  @override
  State<GetSolarWidget> createState() => _GetSolarWidgetState();
}

class _GetSolarWidgetState extends State<GetSolarWidget> {
  AppSettingValueController appSettingValueController = Get.find();
  HomepageBannersController homepageBannersController = Get.find();
  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double textMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();
    return Column(
      children: [
        Container(
          padding: EdgeInsetsDirectional.symmetric(
              vertical: 16 * variablePixelHeight,
              horizontal: 24 * variablePixelWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SectionHeading(text: translation(context).featuredText, showChevronRight: false),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                        child: InkWell(
                      child: Column(
                        children: [
                          SvgContainer(
                              path: "assets/solar/gemSupport.svg",
                              isEnabled: true),
                          const VerticalSpace(height: 8),
                          Container(
                            padding: const EdgeInsets.only(top: 10),
                            alignment: Alignment.center,
                            child: Text(
                              translation(context).gemSupport,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color: AppColors.blackText,
                                fontSize: 14 * textMultiplier,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.25,
                              ),
                            ),
                          )
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const GemSupportCategory()));
                      },
                    )),
                    Flexible(
                        child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ConsumerEmi()));
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: Column(
                          children: [
                            SvgContainer(
                                path: "assets/mpartner/Products_assets/EMI.svg",
                                isEnabled: true),
                            const VerticalSpace(height: 8),
                            Container(
                              padding: const EdgeInsets.only(top: 10),
                              alignment: Alignment.center,
                              child: Text(
                                translation(context).consumerEmi,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  color: AppColors.blackText,
                                  fontSize: 14 * textMultiplier,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.25,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )),
                    /*Column(
                      children: [
                        SvgContainer(
                            path: "assets/mpartner/Products_assets/Service.svg",
                            isEnabled: true),
                        Container(
                          padding: const EdgeInsets.only(top: 5),
                          alignment: Alignment.center,
                          child: Text(
                            "Service\nEscalation",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: AppColors.blackText,
                              fontSize: 14 * textMultiplier,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.25,
                            ),
                          ),
                        )
                      ],
                    )*/
                  ],
                ),
              ),


            ],
          ),
        ),
        Obx(() {
          if (appSettingValueController.solarviable.value=="1") {
            return Container(
              padding: EdgeInsets.only(
                left: variablePixelWidth * 24,
                bottom: variablePixelHeight * 24,
              ),
              // height: variablePixelHeight * 150,
              decoration: const BoxDecoration(color: AppColors.lumiLight5),
              width: double.infinity,
              child: Column(
                children: [
                  const VerticalSpace(height: 12),
                  Padding(
                    padding: EdgeInsets.only(
                      right: variablePixelWidth * 24,
                    ),
                    child: SectionHeading(
                      text: translation(context).luminousEnergySolutions,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const GoSolarHome()));
                      },
                    ),
                  ),
                  const VerticalSpace(height: 16),
                  GetBuilder<HomepageBannersController>(builder: (context) {
                    return homepageBannersController.solarUrls.isNotEmpty
                        ?  Container(child: SolarBannerWidget(),margin: EdgeInsets.only(bottom: 24*variablePixelHeight),)
                        : Container();
                  }),


                  Container(
                    height: variablePixelHeight * 120,
                    padding: EdgeInsets.only(
                      right: variablePixelWidth * 7,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, AppRoutes.solarFinancingDashboard);
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) =>
                              //         const SolarFinanceDashboard()));
                            },
                            child: SolarCategoryCard(
                                imagePath:
                                "assets/mpartner/Homepage_Assets/emi_icon.png",
                                text: translation(context).finance),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                      const SolarDesignHomePage()));
                            },
                            child: SolarCategoryCard(
                                imagePath:
                                "assets/mpartner/Homepage_Assets/lead_icon.png",
                                text: translation(context).solutionDesigning),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                      const ProjectExecutionHomePage()));
                            },
                            child: SolarCategoryCard(
                                imagePath:
                                "assets/mpartner/Homepage_Assets/lead_icon.png",
                                text: translation(context).installationText),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return new Container(); // Return an empty widget if the condition is not met
          }
        })



      ],
    );
  }
}
