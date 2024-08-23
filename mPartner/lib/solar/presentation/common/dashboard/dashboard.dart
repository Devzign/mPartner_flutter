import 'package:flutter/material.dart';

import '../../../../presentation/widgets/horizontalspace/horizontal_space.dart';
import '../../../../presentation/widgets/verticalspace/vertical_space.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import 'custom_container.dart';

class DashboardDataPeice {
  int value;
  String label;
  Color integerColor;
  Function()? onCardClick;

  DashboardDataPeice(
      {required this.value,
      required this.label,
      required this.integerColor,
      this.onCardClick});
}

class SolarDashboard extends StatelessWidget {
  DashboardDataPeice oneByThreePeice;
  DashboardDataPeice firstOneByOnePeice;
  DashboardDataPeice secondOneByOnePeice;
  DashboardDataPeice thirdOneByOnePeice;

  SolarDashboard(
      {super.key,
      required this.oneByThreePeice,
      required this.firstOneByOnePeice,
      required this.secondOneByOnePeice,
      required this.thirdOneByOnePeice});

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    return Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: AppColors.lightGrey2,
          ),
          borderRadius: BorderRadius.circular(12 * variablePixelWidth),
        ),
        child: Padding(
            padding: EdgeInsets.fromLTRB(
                21 * variablePixelWidth,
                16 * variablePixelHeight,
                20 * variablePixelWidth,
                16 * variablePixelHeight),
            child: Column(
              children: [
                GestureDetector(
                    onTap: oneByThreePeice.onCardClick,
                    child: CustomContainer(
                      data: oneByThreePeice,
                      backgroundColor: AppColors.lightGrey4,
                      integerHeight: 24,
                    )),
                const VerticalSpace(height: 12),
                Row(children: [
                  Expanded(
                      child: GestureDetector(
                          onTap: firstOneByOnePeice.onCardClick,
                          child: CustomContainer(
                              data: firstOneByOnePeice, integerHeight: 16))),
                  const HorizontalSpace(width: 8),
                  Expanded(
                      child: GestureDetector(
                          onTap: secondOneByOnePeice.onCardClick,
                          child: CustomContainer(
                              data: secondOneByOnePeice, integerHeight: 16))),
                  const HorizontalSpace(width: 8),
                  Expanded(
                      child: GestureDetector(
                          onTap: thirdOneByOnePeice.onCardClick,
                          child: CustomContainer(
                              data: thirdOneByOnePeice, integerHeight: 16))),
                ])
              ],
            )));
  }
}
