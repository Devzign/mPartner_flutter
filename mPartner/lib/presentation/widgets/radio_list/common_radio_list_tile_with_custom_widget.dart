import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/displaymethods/display_methods.dart';
import '../../../utils/app_colors.dart';

class CommonRadioListTileWithCustomWidget<T> extends StatelessWidget {
  const CommonRadioListTileWithCustomWidget({
    Key? key,
    required this.groupValue,
    required this.widget,
    required this.value,
    required this.onChanged,
    required this.isEnabled,
  }) : super(key: key);

  final widget;
  final bool isEnabled;
  final T? groupValue;
  final T value;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();

    return GestureDetector(
      onTap: () {
        isEnabled ? onChanged(value) : null;
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 8 * h, 0, 8 * h),
        color: AppColors.white,
        

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 24 * f,
              width: 24 * w,
              child: Radio<T>(
                activeColor: AppColors.lumiBluePrimary,
                fillColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  if (states.contains(MaterialState.selected)) {
                    return isEnabled
                        ? AppColors.lumiBluePrimary
                        : AppColors.grayText;
                  }
                  return isEnabled
                      ? AppColors.darkGreyText
                      : AppColors.grayText;
                }),
                value: value,
                groupValue: isEnabled ? groupValue : value,
                onChanged: (newValue) {
                  isEnabled ? onChanged(newValue) : null;
                },
              ),
            ),
            SizedBox(
              width: 4 * w,
            ),
            Expanded(
              child: widget,
            ),
          ],
        ),
      ),
      
    );
  }
}
