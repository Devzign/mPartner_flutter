import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../../presentation/screens/base_screen.dart';
import '../../../../../presentation/screens/network_management/dealer_electrician/components/heading_dealer.dart';
import '../../../../../presentation/screens/userprofile/common_upload_bottom_sheet.dart';
import '../../../../../presentation/screens/userprofile/user_profile_widget.dart';
import '../../../../../presentation/widgets/calendar_widget/custom_calendar_view.dart';
import '../../../../../presentation/widgets/common_button.dart';
import '../../../../../presentation/widgets/horizontalspace/horizontal_space.dart';
import '../../../../../presentation/widgets/verticalspace/vertical_space.dart';
import '../../../../../state/contoller/app_setting_value_controller.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_constants.dart';
import '../../../../../utils/common_methods.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';
import '../../../../../utils/textfield_input_handler.dart';
import '../../../../data/models/option.dart';
import '../../../../state/controller/ProjectExecutionFormController.dart';
import '../../../../utils/solar_app_constants.dart';
import '../../../common/heading_solar.dart';
import '../../../solar_design/design_request_form/components/geocode_info_bottom_sheet.dart';
import '../../components/textfield_project_execution_form_widget.dart';
import '../../model/form_model.dart';
import '../../model/support_reason_model.dart';
import 'common_project_details_form_card.dart';

class CommonRaiseRequestForm extends StatefulWidget {
  final String typeValue;

  const CommonRaiseRequestForm({super.key, required this.typeValue});

  @override
  State<CommonRaiseRequestForm> createState() {
    return _CommonRaiseRequestFormState();
  }
}

enum Category { residential, commercial }

class _CommonRaiseRequestFormState
    extends BaseScreenState<CommonRaiseRequestForm> {
  ProjectExecutionFormController projectExecutionFormController = Get.find();
  AppSettingValueController appSettingValueController = Get.find();

  Category selectedCategory = Category.commercial;
  bool secondaryUserAdded = false;
  final GlobalKey<FormState> _designRequestFormKey = GlobalKey<FormState>();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController contactNameController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController contactEmailController = TextEditingController();
  TextEditingController secondaryNameController = TextEditingController();
  TextEditingController secondaryNumberController = TextEditingController();
  TextEditingController secondaryEmailController = TextEditingController();
  TextEditingController projectNameController = TextEditingController();
  TextEditingController projectAddressController = TextEditingController();
  TextEditingController projectLandmarkController = TextEditingController();
  TextEditingController projectLocationController = TextEditingController();
  TextEditingController projectPincodeController = TextEditingController();
  TextEditingController solutionTypeController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController supportReasonController = TextEditingController();
  TextEditingController subCategoryController = TextEditingController();
  TextEditingController preferredDateController = TextEditingController();

  List<Option> solutionTypes = [];
  List<SupportReason> supportReasonList = [];
  String? selectedState;
  String companyNameErrorMessage = "";
  String contactPersonNameErrorMessage = "";
  String secondaryPersonNameErrorMessage = "";
  String projectNameErrorMessage = "";
  String projectAddressErrorMessage = "";
  String projectLandmarkErrorMessage = "";
  String geocodeErrorMessage = "";
  String pincodeErrorMessage = "";
  String emailErrorMessage = "";
  String secondaryEmailErrorMessage = "";
  String mobileErrorMessage = "";
  String secondaryMobileErrorMessage = "";
  bool enableSubmit = false;
  bool isMobileNumberPrefixEnable=false;
  bool isSecondaryMobileNumberPrefixEnable=false;
  String? selectedFile;
  String selectedDateValue = "";
  DateTime initialSelectedDate =DateTime(DateTime.now().year,
      DateTime.now().month, DateTime.now().day + 2);

  FocusNode mobileNumberFocus =FocusNode();
  FocusNode secondaryMobilNumberFocus =FocusNode();

  var mobileNumberHint="";
  var secondaryMobileNumberHint="";
  bool isPDFView=false;
  Widget? pdfFileViewWidget;
  late Key _pdfPreviewKey;

  @override
  void initState() {
    super.initState();
    companyNameController.addListener(checkAllFields);
    contactNameController.addListener(checkAllFields);
    contactNumberController.addListener(checkAllFields);
    contactEmailController.addListener(checkAllFields);
    secondaryNameController.addListener(checkAllFields);
    secondaryNumberController.addListener(checkAllFields);
    secondaryEmailController.addListener(checkAllFields);
    projectNameController.addListener(checkAllFields);
    projectAddressController.addListener(checkAllFields);
    projectLandmarkController.addListener(checkAllFields);
    projectLocationController.addListener(checkAllFields);
    projectPincodeController.addListener(checkAllFields);
    stateController.addListener(checkAllFields);
    cityController.addListener(checkAllFields);
    solutionTypeController.addListener(checkAllFields);
    supportReasonController.addListener(checkAllFields);
    subCategoryController.addListener(checkAllFields);
    preferredDateController.addListener(checkAllFields);
    solutionTypes.clear();
    projectExecutionFormController.selectedSupportReason.value = "";
    selectedCategory = Category.commercial;
    getStateList();
    getSupportReason();
    getSolutionTypeList();
    projectExecutionFormController.selectedState.value="";

    initialSelectedDate =DateTime(DateTime.now().year,
        DateTime.now().month, DateTime.now().day + appSettingValueController.solarRaiseRequestStartDateLimit);

    mobileNumberFocus.addListener(() {
      setState(() {
        if(mobileNumberFocus.hasFocus){
          isMobileNumberPrefixEnable=true;
          mobileNumberHint="";
        }
        else{
          if(contactNumberController.text.isEmpty) {
              isMobileNumberPrefixEnable=false;
              mobileNumberHint=translation(context).enterMobileNumber;
          }
        }
      });

    });

    secondaryMobilNumberFocus.addListener(() {
      setState(() {
        if(secondaryMobilNumberFocus.hasFocus){
          isSecondaryMobileNumberPrefixEnable=true;
          secondaryMobileNumberHint="";
        }
        else{
          if(secondaryNumberController.text.isEmpty) {
            isSecondaryMobileNumberPrefixEnable=false;
            secondaryMobileNumberHint=translation(context)
                .enterSecondaryContactMobileNumber;
          }
        }
      });

    });
  }

  /* getSupportReason() async {
    await projectExecutionFormController.getReasonForSupport(
        widget.typeValue, Category.commercial);
    supportReasonList.clear();
    supportReasonList.addAll(projectExecutionFormController.supportReasonList);
    setState(() {});
  }*/

  @override
  void dispose() {
    companyNameController.dispose();
    contactNameController.dispose();
    contactNumberController.dispose();
    contactEmailController.dispose();
    secondaryNameController.dispose();
    secondaryNumberController.dispose();
    secondaryEmailController.dispose();
    projectNameController.dispose();
    projectAddressController.dispose();
    projectLandmarkController.dispose();
    projectLocationController.dispose();
    projectPincodeController.dispose();
    stateController.dispose();
    cityController.dispose();
    solutionTypeController.dispose();
    supportReasonController.dispose();
    subCategoryController.dispose();
    preferredDateController.dispose();
    super.dispose();
  }

  void checkAllFields() {
    if (((Category.commercial == selectedCategory &&
                (companyNameController.text.trim().isNotEmpty) &&
                validateName(companyNameController.text,
                    isCompanyName: true)) ||
            Category.residential == selectedCategory) &&
        contactNameController.text.trim().isNotEmpty &&
        validateName(contactNameController.text, isSecondaryField: false) &&
        contactNumberController.text.trim().isNotEmpty &&
        validateMobileNumber(
            contactNumberController.text, false) &&
        contactEmailController.text.trim().isNotEmpty &&
        validateEmail(contactEmailController.text, false) &&
        projectNameController.text.trim().isNotEmpty &&
        validateName(projectNameController.text, isProjectName: true) &&
        projectAddressController.text.trim().isNotEmpty &&
        validateName(projectAddressController.text, isProjectAddress: true) &&
        projectLandmarkController.text.trim().isNotEmpty &&
        validateName(projectLandmarkController.text, isProjectLandmark: true) &&
        projectLocationController.text.trim().isNotEmpty &&
        validateGeocode(projectLocationController.text) &&
        projectPincodeController.text.trim().isNotEmpty &&
        validatePinCode(projectPincodeController.text) &&
        stateController.text.trim().isNotEmpty &&
        cityController.text.trim().isNotEmpty &&
        solutionTypeController.text.trim().isNotEmpty &&
        supportReasonController.text.trim().isNotEmpty &&
        subCategoryController.text.trim().isNotEmpty &&
        preferredDateController.text.trim().isNotEmpty &&
        ((secondaryUserAdded &&
                secondaryNameController.text.trim().isNotEmpty &&
                validateName(secondaryNameController.text,
                    isSecondaryField: true) &&
                secondaryNumberController.text.trim().isNotEmpty &&
                validateMobileNumber(
                    secondaryNumberController.text, true) &&
                secondaryEmailController.text.trim().isNotEmpty &&
                validateEmail(secondaryEmailController.text, true)) ||
            !secondaryUserAdded)) {
      setState(() {
        enableSubmit = true;
      });
    } else {
      setState(() {
        enableSubmit = false;
      });
    }
  }

  FormModel createModel(
      int solutionTypeId, int supportReasonId, int subCategoryId) {
    var typeValue = widget.typeValue == SolarAppConstants.online
        ? "Online"
        : widget.typeValue == SolarAppConstants.onsite
            ? "Onsite"
            : "End-to-end";
    return FormModel(
        projectType: typeValue,
        category:(selectedCategory.name==Category.commercial.name)?translation(context).commercial: translation(context).residential,
        companyName: (selectedCategory == Category.commercial)
            ? companyNameController.text
            : "",
        contactPersonName: contactNameController.text,
        contactPersonNumber: contactNumberController.text,
        contactPersonEmailId: contactEmailController.text,
        secondaryName: (secondaryUserAdded) ? secondaryNameController.text : "",
        secondaryNumber:
            (secondaryUserAdded) ? secondaryNumberController.text : "",
        secondaryEmail:
            (secondaryUserAdded) ? secondaryEmailController.text : "",
        projectName: projectNameController.text,
        projectAddress: projectAddressController.text,
        projectLandmark: projectLandmarkController.text,
        projectLocation: projectLocationController.text,
        projectPincode: projectPincodeController.text,
        state: stateController.text,
        city: cityController.text,
        solutionType: solutionTypeController.text,
        supportReason: supportReasonController.text,
        subCategory: subCategoryController.text,
        solutionTypeId: solutionTypeId,
        supportReasonId: supportReasonId,
        subCategoryId: subCategoryId,
        preferredDate: preferredDateController.text,
        imagePath: selectedFile ?? "");
  }

  bool validateName(String name,
      {bool? isSecondaryField,
      bool? isCompanyName,
      bool? isProjectName,
      bool? isProjectLandmark,
      bool? isProjectAddress}) {
    RegExp regex = RegExp(r"^.{5,50}$");
    if (isProjectAddress != null && isProjectAddress == true) {
      regex = RegExp(r"^.{5,250}$");
    }
    if (name.isEmpty) {
      setState(() {
        if (isSecondaryField != null && isSecondaryField == true) {
          secondaryPersonNameErrorMessage = "";
        } else if (isSecondaryField != null && isSecondaryField == false) {
          contactPersonNameErrorMessage = "";
        }
        if (isCompanyName != null && isCompanyName == true)
          companyNameErrorMessage = "";
        if (isProjectName != null && isProjectName == true)
          projectNameErrorMessage = "";
        if (isProjectLandmark != null && isProjectLandmark == true)
          projectLandmarkErrorMessage = "";
        if (isProjectAddress != null && isProjectAddress == true)
          projectAddressErrorMessage = "";
      });
      return false;
    } else if (!regex.hasMatch(name)) {
      setState(() {
        if (isSecondaryField != null && isSecondaryField == true) {
          secondaryPersonNameErrorMessage = translation(context).enterMin5Char;
        } else if (isSecondaryField != null && isSecondaryField == false) {
          contactPersonNameErrorMessage = translation(context).enterMin5Char;
        }
        if (isCompanyName != null && isCompanyName == true)
          companyNameErrorMessage = translation(context).enterMin5Char;
        if (isProjectName != null && isProjectName == true)
          projectNameErrorMessage = translation(context).enterMin5Char;
        if (isProjectLandmark != null && isProjectLandmark == true)
          projectLandmarkErrorMessage = translation(context).enterMin5Char;
        if (isProjectAddress != null && isProjectAddress == true)
          projectAddressErrorMessage = translation(context).enterMin5Char;
      });
      return false;
    } else {
      setState(() {
        if (isSecondaryField != null && isSecondaryField == true) {
          secondaryPersonNameErrorMessage = "";
        } else if (isSecondaryField != null && isSecondaryField == false) {
          contactPersonNameErrorMessage = "";
        }
        if (isCompanyName != null && isCompanyName == true)
          companyNameErrorMessage = "";
        if (isProjectName != null && isProjectName == true)
          projectNameErrorMessage = "";
        if (isProjectLandmark != null && isProjectLandmark == true)
          projectLandmarkErrorMessage = "";
        if (isProjectAddress != null && isProjectAddress == true)
          projectAddressErrorMessage = "";
      });
      return true;
    }
  }

  bool validateGeocode(String geocode) {
    List<String> parts = geocode.split(',');
    String latitude = "", longitude = "";
    if (parts.length == 2) {
      latitude = removeExtraLeadingZeros(parts[0]);
      longitude = removeExtraLeadingZeros(parts[1]);

      RegExp regexForLat = SolarAppConstants.LATITUDE_REGEX;
      RegExp regexForLon = SolarAppConstants.LONGITUDE_REGEX;

      if (regexForLat.hasMatch(latitude) && regexForLon.hasMatch(longitude) && 
      double.parse(latitude).abs()<=90 && double.parse(longitude).abs()<=180) {
        setState(() {
          geocodeErrorMessage = "";
        });
        return true;
      } else {
        setState(() {
          geocodeErrorMessage = translation(context).invalidFormat;
        });
        return false;
      }
    } else {
      setState(() {
        geocodeErrorMessage = translation(context).invalidFormat;
      });
      return false;
    }
  }

  bool validatePinCode(String pinCode) {
    RegExp regex = RegExp(r'^[0-9]{6}$');
    if (pinCode.isEmpty) {
      setState(() {
        pincodeErrorMessage = "";
      });
      return false;
    } else if (!regex.hasMatch(pinCode)) {
      setState(() {
        pincodeErrorMessage = translation(context).invalidPincode;
      });
      return false;
    } else if (pinCode=="000000"){
      setState(() {
        pincodeErrorMessage = translation(context).invalidPincode;
      });
      return false;
    }
    else {
      setState(() {
        pincodeErrorMessage = "";
      });
      return true;
    }
  }

  bool validateEmail(String email, bool isSecondaryField) {
    RegExp regex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    if (email.isEmpty) {
      setState(() {
        if (isSecondaryField) {
          secondaryEmailErrorMessage = "";
        } else {
          emailErrorMessage = "";
        }
      });

      return false;
    } else if (!regex.hasMatch(email)) {
      setState(() {
        if (isSecondaryField) {
          secondaryEmailErrorMessage = translation(context).invalidEmailId;
        } else {
          emailErrorMessage = translation(context).invalidEmailId;
        }
      });

      return false;
    } else {
      setState(() {
        if (isSecondaryField) {
          secondaryEmailErrorMessage = "";
        } else {
          emailErrorMessage = "";
        }
      });
      return true;
    }
  }

  bool validateMobileNumber(String mobileNumber, bool isSecondaryField) {
    RegExp regex = RegExp(r'^[0-9]{10}$');
    if (mobileNumber.isEmpty) {
      setState(() {
        if (isSecondaryField) {
          secondaryMobileErrorMessage = "";
        } else {
          mobileErrorMessage = "";
        }
      });
      return false;
    } else if (!regex.hasMatch(mobileNumber)) {
      setState(() {
        if (isSecondaryField) {
          secondaryMobileErrorMessage =
              translation(context).validNumberError;
        } else {
          mobileErrorMessage = translation(context).validNumberError;
        }
      });
      return false;
    } else {
      setState(() {
        if (isSecondaryField) {
          secondaryMobileErrorMessage = "";
        } else {
          mobileErrorMessage = "";
        }
      });
      return true;
    }
  }

  @override
  Widget baseBody(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();

    if(!isMobileNumberPrefixEnable){
      mobileNumberHint=translation(context).enterMobileNumber;
    }
    if(!isSecondaryMobileNumberPrefixEnable){
      secondaryMobileNumberHint=translation(context)
          .enterSecondaryContactMobileNumber;
    }
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeadingSolar(
              heading: getTitle(widget.typeValue),
            ),
            UserProfileWidget(
              top: 8 * h,
              bottom: 28 * h,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24 * h),
                child: SingleChildScrollView(
                  child: Form(
                    key: _designRequestFormKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FormHeading(f),
                        const VerticalSpace(height: 16),
                        CategoryRadioHeading(f),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Flexible(
                              flex: 1,
                              child: GestureDetector(
                                onTap: () {
                                  FocusScope.of(context).unfocus();
                                  secondaryUserAdded = false;
                                  selectedCategory = Category.commercial;
                                  initialSelectedDate =DateTime(DateTime.now().year,
                                      DateTime.now().month, DateTime.now().day + appSettingValueController.solarRaiseRequestStartDateLimit);
                                  getSupportReason();
                                },
                                child: ListTile(
                                  horizontalTitleGap: 0,
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(translation(context).commercial),
                                  titleTextStyle: GoogleFonts.poppins(
                                    color: AppColors.darkText2,
                                    fontSize: 14 * f,
                                    fontWeight: FontWeight.w400,
                                    height: 20 / 14,
                                    letterSpacing: 0.25,
                                  ),
                                  leading: SizedBox(
                                    width: 32 * w,
                                    height: 32 * h,
                                    child: SizedBox(
                                      width: 13.33 * w,
                                      height: 13.33 * h,
                                      child: Radio<Category>(
                                          activeColor:
                                              AppColors.lumiBluePrimary,
                                          value: Category.commercial,
                                          groupValue: selectedCategory,
                                          onChanged: (value) async {
                                            FocusScope.of(context).unfocus();
                                            secondaryUserAdded = false;
                                            selectedCategory = value!;
                                            initialSelectedDate =DateTime(DateTime.now().year,
                                                DateTime.now().month, DateTime.now().day + appSettingValueController.solarRaiseRequestStartDateLimit);
                                            getSupportReason();
                                            checkAllFields();
                                          }),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: GestureDetector(
                                onTap: () {
                                  FocusScope.of(context).unfocus();
                                  secondaryUserAdded = false;
                                  selectedCategory = Category.residential;
                                  initialSelectedDate =DateTime(DateTime.now().year,
                                      DateTime.now().month, DateTime.now().day + appSettingValueController.solarRaiseRequestStartDateLimit);
                                  getSupportReason();
                                },
                                child: ListTile(
                                  horizontalTitleGap: 0,
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(translation(context).residential),
                                  titleTextStyle: GoogleFonts.poppins(
                                    color: AppColors.darkText2,
                                    fontSize: 14 * f,
                                    fontWeight: FontWeight.w400,
                                    height: 20 / 14,
                                    letterSpacing: 0.25,
                                  ),
                                  leading: SizedBox(
                                    width: 32 * w,
                                    height: 32 * h,
                                    child: SizedBox(
                                      width: 13.33 * w,
                                      height: 13.33 * h,
                                      child: Radio<Category>(
                                        activeColor: AppColors.lumiBluePrimary,
                                        value: Category.residential,
                                        groupValue: selectedCategory,
                                        onChanged: (value) {
                                          setState(
                                            () async {
                                              FocusScope.of(context).unfocus();
                                              secondaryUserAdded = false;
                                              selectedCategory = value!;
                                              initialSelectedDate =DateTime(DateTime.now().year,
                                                  DateTime.now().month, DateTime.now().day + appSettingValueController.solarRaiseRequestStartDateLimit);
                                              companyNameController.clear();
                                              getSupportReason();
                                            },
                                          );
                                          checkAllFields();
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const VerticalSpace(height: 12),
                        if (Category.commercial == selectedCategory)
                          TextFieldProjectExecutionForm(
                            context: context,
                            controller: companyNameController,
                            keyboardType: TextInputType.text,
                            isMandatory: true,
                            errorText: companyNameErrorMessage,
                            labelText: translation(context).companyName,
                            hintText:
                                translation(context).contactPersonFirmName,
                            onChangedFunction: (value) {
                              validateName(value, isCompanyName: true);
                            },
                            inputFormatters: <TextInputFormatter>[
                              HandleFirstSpaceAndDotInputFormatter(),
                              HandleMultipleDotsInputFormatter(),
                              FilteringTextInputFormatter.allow(
                                  AppConstants.VALIDATE_COMPANY_REGEX),
                            ],
                            maxLength: AppConstants.nameInputMaxLength,
                          ),
                        TextFieldProjectExecutionForm(
                          context: context,
                          controller: contactNameController,
                          keyboardType: TextInputType.text,
                          isMandatory: true,
                          errorText: contactPersonNameErrorMessage,
                          labelText: translation(context).contactPersonName,
                          hintText: translation(context).contactPersonName,
                          onChangedFunction: (value) {
                            validateName(value, isSecondaryField: false);
                          },
                          inputFormatters: [
                            HandleFirstSpaceAndDotInputFormatter(),
                            HandleMultipleDotsInputFormatter(),
                            FilteringTextInputFormatter.allow(
                                AppConstants.VALIDATE_NAME_REGEX),
                          ],
                          maxLength: AppConstants.nameInputMaxLength,
                        ),
                        TextFieldProjectExecutionForm(
                          context: context,
                          controller: contactNumberController,
                          keyboardType: TextInputType.number,
                          isMandatory: true,
                          errorText: mobileErrorMessage,
                          labelText:
                              translation(context).contactPersonMobileNumber,
                          hintText: mobileNumberHint,
                          onChangedFunction: (value) {
                            validateMobileNumber(value, false);
                          },
                          inputFormatters: [
                            HandleFirstDigitInMobileTextFieldFormatter(),
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          maxLength: 10,
                          isMobileNumber: true,
                          isMobilePrefixEnabled: isMobileNumberPrefixEnable,
                          focusNode:mobileNumberFocus
                        ),
                        TextFieldProjectExecutionForm(
                          context: context,
                          controller: contactEmailController,
                          keyboardType: TextInputType.emailAddress,
                          isMandatory: true,
                          labelText: translation(context).contactPersonEmailId,
                          hintText: translation(context).enterEmailId,
                          errorText: emailErrorMessage,
                          onChangedFunction: (value) {
                            validateEmail(value, false);
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.deny(RegExp('(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])')),
                            FilteringTextInputFormatter.deny(
                                RegExp(r'[!#$%^&*(),?:{}|<>]')),
                            HandleFirstCharacterEmailInputFormatter(),
                            HandleMultipleDotsInputFormatter(),
                            HandleMultipleCommasInputFormatter(),
                            HandleMultipleAtTheRateInputFormatter(),
                            HandleMultipleDollarInputFormatter(),
                            FilteringTextInputFormatter.deny(RegExp(r'\s')),
                          ],
                          maxLength: AppConstants.emailInputMaxLength,
                          bottomPadding: 0,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              secondaryUserAdded = !secondaryUserAdded;
                              if (secondaryUserAdded == false) {
                                secondaryNameController.clear();
                                secondaryEmailController.clear();
                                secondaryNumberController.clear();
                                secondaryEmailErrorMessage="";
                                secondaryMobileErrorMessage="";
                                secondaryPersonNameErrorMessage="";
                                isSecondaryMobileNumberPrefixEnable=false;
                              }
                              checkAllFields();
                            });
                          },
                          child: Container(
                            padding:
                                EdgeInsets.fromLTRB(2 * w, 24 * h, 0, 24 * h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Icon(
                                    (!secondaryUserAdded)
                                        ? Icons.add
                                        : Icons.remove,
                                    color: AppColors.lumiBluePrimary),
                                const HorizontalSpace(width: 8),
                                Text(
                                  (!secondaryUserAdded)
                                      ? translation(context).addSecondaryUser
                                      : translation(context)
                                          .removeSecondaryUser,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    color: AppColors.lumiBluePrimary,
                                    fontSize: 14 * f,
                                    fontWeight: FontWeight.w500,
                                    height: 20 / 14,
                                    letterSpacing: 0.1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        AnimatedSize(
                          duration: const Duration(milliseconds: 100),
                          curve: Curves.fastLinearToSlowEaseIn,
                          child: (!secondaryUserAdded)
                              ? const SizedBox()
                              : Padding(
                                  padding: EdgeInsets.only(top: 8 * h),
                                  child: Column(
                                    children: [
                                      TextFieldProjectExecutionForm(
                                        context: context,
                                        controller: secondaryNameController,
                                        keyboardType: TextInputType.text,
                                        isMandatory: true,
                                        errorText:
                                            secondaryPersonNameErrorMessage,
                                        labelText: translation(context)
                                            .secondaryContactName,
                                        hintText: translation(context)
                                            .enterSecondaryContactName,
                                        onChangedFunction: (value) {
                                          validateName(value,
                                              isSecondaryField: true);
                                        },
                                        inputFormatters: [
                                          HandleFirstSpaceAndDotInputFormatter(),
                                          HandleMultipleDotsInputFormatter(),
                                          FilteringTextInputFormatter.allow(
                                              AppConstants.VALIDATE_NAME_REGEX),
                                        ],
                                        maxLength:
                                            AppConstants.nameInputMaxLength,
                                      ),
                                      TextFieldProjectExecutionForm(
                                        context: context,
                                        controller: secondaryNumberController,
                                        keyboardType: TextInputType.number,
                                        isMandatory: true,
                                        errorText: secondaryMobileErrorMessage,
                                        labelText: translation(context)
                                            .secondaryContactMobile,
                                        hintText: secondaryMobileNumberHint,
                                        onChangedFunction: (value) {
                                          validateMobileNumber(
                                              value, true);
                                        },
                                        inputFormatters: [
                                          HandleFirstDigitInMobileTextFieldFormatter(),
                                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                        ],
                                        maxLength: 10,
                                        isMobileNumber: true,
                                        isSecondaryMobilePrefixEnabled:isSecondaryMobileNumberPrefixEnable ,
                                        focusNode: secondaryMobilNumberFocus,
                                      ),
                                      TextFieldProjectExecutionForm(
                                        context: context,
                                        controller: secondaryEmailController,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        isMandatory: true,
                                        errorText: secondaryEmailErrorMessage,
                                        labelText: translation(context)
                                            .secondaryContactEmailId,
                                        hintText: translation(context)
                                            .enterSecondaryContactEmailId,
                                        maxLength:
                                            AppConstants.emailInputMaxLength,
                                        onChangedFunction: (value) {
                                          validateEmail(value, true);
                                        },
                                        inputFormatters: [
                                          FilteringTextInputFormatter.deny(RegExp('(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])')),
                                          FilteringTextInputFormatter.deny(
                                              RegExp(r'[!#$%^&*(),?:{}|<>]')),
                                          HandleFirstCharacterEmailInputFormatter(),
                                          HandleMultipleDotsInputFormatter(),
                                          HandleMultipleCommasInputFormatter(),
                                          HandleMultipleAtTheRateInputFormatter(),
                                          HandleMultipleDollarInputFormatter(),
                                          FilteringTextInputFormatter.deny(
                                              RegExp(r'\s')),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                        TextFieldProjectExecutionForm(
                          context: context,
                          controller: projectNameController,
                          maxLength: SolarAppConstants.solarProjectNameInputMaxLength,
                          keyboardType: TextInputType.text,
                          isMandatory: true,
                          labelText: translation(context).projectName,
                          hintText: translation(context).enterProjectName,
                          errorText: projectNameErrorMessage,
                          onChangedFunction: (value) {
                            validateName(value, isProjectName: true);
                          },
                          inputFormatters: [
                            HandleFirstSpaceAndDotInputFormatter(),
                            HandleMultipleDotsInputFormatter(),
                            FilteringTextInputFormatter.allow(
                                SolarAppConstants.PROJECT_NAME_REGEX),
                          ],
                        ),
                        TextFieldProjectExecutionForm(
                          context: context,
                          controller: projectAddressController,
                          keyboardType: TextInputType.text,
                          isMandatory: true,
                          labelText: translation(context).projectAddress,
                          hintText: translation(context).enterAddress,
                          errorText: projectAddressErrorMessage,
                          onChangedFunction: (value) {
                            validateName(value, isProjectAddress: true);
                            // validateTextFields(value, projectAddressErrorMessage);
                          },
                          inputFormatters: [
                            HandleBeginningInputFormatter(),
                            HandleMultipleDotsInputFormatter(),
                            HandleMultipleCommasInputFormatter(),
                            HandleMultipleHyphensInputFormatter(),
                            FilteringTextInputFormatter.allow(
                                SolarAppConstants.PROJECT_ADDRESS_REGEX),
                          ],
                          maxLength:
                              SolarAppConstants.solarProjectAddressInputMaxLength,
                        ),
                        TextFieldProjectExecutionForm(
                          context: context,
                          controller: projectLandmarkController,
                          keyboardType: TextInputType.text,
                          isMandatory: true,
                          labelText: translation(context).projectLandmark,
                          hintText: translation(context).enterLandmark,
                          errorText: projectLandmarkErrorMessage,
                          onChangedFunction: (value) {
                            validateName(value, isProjectLandmark: true);
                          },
                          inputFormatters: [
                            HandleFirstSpaceAndDotInputFormatter(),
                            HandleMultipleDotsInputFormatter(),
                            FilteringTextInputFormatter.allow(
                                SolarAppConstants.PROJECT_LANDMARK_REGEX),
                          ],
                          maxLength: AppConstants.nameInputMaxLength,
                        ),
                        TextFieldProjectExecutionForm(
                            context: context,
                            controller: projectLocationController,
                            keyboardType: TextInputType.text,
                            isMandatory: true,
                            labelText:
                                translation(context).projectCurrentLocation,
                            hintText: translation(context)
                                .enterLocationGeoCoordinates,
                            errorText: geocodeErrorMessage,
                            onChangedFunction: (value) {
                              if (value.isNotEmpty) {
                                var isValid=validateGeocode(value);
                                if(isValid){
                                  setState(() {
                                    geocodeErrorMessage = "";
                                  });
                                }
                              }
                              else{
                                setState(() {
                                  geocodeErrorMessage = "";
                                });
                              }

                              //  projectLocationController.text=value.trim().replaceAll("..", ".");
                              //  projectLocationController.text=value.trim().replaceAll(",,", ",");

                            },
                            inputFormatters: [
                              HandleLatLngBeginningInputFormatter(),
                              HandleMultipleCommasInputFormatter(),
                              HandleMultipleDotsInputFormatter(),
                              LatLngTextInputFormatter(),
                            ],
                            trailingIcon: const Icon(
                              Icons.info_outline_rounded,
                              color: AppColors.downArrowColor,
                            ),
                            onIconPress: () => showGeocodeInfoBottomSheet(
                                context, h, w, f, r)),
                        TextFieldProjectExecutionForm(
                          context: context,
                          controller: projectPincodeController,
                          keyboardType: TextInputType.number,
                          isMandatory: true,
                          labelText: translation(context).projectPincode,
                          hintText: translation(context).enterPincode,
                          errorText: pincodeErrorMessage,
                          onChangedFunction: (value) {
                            validatePinCode(value);
                          },
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9]'),
                            ),
                            FilteringTextInputFormatter.deny(
                              RegExp(
                                  r'^0+'), //users can't type 0 at 1st position
                            ),
                          ],
                          maxLength: 6,
                        ),
                        TextFieldProjectExecutionForm(
                          context: context,
                          controller: stateController,
                          keyboardType: TextInputType.none,
                          isMandatory: true,
                          labelText: translation(context).state,
                          hintText: translation(context).selectState,
                          trailingIcon:
                              const Icon(Icons.keyboard_arrow_down_outlined),
                          onChangedFunction: (value) {
                            setState(() {

                            });
                          },
                          inputFormatters: [],
                          readOnly: true,
                          isCityStateSelector: true,
                          cityStateEnum: CityState.State,
                          cityController: cityController,
                        ),
                        TextFieldProjectExecutionForm(
                          context: context,
                          controller: cityController,
                          keyboardType: TextInputType.none,
                          isMandatory: true,
                          labelText: translation(context).city,
                          hintText: translation(context).selectCity,
                          trailingIcon:
                          Icon(Icons.keyboard_arrow_down_outlined,color: stateController.text.isNotEmpty?AppColors.downArrowColor:AppColors.disabledDownArrorwColor,),
                          onChangedFunction: (value) {},
                          inputFormatters: [],
                          readOnly: true,
                          isCityStateSelector: true,
                          cityStateEnum: CityState.City,
                          selectedState: stateController.text,
                        ),
                        TextFieldProjectExecutionForm(
                          context: context,
                          controller: solutionTypeController,
                          keyboardType: TextInputType.none,
                          isMandatory: true,
                          labelText: translation(context).solutionType,
                          hintText: translation(context).selectSolutionType,
                          trailingIcon:
                              const Icon(Icons.keyboard_arrow_down_outlined),
                          onChangedFunction: (value) {},
                          inputFormatters: [],
                          readOnly: true,
                          isSolutionTypeSelector: true,
                          solutionTypes: solutionTypes,
                        ),
                        TextFieldProjectExecutionForm(
                          context: context,
                          controller: supportReasonController,
                          subCategoryController: subCategoryController,
                          keyboardType: TextInputType.none,
                          isMandatory: true,
                          labelText: translation(context).reasonForSupport,
                          hintText: translation(context).selectReasonForSupport,
                          onChangedFunction: (value) {
                            setState(() {

                            });
                          },
                          inputFormatters: [],
                          readOnly: true,
                          trailingIcon:
                              Icon(Icons.keyboard_arrow_down_outlined),
                          isSupportReason: true,
                          supportReasonList: supportReasonList,
                        ),
                        TextFieldProjectExecutionForm(
                          context: context,
                          controller: subCategoryController,
                          keyboardType: TextInputType.none,
                          isMandatory: true,
                          labelText: translation(context).subCategory,
                          hintText: translation(context).selectSubCategory,
                          onChangedFunction: (value) {},
                          inputFormatters: [],
                          readOnly: true,
                          trailingIcon:
                          Icon(Icons.keyboard_arrow_down_outlined,color: supportReasonController.text.isNotEmpty?AppColors.downArrowColor:AppColors.disabledDownArrorwColor,),
                          isSubCategory: true,
                          supportReasonList: supportReasonList,
                        ),
                        Container(
                          height: 52 * h,
                          child: CustomCalendarView(
                            labelText: (widget.typeValue == "online")
                                ? translation(context)
                                    .preferredDateOfConsultation
                                : translation(context).preferredDateOfVisit,
                            hintText: "DD/MM/YYYY",
                            icon: Icon(
                              Icons.calendar_month_outlined,
                              color: AppColors.grey,
                            ),
                            calendarType:
                                AppConstants.singleSelectionCalenderType,
                            dateFormat: "dd/MM/yyyy",
                            errorText: "",
                            initialDateSelection: initialSelectedDate,
                            calendarStartDate: DateTime(DateTime.now().year,
                                DateTime.now().month, DateTime.now().day + appSettingValueController.solarRaiseRequestStartDateLimit),
                            calendarEndDate: DateTime(DateTime.now().year,
                                DateTime.now().month, DateTime.now().day + appSettingValueController.solarRaiseRequestEndDateLimit),
                            singleDateEditController: preferredDateController,
                            onDateSelected: (selectedDate) {
                              preferredDateController.text = selectedDate;
                              DateTime selectedDateObject =
                                  DateFormat("dd/MM/yyyy").parse(selectedDate);
                                initialSelectedDate = selectedDateObject;
                              // checkTextFieldStatus();
                            },
                            onDateRangeSelected: (startDate, endDate) {
                              print("view2 ${startDate}- ${endDate}");
                            },
                          ),
                        ),
                        SizedBox(
                          height: 16 * h,
                        ),
                        Row(
                          children: [
                            Text(
                              translation(context).uploadAnyDocument,
                              style: GoogleFonts.poppins(
                                color: AppColors.grayText,
                                fontSize: 12 * f,
                                fontWeight: FontWeight.w500,
                                height: 20 / 12,
                                letterSpacing: 0.1,
                              ),
                            ),
                          ],
                        ),
                        const VerticalSpace(height: 12),
                        DottedBorder(
                          color: AppColors.lumiBluePrimary,
                          strokeWidth: 1 * w,
                          borderType: BorderType.RRect,
                          radius: Radius.circular(4 * r),
                          dashPattern: [6 * r, 3 * r],
                          child: (selectedFile != null)
                              ? Container(
                              width: 175 * w,
                              height: 110 * h,
                              decoration: ShapeDecoration(
                                color: AppColors.lumiLight5,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      width: 1 * r, color: AppColors.white),
                                  borderRadius:
                                  BorderRadius.circular(4 * r),
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Container(
                                    padding: EdgeInsets.fromLTRB(
                                        5 * w, 5 * h, 5 * w, 5 * h),
                                    width: double.infinity,
                                    height: double.infinity,
                                    child: (isPDFView)?KeyedSubtree(
                                      key: _pdfPreviewKey,
                                      child: pdfFileViewWidget??Container(),
                                    ): Image.file(
                                      File(selectedFile!),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                      right: 0,
                                      top: 0,
                                      child: Container(
                                          height: 30 * h,
                                          width: 30 * w,
                                          padding: EdgeInsets.all(3 * r),
                                          margin: EdgeInsets.only(
                                              top: 10 * h, right: 10 * w),
                                          child: InkWell(
                                              onTap: () {
                                                showUploadBottomSheet(
                                                    context,
                                                    translation(context)
                                                        .selectImage,
                                                        (filePath) async{
                                                        final ext=  filePath.split(".").last;
                                                        if(ext=="pdf"){
                                                          selectedFile =
                                                              filePath;
                                                         pdfFileViewWidget= await getPdfPreview(selectedFile!);
                                                          setState(() {
                                                            _pdfPreviewKey = UniqueKey();
                                                            isPDFView=true;
                                                          });
                                                        }
                                                        else{
                                                          setState(() {
                                                            pdfFileViewWidget=null;
                                                            isPDFView=false;
                                                            selectedFile =
                                                                filePath;
                                                          });
                                                        }
                                                    },
                                                    isAllowedPDFAndImage:true
                                                    );
                                              },
                                              child: Container(
                                                  child: SvgPicture.asset(
                                                      "assets/mpartner/network/image_edit.svg"))))),
                                ],
                              ))
                              : GestureDetector(
                            onTap: () {
                              showUploadBottomSheet(context,
                                  translation(context).selectImage,
                                      (filePath) async {
                                    final ext=  filePath.split(".").last;
                                    if(ext=="pdf"){
                                      selectedFile =
                                          filePath;
                                      pdfFileViewWidget= await getPdfPreview(selectedFile!);
                                      setState(() {
                                        _pdfPreviewKey = UniqueKey();
                                        isPDFView=true;
                                      });
                                    }
                                    else{
                                      setState(() {
                                        pdfFileViewWidget=null;
                                        isPDFView=false;
                                        selectedFile =
                                            filePath;
                                      });
                                    }
                                     checkAllFields();
                                  },
                                  isAllowedPDFAndImage:true
                              );
                            },
                            child: Container(
                              width: 175 * w,
                              height: 110 * h,
                              decoration: ShapeDecoration(
                                color: AppColors.lumiLight5,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      width: 1 * r,
                                      color: AppColors.white),
                                  borderRadius:
                                  BorderRadius.circular(4 * r),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.add,
                                    color: AppColors.lumiBluePrimary,
                                  ),
                                  Text(
                                    translation(context).addDocument,
                                    style: GoogleFonts.poppins(
                                      color: AppColors.lumiBluePrimary,
                                      fontSize: 12 * f,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.50 * w,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const VerticalSpace(height: 8),
                        Text(
                          selectedFile != null
                              ? selectedFile!.split("/").last
                              : "",
                          style: GoogleFonts.poppins(
                            color: AppColors.grayText,
                            fontSize: 12 * f,
                            fontWeight: FontWeight.w500,
                            height: 16 / 12,
                            letterSpacing: 0.10,
                          ),
                        ),
                        const VerticalSpace(height: 40),
                        CommonButton(
                          containerHeight: 48 * h,
                          onPressed: () {
                            var solutionTypeId = 0;
                            var supportReasonId = 0;
                            var subCategoryId = 0;
                            solutionTypes.forEach((element) {
                              if (element.name == solutionTypeController.text) {
                                solutionTypeId = element.id;
                              }
                            });
                            supportReasonList.forEach((element) {
                              if (element.reason ==
                                  supportReasonController.text) {
                                supportReasonId = element.reasonId;
                                element.subCategories.forEach((data) {
                                  if (data.subCategory ==
                                      subCategoryController.text) {
                                    subCategoryId = data.subCategoryId;
                                  }
                                });
                              }
                            });

                            FormModel details = createModel(
                                solutionTypeId, supportReasonId, subCategoryId);
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ProjectDetailsFormCard(
                                      formDetails: details,
                                      typeValue: widget.typeValue,
                                    )));
                          },
                          isEnabled: enableSubmit,
                          buttonText: translation(context).submit,
                          backGroundColor: AppColors.lumiBluePrimary,
                          containerBackgroundColor: AppColors.white,
                          horizontalPadding: 0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Widget> getPdfPreview(String filePath) async {
    if(filePath.isPDFFileName){
      return PDFView(
        filePath: filePath,
        enableSwipe: false,
        swipeHorizontal: false,
        autoSpacing: false,
        pageFling: true,
        pageSnap: true,
        defaultPage: 0,
        fitPolicy: FitPolicy.WIDTH,
        onError: (error) {
          print("Error loading PDF: $error");
        },
        onPageError: (page, error) {
          print("$page: $error");
        },
      );
    }
    else {
      return const Center(child: Icon(Icons.error));
    }
  }

  getTitle(String typeValue) {
    if (typeValue == SolarAppConstants.online) {
      return translation(context).onlineGuidance;
    } else if (typeValue == SolarAppConstants.onsite) {
      return translation(context).onsiteGuidance;
    } else {
      return translation(context).endToEndDeployment;
    }
  }

  void getSupportReason() async {
    setState(() {
      clearAllFieldData();
    });
    projectExecutionFormController.selectedSupportReason.value = "";
    supportReasonController.text = "";
    subCategoryController.text = "";
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await projectExecutionFormController.getReasonForSupport(
          widget.typeValue, selectedCategory);
      supportReasonList.clear();
      supportReasonList.addAll(projectExecutionFormController.supportReasonList);
      setState(() {});
    });

  }

  void clearAllFieldData() {
    companyNameController.text = "";
    contactNameController.text = "";
    contactNumberController.text = "";
    contactEmailController.text = "";
    secondaryNameController.text = "";
    secondaryNumberController.text = "";
    secondaryEmailController.text = "";
    projectNameController.text = "";
    projectAddressController.text = "";
    projectLandmarkController.text = "";
    projectLocationController.text = "";
    projectPincodeController.text = "";
    stateController.text = "";
    cityController.text = "";
    solutionTypeController.text = "";
    supportReasonController.text = "";
    subCategoryController.text = "";
    preferredDateController.text = "";
    companyNameErrorMessage = "";
    contactPersonNameErrorMessage = "";
    secondaryPersonNameErrorMessage = "";
    projectNameErrorMessage = "";
    projectAddressErrorMessage = "";
    projectLandmarkErrorMessage = "";
    geocodeErrorMessage = "";
    pincodeErrorMessage = "";
    emailErrorMessage = "";
    secondaryEmailErrorMessage = "";
    mobileErrorMessage = "";
    secondaryMobileErrorMessage = "";
    selectedFile = null;
  }

  void getStateList() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      projectExecutionFormController.getStates();
    });
  }

  void getSolutionTypeList() async {
   WidgetsBinding.instance.addPostFrameCallback((_) async {
     await projectExecutionFormController.getSolutionTypes();
     solutionTypes.clear();
     solutionTypes.addAll(projectExecutionFormController.solutionTypeList);
     setState(() {

     });
   });

  }
}

class CategoryRadioHeading extends StatelessWidget {
  final double f;

  const CategoryRadioHeading(
    this.f, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          translation(context).projectType,
          style: GoogleFonts.poppins(
            fontSize: 14 * f,
            color: AppColors.black,
            height: 20 / 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1,
          ),
        ),
        /*Text(
          '*',
          style: GoogleFonts.poppins(
            fontSize: 14 * f,
            color: AppColors.errorRed,
            height: 20 / 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1,
          ),
        ),*/
      ],
    );
  }
}

class FormHeading extends StatelessWidget {
  final double f;

  const FormHeading(
    this.f, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      translation(context).addCustomerProjectDetails,
      style: GoogleFonts.poppins(
        fontSize: 16 * f,
        color: AppColors.darkText2,
        height: 20 / 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      ),
    );
  }
} 

