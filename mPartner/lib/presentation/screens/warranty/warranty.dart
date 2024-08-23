import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/displaymethods/display_methods.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/localdata/language_constants.dart';
import '../../widgets/common_qr1.dart';
import '../../widgets/divider_with_middle_text.dart';
import '../../widgets/headers/back_button_header_widget.dart';
import '../../widgets/verticalspace/vertical_space.dart';
import '../base_screen.dart';
import '../userprofile/user_profile_widget.dart';
import 'components/qr_code_widget.dart';
import 'components/textfield_serial_no.dart';
import 'warranty_manual.dart';
import 'warranty_qr_navigation.dart';

class WarrantyScreen extends StatefulWidget {
  const WarrantyScreen({super.key});

  @override
  State<WarrantyScreen> createState() => _warrantyScreenState();
}

class _warrantyScreenState extends BaseScreenState<WarrantyScreen> {
  @override
  Widget baseBody(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                HeaderWidgetWithBackButton(
                  onPressed: () => {Navigator.pop(context)},
                  heading: translation(context).checkWarrantyStatus,
                ),
                UserProfileWidget(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24 * variablePixelWidth),
                  child: Column(
                    children: [
                      Text(
                        translation(context)
                            .scanQRCodeOrEnterSerialNumberToCheckWarrantyStatus,
                        style: GoogleFonts.poppins(
                          color: AppColors.darkGrey,
                          fontSize: 16 * variablePixelHeight,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const VerticalSpace(height: 32),
                  InkWell(
                      onTap: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BarcodeAndQRScanner(
                                  onBackButtonPressed: () =>
                                      {Navigator.pop(context)},
                                  routeWidget: WarrantyQrNavigation(
                                    showManualWarrantyButton: true,
                                  ),
                                  showBottomModal: false,
                                  onBackButtonPressedWithController:
                                      (pauseCamera, resumeCamera) => {},
                                ),
                                // BarcodeScannerWithOverlay(
                                //     routeWidget: WarrantyQrNavigation(
                                //       showManualWarrantyButton: true,
                                //     ),
                                // ),
                              ),
                            ),
                          },
                      child: const QRcodeWidget()),
                  const VerticalSpace(height: 34),
                  const DividerWithMiddleText(text: "OR"),
                  const VerticalSpace(height: 34),
                  GestureDetector(
                    onTap: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => WarrantyManual()),
                      ),
                    },
                    child: SizedBox(
                      height: 56 * variablePixelHeight,
                      child: TextFieldSerialNo(
                        isEnabled: false,
                        clearText: true,
                      ),
                    ),
                  ),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
