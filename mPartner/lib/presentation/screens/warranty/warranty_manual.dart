import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../userprofile/user_profile_widget.dart';
import '../../../state/contoller/warranty_controller.dart';
import '../../widgets/common_button.dart';
import '../../widgets/headers/back_button_header_widget.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../utils/localdata/language_constants.dart';
import 'warranty_qr_navigation.dart';

class WarrantyManual extends StatefulWidget {
  WarrantyManual({super.key});

  @override
  State<WarrantyManual> createState() => _WarrantyManualState();
}

class _WarrantyManualState extends State<WarrantyManual> {
  final WarrantyController warrantyController = Get.find();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    warrantyController.textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Obx(
          () => SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    HeaderWidgetWithBackButton(
                      onPressed: () => {Navigator.pop(context)},
                      heading: translation(context).checkWarrantyStatus,
                    ),
                    UserProfileWidget(),
                    TextFieldManualEntry(
                      horizontalPadding: 24,
                    ),
                  ],
                ),
                CommonButton(
                  onPressed: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          settings: RouteSettings(
                              arguments: warrantyController.textController.text),
                          builder: (context) => WarrantyQrNavigation(
                            showManualWarrantyButton: false,
                          ),
                        ))
                  },
                  isEnabled: warrantyController.isLengthValid.value,
                  buttonText: translation(context).continueButtonText,
                  bottomPadding: 32,
                  containerBackgroundColor: AppColors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TextFieldManualEntry extends StatelessWidget {
  TextFieldManualEntry({
    this.isEnabled = true,
    this.horizontalPadding = 0,
    super.key,
    this.clearText = false,
  });

  final double horizontalPadding;
  final bool isEnabled;
  final WarrantyController c = Get.find();
  final bool clearText;

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding * variablePixelWidth),
        child: TextField(
          controller: c.textController,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
          maxLength: 14,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9]")),
          ],
          enabled: isEnabled,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
                vertical: 18 * variablePixelHeight,
                horizontal: 16 * variablePixelWidth),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.grey, width: 0.0),
          ),
            border: const OutlineInputBorder(),
            hintStyle: GoogleFonts.poppins(
                color: AppColors.lightGrey1,
                fontSize: 14 * variablePixelHeight,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.50),
            floatingLabelStyle: GoogleFonts.poppins(
              color: AppColors.lightGrey1,
              fontSize: 12 * variablePixelWidth,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.40,
            ),
            labelText: translation(context).serialNo,
            hintText: translation(context).checkSerialNumber,
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
        ),
      
    );
  }
}
