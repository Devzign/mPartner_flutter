import 'package:flutter/material.dart';

import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../widgets/common_button.dart';

class ContinueButton extends StatefulWidget {
  final bool isEnabled;
  final VoidCallback onPressed;

  const ContinueButton({
    required this.isEnabled,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  State<ContinueButton> createState() => _ContinueButtonState();
}

class _ContinueButtonState extends State<ContinueButton> {
  @override
  Widget build(BuildContext context) {
    double labelFontSize = DisplayMethods(context: context).getLabelFontSize();
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();

    return Align(
        alignment: Alignment.bottomCenter,
        child: CommonButton(
          onPressed: widget.onPressed,
          backGroundColor: widget.isEnabled
              ? AppColors.lumiBluePrimary
              : AppColors.lightWhite2,
          textColor: AppColors.lightWhite,
          isEnabled: widget.isEnabled,
          buttonText: translation(context).continueButtonText,
          containerBackgroundColor: AppColors.lightWhite1,
        ));
  }
}
