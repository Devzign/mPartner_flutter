import 'package:flutter/material.dart';

import '../../../../presentation/widgets/notification_bell_icon_widget.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/displaymethods/display_methods.dart';
import '../../screens/omni_search/omni_search.dart';

class HomeHeaderWidget extends StatelessWidget {
  const HomeHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double pixelMultiplier =
        DisplayMethods(context: context).getPixelMultiplier();
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      height: variablePixelHeight * 90,
      padding: EdgeInsets.only(
          top: 12 * variablePixelHeight,
          left: 24 * variablePixelWidth,
          right: 24 * variablePixelWidth,
          bottom: 12 * variablePixelHeight),
      decoration: BoxDecoration(
        color: AppColors.lightWhite1,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24 * pixelMultiplier),
          bottomRight: Radius.circular(24 * pixelMultiplier),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.lightGrey,
            blurRadius: 8 * pixelMultiplier,
            offset: Offset(0, 2 * pixelMultiplier),
            spreadRadius: 2 * pixelMultiplier,
          )
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/mpartner/Homepage_Assets/luminous_logo.png',
              height: 40 * variablePixelHeight,
              width: 91 * variablePixelWidth,
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    print("onClickWorking");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const OmniSearch()));
                  },
                  child: Container(
                    width: 40 * pixelMultiplier,
                    height: 40 * pixelMultiplier,
                    decoration: ShapeDecoration(
                        color: AppColors.white,
                        shape: OvalBorder(
                            side: BorderSide(
                                width: 1 * variablePixelWidth,
                                color: AppColors.lightGrey2))),
                    child: Center(
                      child: Icon(
                        Icons.search,
                        color: AppColors.headerIconColors,
                        size: 24 * pixelMultiplier,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: variablePixelWidth * 16,
                ),
                const NotificationBellIconWidget(),
              ],
            )
          ],
        ),
      ),
    );
  }
}
