import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../state/contoller/create_dealer_electrician_controller.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../widgets/headers/network_mgmnt_header_widget.dart';
import '../../base_screen.dart';
import '../../userprofile/user_profile_widget.dart';
import 'components/heading_dealer.dart';
import 'components/address_detail_form_widget.dart';
import 'components/common_network_utils.dart';
import 'components/submit_button.dart';
import 'document_upload.dart';

class AddAddressDetails extends StatefulWidget {
  final String selectedUserType;
  const AddAddressDetails({super.key, required this. selectedUserType});

  @override
  State<AddAddressDetails> createState() => _AddAddressDetailsState();
}

class _AddAddressDetailsState extends BaseScreenState<AddAddressDetails> {
  late double variablePixelHeight;
  late double variablePixelWidth;
  late double variablePixelMultiplier;
  late double textMultiplier;
  CreateDealerElectricianController controller = Get.find();


  @override
  Widget baseBody(BuildContext context) {
    variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    variablePixelMultiplier =
        DisplayMethods(context: context).getPixelMultiplier();
    textMultiplier = DisplayMethods(context: context).getTextFontMultiplier();
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.lightWhite1,
        bottomNavigationBar: submitButtonWidget(),
        body: SafeArea(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            NetworkManagementHeaderWidget(heading: widget.selectedUserType==UserType.dealer? translation(context).newDealer: translation(context).newElectrician),
            UserProfileWidget(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24*variablePixelWidth),
              child: titleWidget(textMultiplier, variablePixelMultiplier),
            ),
            Expanded(
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24*variablePixelWidth),
                  child:  AddressDetailForm(widget.selectedUserType)),
            )
          ]),
        ),
      ),
    );
  }

  Widget titleWidget(double textMultiplier, double variablePixelMultiplier) {
    return Container(
      height: 40 * variablePixelMultiplier,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            translation(context).addressDetails,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: AppColors.darkText2,
              fontSize: 16 * textMultiplier,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            "${ translation(context).step} 2 of 3",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: AppColors.hintColor,
              fontSize: 14 * textMultiplier,
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }

  Widget submitButtonWidget() {
    return Obx(() {
      return Container(
        height: 100 * variablePixelHeight,
        padding: EdgeInsets.fromLTRB(
            1 * variablePixelWidth, 0, 1 * variablePixelWidth, 0),
        alignment: Alignment.center,
        child: SubmitButton(
            onPressed: () {
              FocusScope.of(context).unfocus();
              if(controller.enableAddressSubmit.value) {
                bool isValidated= controller.validateAddressField(context);
                if(isValidated){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>DocumentUpload(selectedUserType: widget.selectedUserType)));
                }
              }
              else{
                //  controller.emptyValidation();
              }
            },
            isEnabled: controller.enableAddressSubmit.value,
            containerBackgroundColor: AppColors.white,
            buttonText: 'Next'),
      );
    });
  }

}
