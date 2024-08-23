import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/routes/app_routes.dart';
import '../../../../utils/utils.dart';

import '../../../presentation/screens/base_screen.dart';
import '../../../presentation/screens/help_and_support/help_and_support.dart';
import '../../../presentation/screens/userprofile/user_profile_widget.dart';
import '../../../presentation/widgets/horizontalspace/horizontal_space.dart';
import '../../../presentation/widgets/verticalspace/vertical_space.dart';
import '../../../solar/presentation/common/help_support_widget.dart';
import '../../utils/gem_app_constants.dart';
import 'component/headingGemSupportCategory.dart';
import 'component/tenders_type_widget.dart';


class GemTenderHome extends StatefulWidget {
  const GemTenderHome({super.key});

  @override
  State<GemTenderHome> createState() => _GemTenderHomeState();
}

class _GemTenderHomeState extends BaseScreenState<GemTenderHome> {
  void _navigateToGemScreen(saleType) {
    switch (saleType) {
      case 'State Tenders':
        //Utils().showToast('State Tenders', context);
        Navigator.pushNamed(context, AppRoutes.gemSupportTenderDetails, arguments: 0);
        break;
      case "Central PSU's":
       // Utils().showToast("Central PSU's", context);
        Navigator.pushNamed(context, AppRoutes.gemSupportTenderDetails, arguments: 1,);
        break;
    }
  }

  @override
  Widget baseBody(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double variablePixelMultiplier =
        DisplayMethods(context: context).getPixelMultiplier();

   return Scaffold(
  backgroundColor: Colors.white,
  body:Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Padding(
        padding: EdgeInsets.only(
            left: 14 * variablePixelWidth,
            top: 48 * variablePixelHeight),
        child: HeadingGemSupportCategory(
          icon: Icon(
            Icons.arrow_back_outlined,
            color: AppColors.iconColor,
            size: 24 * variablePixelMultiplier,
          ),
          heading: "${translation(context).tenders}",
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
        UserProfileWidget(
        top: 8 * variablePixelHeight,
      ),
      TendersTypeWidget(onTenderTypeSelected: _navigateToGemScreen),
      Spacer(),
      const HelpSupportWidget(previousRoute: GemAppConstants.tenderTrmCnd),
      VerticalSpace(height: 32)


    ],
  ),
);

  }
}
