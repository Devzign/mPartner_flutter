import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../../state/contoller/create_dealer_electrician_controller.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_constants.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';
import '../../../../../utils/textfield_input_handler.dart';
import '../../../../widgets/calendar_widget/custom_calendar_view.dart';
import 'common_network_utils.dart';
import 'custom_text_fields.dart';

class FirmAndPersonalDetailForm extends StatefulWidget {
  final String selectedUserType;

  const FirmAndPersonalDetailForm(this.selectedUserType, {super.key});

  @override
  State<FirmAndPersonalDetailForm> createState() =>
      _FirmAndPersonalDetailFormState();
}

class _FirmAndPersonalDetailFormState extends State<FirmAndPersonalDetailForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  CreateDealerElectricianController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    final variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    final variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    return SingleChildScrollView(
        child: Container(
            margin: EdgeInsets.only(top: 20.0 * variablePixelWidth),
            child: Obx(() {
              return Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.always,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: controller.companyNameController,
                      labelText: (widget.selectedUserType == UserType.dealer)
                          ? translation(context).dealerFirmPropertyName
                          : translation(context).fullName,
                      hintText: (widget.selectedUserType == UserType.dealer)
                          ? translation(context).dealerFirmName
                          : translation(context).enterFullName,
                      errorText: controller.companyErrorText.value,
                      keyboardType: TextInputType.text,
                      maxLength: AppConstants.nameInputMaxLength,
                      inputFormatters: [
                        HandleFirstSpaceAndDotInputFormatter(),
                        HandleMultipleDotsInputFormatter(),
                        FilteringTextInputFormatter.allow(AppConstants.VALIDATE_COMPANY_REGEX),
                      ],
                      onValueChanged: (value) {
                        checkisTextEmpty();
                      },
                      isManditory: true,
                      context: context,
                    ),
                    (widget.selectedUserType == UserType.dealer)
                        ? SizedBox(
                            height: 24 * variablePixelHeight,
                          )
                        : Container(),
                    (widget.selectedUserType == UserType.dealer)
                        ? CustomTextField(
                            controller: controller.delearController,
                            labelText: translation(context).dealerName,
                            hintText: translation(context).dealerFirmShopname,
                            keyboardType: TextInputType.text,
                            inputFormatters: [
                              HandleFirstSpaceAndDotInputFormatter(),
                              HandleMultipleDotsInputFormatter(),
                              FilteringTextInputFormatter.allow(AppConstants.VALIDATE_COMPANY_REGEX),
                            ],
                            maxLength: AppConstants.nameInputMaxLength,
                            errorText: controller.dealerErrorText.value,
                            onValueChanged: (value) {
                              checkisTextEmpty();
                            },
                            context: context,
                            isManditory: true,
                          )
                        : Container(),
                    (widget.selectedUserType == UserType.dealer)
                        ? SizedBox(
                            height: 24 * variablePixelHeight,
                          )
                        : Container(),
                    (widget.selectedUserType == UserType.dealer)
                        ? CustomTextField(
                            controller: controller.ownerController,
                            labelText: translation(context).ownerName,
                            hintText: translation(context).enterOwnerName,
                            maxLength: AppConstants.nameInputMaxLength,
                            errorText: controller.ownerErrorText.value,
                            keyboardType: TextInputType.text,
                            inputFormatters: [
                              HandleFirstSpaceAndDotInputFormatter(),
                              HandleMultipleDotsInputFormatter(),
                              FilteringTextInputFormatter.allow(AppConstants.VALIDATE_NAME_REGEX),
                            ],
                            context: context,
                            onValueChanged: (value) {
                              checkisTextEmpty();
                            },
                            isManditory: true,
                          )
                        : Container(),
                    SizedBox(
                      height: 24 * variablePixelHeight,
                    ),
                    CustomTextField(
                      controller: controller.mobileNumberController,
                      labelText: (widget.selectedUserType == UserType.dealer)
                          ? translation(context).mobileNumber
                          : translation(context).mobileNumber,
                      hintText: (widget.selectedUserType == UserType.dealer)
                          ? translation(context).enterPhoneNoHint
                          : translation(context).enterPhoneNoHint,
                      keyboardType: TextInputType.phone,
                      context: context,
                      inputFormatters: [
                        HandleFirstDigitInMobileTextFieldFormatter(),
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      maxLength: AppConstants.mobileNumberInputMaxLength,
                      errorText: controller.mobileErrorText.value,
                      onValueChanged: (value) {
                        checkisTextEmpty();
                        controller.mobileErrorText.value = "";
                      },
                      isManditory: true,
                    ),
                    SizedBox(
                      height: 24 * variablePixelHeight,
                    ),
                    CustomTextField(
                      controller: controller.emailController,
                      labelText: (widget.selectedUserType == UserType.dealer)
                          ? translation(context).emailId
                          : translation(context).emailId,
                      hintText: (widget.selectedUserType == UserType.dealer)
                          ? translation(context).enterEmailId
                          : translation(context).enterEmailId,
                      keyboardType: TextInputType.emailAddress,
                      context: context,
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(r'\s')),
                      ],
                      maxLength: AppConstants.emailInputMaxLength,
                      errorText: controller.emailErrorText.value,
                      onValueChanged: (value) {
                        checkisTextEmpty();
                        if (value.isNotEmpty) {
                          controller.validateEmail(value, context);
                        } else {
                          controller.emailErrorText.value = "";
                        }
                      },
                      isManditory: true,
                    ),
                    SizedBox(
                      height: 24 * variablePixelHeight,
                    ),
                    (widget.selectedUserType == UserType.electrician)
                        ? CustomCalendarView(
                            labelText: translation(context).dob,
                            hintText: translation(context).selectDateFormat,
                            icon: Icon(
                              Icons.calendar_month_outlined,
                              color: AppColors.grey,
                            ),
                            calendarType:
                                AppConstants.singleSelectionCalenderType,
                            dateFormat: "dd/MM/yyyy",
                            initialDateSelection: DateTime(
                                DateTime.now().year - 18,
                                DateTime.now().month,
                                DateTime.now().day),
                            errorText: "",
                            calendarStartDate: DateTime(1950, 1, 1),
                            calendarEndDate: DateTime(DateTime.now().year - 18,
                                DateTime.now().month, DateTime.now().day),
                            singleDateEditController:
                                controller.dobTextEditController,
                            onDateSelected: (selectedDate) {
                              print("view1 ${selectedDate}");
                              controller.dobTextEditController.text =
                                  selectedDate;
                              checkisTextEmpty();
                            },
                            onDateRangeSelected: (startDate, endDate) {
                              print("view2 ${startDate}- ${endDate}");
                            },
                          )
                        : Container(),
                  ],
                ),
              );
            })));
  }

  void checkisTextEmpty() {
    if (widget.selectedUserType == UserType.dealer) {
      if (controller.companyNameController.text.trim().isNotEmpty &&
          controller.ownerController.text.trim().isNotEmpty &&
          controller.delearController.text.trim().isNotEmpty &&
          controller.mobileNumberController.text.trim().isNotEmpty &&
          controller.mobileNumberController.text
                  .toString()
                  .replaceAll("+91 - ", "")
                  .trim()
                  .length ==
              10 &&
          controller.emailController.text.trim().isNotEmpty) {
        controller.enableSubmit.value = true;
        // controller.emptyValidation();
      } else {
        controller.enableSubmit.value = false;
        //  controller.emptyValidation();
      }
    } else {
      if (controller.companyNameController.text.trim().isNotEmpty &&
          controller.mobileNumberController.text.trim().isNotEmpty &&
          controller.mobileNumberController.text
                  .toString()
                  .replaceAll("+91 - ", "")
                  .trim()
                  .length ==
              10 &&
          controller.emailController.text.trim().isNotEmpty &&
          controller.dobTextEditController.text.trim().isNotEmpty) {
        controller.enableSubmit.value = true;
        // controller.emptyValidation();
      } else {
        controller.enableSubmit.value = false;
        //  controller.emptyValidation();
      }
    }
  }
}
