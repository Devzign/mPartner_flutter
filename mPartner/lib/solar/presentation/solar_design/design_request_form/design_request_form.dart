import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../presentation/screens/base_screen.dart';
import '../../../../presentation/screens/network_management/dealer_electrician/components/heading_dealer.dart';
import '../../../../presentation/screens/userprofile/common_upload_bottom_sheet.dart';
import '../../../../presentation/screens/userprofile/user_profile_widget.dart';
import '../../../../presentation/widgets/calendar_widget/custom_calendar_view.dart';
import '../../../../presentation/widgets/common_button.dart';
import '../../../../presentation/widgets/horizontalspace/horizontal_space.dart';
import '../../../../presentation/widgets/verticalspace/vertical_space.dart';
import '../../../../state/contoller/app_setting_value_controller.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/common_methods.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/enums.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../../utils/textfield_input_handler.dart';
import '../../../data/models/design_request_model.dart';
import '../../../data/models/option.dart';
import '../../../data/models/state_model.dart';
import '../../../state/controller/solar_design_request_controller.dart';
import '../../../utils/solar_app_constants.dart';
import '../../common/heading_solar.dart';
import 'components/geocode_info_bottom_sheet.dart';
import 'components/textfield_design_form.dart';
import 'design_request_after_submit.dart';

class DesignRequestForm extends StatefulWidget {
  const DesignRequestForm({required this.solarModuleType, super.key});

  final SolarModuleType solarModuleType;

  @override
  State<DesignRequestForm> createState() {
    return _DesignRequestFormState();
  }
}

enum SolarModuleType { physical, digital }

enum Category { residential, commercial }

class _DesignRequestFormState extends BaseScreenState<DesignRequestForm> {
  late Widget _pdfPreviewWidget;
  late Key _pdfPreviewKey;
  bool showPdfPreview = false;
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
  TextEditingController energyConsumptionController = TextEditingController();
  TextEditingController monthlyBillController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  List<Option> solutionTypes = [];
  List<Option> averageEnergyValues = [];
  String selectedState = "";

  String companyNameErrorMessage = "";
  String contactPersonNameErrorMessage = "";
  String secondaryPersonNameErrorMessage = "";
  String projectNameErrorMessage = "";
  String projectAddressErrorMessage = "";
  String projectLandmarkErrorMessage = "";
  String avergeMonthlyBillErrorMessage = "";
  String geocodeErrorMessage = "";
  String pincodeErrorMessage = "";
  String emailErrorMessage = "";
  String secondaryEmailErrorMessage = "";
  String mobileErrorMessage = "";
  String secondaryMobileErrorMessage = "";
  String averageEnergyErrorMessage = "";
  bool enableSubmit = false;
  String? selectedImage;
  String selectedDateValue = "";
  DateTime initialSelectedDate = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day + 2);

  TextEditingController dateController = TextEditingController();
  SolarDesignRequestController solarDesignRequestController = Get.find();
  bool isMobileNumberPrefixEnable=false;
  bool isSecondaryMobileNumberPrefixEnable=false;
  bool isRupeeSymbolEnable=false;
  FocusNode mobileNumberFocus =FocusNode();
  FocusNode secondaryMobilNumberFocus =FocusNode();
  FocusNode monthlyBillFocus = FocusNode();

  var mobileNumberHint="";
  var secondaryMobileNumberHint="";
  var monthlyBillHint = "";

  AppSettingValueController appSettingValueController = Get.find();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        solutionTypes = solarDesignRequestController.solutionTypeListDesign;
      });
      if(solutionTypes.isEmpty){
        solarDesignRequestController.getSolutionTypes(SolutionTypes.SolarDesignSolutionType.name);
      }
      // final energyTypesResponse = await solarRemoteDataSource.getEnergyConsumptionTypes();
      // energyTypesResponse.fold(
      //   (l) => logger.e(l),
      //   (r) => setState(() {
      //         averageEnergyValues = r.data;
      // }));
      initialSelectedDate= DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day + appSettingValueController.solarRaiseRequestStartDateLimit);
      solarDesignRequestController.getStates();
      solarDesignRequestController.clearState();
    });
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
    energyConsumptionController.addListener(checkAllFields);
    monthlyBillController.addListener(checkAllFields);
    dateController.addListener(checkAllFields);

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

    
      monthlyBillFocus.addListener(() {
      setState(() {
        if(monthlyBillFocus.hasFocus){
          isRupeeSymbolEnable=true;
          monthlyBillHint="";
        }
        else{
          if(monthlyBillController.text.isEmpty) {
            isRupeeSymbolEnable=false;
            monthlyBillHint=translation(context).enterMonthlyBillAmountinRupees;
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

    super.initState();
  }

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
    energyConsumptionController.dispose();
    monthlyBillController.dispose();
    dateController.dispose();
    super.dispose();
  }

  void clearForm() {
    companyNameController.clear();
    companyNameErrorMessage = '';
    contactNameController.clear();
    contactPersonNameErrorMessage = '';
    contactNumberController.clear();
    mobileErrorMessage = '';
    contactEmailController.clear();
    emailErrorMessage = '';
    secondaryNameController.clear();
    secondaryPersonNameErrorMessage = '';
    secondaryNumberController.clear();
    secondaryMobileErrorMessage = '';
    secondaryEmailController.clear();
    secondaryEmailErrorMessage = '';
    projectNameController.clear();
    projectNameErrorMessage = '';
    projectAddressController.clear();
    projectAddressErrorMessage = '';
    projectLandmarkController.clear();
    projectLandmarkErrorMessage = '';
    projectLocationController.clear();
    geocodeErrorMessage = '';
    projectPincodeController.clear();
    pincodeErrorMessage = '';
    stateController.clear();
    cityController.clear();
    solutionTypeController.clear();
    energyConsumptionController.clear();
    averageEnergyErrorMessage = '';
    monthlyBillController.clear();
    avergeMonthlyBillErrorMessage = '';
    selectedImage = null;
    showPdfPreview = false;
    selectedDateValue = "";
    dateController.clear();
    solarDesignRequestController.updateSelectedState(SolarStateData(stateId: '', stateName: ''));
    enableSubmit=false;
    secondaryUserAdded=false;
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
        validateMobileNumber(contactNumberController.text, false) &&
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
        energyConsumptionController.text.trim().isNotEmpty &&
        validateEnergyConsumption(energyConsumptionController.text) && 
        monthlyBillController.text.trim().isNotEmpty &&
        validateMonthlyBill(monthlyBillController.text) &&
        ((widget.solarModuleType == SolarModuleType.physical &&
                selectedDateValue.isNotEmpty) ||
            (widget.solarModuleType == SolarModuleType.digital)) &&
        ((secondaryUserAdded &&
                secondaryNameController.text.trim().isNotEmpty &&
                validateName(secondaryNameController.text,
                    isSecondaryField: true) &&
                secondaryNumberController.text.trim().isNotEmpty &&
                validateMobileNumber(secondaryNumberController.text, true) &&
                secondaryEmailController.text.trim().isNotEmpty &&
                validateEmail(secondaryEmailController.text, true)) ||
            !secondaryUserAdded) &&
        selectedImage != null) {
      setState(() {
        enableSubmit = true;
      });
    } else {
      setState(() {
        enableSubmit = false;
      });
    }
  }

  DesignFormModel createModel() {
    return DesignFormModel(
        category: selectedCategory.name,
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
        averageEnergy: energyConsumptionController.text,
        monthlyBill: monthlyBillController.text,
        imagePath: selectedImage!,
        preferredDateOfVisit:
            (SolarModuleType.physical == widget.solarModuleType)
                ? selectedDateValue
                : "",
        solarModuleType: widget.solarModuleType.name);
  }

  bool validateName(String name,
      {bool? isSecondaryField,
      bool? isCompanyName,
      bool? isProjectName,
      bool? isProjectLandmark,
      bool? isProjectAddress}) {
    RegExp regex = SolarAppConstants.NAME_REGEX_1;
    if (isProjectAddress != null && isProjectAddress == true) {
      regex = SolarAppConstants.NAME_REGEX_2;
    }
    if (name.isEmpty) {
      setState(() {
        if (isSecondaryField != null && isSecondaryField == true) {
          secondaryPersonNameErrorMessage = "";
        } else if (isSecondaryField != null && isSecondaryField == false) {
          contactPersonNameErrorMessage = "";
        }
        if (isCompanyName != null && isCompanyName == true) {
          companyNameErrorMessage = "";
        }
        if (isProjectName != null && isProjectName == true) {
          projectNameErrorMessage = "";
        }
        if (isProjectLandmark != null && isProjectLandmark == true) {
          projectLandmarkErrorMessage = "";
        }
        if (isProjectAddress != null && isProjectAddress == true) {
          projectAddressErrorMessage = "";
        }
      });
      return false;
    } else if (!regex.hasMatch(name)) {
      setState(() {
        if (isSecondaryField != null && isSecondaryField == true) {
          secondaryPersonNameErrorMessage = translation(context).enterMin5Char;
        } else if (isSecondaryField != null && isSecondaryField == false) {
          contactPersonNameErrorMessage = translation(context).enterMin5Char;
        }
        if (isCompanyName != null && isCompanyName == true) {
          companyNameErrorMessage = translation(context).enterMin5Char;
        }
        if (isProjectName != null && isProjectName == true) {
          projectNameErrorMessage = translation(context).enterMin5Char;
        }
        if (isProjectLandmark != null && isProjectLandmark == true) {
          projectLandmarkErrorMessage = translation(context).enterMin5Char;
        }
        if (isProjectAddress != null && isProjectAddress == true) {
          projectAddressErrorMessage = translation(context).enterMin5Char;
        }
      });
      return false;
    } else {
      setState(() {
        if (isSecondaryField != null && isSecondaryField == true) {
          secondaryPersonNameErrorMessage = "";
        } else if (isSecondaryField != null && isSecondaryField == false) {
          contactPersonNameErrorMessage = "";
        }
        if (isCompanyName != null && isCompanyName == true) {
          companyNameErrorMessage = "";
        }
        if (isProjectName != null && isProjectName == true) {
          projectNameErrorMessage = "";
        }
        if (isProjectLandmark != null && isProjectLandmark == true) {
          projectLandmarkErrorMessage = "";
        }
        if (isProjectAddress != null && isProjectAddress == true) {
          projectAddressErrorMessage = "";
        }
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
    RegExp regex = SolarAppConstants.PINCODE_REGEX;
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
    } else {
      if (pinCode == '000000') {
        setState(() {
          pincodeErrorMessage = translation(context).invalidPincode;
        });
      } else {
        setState(() {
          pincodeErrorMessage = "";
        });
      }
      return true;
    }
  }

  bool validateEmail(String email, bool isSecondaryField) {
    RegExp regex = SolarAppConstants.EMAIL_REGEX;
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
          secondaryEmailErrorMessage = translation(context).enterAValidEmail;
        } else {
          emailErrorMessage = translation(context).enterAValidEmail;
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
    RegExp regex = SolarAppConstants.MOBILE_NUMBER_REGEX;
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
          secondaryMobileErrorMessage = translation(context).enterAvalidNumber;
        } else {
          mobileErrorMessage = translation(context).enterAvalidNumber;
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

  bool validateEnergyConsumption(String consumption) {
    RegExp regExp = SolarAppConstants.DIGITS_REGEX;

    if (consumption.isEmpty) {
      setState(() {
        averageEnergyErrorMessage = "";
      });
      return false;
    } else {
      if (!regExp.hasMatch(consumption)) {
        setState(() {
          averageEnergyErrorMessage = translation(context).invalidValue;
        });
        return false;
      } else {
        int value = int.tryParse(consumption.replaceAll(',', '')) ?? 0;
        if (value < 1 || value > 10000) {
          setState(() {
            averageEnergyErrorMessage =
                translation(context).energyConsumptionValidation;
          });
          return false;
        } else {
          setState(() {
            averageEnergyErrorMessage = "";
          });
          return true;
        }
      }
    }
  }

  bool validateMonthlyBill(String amount) {
    RegExp regExp = SolarAppConstants.DIGITS_REGEX;

    if (amount.isEmpty) {
      setState(() {
        avergeMonthlyBillErrorMessage = "";
      });
      return false;
    } else {
      if (!regExp.hasMatch(amount)) {
        setState(() {
          avergeMonthlyBillErrorMessage = translation(context).invalidValue;
        });
        return false;
      } else {
        int value = int.tryParse(amount.replaceAll(',', '')) ?? 0;
        if (value < 1000 || value > 15000000) {
          setState(() {
            avergeMonthlyBillErrorMessage =
                translation(context).billAmountValidation;
          });
          return false;
        } else {
          setState(() {
            avergeMonthlyBillErrorMessage = "";
          });
          return true;
        }
      }
    }
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
          logger.e("Error loading PDF: $error");
        },
        onPageError: (page, error) {
          logger.e("$page: $error");
        },
      );
    }
    else {
      return const Center(child: Icon(Icons.error));
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
    if(!isRupeeSymbolEnable){
      monthlyBillHint=translation(context).enterMonthlyBillAmountinRupees;
    }
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeadingSolar(
              heading: (widget.solarModuleType == SolarModuleType.physical)
                  ? translation(context).physicalVisitAndDesigning
                  : translation(context).digitalDesigning,
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
                                onTap: () => setState(() {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  // FocusScope.of(context).unfocus();
                                  selectedCategory = Category.commercial;
                                  initialSelectedDate = DateTime(
                                      DateTime.now().year, DateTime.now().month, DateTime.now().day + appSettingValueController.solarRaiseRequestStartDateLimit);
                                  isMobileNumberPrefixEnable=false;
                                  isSecondaryMobileNumberPrefixEnable=false;
                                  isRupeeSymbolEnable=false;
                                  clearForm();
                                }),
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
                                          onChanged: (value) {
                                            setState(() {
                                              FocusManager.instance.primaryFocus?.unfocus();
                                              // FocusScope.of(context).unfocus();
                                              selectedCategory = value!;
                                              initialSelectedDate = DateTime(
                                                  DateTime.now().year, DateTime.now().month, DateTime.now().day + appSettingValueController.solarRaiseRequestStartDateLimit);
                                              isMobileNumberPrefixEnable=false;
                                              isSecondaryMobileNumberPrefixEnable=false;
                                              isRupeeSymbolEnable=false;
                                              clearForm();
                                            });
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
                                onTap: () => setState(() {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  // FocusScope.of(context).unfocus();
                                  selectedCategory = Category.residential;
                                  initialSelectedDate = DateTime(
                                      DateTime.now().year, DateTime.now().month, DateTime.now().day + appSettingValueController.solarRaiseRequestStartDateLimit);
                                  isMobileNumberPrefixEnable=false;
                                  isSecondaryMobileNumberPrefixEnable=false;
                                  isRupeeSymbolEnable=false;
                                  clearForm();
                                }),
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
                                            () {
                                              FocusManager.instance.primaryFocus?.unfocus();
                                              // FocusScope.of(context).unfocus();
                                              selectedCategory = value!;
                                              initialSelectedDate = DateTime(
                                                  DateTime.now().year, DateTime.now().month, DateTime.now().day + appSettingValueController.solarRaiseRequestStartDateLimit);
                                              isMobileNumberPrefixEnable=false;
                                              isSecondaryMobileNumberPrefixEnable=false;
                                              isRupeeSymbolEnable=false;
                                              clearForm();
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
                          TextFieldDesignForm(
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
                              HandleBeginningInputFormatter(),
                              HandleMultipleDotsInputFormatter(),
                              FilteringTextInputFormatter.allow(
                                  AppConstants.VALIDATE_COMPANY_REGEX),
                            ],
                            maxLength: AppConstants.nameInputMaxLength,
                          ),
                        TextFieldDesignForm(
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
                            HandleBeginningInputFormatter(),
                            HandleMultipleDotsInputFormatter(),
                            FilteringTextInputFormatter.allow(
                                AppConstants.VALIDATE_NAME_REGEX),
                          ],
                          maxLength: AppConstants.nameInputMaxLength,
                        ),
                        TextFieldDesignForm(
                          context: context,
                          controller: contactNumberController,
                          keyboardType: TextInputType.number,
                          isMandatory: true,
                          errorText: mobileErrorMessage,
                          labelText:
                              translation(context).contactPersonMobileNumber,
                          hintText: mobileNumberHint,
                          onChangedFunction: (value) {
                            contactNumberController.text.replaceAll(".", "");
                            contactNumberController.text.replaceAll("-", "");
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
                        TextFieldDesignForm(
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
                            FilteringTextInputFormatter.deny(RegExp(r'[!#$%^&*(),?:{}|<>]')),
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
                                secondaryPersonNameErrorMessage = '';
                                secondaryEmailController.clear();
                                secondaryEmailErrorMessage = '';
                                secondaryNumberController.clear();
                                secondaryMobileErrorMessage = '';
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
                                      TextFieldDesignForm(
                                        context: context,
                                        controller: secondaryNameController,
                                        keyboardType: TextInputType.text,
                                        isMandatory: true,
                                        errorText:
                                            secondaryPersonNameErrorMessage,
                                        labelText: translation(context)
                                            .secondaryContactName,
                                        hintText: translation(context)
                                            .secondaryContactName,
                                        onChangedFunction: (value) {
                                          validateName(value,
                                              isSecondaryField: true);
                                        },
                                        inputFormatters: [
                                          HandleBeginningInputFormatter(),
                                          HandleMultipleDotsInputFormatter(),
                                          FilteringTextInputFormatter.allow(
                                              AppConstants.VALIDATE_NAME_REGEX),
                                        ],
                                        maxLength:
                                            AppConstants.nameInputMaxLength,
                                      ),
                                      TextFieldDesignForm(
                                        context: context,
                                        controller: secondaryNumberController,
                                        keyboardType: TextInputType.number,
                                        isMandatory: true,
                                        errorText: secondaryMobileErrorMessage,
                                        labelText: translation(context)
                                            .secondaryContactMobileNumber,
                                        hintText: secondaryMobileNumberHint,
                                        onChangedFunction: (value) {
                                          validateMobileNumber(value, true);
                                        },
                                        inputFormatters: [
                                          HandleFirstDigitInMobileTextFieldFormatter(),
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'[0-9]')),
                                        ],
                                        maxLength: 10,
                                        isMobileNumber: true,
                                        isSecondaryMobilePrefixEnabled:isSecondaryMobileNumberPrefixEnable ,
                                        focusNode: secondaryMobilNumberFocus
                                      ),
                                      TextFieldDesignForm(
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
                                          FilteringTextInputFormatter.deny(RegExp(r'[!#$%^&*(),?:{}|<>]')),
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
                        TextFieldDesignForm(
                          context: context,
                          controller: projectNameController,
                          keyboardType: TextInputType.text,
                          isMandatory: true,
                          labelText: translation(context).projectName,
                          hintText: translation(context).enterProjectName,
                          errorText: projectNameErrorMessage,
                          onChangedFunction: (value) {
                            validateName(value, isProjectName: true);
                          },
                          inputFormatters: [
                            HandleBeginningInputFormatter(),
                            HandleMultipleDotsInputFormatter(),
                            FilteringTextInputFormatter.allow(
                                SolarAppConstants.PROJECT_NAME_REGEX),
                          ],
                        ),
                        TextFieldDesignForm(
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
                        TextFieldDesignForm(
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
                            HandleBeginningInputFormatter(),
                            HandleMultipleDotsInputFormatter(),
                            FilteringTextInputFormatter.allow(
                                SolarAppConstants.PROJECT_LANDMARK_REGEX),
                          ],
                          maxLength: AppConstants.nameInputMaxLength,
                        ),
                        TextFieldDesignForm(
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
                                validateGeocode(value);
                              } else {
                                setState(() {
                                  geocodeErrorMessage = "";
                                });
                              }
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
                        TextFieldDesignForm(
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
                                SolarAppConstants.DIGITS_REGEX),
                          ],
                          maxLength: 6,
                        ),
                        TextFieldDesignForm(
                          context: context,
                          controller: stateController,
                          keyboardType: TextInputType.none,
                          isMandatory: true,
                          labelText: translation(context).state,
                          hintText: translation(context).selectState,
                          trailingIcon:
                              const Icon(Icons.keyboard_arrow_down_outlined),
                          onChangedFunction: (value) {},
                          inputFormatters: [],
                          readOnly: true,
                          isCityStateSelector: true,
                          cityStateEnum: CityState.State,
                          cityController: cityController,
                        ),
                        TextFieldDesignForm(
                          context: context,
                          controller: cityController,
                          keyboardType: TextInputType.none,
                          isMandatory: true,
                          labelText: translation(context).city,
                          hintText: translation(context).selectCity,
                          trailingIcon: Icon(
                            Icons.keyboard_arrow_down_outlined,
                            color: solarDesignRequestController
                                        .selectedState.value !=
                                    ''
                                ? AppColors.downArrowColor
                                : AppColors.disabledDownArrorwColor,
                          ),
                          onChangedFunction: (value) {},
                          inputFormatters: [],
                          readOnly: true,
                          isCityStateSelector: true,
                          cityStateEnum: CityState.City,
                          selectedState: stateController.text,
                        ),
                        TextFieldDesignForm(
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
                        TextFieldDesignForm(
                          context: context,
                          controller: energyConsumptionController,
                          keyboardType: TextInputType.number,
                          isMandatory: true,
                          labelText:
                              '${translation(context).averageEnergyConsumption}(kWh)',
                          hintText:
                              translation(context).enterEnergyConsumptioninkWh,
                          errorText: averageEnergyErrorMessage,
                          onChangedFunction: (value) {
                            // energyConsumptionController.text='${energyConsumptionController.text} kWh';
                            // energyConsumptionController.selection =
                            // TextSelection.collapsed(offset: energyConsumptionController.text.length - 4);
                            // if(energyConsumptionController.text==' kWh') {
                            //   energyConsumptionController.clear();
                            // }
                            validateEnergyConsumption(value);
                          },
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                                SolarAppConstants.DIGITS_REGEX),
                                CurrencyInputFormatter(),
                          ],
                        ),
                        // TextFieldDesignForm(
                        //   context: context,
                        //   controller: energyConsumptionController,
                        //   keyboardType: TextInputType.none,
                        //   isMandatory: true,
                        //   labelText: 'Average Energy Consumption',
                        //   hintText: 'Select Energy Consumption',
                        //   trailingIcon: const Icon(Icons.keyboard_arrow_down_outlined),
                        //   onChangedFunction: (value) {},
                        //   inputFormatters: [],
                        //   readOnly: true,
                        //   isAverageEnergySelector: true,
                        //   averageEnergyValues: averageEnergyValues,
                        // ),
                        TextFieldDesignForm(
                          context: context,
                          controller: monthlyBillController,
                          keyboardType: TextInputType.number,
                          isMandatory: true,
                          labelText: translation(context).averageMonthlyBill,
                          hintText: monthlyBillHint,
                          errorText: avergeMonthlyBillErrorMessage,
                          isRupeeSymbolEnabled: isRupeeSymbolEnable,
                          focusNode: monthlyBillFocus,
                          onChangedFunction: (value) {
                            print('isRupeeSymbolEnabled: $isRupeeSymbolEnable');
                            validateMonthlyBill(value);
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                SolarAppConstants.DIGITS_REGEX),
                            CurrencyInputFormatter(),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              translation(context).uploadLatestElectricityBill,
                              style: GoogleFonts.poppins(
                                color: AppColors.grayText,
                                fontSize: 12 * f,
                                fontWeight: FontWeight.w500,
                                height: 20 / 12,
                                letterSpacing: 0.1,
                              ),
                            ),
                            Text(
                              '*',
                              style: GoogleFonts.poppins(
                                color: AppColors.errorRed,
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
                          child: GestureDetector(
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              showUploadBottomSheet(
                                  context, translation(context).selectImage,
                                  (imagePath) async {
                                    if (imagePath.endsWith('.pdf')) {
                                      _pdfPreviewWidget = await getPdfPreview(imagePath!);
                                      setState(() {
                                        _pdfPreviewKey = UniqueKey();
                                        showPdfPreview = true;
                                        selectedImage = imagePath;
                                      });
                                    } else {
                                      setState(() {
                                        showPdfPreview = false;
                                        selectedImage = imagePath;
                                      });
                                    }
                                checkAllFields();
                                logger.d('selected image is $selectedImage');
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
                                      width: 1 * r, color: AppColors.white),
                                  borderRadius: BorderRadius.circular(4 * r),
                                ),
                              ),
                              child: (showPdfPreview == true)
                                  ? Stack(
                                    children: [
                                      Positioned(
                                        child: Padding(
                                            padding: EdgeInsets.fromLTRB(5 * w, 5 * h, 5 * w, 5 * h),
                                            child: KeyedSubtree(
                                              key: _pdfPreviewKey,
                                              child: _pdfPreviewWidget,
                                            )),
                                      ),
                                      Positioned(
                                        top: 20 * h,
                                        right: 20 * w,
                                        child: InkWell(
                                            onTap: () {
                                              FocusScope.of(context).unfocus();
                                              showUploadBottomSheet(
                                                  context, translation(context).selectImage,
                                                      (imagePath) async {
                                                    if (imagePath.endsWith('.pdf')) {
                                                      _pdfPreviewWidget = await getPdfPreview(imagePath!);
                                                      setState(() {
                                                        _pdfPreviewKey = UniqueKey();
                                                        showPdfPreview = true;
                                                        selectedImage = imagePath;
                                                      });
                                                    } else {
                                                      setState(() {
                                                        showPdfPreview = false;
                                                        selectedImage = imagePath;
                                                      });
                                                    }
                                                    checkAllFields();
                                                    logger.d('selected image is $selectedImage');
                                                  },
                                                  isAllowedPDFAndImage:true
                                              );
                                            },
                                            child: SvgPicture.asset(
                                                "assets/mpartner/network/image_edit.svg")),
                                      ),
                                    ],
                                  )
                                  : (selectedImage != null)
                                    ? Stack(
                                      children: [
                                        Positioned(
                                          child: Center(
                                            child: Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  5 * w, 5 * h, 5 * w, 5 * h),
                                              width: double.infinity,
                                              height: double.infinity,
                                              child: Image.file(
                                                File(selectedImage!),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 20 * h,
                                          right: 20 * w,
                                          child: InkWell(
                                              onTap: () {
                                                FocusScope.of(context).unfocus();
                                                showUploadBottomSheet(
                                                    context, translation(context).selectImage,
                                                        (imagePath) async {
                                                      if (imagePath.endsWith('.pdf')) {
                                                        _pdfPreviewWidget = await getPdfPreview(imagePath!);
                                                        setState(() {
                                                          _pdfPreviewKey = UniqueKey();
                                                          showPdfPreview = true;
                                                          selectedImage = imagePath;
                                                        });
                                                      } else {
                                                        setState(() {
                                                          showPdfPreview = false;
                                                          selectedImage = imagePath;
                                                        });
                                                      }
                                                      checkAllFields();
                                                      logger.d('selected image is $selectedImage');
                                                    },
                                                    isAllowedPDFAndImage:true
                                                );
                                              },
                                              child: SvgPicture.asset(
                                                  "assets/mpartner/network/image_edit.svg")),
                                        ),
                                      ],
                                    )
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.add,
                                          color: AppColors.lumiBluePrimary,
                                        ),
                                        Text(
                                          translation(context).addBill,
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
                        if (selectedImage != null)
                          const VerticalSpace(height: 8),
                        Text(
                          selectedImage != null
                              ? selectedImage!.split("/").last
                              : "",
                          style: GoogleFonts.poppins(
                            color: AppColors.grayText,
                            fontSize: 12 * f,
                            fontWeight: FontWeight.w500,
                            height: 16 / 12,
                            letterSpacing: 0.10,
                          ),
                        ),
                        if (selectedImage != null)
                          const VerticalSpace(height: 24),
                        if (SolarModuleType.physical == widget.solarModuleType)
                          Container(
                              height: 48 * h,
                              margin:
                                  EdgeInsets.only(top: 16 * h, bottom: 16 * h),
                              child: CustomCalendarView(
                                labelText:
                                    translation(context).preferredDateOfVisit,
                                hintText: translation(context).selectDateFormat,
                                icon: const Icon(
                                  Icons.calendar_month_outlined,
                                  color: AppColors.grey,
                                ),
                                calendarType:
                                    AppConstants.singleSelectionCalenderType,
                                dateFormat:
                                    SolarAppConstants.dateTimeFormatCalender,
                                errorText: "",
                                initialDateSelection: initialSelectedDate,
                                calendarStartDate:
                                    DateTime.now().add( Duration(days: appSettingValueController.solarRaiseRequestStartDateLimit)),
                                calendarEndDate: DateTime.now()
                                    .add( Duration(days: appSettingValueController.solarRaiseRequestEndDateLimit)),
                                singleDateEditController: dateController,
                                onDateSelected: (selectedDate) {
                                  logger.d("view1 $selectedDate");
                                  setState(() {
                                    selectedDateValue = selectedDate;
                                    initialSelectedDate =
                                        DateFormat("dd/MM/yyyy")
                                            .parse(selectedDate);
                                  });
                                  checkAllFields();
                                },
                                onDateRangeSelected: (startDate, endDate) {
                                  logger.d("view2 $startDate- $endDate");
                                },
                              )),
                        const VerticalSpace(height: 16),
                        CommonButton(
                          containerHeight: 48 * h,
                          onPressed: () {
                            DesignFormModel details = createModel();
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => DesignRequestAfterSubmit(
                                      designFormDetails: details,
                                      solarModuleType: widget.solarModuleType,
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

