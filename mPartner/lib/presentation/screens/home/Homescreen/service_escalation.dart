import 'package:flutter/material.dart';
import 'package:mpartner/utils/app_colors.dart';
import 'package:mpartner/utils/displaymethods/display_methods.dart';
import 'package:mpartner/presentation/screens/home/widgets/section_headings.dart';
import 'package:mpartner/presentation/screens/home/widgets/service_escalation_card.dart';
import 'package:mpartner/presentation/widgets/verticalspace/vertical_space.dart';

import '../../../../utils/localdata/language_constants.dart';

class ServiceEscalationWidget extends StatefulWidget {
  const ServiceEscalationWidget({super.key});

  @override
  State<ServiceEscalationWidget> createState() =>
      _ServiceEscalationWidgetState();
}

class _ServiceEscalationWidgetState extends State<ServiceEscalationWidget> {
  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    return Container(
      color: AppColors.lumiLight5,
      padding: EdgeInsetsDirectional.symmetric(
          vertical: variablePixelHeight * 16,
          horizontal: variablePixelWidth * 24),
      child: Column(children: [
        SectionHeading(text: translation(context).serviceEscalation),
        VerticalSpace(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ServiceEscalationCard(
                imagePath:
                    "assets/mpartner/Homepage_Assets/customerComplaints_icon.png",
                text: translation(context).customerComplaints),
            ServiceEscalationCard(
                imagePath:
                    "assets/mpartner/Homepage_Assets/serviceInstallation_icon.png",
                text: translation(context).serviceInstallation)
          ],
        )
      ]),
    );
  }
}
