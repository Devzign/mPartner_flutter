


import 'package:flutter/material.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../presentation/screens/userprofile/user_profile_widget.dart';
import '../../presentation/gem_tender/component/headingGemSupportCategory.dart';


class GemHeader extends StatelessWidget{
  String?headerText;
  GemHeader(this.headerText);
  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
    DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
    DisplayMethods(context: context).getVariablePixelWidth();
    double variablePixelMultiplier =
    DisplayMethods(context: context).getPixelMultiplier();
    return new Column(
      children: [
         Padding(
            padding: EdgeInsets.only(left: 14 * variablePixelWidth, top: 45 * variablePixelHeight),
            child: HeadingGemSupportCategory(
              icon: Icon(
                Icons.
                arrow_back_outlined,
                color: AppColors.
                iconColor
                ,
                size: 24 * variablePixelMultiplier,
              ),
              heading:headerText.toString(),
              onPressed: () {
                Navigator.
                of
                  (context).pop();
              },
            )),
          UserProfileWidget(
          top: 8 * variablePixelHeight,
        ),
      ],
    );

  }

}