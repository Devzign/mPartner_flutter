import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/routes/app_routes.dart';
import '../../../presentation/screens/base_screen.dart';
import '../../../presentation/screens/userprofile/user_profile_widget.dart';
import '../../../presentation/widgets/verticalspace/vertical_space.dart';
import '../../../solar/presentation/common/help_support_widget.dart';
import '../../utils/gem_app_constants.dart';
import 'component/category_type_widget.dart';
import 'component/headingGemSupportCategory.dart';


class GemSupportCategory extends StatefulWidget {
  const GemSupportCategory({super.key});

  @override
  State<GemSupportCategory> createState() => _GemSupportCategoryState();
}

class _GemSupportCategoryState extends BaseScreenState<GemSupportCategory> {
  void _navigateToGemScreen(saleType) {
    switch (saleType) {
      case 'Manufacturing Authorization Form':
        //Utils().showToast('Manufacturing Authorization Form', context);
        Navigator.pushNamed(context, AppRoutes.gemSupportMafHomePage);

        break;
      case 'Authorization Code':
        // Utils().showToast('Authorization Code', context);
       Navigator.pushNamed(context, AppRoutes.gemSupportAuthCode);
        break;
      case 'Tenders':
        // Utils().showToast('Tenders', context);
        Navigator.pushNamed(context, AppRoutes.gemSupportTenderHome);
        // Navigator.pushNamed(context, AppRoutes.intermediarySales);
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
      body:Column(mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
                padding: EdgeInsets.only(
                    left: 14 * variablePixelWidth, top: 48 * variablePixelHeight),
                child: HeadingGemSupportCategory(
                  icon: Icon(
                    Icons.arrow_back_outlined,
                    color: AppColors.iconColor,
                    size: 24 * variablePixelMultiplier,
                  ),
                  heading: "${translation(context).gemSupport}",
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )),
            UserProfileWidget(
              top: 8 * variablePixelHeight,
            ),
            CategoryTypeWidget(onCategoryTypeSelected: _navigateToGemScreen),
            const Spacer(),
            const HelpSupportWidget(previousRoute: GemAppConstants.gemSupportTrmCnd),
            VerticalSpace(height: 32)
          ]),
    );
  }
}
