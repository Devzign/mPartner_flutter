import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../presentation/screens/report_management/widgets/common_bottom_modal.dart';
import '../../../../presentation/screens/userprofile/components/form_field_widget.dart';
import '../../../../presentation/screens/userprofile/upperCaseFormatter.dart';
import '../../../../presentation/screens/userprofile/user_profile_widget.dart';
import '../../../../presentation/widgets/common_button.dart';
import '../../../../presentation/widgets/headers/back_button_header_widget.dart';
import '../../../../presentation/widgets/horizontalspace/horizontal_space.dart';
import '../../../../presentation/widgets/verticalspace/vertical_space.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/enums.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../../utils/textfield_input_handler.dart';
import '../../../data/models/option.dart';
import '../../../data/models/state_model.dart';
import '../../../state/controller/banking_partners_controller.dart';
import '../../../state/controller/solar_design_request_controller.dart';
import '../../../state/controller/solar_finance_controller.dart';
import '../../../utils/solar_app_constants.dart';
import '../../common/heading_solar.dart';
import '../../common/validations.dart';
import '../banking_partners/preferred_bank_options.dart';
import 'components/city_list.dart';
import 'components/drop_down_selection_list.dart';
import 'components/secondary_user_form_field_widget.dart';
import 'components/solution_types.dart';
import 'components/state_list.dart';
import 'components/unit_options.dart';
import 'customer_project_details_screen.dart';

class SolarFinanceRequestForm extends StatefulWidget {
  const SolarFinanceRequestForm({super.key});

  @override
  State<SolarFinanceRequestForm> createState() => _SolarFinanceRequestFormState();
}

class _SolarFinanceRequestFormState extends State<SolarFinanceRequestForm> {
  String selectedRadio = 'commercial';
  bool isSubmitEnabled = false;
  String prefix = '';
  String secondaryPrefix = '';
  bool isAddSecondaryUserClicked = false;
  bool isValidGstNo = false;
  bool isValidPanNo = false;
  bool isValidPin = false;
  bool isValidMobileNumber = false;
  bool isValidSecMobNo = false;
  bool isValidEmail = false;
  bool isValidSecEmail = false;
  bool isValidCompanyName = false;
  bool isValidName = false;
  bool isValidSecName = false;
  bool isValidProjectName = false;
  bool isValidProjectCapacity = false;
  bool isValidProjectCost = false;
  String errorTextGstNo = "";
  String errorTextPanNo = '';
  String errorTextPin = "";
  String errorTextMobileNumber = "";
  String errorTextSecMobNo = "";
  String errorTextEmail = "";
  String errorTextSecEmail = "";
  String errorTextCompanyName = "";
  String errorTextName = "";
  String errorSecName = "";
  String errorTextProjectName = "";
  String errorTextProjectCapacity = "";
  String errorTextProjectCost = "";
  TextEditingController companyNameController = TextEditingController();
  TextEditingController personNameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController emailIdController = TextEditingController();
  TextEditingController projectNameController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController solutionTypeController = TextEditingController();
  TextEditingController projectCapacityController = TextEditingController();
  TextEditingController unitController = TextEditingController();
  TextEditingController projectCostController = TextEditingController();
  TextEditingController preferredBankController = TextEditingController();
  TextEditingController gstinNumberController = TextEditingController();
  TextEditingController panNumberController = TextEditingController();
  TextEditingController secondaryContactNameController = TextEditingController();
  TextEditingController secondaryContactMobileNoController = TextEditingController();
  TextEditingController secondaryContactEmailIdController = TextEditingController();
  BankingPartnersController bankingPartnersController = Get.find();
  SolarFinanceController solarFinanceController = Get.find();
  SolarDesignRequestController solarDesignRequestController = Get.find();
  int bankId = 0;
  int unitId = 0;

  @override
  void initState() {
    bankingPartnersController.clearBankingPartnersController();
    solarFinanceController.clearSolarFinanceController();
    solarDesignRequestController.clearState();
    solarDesignRequestController.solutionTypeListFinance=<Option>[].obs;
    bankingPartnersController.fetchPreferredBanksList();
    solarFinanceController.fetchUnits();
    solarDesignRequestController.getStates();
    solarDesignRequestController.getSolutionTypes(SolutionTypes.SolarFinancingSolutionType.name);
    super.initState();
  }

  void clearTextfields() {
    companyNameController.text = "";
    personNameController.text = "";
    mobileNumberController.text = "";
    emailIdController.text = "";
    projectNameController.text = "";
    pincodeController.text = "";
    stateController.text = "";
    cityController.text = "";
    solutionTypeController.text = "";
    projectCapacityController.text = "";
    unitController.text = "";
    projectCostController.text = "";
    preferredBankController.text = "";
    gstinNumberController.text = "";
    panNumberController.text = "";
    secondaryContactNameController.text = "";
    secondaryContactMobileNoController.text = "";
    secondaryContactEmailIdController.text = "";
    prefix = "";
    secondaryPrefix = "";
    isAddSecondaryUserClicked = false;
    errorTextGstNo = "";
    errorTextPanNo = '';
    errorTextPin = "";
    errorTextMobileNumber = "";
    errorTextSecMobNo = "";
    errorTextEmail = "";
    errorTextSecEmail = "";
    errorTextCompanyName = "";
    errorTextName = "";
    errorSecName = "";
    errorTextProjectName = "";
    errorTextProjectCapacity = "";
    errorTextProjectCost = "";
    solarDesignRequestController.updateSelectedState(SolarStateData(stateId: '', stateName: ''));
  }

  String capitalizeEachWord(String text) {
    List<String> words = text.split(' ');
    for (int i = 0; i < words.length; i++) {
      if (words[i].isNotEmpty) {
        // Special case for "And"
        if (words[i].toLowerCase() == 'and') {
          words[i] = '&';
        } else {
          words[i] = words[i][0].toUpperCase() + words[i].substring(1).toLowerCase();
        }
      }
    }
    return words.join(' ');
  }

  final indianRupeesFormat = NumberFormat.currency(
    name: "INR",
    locale: 'en_IN',
    decimalDigits: 0,
    symbol: '\u{20B9} ',
  );

  void checkTextFieldStatus() {
    setState(() {
      bool commonConditions = personNameController.text.isNotEmpty &&
          mobileNumberController.text.isNotEmpty && emailIdController.text.isNotEmpty &&
          projectNameController.text.isNotEmpty && pincodeController.text.isNotEmpty &&
          stateController.text.isNotEmpty && cityController.text.isNotEmpty && solutionTypeController.text.isNotEmpty &&
          projectCapacityController.text.isNotEmpty && unitController.text.isNotEmpty &&
          projectCostController.text.isNotEmpty && preferredBankController.text.isNotEmpty &&
          panNumberController.text.isNotEmpty && isValidName && isValidPanNo && isValidMobileNumber
          && isValidEmail && isValidPin && isValidProjectName && isValidProjectCapacity && isValidProjectCost;
      bool additionalConditions = !isAddSecondaryUserClicked ||
          (secondaryContactNameController.text.isNotEmpty &&
              secondaryContactMobileNoController.text.isNotEmpty &&
              secondaryContactEmailIdController.text.isNotEmpty && isValidSecName && isValidSecMobNo && isValidSecEmail);
      if (selectedRadio == 'commercial') {
        isSubmitEnabled = commonConditions &&
            companyNameController.text.isNotEmpty && gstinNumberController.text.isNotEmpty && isValidCompanyName &&
            isValidGstNo  && additionalConditions;
      } else {
        isSubmitEnabled = commonConditions && additionalConditions;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight = DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth = DisplayMethods(context: context).getVariablePixelWidth();
    double textFontMultiplier = DisplayMethods(context: context).getTextFontMultiplier();
    double pixelMultiplier = DisplayMethods(context: context).getPixelMultiplier();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            HeadingSolar(
              heading: translation(context).financeRequest,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            UserProfileWidget(
              top: 8 * variablePixelHeight,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 24 * variablePixelWidth, right: 24 * variablePixelWidth),
                        child: Text(
                          translation(context).addCustomerProjectDetails,
                          style: GoogleFonts.poppins(
                            color: AppColors.darkText2,
                            fontSize: 16 * textFontMultiplier,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.10,
                          ),
                        ),
                      ),
                      const VerticalSpace(height: 16),
                      Container(
                        margin: EdgeInsets.only(left: 24 * variablePixelWidth, right: 24 * variablePixelWidth),
                        child: Text(
                          translation(context).projectType,
                          style: GoogleFonts.poppins(
                            color: AppColors.darkText2,
                            fontSize: 14 * textFontMultiplier,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.10,
                          ),
                        ),
                      ),
                      const VerticalSpace(height: 8),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24 * variablePixelWidth),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Flexible(
                              flex: 1,
                              child: GestureDetector(
                                onTap: () => setState(() {
                                  clearTextfields();
                                  FocusScope.of(context).unfocus();
                                  checkTextFieldStatus();
                                  selectedRadio = "commercial";
                                }),
                                child: ListTile(
                                  horizontalTitleGap: 0,
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(translation(context).commercial),
                                  titleTextStyle: GoogleFonts.poppins(
                                    color: AppColors.darkText2,
                                    fontSize: 14 * textFontMultiplier,
                                    fontWeight: FontWeight.w400,
                                    height: 20 / 14,
                                    letterSpacing: 0.25,
                                  ),
                                  leading: SizedBox(
                                    width: 32 * variablePixelWidth,
                                    height: 32 * variablePixelHeight,
                                    child: SizedBox(
                                      width: 13.33 * variablePixelWidth,
                                      height: 13.33 * variablePixelHeight,
                                      child: Radio(
                                          activeColor: AppColors.lumiBluePrimary,
                                          value: 'commercial',
                                          groupValue: selectedRadio,
                                          onChanged: (value) {
                                            setState(() => selectedRadio = value as String);
                                            clearTextfields();
                                            FocusScope.of(context).unfocus();
                                            checkTextFieldStatus();
                                          }),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: GestureDetector(
                                onTap: () => setState(() {
                                  clearTextfields();
                                  FocusScope.of(context).unfocus();
                                  checkTextFieldStatus();
                                  selectedRadio = "residential";
                                }),
                                child: ListTile(
                                  horizontalTitleGap: 0,
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(translation(context).residential),
                                  titleTextStyle: GoogleFonts.poppins(
                                    color: AppColors.darkText2,
                                    fontSize: 14 * textFontMultiplier,
                                    fontWeight: FontWeight.w400,
                                    height: 20 / 14,
                                    letterSpacing: 0.25,
                                  ),
                                  leading: SizedBox(
                                    width: 32 * variablePixelWidth,
                                    height: 32 * variablePixelHeight,
                                    child: SizedBox(
                                      width: 13.33 * variablePixelWidth,
                                      height: 13.33 * variablePixelHeight,
                                      child: Radio(
                                          activeColor: AppColors.lumiBluePrimary,
                                          value: 'residential',
                                          groupValue: selectedRadio,
                                          onChanged: (value) {
                                            setState(() => selectedRadio = value as String);
                                            clearTextfields();
                                            FocusScope.of(context).unfocus();
                                            checkTextFieldStatus();
                                          }),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 24 * variablePixelWidth, right: 24 * variablePixelWidth),
                        child: Column(
                          children: [
                            const VerticalSpace(height: 12),
                            selectedRadio == "commercial" ? FormFieldWidget(
                              controller: companyNameController,
                              inputFormatter: [
                                HandleFirstSpaceAndDotInputFormatter(),
                                HandleMultipleDotsInputFormatter(),
                                FilteringTextInputFormatter.allow(AppConstants.VALIDATE_COMPANY_REGEX),
                              ],
                              textCapitalization: TextCapitalization.words,
                              onTap: (){
                                if(mobileNumberController.text.isEmpty){
                                  setState(() {
                                    prefix = '';
                                  });
                                }
                                if(secondaryContactMobileNoController.text.isEmpty){
                                  setState(() {
                                    secondaryPrefix = '';
                                  });
                                }
                              },
                              labelText: translation(context).dealerFirmPropertyName,
                              hintText: translation(context).contactPersonFirmName,
                              keyboardType: TextInputType.text,
                              maxLength: AppConstants.nameInputMaxLength,
                              errorText: errorTextCompanyName.isNotEmpty ? errorTextCompanyName : null,
                              onChanged: (value) {
                                var validationResult = validateName(companyNameController.text, context);
                                setState(() {
                                  isValidCompanyName = validationResult.value1;
                                  errorTextCompanyName = validationResult.value2;
                                });
                                checkTextFieldStatus();
                              },
                            ) : const SizedBox(height: 0),
                            selectedRadio == "commercial" ? const VerticalSpace(height: 24) : const SizedBox(height: 0),
                            FormFieldWidget(
                              controller: personNameController,
                              maxLength: AppConstants.nameInputMaxLength,
                              keyboardType: TextInputType.text,
                              inputFormatter: [
                                HandleFirstSpaceAndDotInputFormatter(),
                                HandleMultipleDotsInputFormatter(),
                                FilteringTextInputFormatter.allow(AppConstants.VALIDATE_NAME_REGEX),
                              ],
                              textCapitalization: TextCapitalization.words,
                              labelText: translation(context).contactPersonName,
                              hintText: translation(context).contactPersonName,
                              errorText: errorTextName.isNotEmpty ? errorTextName : null,
                              onChanged: (value) {
                                var validationResult = validateName(personNameController.text, context);
                                setState(() {
                                  isValidName = validationResult.value1;
                                  errorTextName = validationResult.value2;
                                });
                                checkTextFieldStatus();
                              },
                              onTap: (){
                                if(mobileNumberController.text.isEmpty){
                                  setState(() {
                                    prefix = '';
                                  });
                                }
                                if(secondaryContactMobileNoController.text.isEmpty){
                                  setState(() {
                                    secondaryPrefix = '';
                                  });
                                }
                              },
                            ),
                            const VerticalSpace(height: 24),
                            FormFieldWidget(
                              controller: mobileNumberController,
                              labelText: translation(context).contactPersonMobileNumber,
                              hintText: translation(context).enterMobileNumber,
                              onChanged: (value) {
                                var mobileNumberValidationResult = validateMobileNumber(mobileNumberController.text, context);
                                setState(() {
                                  isValidMobileNumber = mobileNumberValidationResult.value1;
                                  errorTextMobileNumber = mobileNumberValidationResult.value2;
                                });
                                checkTextFieldStatus();
                              },
                              onTap: () {
                                setState(() {
                                  prefix = SolarAppConstants.mobileNoPrefix;
                                });
                                if(secondaryContactMobileNoController.text.isEmpty){
                                  setState(() {
                                    secondaryPrefix = '';
                                  });
                                }
                              },
                              inputFormatter: <TextInputFormatter>[
                                HandleFirstDigitInMobileTextFieldFormatter(),
                                FilteringTextInputFormatter.allow(SolarAppConstants.DIGITS_REGEX),
                              ],
                              maxLength: SolarAppConstants.maxLength10,
                              errorText: errorTextMobileNumber.isNotEmpty ? errorTextMobileNumber : null,
                              keyboardType: TextInputType.number,
                              prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 16 * variablePixelWidth),
                                child: Text(
                                  prefix,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14 * textFontMultiplier,
                                    fontWeight: FontWeight.w500,
                                    height: 0.12,
                                    letterSpacing: 0.50,
                                  )
                                ),
                              ),
                            ),
                            const VerticalSpace(height: 24),
                            FormFieldWidget(
                              controller: emailIdController,
                              keyboardType: TextInputType.emailAddress,
                              inputFormatter: [
                                FilteringTextInputFormatter.deny(RegExp('(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])')),
                                FilteringTextInputFormatter.deny(RegExp(r'[!#$%^&*(),?:{}|<>]')),
                                HandleFirstCharacterEmailInputFormatter(),
                                HandleMultipleDotsInputFormatter(),
                                HandleMultipleCommasInputFormatter(),
                                HandleMultipleAtTheRateInputFormatter(),
                                HandleMultipleDollarInputFormatter(),
                                FilteringTextInputFormatter.deny(SolarAppConstants.SPACE_REGEX),
                              ],
                              maxLength: AppConstants.emailInputMaxLength,
                              onTap: (){
                                if(mobileNumberController.text.isEmpty){
                                  setState(() {
                                    prefix = '';
                                  });
                                }
                                if(secondaryContactMobileNoController.text.isEmpty){
                                  setState(() {
                                    secondaryPrefix = '';
                                  });
                                }
                              },
                              errorText: errorTextEmail.isNotEmpty ? errorTextEmail : null,
                              labelText: translation(context).contactPersonEmailId,
                              hintText: translation(context).enterEmailId,
                              onChanged: (value) {
                                var emailValidationResult = validateEmail(emailIdController.text, context);
                                setState(() {
                                  isValidEmail = emailValidationResult.value1;
                                  errorTextEmail = emailValidationResult.value2;
                                });
                                checkTextFieldStatus();
                              },
                            ),
                          ],
                        ),
                      ),
                      const VerticalSpace(height: 12),
                      isAddSecondaryUserClicked ? GestureDetector(
                        onTap: (){
                          setState(() {
                            isAddSecondaryUserClicked = false;
                            secondaryContactNameController.text = "";
                            secondaryContactMobileNoController.text = "";
                            secondaryContactEmailIdController.text = "";
                            secondaryPrefix = '';
                            errorSecName = ''; errorTextSecMobNo = ''; errorTextSecEmail = '';
                            checkTextFieldStatus();
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 24 * variablePixelWidth, right: 24 * variablePixelWidth),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(
                                Icons.remove,
                                size: 24 * pixelMultiplier,
                                color: AppColors.lumiBluePrimary,
                              ),
                              const HorizontalSpace(width: 4),
                              Text(
                                translation(context).removeSecondaryUser,
                                style: GoogleFonts.poppins(
                                  color: AppColors.lumiBluePrimary,
                                  fontSize: 14 * textFontMultiplier,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ): GestureDetector(
                        onTap: (){
                          setState(() {
                            isAddSecondaryUserClicked = true;
                            checkTextFieldStatus();
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 24 * variablePixelWidth, right: 24 * variablePixelWidth),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(
                                Icons.add,
                                size: 24 * pixelMultiplier,
                                color: AppColors.lumiBluePrimary,
                              ),
                              const HorizontalSpace(width: 4),
                              Text(
                                translation(context).addSecondaryUser,
                                style: GoogleFonts.poppins(
                                  color: AppColors.lumiBluePrimary,
                                  fontSize: 14 * textFontMultiplier,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 24 * variablePixelWidth, right: 24 * variablePixelWidth),
                        child: isAddSecondaryUserClicked ? Column(
                          children: [
                            const VerticalSpace(height: 12),
                            SecondaryUserFormFieldWidget(
                              controller: secondaryContactNameController,
                              maxLength: AppConstants.nameInputMaxLength,
                              keyboardType: TextInputType.text,
                              inputFormatter: [
                                HandleFirstSpaceAndDotInputFormatter(),
                                HandleMultipleDotsInputFormatter(),
                                FilteringTextInputFormatter.allow(AppConstants.VALIDATE_NAME_REGEX),
                              ],
                              textCapitalization: TextCapitalization.words,
                              errorText: errorSecName.isNotEmpty ? errorSecName : null,
                              onTap: (){
                                if(mobileNumberController.text.isEmpty){
                                  setState(() {
                                    prefix = '';
                                  });
                                }
                                if(secondaryContactMobileNoController.text.isEmpty){
                                  setState(() {
                                    secondaryPrefix = '';
                                  });
                                }
                              },
                              labelText: translation(context).secondaryContactName,
                              hintText: translation(context).enterSecondaryContactName,
                              onChanged: (value) {
                                var validationResult = validateName(secondaryContactNameController.text, context);
                                setState(() {
                                  isValidSecName = validationResult.value1;
                                  errorSecName = validationResult.value2;
                                });
                                checkTextFieldStatus();
                              },
                            ),
                            const VerticalSpace(height: 24),
                            SecondaryUserFormFieldWidget(
                              controller: secondaryContactMobileNoController,
                              labelText: translation(context).secondaryContactMobileNumber,
                              hintText: translation(context).enterSecondaryContactMobileNumber,
                              onTap: () {
                                setState(() {
                                  secondaryPrefix = SolarAppConstants.mobileNoPrefix;
                                });
                                if(mobileNumberController.text.isEmpty){
                                  setState(() {
                                    prefix = '';
                                  });
                                }
                              },
                              onChanged: (value) {
                                var secMobileNumberValidationResult = validateMobileNumber(secondaryContactMobileNoController.text, context);
                                setState(() {
                                  isValidSecMobNo = secMobileNumberValidationResult.value1;
                                  errorTextSecMobNo = secMobileNumberValidationResult.value2;
                                });
                                checkTextFieldStatus();
                              },
                              inputFormatter: <TextInputFormatter>[
                                HandleFirstDigitInMobileTextFieldFormatter(),
                                FilteringTextInputFormatter.allow(SolarAppConstants.DIGITS_REGEX),
                              ],
                              maxLength: SolarAppConstants.maxLength10,
                              errorText: errorTextSecMobNo.isNotEmpty ? errorTextSecMobNo : null,
                              keyboardType: TextInputType.number,
                              prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 16 * variablePixelWidth),
                                child: Text(
                                    secondaryPrefix,
                                    style: GoogleFonts.poppins(
                                      fontSize: 14 * textFontMultiplier,
                                      fontWeight: FontWeight.w500,
                                      height: 0.12,
                                      letterSpacing: 0.50,
                                    )
                                ),
                              ),
                            ),
                            const VerticalSpace(height: 24),
                            SecondaryUserFormFieldWidget(
                              controller: secondaryContactEmailIdController,
                              keyboardType: TextInputType.emailAddress,
                              inputFormatter: [
                                FilteringTextInputFormatter.deny(RegExp('(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])')),
                                FilteringTextInputFormatter.deny(RegExp(r'[!#$%^&*(),?:{}|<>]')),
                                HandleFirstCharacterEmailInputFormatter(),
                                HandleMultipleDotsInputFormatter(),
                                HandleMultipleCommasInputFormatter(),
                                HandleMultipleAtTheRateInputFormatter(),
                                HandleMultipleDollarInputFormatter(),
                                FilteringTextInputFormatter.deny(SolarAppConstants.SPACE_REGEX),
                              ],
                              maxLength: AppConstants.emailInputMaxLength,
                              onTap: (){
                                if(mobileNumberController.text.isEmpty){
                                  setState(() {
                                    prefix = '';
                                  });
                                }
                                if(secondaryContactMobileNoController.text.isEmpty){
                                  setState(() {
                                    secondaryPrefix = '';
                                  });
                                }
                              },
                              errorText: errorTextSecEmail.isNotEmpty ? errorTextSecEmail : null,
                              labelText: translation(context).secondaryContactEmailId,
                              hintText: translation(context).enterSecondaryContactEmailId,
                              onChanged: (value) {
                                var secEmailValidationResult = validateEmail(secondaryContactEmailIdController.text, context);
                                setState(() {
                                  isValidSecEmail = secEmailValidationResult.value1;
                                  errorTextSecEmail = secEmailValidationResult.value2;
                                });
                                checkTextFieldStatus();
                              },
                            ),
                          ],
                        ) : const SizedBox(height: 0),
                      ),
                      const VerticalSpace(height: 24),
                      Padding(
                        padding: EdgeInsets.only(left: 24 * variablePixelWidth, right: 24 * variablePixelWidth),
                        child: Column(
                          children: [
                            FormFieldWidget(
                              controller: projectNameController,
                              keyboardType: TextInputType.text,
                              inputFormatter: [
                                HandleFirstSpaceInputFormatter(),
                                FilteringTextInputFormatter.allow(SolarAppConstants.PROJECT_NAME_REGEX)
                              ],
                              textCapitalization: TextCapitalization.words,
                              onTap: (){
                                if(mobileNumberController.text.isEmpty){
                                  setState(() {
                                    prefix = '';
                                  });
                                }
                                if(secondaryContactMobileNoController.text.isEmpty){
                                  setState(() {
                                    secondaryPrefix = '';
                                  });
                                }
                              },
                              errorText: errorTextProjectName.isNotEmpty ? errorTextProjectName : null,
                              maxLength: AppConstants.nameInputMaxLength,
                              labelText: translation(context).projectName,
                              hintText: translation(context).enterProjectName,
                              onChanged: (value) {
                                var validationResult = validateName(projectNameController.text, context);
                                setState(() {
                                  isValidProjectName = validationResult.value1;
                                  errorTextProjectName = validationResult.value2;
                                });
                                checkTextFieldStatus();
                              },
                            ),
                            const VerticalSpace(height: 24),
                            FormFieldWidget(
                              controller: pincodeController,
                              inputFormatter: [
                                FilteringTextInputFormatter.allow(SolarAppConstants.DIGITS_REGEX)
                              ],
                              keyboardType: TextInputType.number,
                              onTap: (){
                                if(mobileNumberController.text.isEmpty){
                                  setState(() {
                                    prefix = '';
                                  });
                                }
                                if(secondaryContactMobileNoController.text.isEmpty){
                                  setState(() {
                                    secondaryPrefix = '';
                                  });
                                }
                              },
                              errorText: errorTextPin.isNotEmpty ? errorTextPin : null,
                              labelText: translation(context).pincode,
                              maxLength: SolarAppConstants.pincodeMaxLength,
                              hintText: translation(context).enterPincode,
                              onChanged: (value) {
                                var pinCodeValidationResult = validatePinCode(pincodeController.text, context);
                                setState(() {
                                  isValidPin = pinCodeValidationResult.value1;
                                  errorTextPin = pinCodeValidationResult.value2;
                                });
                                checkTextFieldStatus();
                              },
                            ),
                            const VerticalSpace(height: 24),
                            DropDownSelectionWidget(
                              controller:  stateController,
                              labelText: translation(context).state,
                              isMandatory: true,
                              onChanged: (value) {
                                checkTextFieldStatus();
                              },
                              placeholdertext: translation(context).selectState,
                              icon: Icons.keyboard_arrow_down_outlined,
                              modalBody: CommonBottomModal(
                                modalLabelText: translation(context).selectState,
                                body: StatesList(
                                  onStateSelected: (stateName, stateId) async {
                                    Navigator.pop(context);
                                    if(stateName.isNotEmpty){
                                      setState(() {
                                        stateController.text = capitalizeEachWord(stateName);
                                        cityController.text = "";
                                      });
                                      solarDesignRequestController.updateSelectedState(SolarStateData(stateId: stateId, stateName: stateName));
                                      await solarDesignRequestController.getCities();
                                      checkTextFieldStatus();
                                    }
                                  },
                                ),
                              ),
                              textColor: AppColors.titleColor,
                            ),
                            const VerticalSpace(height: 24),
                            DropDownSelectionWidget(
                              isEnabled: stateController.text.isNotEmpty ? true : false,
                              controller:  cityController,
                              labelText: translation(context).city,
                              isMandatory: true,
                              onChanged: (value) {
                                checkTextFieldStatus();
                              },
                              placeholdertext: translation(context).selectCity,
                              icon: Icons.keyboard_arrow_down_outlined,
                              modalBody: CommonBottomModal(
                                modalLabelText: translation(context).selectCity,
                                body: CityList(
                                  onCitySelected: (city) {
                                    Navigator.pop(context);
                                    if(city.isNotEmpty){
                                      setState(() {
                                        cityController.text = capitalizeEachWord(city);
                                      });
                                      checkTextFieldStatus();
                                    }
                                  },
                                ),
                              ),
                              textColor: AppColors.titleColor,
                            ),
                            const VerticalSpace(height: 24),
                            DropDownSelectionWidget(
                              controller:  solutionTypeController,
                              labelText: translation(context).solutionType,
                              isMandatory: true,
                              onChanged: (value) {
                                checkTextFieldStatus();
                              },
                              placeholdertext: translation(context).selectSolutionType,
                              icon: Icons.keyboard_arrow_down_outlined,
                              modalBody: CommonBottomModal(
                                modalLabelText: translation(context).selectSolutionType,
                                body: SolutionTypesList(
                                  onSolutionTypeSelected: (solutionType, solutionTypeId) {
                                    Navigator.pop(context);
                                    if(solutionType.isNotEmpty){
                                      setState(() {
                                        solutionTypeController.text = solutionType;
                                        solarDesignRequestController.updateSelectedSolutionTypeId(solutionTypeId.toString());
                                      });
                                      checkTextFieldStatus();
                                    }
                                  },
                                ),
                              ),
                              textColor: AppColors.titleColor,
                            ),
                          ],
                        ),
                      ),
                      const VerticalSpace(height: 24),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              width: 167 * variablePixelWidth,
                              margin: EdgeInsets.only(left: 24 * variablePixelWidth),
                              child:   FormFieldWidget(
                                controller: projectCapacityController,
                                inputFormatter: [
                                  FilteringTextInputFormatter.allow(SolarAppConstants.NON_ZERO_FIRST_DIGIT_REGEX)
                                ],
                                keyboardType: TextInputType.number,
                                onTap: (){
                                  if(mobileNumberController.text.isEmpty){
                                    setState(() {
                                      prefix = '';
                                    });
                                  }
                                  if(secondaryContactMobileNoController.text.isEmpty){
                                    setState(() {
                                      secondaryPrefix = '';
                                    });
                                  }
                                },
                                errorText: errorTextProjectCapacity.isNotEmpty ? errorTextProjectCapacity : null,
                                labelText: translation(context).projectCapacity,
                                maxLength: SolarAppConstants.projectCapacityMaxLength,
                                hintText: translation(context).enterCapacity,
                                onChanged: (value) {
                                  var validationResult = validateValueAndUnit(projectCapacityController.text, unitController.text, context);
                                  setState(() {
                                    isValidProjectCapacity = validationResult.value1;
                                    errorTextProjectCapacity = validationResult.value2;
                                  });
                                  checkTextFieldStatus();
                                },
                              ),
                            ),
                          ),
                          const HorizontalSpace(width: 12),
                          Expanded(
                            child:
                            Container(
                              width: 167 * variablePixelWidth,
                              height: 50 * variablePixelHeight,
                              margin: EdgeInsets.only(right: 24 * variablePixelWidth),
                              child: DropDownSelectionWidget(
                                controller:  unitController,
                                labelText: translation(context).unit,
                                isMandatory: true,
                                onChanged: (value) {
                                  checkTextFieldStatus();
                                },
                                placeholdertext: translation(context).selectUnit,
                                icon: Icons.keyboard_arrow_down_outlined,
                                modalBody: CommonBottomModal(
                                  modalLabelText: translation(context).selectUnit,
                                  body: UnitOptions(
                                    onUnitSelected: (unit, id) {
                                      Navigator.pop(context);
                                      if(unit.isNotEmpty){
                                        setState(() {
                                          unitController.text = unit;
                                          unitId = id;
                                          var validationResult = validateValueAndUnit(projectCapacityController.text, unitController.text, context);
                                          isValidProjectCapacity = validationResult.value1;
                                          errorTextProjectCapacity = validationResult.value2;
                                        });
                                        checkTextFieldStatus();
                                      }
                                    },
                                  ),
                                ),
                                textColor: AppColors.titleColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const VerticalSpace(height: 24),
                      Padding(
                        padding: EdgeInsets.only(left: 24 * variablePixelWidth, right: 24 * variablePixelWidth),
                        child: Column(
                          children: [
                            FormFieldWidget(
                              controller: projectCostController,
                              inputFormatter: [
                                FilteringTextInputFormatter.allow(SolarAppConstants.DIGITS_REGEX)
                              ],
                              keyboardType: TextInputType.number,
                              onTap: (){
                                if(mobileNumberController.text.isEmpty){
                                  setState(() {
                                    prefix = '';
                                  });
                                }
                                if(secondaryContactMobileNoController.text.isEmpty){
                                  setState(() {
                                    secondaryPrefix = '';
                                  });
                                }
                              },
                              errorText: errorTextProjectCost.isNotEmpty ? errorTextProjectCost : null,
                              labelText: translation(context).projectCost,
                              maxLength: SolarAppConstants.maxLength15,
                              hintText: translation(context).enterProjectCost,
                              onChanged: (value) {
                                var validationResult = validateCost(projectCostController.text, context);
                                setState(() {
                                  isValidProjectCost = validationResult.value1;
                                  errorTextProjectCost = validationResult.value2;
                                });
                                projectCostController.text =  projectCostController.text.isNotEmpty
                                    ? indianRupeesFormat.format(double.parse(projectCostController.text)).toString()
                                    : "";
                                checkTextFieldStatus();
                              },
                            ),
                            const VerticalSpace(height: 24),
                            DropDownSelectionWidget(
                              controller:  preferredBankController,
                              labelText: translation(context).preferredBank,
                              isMandatory: true,
                              onChanged: (value) {
                                checkTextFieldStatus();
                              },
                              placeholdertext: translation(context).selectPreferredBank,
                              icon: Icons.keyboard_arrow_down_outlined,
                              modalBody: CommonBottomModal(
                                modalLabelText: translation(context).selectPreferredBank,
                                body: PreferredBankOptions(
                                  onBankSelected: (bank, id) {
                                    Navigator.pop(context);
                                    if(bank.isNotEmpty){
                                      setState(() {
                                        preferredBankController.text = bank;
                                        bankId = id;
                                      });
                                      checkTextFieldStatus();
                                    }
                                  },
                                ),
                              ),
                              textColor: AppColors.titleColor,
                            ),
                            const VerticalSpace(height: 24),
                            selectedRadio == "commercial" ? FormFieldWidget(
                              controller: gstinNumberController,
                              textCapitalization: TextCapitalization.characters,
                              inputFormatter: [
                                UpperCaseTextFormatter(),
                                FilteringTextInputFormatter.allow(SolarAppConstants.DIGITS_CHARS_REGEX)
                              ],
                              maxLength: SolarAppConstants.maxLength15,
                              labelText: translation(context).firmGstinNumber,
                              onTap: (){
                                if(mobileNumberController.text.isEmpty){
                                  setState(() {
                                    prefix = '';
                                  });
                                }
                                if(secondaryContactMobileNoController.text.isEmpty){
                                  setState(() {
                                    secondaryPrefix = '';
                                  });
                                }
                              },
                              errorText: errorTextGstNo.isNotEmpty ? errorTextGstNo : null,
                              hintText: translation(context).enterCustomerFirmGstinNumber,
                              onChanged: (value) {
                                var gstValidationResult = validateGstNo(gstinNumberController.text, context);
                                setState(() {
                                  isValidGstNo = gstValidationResult.value1;
                                  errorTextGstNo = gstValidationResult.value2;
                                });
                                checkTextFieldStatus();
                              },
                            ) : const SizedBox(height: 0),
                            selectedRadio == "commercial" ? const VerticalSpace(height: 24) : const SizedBox(height: 0),
                            FormFieldWidget(
                              controller: panNumberController,
                              inputFormatter: [
                                UpperCaseTextFormatter(),
                                FilteringTextInputFormatter.allow(SolarAppConstants.DIGITS_CHARS_REGEX)
                              ],
                              maxLength: SolarAppConstants.maxLength10,
                              textCapitalization: TextCapitalization.characters,
                              onTap: (){
                                if(mobileNumberController.text.isEmpty){
                                  setState(() {
                                    prefix = '';
                                  });
                                }
                                if(secondaryContactMobileNoController.text.isEmpty){
                                  setState(() {
                                    secondaryPrefix = '';
                                  });
                                }
                              },
                              labelText: selectedRadio == 'commercial' ? translation(context).firmPanNumber : translation(context).panNumber,
                              hintText: selectedRadio == 'commercial' ? translation(context).enterCustomerFirmPanNumber : translation(context).enterPanNumber,
                              errorText: errorTextPanNo.isNotEmpty ? errorTextPanNo : null,
                              onChanged: (value) {
                                var panValidationResult = validatePanNo(panNumberController.text, context);
                                setState(() {
                                  isValidPanNo = panValidationResult.value1;
                                  errorTextPanNo = panValidationResult.value2;
                                });
                                checkTextFieldStatus();
                              },
                            ),
                            const VerticalSpace(height: 24)
                          ],
                        ),
                      ),
                    ]
                ),
              ),
            ),
            const VerticalSpace(height: 12),
            Container(
              alignment: Alignment.bottomCenter,
              child: CommonButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerProjectDetails(
                      category: selectedRadio,
                      isAddSecondaryUserClicked: isAddSecondaryUserClicked,
                      companyName: companyNameController.text,
                      personName: personNameController.text,
                      mobileNumber: mobileNumberController.text,
                      emailId: emailIdController.text,
                      projectName: projectNameController.text,
                      pincode: pincodeController.text,
                      state: stateController.text,
                      city: cityController.text,
                      solutionType: solutionTypeController.text,
                      projectCapacity: projectCapacityController.text,
                      unit: unitController.text,
                      unitId: unitId,
                      projectCost: projectCostController.text,
                      preferredBank: preferredBankController.text,
                      preferredBankId: bankId,
                      gstinNumber: gstinNumberController.text,
                      panNumber: panNumberController.text,
                      secondaryContactName: secondaryContactNameController.text,
                      secondaryContactMobileNo: secondaryContactMobileNoController.text,
                      secondaryContactEmailId: secondaryContactEmailIdController.text,
                    )));
                  },
                  isEnabled: isSubmitEnabled,
                  containerBackgroundColor: AppColors.white,
                  buttonText: translation(context).submit),
            ),
          ],
        ),
      ),
    );
  }
}