import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../../state/contoller/create_dealer_electrician_controller.dart';
import '../../../../../utils/app_constants.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';
import '../../../../../utils/textfield_input_handler.dart';
import 'common_network_utils.dart';
import 'custom_text_fields.dart';
import 'dropddown_widget.dart';

class AddressDetailForm extends StatefulWidget {
  final String selectedUserType;

  const AddressDetailForm(this.selectedUserType, {super.key});

  @override
  State<AddressDetailForm> createState() => _AddressDetailFormState();
}

class _AddressDetailFormState extends State<AddressDetailForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  CreateDealerElectricianController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    final variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    final variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
              margin: EdgeInsets.only(top: 20.0 * variablePixelWidth),
              child: Obx(() {
                return Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.always,
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: controller.address1Controller,
                        labelText: translation(context).houseNo,
                        hintText: translation(context).enterHouseNo,
                        maxLength: AppConstants.addressInputMaxLength,
                        errorText: controller.address1ErrorText.value,
                        keyboardType: TextInputType.text,
                        inputFormatters: [HandleFirstSpaceInputFormatter()],
                        onValueChanged: (value) {
                          checkisTextEmpty();
                        },
                        isManditory: true,
                        context: context,
                      ),
                      SizedBox(
                        height: 24 * variablePixelHeight,
                      ),
                      CustomTextField(
                        controller: controller.address2Controller,
                        labelText: translation(context).apartment,
                        hintText: translation(context).enterAreaName,
                        keyboardType: TextInputType.text,
                        maxLength: AppConstants.addressInputMaxLength,
                        errorText: controller.address2ErrorText.value,
                        inputFormatters: [HandleFirstSpaceInputFormatter()],
                        onValueChanged: (value) {
                          checkisTextEmpty();
                        },
                        context: context,
                        isManditory: true,
                      ),
                      SizedBox(
                        height: 24 * variablePixelHeight,
                      ),
                      CustomTextField(
                        controller: controller.postalCodeController,
                        labelText: (widget.selectedUserType == UserType.dealer)
                            ? translation(context).pastalCode
                            : translation(context).pastalCode,
                        hintText: (widget.selectedUserType == UserType.dealer)
                            ? translation(context).enterYourPostalCode
                            : translation(context).enterYourPostalCode,
                        errorText: controller.postalCodeErrorText.value,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                        context: context,
                        maxLength: AppConstants.pinCodeInputMaxLength,
                        onValueChanged: (value) {
                          checkisTextEmpty();
                          if (value.isNotEmpty && value.length != 6) {
                            controller.postalCodeErrorText.value =
                                translation(context).validPostalCodeError;
                          } else {
                            controller.postalCodeErrorText.value = "";
                          }
                        },
                        isManditory: true,
                      ),
                      SizedBox(
                        height: 24 * variablePixelHeight,
                      ),
                      CustomTextField(
                        controller: controller.stateController,
                        labelText: (widget.selectedUserType == UserType.dealer)
                            ? translation(context).state
                            : translation(context).state,
                        hintText: (widget.selectedUserType == UserType.dealer)
                            ? translation(context).chooseState
                            : translation(context).chooseState,
                        //errorText: controller.postalCodeErrorText.value,
                        keyboardType: TextInputType.text,
                        context: context,
                        onValueChanged: (value) {
                          // checkisTextEmpty();
                        },
                        isEnabled: false,
                        isManditory: true,
                      ),

                      /*  DropdownWidget(
                    labelText:  (widget.selectedUserType==UserType.dealer)?DealerConstant.address_label4:ElectricianConstant.address_label4,
                    hintText:  (widget.selectedUserType==UserType.dealer)?DealerConstant.address_label4_hint:ElectricianConstant.address_label4_hint,
                    icon: Icon(Icons.keyboard_arrow_down),
                    dropDownType: "State",
                    onDropDownSelected: (value,type){

                    },
                    onDateSelected: (value, type) {
                     // _handleDateSelected(value, type);
                    },
                    onDealerSelected: (value, type) {
                     // _handleDealerSelected(value, type);
                    }),*/
                      SizedBox(
                        height: 24 * variablePixelHeight,
                      ),
                      DropdownWidget(
                          textEditController: controller.districtController,
                          errorText: controller.districtErrorText.value,
                          labelText:
                              (widget.selectedUserType == UserType.dealer)
                                  ? translation(context).district
                                  : translation(context).district,
                          hintText: (widget.selectedUserType == UserType.dealer)
                              ? translation(context).chooseDistrict
                              : translation(context).chooseDistrict,
                          icon: Icon(Icons.keyboard_arrow_down),
                          dropDownType: "district",
                          onDropDownSelected: (value, type) async {
                            print(value.name);
                            checkisTextEmpty();
                          },
                          onDateSelected: (value, type) {
                            // _handleDateSelected(value, type);
                          },
                          onDealerSelected: (value, type) {
                            // _handleDealerSelected(value, type);
                          }),
                      SizedBox(
                        height: 24 * variablePixelHeight,
                      ),
                      DropdownWidget(
                          textEditController: controller.cityController,
                          errorText: controller.cityErrorText.value,
                          labelText:
                              (widget.selectedUserType == UserType.dealer)
                                  ? translation(context).city
                                  : translation(context).city,
                          hintText: (widget.selectedUserType == UserType.dealer)
                              ? translation(context).chooseCity
                              : translation(context).chooseCity,
                          icon: Icon(Icons.keyboard_arrow_down),
                          dropDownType: "city",
                          onDropDownSelected: (value, type) {
                            print(value.name);
                            checkisTextEmpty();
                          },
                          onDateSelected: (value, type) {
                            // _handleDateSelected(value, type);
                          },
                          onDealerSelected: (value, type) {
                            //  _handleDealerSelected(value, type);
                          }),
                    ],
                  ),
                );
              })),
        ],
      ),
    );
  }

  void checkisTextEmpty() {
    if (controller.address1Controller.text.trim().isNotEmpty &&
        controller.address2Controller.text.trim().isNotEmpty &&
        controller.postalCodeController.text.trim().isNotEmpty &&
        controller.selectedDistrict != null &&
        controller.selectedCity != null) {
      controller.enableAddressSubmit.value = true;
    } else {
      controller.enableAddressSubmit.value = false;
    }
  }
}
