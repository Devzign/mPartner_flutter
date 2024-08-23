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
import 'components/common_network_utils.dart';
import 'components/firm_detail_form_widget.dart';
import 'components/submit_button.dart';

import 'add_address_details.dart';

class CreateFirmPersonalDetails extends StatefulWidget {
  final String selectedUserType;
  const CreateFirmPersonalDetails( {required this.selectedUserType,super.key});

  @override
  State<CreateFirmPersonalDetails> createState() => _CreateFirmPersonalDetailsState();
}

class _CreateFirmPersonalDetailsState extends BaseScreenState<CreateFirmPersonalDetails> {
  late double variablePixelHeight;
  late double variablePixelWidth;
  late double variablePixelMultiplier;
  late double textMultiplier;
  late String selectedUserType;
  CreateDealerElectricianController controller = Get.find();


  @override
  void initState() {
    selectedUserType=widget.selectedUserType;
    super.initState();
    controller.getStateList();
  }

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
       // controller.dispose();
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.lightWhite1,
        bottomNavigationBar: submitButtonWidget(),
        body: SafeArea(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            NetworkManagementHeaderWidget(heading:(selectedUserType==UserType.dealer)? translation(context).newDealer:translation(context).newElectrician),
            UserProfileWidget(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24*variablePixelWidth),
              child: titleWidget(textMultiplier, variablePixelMultiplier),
            ),
            Expanded(
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24*variablePixelWidth),
                  child:  FirmAndPersonalDetailForm(selectedUserType)),
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
          InkWell(
            onTap: ()async{
            /*  final DateTime? newDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900, 1),
                lastDate: DateTime(2200, 1),
                helpText: 'Select a date',

              );*/

              /*
                 final DateTimeRange? newDate = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2010, 1),
                lastDate: DateTime(2030, 1),
                helpText: 'Select a date',
                initialDateRange: DateTimeRange(
                  start: DateTime(2023, 12, 25),
                  end: DateTime(2023, 12, 30),
                ),
              );*/
            },
            child: Text(
              (selectedUserType==UserType.dealer)? translation(context).firmDetails:translation(context).personalDetails ,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: AppColors.darkText2,
                fontSize: 16 * textMultiplier,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            "${translation(context).step} 1 of 3",
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
              if(controller.enableSubmit.value) {
              bool isValidated= controller.validateFirmField(context);
              if(isValidated){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>AddAddressDetails(selectedUserType: widget.selectedUserType)));
              }

                //   Navigator.push(context, MaterialPageRoute(builder: (context)=>AddAddressDetails(selectedUserType: widget.selectedUserType)));

              }
              else{
              //  controller.emptyValidation();
              }
            },
            isEnabled: controller.enableSubmit.value,
            containerBackgroundColor: AppColors.white,
            buttonText: translation(context).nextButtonText),
      );
    });
  }

}
