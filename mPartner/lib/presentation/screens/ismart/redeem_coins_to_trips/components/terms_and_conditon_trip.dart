import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../state/contoller/coin_to_trips_redemption_controller.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';
import '../../../../widgets/buttons/primary_button.dart';
import '../../../../widgets/horizontalspace/horizontal_space.dart';
import '../../../../widgets/verticalspace/vertical_space.dart';
import '../../../our_products/components/title_bottom_modal.dart';

class TermsAndConditonTrip extends StatelessWidget {
  TermsAndConditonTrip({super.key, required this.htmlData});
  CoinsToTripController c = Get.find();
  final String htmlData;
  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();

    return Obx(
      () => Padding(
        padding: EdgeInsets.fromLTRB(24 * w, 0, 24 * w, 32 * h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            titleBottomModal(
                title: translation(context).acceptAndProceed,
                onPressed: () => {Navigator.pop(context)}),
            VerticalSpace(height: 28),
            Flexible(
                child: HtmlWidget(
              htmlData,
              customStylesBuilder: (element) => element.localName == "h1"
                  ? {
                      'font-size': '${14 * f}px',
                    }
                  : null,
              renderMode: RenderMode.listView,
              textStyle: GoogleFonts.poppins(
                color: AppColors.darkGreyText,
                fontSize: 12 * f,
                fontWeight: FontWeight.w500,
                height: 0,
              ),
            )),
            VerticalSpace(height: 28),
            GestureDetector(
              onTap: () => {c.isTermsAndConditonsAccepted.toggle()},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 24 * h,
                    width: 24 * w,
                    child: Checkbox(
                        fillColor: MaterialStateProperty.resolveWith((states) {
                          if (!states.contains(MaterialState.selected)) {
                            return Colors.transparent;
                          }
                          return AppColors.lumiBluePrimary;
                        }),
                        value: c.isTermsAndConditonsAccepted.value,
                        onChanged: null),
                  ),
                  HorizontalSpace(width: 8),
                  Flexible(
                    child: Text(
                      softWrap: true,
                      translation(context).iAcceptAllTheTermsAndConditions,
                      style: GoogleFonts.poppins(
                        color: AppColors.darkGreyText,
                        fontSize: 12 * f,
                        fontWeight: FontWeight.w500,
                        height: 20 / 12,
                        letterSpacing: 0.10 * w,
                      ),
                    ),
                  )
                ],
              ),
            ),
            VerticalSpace(height: 16),
            Row(
              children: [
                PrimaryButton(
                    buttonText: translation(context).acceptAndProceed,
                    buttonHeight: 48,
                    onPressed: () => {Navigator.pop(context)},
                    isEnabled: c.isTermsAndConditonsAccepted.value),
              ],
            )
          ],
        ),
      ),
    );
  }
}
