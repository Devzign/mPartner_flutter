import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../lms/presentation/training_course_list.dart';
import '../../../../state/contoller/user_data_controller.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/routes/app_routes.dart';
import '../widgets/quicklinks_card.dart';
import '../widgets/section_headings.dart';
import '../../../widgets/verticalspace/vertical_space.dart';
import '../../../../utils/localdata/language_constants.dart';

class QuicklinksWidget extends StatefulWidget {
  const QuicklinksWidget({super.key});

  @override
  State<QuicklinksWidget> createState() => _QuicklinksWidgetState();
}

class _QuicklinksWidgetState extends State<QuicklinksWidget> {
  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    UserDataController controller = Get.find();
    return Container(
      padding: EdgeInsetsDirectional.symmetric(
          horizontal: variablePixelWidth * 24,
          vertical: variablePixelHeight * 24),
      child: Column(

        children: [
          SectionHeading(
            text: translation(context).quicklinks,
            showChevronRight: false,
          ),
          const VerticalSpace(height: 16),
          Visibility(
            visible: controller.userType.toLowerCase() == 'disty',
            child: Table(
              children: [
                TableRow(
                  children: [
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: QuickLinksCard(
                          imagePath: "assets/mpartner/Homepage_Assets/Report.svg",
                          route: AppRoutes.selectReportType),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: QuickLinksCard(
                          imagePath:
                              "assets/mpartner/Homepage_Assets/Warranty.svg",
                          route: AppRoutes.warranty),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: QuicklinksText(
                          text: translation(context).reportManagement,
                          route: AppRoutes.selectReportType),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: QuicklinksText(
                          text: translation(context).warrantyCheck,
                          route: AppRoutes.warranty),
                    ),
                  ],
                )
              ],
            ),
          ),
          Visibility(
            visible: controller.userType.toLowerCase() == 'dealer',
            child: Table(
              children: [
                TableRow(
                  children: [
                    if (controller.isPrimaryNumberLogin)
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.middle,
                        child: QuickLinksCard(
                            imagePath:
                                "assets/mpartner/Homepage_Assets/Trips.svg",
                            route: AppRoutes.coinsToTrip),
                      ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: QuickLinksCard(
                          imagePath:
                              "assets/mpartner/Homepage_Assets/Warranty.svg",
                          route: AppRoutes.warranty),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: QuickLinksCard(
                          imagePath:
                              "assets/mpartner/Homepage_Assets/History.svg",
                          route: AppRoutes.coinDetailedHistory),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    if (controller.isPrimaryNumberLogin)
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.middle,
                        child: QuicklinksText(
                          text: translation(context).tripRedemption,
                           route: AppRoutes.coinsToTrip,
                        ),
                      ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: QuicklinksText(
                        text: translation(context).warrantyCheck,
                        route: AppRoutes.warranty
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: QuicklinksText(
                        text: translation(context).coinHistory,
                        route: AppRoutes.coinDetailedHistory
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
