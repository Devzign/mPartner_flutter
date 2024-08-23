import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';
import '../../../../widgets/common_qr1.dart';
import '../register_sale_combo.dart';
import '../../../../widgets/horizontalspace/horizontal_space.dart';
import '../../../../widgets/verticalspace/vertical_space.dart';

import 'combo_back_button.dart';
import 'q_r_screen_back_button.dart';

class AddBatteryButton extends StatelessWidget {
  const AddBatteryButton({super.key, required this.number});
  final String number;

  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double r = DisplayMethods(context: context).getPixelMultiplier();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    return GestureDetector(
      onTap: () => {
        
        Navigator.push(
            context,
            MaterialPageRoute(
                // settings: RouteSettings(arguments: userInfo),
                builder: (context) => BarcodeAndQRScanner(
                      title: "Tertiary Sales",
                      subtitle: "Inverter & Battery Combo",
                      onBackButtonPressed: () => {},
                      onBackButtonPressedWithController:
                          (pauseCamera, resumeCamera) => {
                        pauseCamera(),
                        showModalBottomSheet(
                            isScrollControlled: false,
                            useSafeArea: true,
                            enableDrag: false,
                            isDismissible: false,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(28 * r),
                                    topRight: Radius.circular(28 * r))),
                            showDragHandle: false,
                            backgroundColor: AppColors.white,
                            context: context,
                            builder: (BuildContext context) {
                              return PopScope(
                                  canPop: false,
                                  child: ComboBackButton(
                                      resumeCamera: resumeCamera));
                            }),
                      },
                      showBottomModal: false,
                      routeWidget: ComboScreen(),
                      useFunction: true,
                    ))),
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(0, 10 * h, 16 * w, 10 * h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.add, size: 18 * w, color: AppColors.lumiBluePrimary),
                HorizontalSpace(width: 8),
                Text(
                  "${translation(context).addBattery} $number",
                  style: GoogleFonts.poppins(
                    color: AppColors.lumiBluePrimary,
                    fontSize: 14 * f,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.10 * w,
                  ),
                ),
              ],
            ),
          ),
          VerticalSpace(height: 4),
        ],
      ),
    );
  }
}
