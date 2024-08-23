import 'dart:convert';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../data/datasource/mpartner_remote_data_source.dart';
import '../../../data/models/user_passport_upload_model.dart';
import '../../../data/models/user_profile_model.dart';
import '../../../services/services_locator.dart';
import '../../../state/contoller/user_data_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/displaymethods/display_methods.dart';
import '../../../utils/localdata/language_constants.dart';
import '../../../utils/routes/app_routes.dart';
import '../../../utils/textfield_input_handler.dart';
import '../../widgets/calendar_widget/custom_calendar_view.dart';
import '../../widgets/headers/header_widget_with_right_align_action_button.dart';
import '../../widgets/common_button.dart';
import '../../widgets/horizontalspace/horizontal_space.dart';
import '../../widgets/verticalspace/vertical_space.dart';
import '../base_screen.dart';
import 'common_upload_bottom_sheet.dart';
import 'components/form_field_widget.dart';
import 'components/gender_selection_list.dart';
import 'components/show_alert_bottom_sheet.dart';
import 'upperCaseFormatter.dart';
import 'user_profile.dart';
import 'user_profile_widget.dart';

class PassportUpload extends StatefulWidget {
  const PassportUpload({super.key});

  @override
  State<PassportUpload> createState() => _PassportUploadState();
}

class _PassportUploadState extends BaseScreenState<PassportUpload> {
  bool isPhotoClickedFront = false;
  String imagePathFront = '';
  bool isPhotoClickedBack = false;
  String imagePathBack = '';
  bool isSubmitEnabled = false;
  TextEditingController passportNoController = TextEditingController();
  TextEditingController nationalityController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController placeOfIssueController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
  TextEditingController placeOfBirthController = TextEditingController();
  TextEditingController dateOfIssueController = TextEditingController();
  TextEditingController dateOfExpiryController = TextEditingController();
  bool isValidPassNo = false;
  String errorTextPassNo = '';
  bool isValidNationality = false,
      isValidFirstName = false,
      isValidLastName = false,
      isValidPlaceOfIssue = false,
      isValidPlaceOfBirth = false;
  String errorTextNationality = '',
      errorTextFirstName = '',
      errorTextLastName = '',
      errorTextPlaceOfIssue = '',
      errorTextPlaceOfBirth = '';
  UserDataController controller = Get.find();
  var userUploadPassportOutput = <UserPassportUploadModel>[];
  DateTime initialSelectedDate = DateTime(
      DateTime.now().year - 18, DateTime.now().month, DateTime.now().day);

  postUserPanDetails(
      String passportNo,
      String nationality,
      String gender,
      String firstName,
      String lastName,
      String placeOfIssue,
      String dateOfBirth,
      String birthPlace,
      String issueDate,
      String expiryDate,
      String imagePathFront,
      String imagePathBack) async {
    try {
      BaseMPartnerRemoteDataSource baseMPartnerRemoteDataSource =
          sl<BaseMPartnerRemoteDataSource>();
      final result = await baseMPartnerRemoteDataSource.userPassportUpload(
          passportNo,
          nationality,
          gender,
          firstName,
          lastName,
          placeOfIssue,
          dateOfBirth,
          birthPlace,
          issueDate,
          expiryDate,
          imagePathFront,
          imagePathBack);
      result.fold((l) {
        print("Error: $l");
      }, (r) async {
        if (r.status == "200") {
          userUploadPassportOutput.clear();
          userUploadPassportOutput.add(r);
          final getUserProfileResult =
              await baseMPartnerRemoteDataSource.getUserProfile();
          getUserProfileResult.fold(
            (l) {
              print("Error: $l");
            },
            (r) async {
              final List<UserProfile> userProfileData = [];
              userProfileData.addAll(r);
              if(userProfileData.isNotEmpty && controller.isPrimaryNumberLogin){
                if(userProfileData[0].phone.isNotEmpty){
                  logger.d("[userProfileData[0].phone passport] ::  ${userProfileData[0].phone}");
                  controller.updatePhoneNumber(userProfileData[0].phone);
                }
              }
              final userProfileJson = jsonEncode(userProfileData);
              controller.updateUserProfile(userProfileJson);
            },
          );
        } else {
          print("Error PP upload");
        }
      });
    } catch (e) {
      print("Error Captured: ${e}");
    }
  }

  void checkTextFieldStatus() {
    setState(() {
      isSubmitEnabled = passportNoController.text.isNotEmpty &&
          nationalityController.text.isNotEmpty &&
          genderController.text.isNotEmpty &&
          firstNameController.text.isNotEmpty &&
          lastNameController.text.isNotEmpty &&
          placeOfIssueController.text.isNotEmpty &&
          dateOfBirthController.text.isNotEmpty &&
          placeOfBirthController.text.isNotEmpty &&
          dateOfIssueController.text.isNotEmpty &&
          dateOfExpiryController.text.isNotEmpty &&
          isPhotoClickedFront &&
          isPhotoClickedBack &&
          isValidPassNo &&
          isValidNationality &&
          isValidFirstName &&
          isValidLastName &&
          isValidPlaceOfIssue &&
          isValidPlaceOfBirth;
    });
  }

  void validatePassportNo(String passportNo) {
    RegExp regex = RegExp(r'^(?!^0+$)[A-Z0-9]{8,12}$');
    if (passportNo.isEmpty) {
      setState(() {
        isValidPassNo = false;
        errorTextPassNo = "";
      });
    } else if (!regex.hasMatch(passportNo)) {
      setState(() {
        isValidPassNo = false;
        errorTextPassNo = translation(context).passportValidation;
      });
    } else {
      setState(() {
        isValidPassNo = true;
        errorTextPassNo = "";
      });
    }
  }

  void validateField(TextEditingController controller, String field) {
    setState(() {
      switch (field) {
        case 'nationality':
          RegExp regex = AppConstants.VALIDATE_ALPHABETS_REGEX;
          bool isEmpty = controller.text.isEmpty;
          bool hasMatch = regex.hasMatch(controller.text);
          isValidNationality = isEmpty || hasMatch;
          errorTextNationality = isEmpty
              ? ''
              : !hasMatch
                  ? translation(context).fieldCantContainNoOrSpecialCharacters
                  : '';
          break;
        case 'firstName':
          RegExp regex = AppConstants.VALIDATE_NAME_REGEX;
          bool isEmpty = controller.text.isEmpty;
          bool hasMatch = regex.hasMatch(controller.text);
          isValidFirstName = isEmpty || hasMatch;
          errorTextFirstName = isEmpty
              ? ''
              : !hasMatch
                  ? translation(context).fieldCantContainNoOrSpecialCharacters
                  : '';
          break;
        case 'lastName':
          RegExp regex = AppConstants.VALIDATE_NAME_REGEX;
          bool isEmpty = controller.text.isEmpty;
          bool hasMatch = regex.hasMatch(controller.text);
          isValidLastName = isEmpty || hasMatch;
          errorTextLastName = isEmpty
              ? ''
              : !hasMatch
                  ? translation(context).fieldCantContainNoOrSpecialCharacters
                  : '';
          break;
        case 'placeOfIssue':
          RegExp regex = AppConstants.VLIDATE_PLACE_REGEX;
          bool isEmpty = controller.text.isEmpty;
          bool hasMatch = regex.hasMatch(controller.text);
          isValidPlaceOfIssue = isEmpty || hasMatch;
          errorTextPlaceOfIssue = isEmpty
              ? ''
              : !hasMatch
                  ? translation(context).fieldCantContainNoOrSpecialCharacters
                  : '';
          break;
        case 'placeOfBirth':
          RegExp regex = AppConstants.VLIDATE_PLACE_REGEX;
          bool isEmpty = controller.text.isEmpty;
          bool hasMatch = regex.hasMatch(controller.text);
          isValidPlaceOfBirth = isEmpty || hasMatch;
          errorTextPlaceOfBirth = isEmpty
              ? ''
              : !hasMatch
                  ? translation(context).fieldCantContainNoOrSpecialCharacters
                  : '';
          break;
        default:
          break;
      }
    });
  }

  @override
  Widget baseBody(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double textFontMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();
    double pixelMultiplier =
        DisplayMethods(context: context).getPixelMultiplier();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: Column(
                children: [
                  HeaderWidgetWithRightAlignActionButton(text: translation(context).passport),
                  UserProfileWidget(top: 8*variablePixelHeight),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  left: 24 * variablePixelWidth,
                                  right: 24 * variablePixelWidth),
                              child: Text(
                                translation(context).passportDetails,
                                style: GoogleFonts.poppins(
                                  color: AppColors.darkText2,
                                  fontSize: 16 * textFontMultiplier,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.10,
                                ),
                              ),
                            ),
                            const VerticalSpace(height: 20),
                            Container(
                              margin: EdgeInsets.only(
                                  left: 24 * variablePixelWidth,
                                  right: 24 * variablePixelWidth),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FormFieldWidget(
                                    controller: passportNoController,
                                    inputFormatter: [
                                      UpperCaseTextFormatter(),
                                      FilteringTextInputFormatter.allow(
                                          RegExp("[0-9a-zA-Z]"))
                                    ],
                                    textCapitalization:
                                        TextCapitalization.characters,
                                    labelText: translation(context).passportNo,
                                    maxLength: 12,
                                    hintText:
                                        translation(context).enterYourPassNo,
                                    errorText: errorTextPassNo.isNotEmpty
                                        ? errorTextPassNo
                                        : null,
                                    onChanged: (value) {
                                      validatePassportNo(
                                          passportNoController.text);
                                      checkTextFieldStatus();
                                    },
                                  ),
                                  const VerticalSpace(height: 24),
                                  FormFieldWidget(
                                    controller: nationalityController,
                                    inputFormatter: [
                                      FilteringTextInputFormatter.allow(
                                          AppConstants.VALIDATE_ALPHABETS_REGEX)
                                    ],
                                    textCapitalization:
                                        TextCapitalization.words,
                                    labelText: translation(context).nationality,
                                    hintText:
                                        translation(context).enterNationality,
                                    keyboardType: TextInputType.text,
                                    maxLength: 50,
                                    errorText: errorTextNationality.isNotEmpty
                                        ? errorTextNationality
                                        : null,
                                    onChanged: (value) {
                                      validateField(
                                          nationalityController, 'nationality');
                                      checkTextFieldStatus();
                                    },
                                  ),
                                  const VerticalSpace(height: 24),
                                  FormFieldWidget(
                                    controller: genderController,
                                    labelText: translation(context).gender,
                                    hintText: translation(context).select,
                                    readOnly: true,
                                    suffixIcon: Icons.keyboard_arrow_down,
                                    suffixIconColor: AppColors.downArrowColor,
                                    onSuffixPress: () {
                                      selectGenderBottomSheet(context,
                                          (String selectedGender) {
                                        genderController.text = selectedGender;
                                      });
                                    },
                                    onChanged: (value) {
                                      checkTextFieldStatus();
                                    },
                                  ),
                                  const VerticalSpace(height: 24),
                                  FormFieldWidget(
                                    controller: firstNameController,
                                    labelText: translation(context).firstName,
                                    hintText:
                                        translation(context).enterYourFirstName,
                                    inputFormatter: [
                                      HandleFirstSpaceAndDotInputFormatter(),
                                      HandleMultipleDotsInputFormatter(),
                                      FilteringTextInputFormatter.allow(
                                          AppConstants.VALIDATE_NAME_REGEX)
                                    ],
                                    textCapitalization:
                                        TextCapitalization.words,
                                    maxLength: 50,
                                    keyboardType: TextInputType.text,
                                    errorText: errorTextFirstName.isNotEmpty
                                        ? errorTextFirstName
                                        : null,
                                    onChanged: (value) {
                                      validateField(
                                          firstNameController, 'firstName');
                                      checkTextFieldStatus();
                                    },
                                  ),
                                  const VerticalSpace(height: 24),
                                  FormFieldWidget(
                                    controller: lastNameController,
                                    labelText: translation(context).lastName,
                                    hintText:
                                        translation(context).enterYourLastName,
                                    inputFormatter: [
                                      HandleFirstSpaceAndDotInputFormatter(),
                                      HandleMultipleDotsInputFormatter(),
                                      FilteringTextInputFormatter.allow(
                                          AppConstants.VALIDATE_NAME_REGEX)
                                    ],
                                    textCapitalization:
                                        TextCapitalization.words,
                                    maxLength: 50,
                                    keyboardType: TextInputType.text,
                                    errorText: errorTextLastName.isNotEmpty
                                        ? errorTextLastName
                                        : null,
                                    onChanged: (value) {
                                      validateField(
                                          lastNameController, 'lastName');
                                      checkTextFieldStatus();
                                    },
                                  ),
                                  const VerticalSpace(height: 24),
                                  FormFieldWidget(
                                    controller: placeOfIssueController,
                                    labelText:
                                        translation(context).placeOfIssue,
                                    hintText:
                                        translation(context).enterPlaceOfIssue,
                                    inputFormatter: [
                                      HandlePlaceInputFormatter(),
                                      FilteringTextInputFormatter.allow(
                                        AppConstants.VLIDATE_PLACE_REGEX,
                                      ),
                                    ],
                                    textCapitalization:
                                        TextCapitalization.words,
                                    maxLength: 50,
                                    keyboardType: TextInputType.text,
                                    errorText: errorTextPlaceOfIssue.isNotEmpty
                                        ? errorTextPlaceOfIssue
                                        : null,
                                    onChanged: (value) {
                                      validateField(placeOfIssueController,
                                          'placeOfIssue');
                                      checkTextFieldStatus();
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const VerticalSpace(height: 24),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        width: 167 * variablePixelWidth,
                                        height: 50 * variablePixelHeight,
                                        margin: EdgeInsets.only(
                                            left: 24 * variablePixelWidth),
                                        child: CustomCalendarView(
                                          labelText: translation(context).dob,
                                          hintText: translation(context)
                                              .selectDateFormat,
                                          icon: Icon(
                                            Icons.calendar_month_outlined,
                                            color: AppColors.grey,
                                          ),
                                          calendarType: AppConstants
                                              .singleSelectionCalenderType,
                                          dateFormat: "dd/MM/yyyy",
                                          initialDateSelection: DateTime(
                                              DateTime.now().year - 18,
                                              DateTime.now().month,
                                              DateTime.now().day),
                                          errorText: "",
                                          calendarStartDate:
                                              DateTime(1950, 1, 1),
                                          calendarEndDate: DateTime(
                                              DateTime.now().year - 18,
                                              DateTime.now().month,
                                              DateTime.now().day),
                                          singleDateEditController:
                                              dateOfBirthController,
                                          onDateSelected: (selectedDate) {
                                            print("view1 ${selectedDate}");
                                            dateOfBirthController.text =
                                                selectedDate;
                                            DateTime selectedDateObject =
                                                DateFormat("dd/MM/yyyy")
                                                    .parse(selectedDate);
                                            initialSelectedDate =
                                                selectedDateObject;
                                            checkTextFieldStatus();
                                          },
                                          onDateRangeSelected:
                                              (startDate, endDate) {
                                            print(
                                                "view2 ${startDate}- ${endDate}");
                                          },
                                        ),
                                      ),
                                    ),
                                    const HorizontalSpace(width: 12),
                                    Expanded(
                                      child: Container(
                                        width: 167 * variablePixelWidth,
                                        margin: EdgeInsets.only(
                                            right: 24 * variablePixelWidth),
                                        child: FormFieldWidget(
                                          controller: placeOfBirthController,
                                          labelText:
                                              translation(context).placeOfBirth,
                                          hintText:
                                              translation(context).enterPlace,
                                          inputFormatter: [
                                            HandlePlaceInputFormatter(),
                                            FilteringTextInputFormatter.allow(
                                              AppConstants.VLIDATE_PLACE_REGEX,
                                            ),
                                          ],
                                          textCapitalization:
                                              TextCapitalization.words,
                                          maxLength: 50,
                                          keyboardType: TextInputType.text,
                                          errorText:
                                              errorTextPlaceOfBirth.isNotEmpty
                                                  ? errorTextPlaceOfBirth
                                                  : null,
                                          onChanged: (value) {
                                            validateField(
                                                placeOfBirthController,
                                                'placeOfBirth');
                                            checkTextFieldStatus();
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const VerticalSpace(height: 24),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                          width: 167 * variablePixelWidth,
                                          height: 50 * variablePixelHeight,
                                          margin: EdgeInsets.only(
                                              left: 24 * variablePixelWidth),
                                          child: CustomCalendarView(
                                            labelText: translation(context)
                                                .dateOfIssue,
                                            hintText: translation(context)
                                                .selectDateFormat,
                                            icon: Icon(
                                              Icons.calendar_month_outlined,
                                              color: AppColors.grey,
                                            ),
                                            calendarType: AppConstants
                                                .singleSelectionCalenderType,
                                            dateFormat: "dd/MM/yyyy",
                                            initialDateSelection:
                                                DateTime.now(),
                                            errorText: "",
                                            calendarStartDate:
                                                DateTime(1950, 1, 1),
                                            calendarEndDate: DateTime.now(),
                                            singleDateEditController:
                                                dateOfIssueController,
                                            onDateSelected: (selectedDate) {
                                              print("view1 ${selectedDate}");
                                              dateOfIssueController.text =
                                                  selectedDate;
                                              DateTime selectedDateObject =
                                                  DateFormat("dd/MM/yyyy")
                                                      .parse(selectedDate);
                                              initialSelectedDate =
                                                  selectedDateObject;
                                              checkTextFieldStatus();
                                            },
                                            onDateRangeSelected:
                                                (startDate, endDate) {
                                              print(
                                                  "view2 ${startDate}- ${endDate}");
                                            },
                                          )),
                                    ),
                                    const HorizontalSpace(width: 12),
                                    Expanded(
                                      child: Container(
                                          width: 167 * variablePixelWidth,
                                          height: 50 * variablePixelHeight,
                                          margin: EdgeInsets.only(
                                              right: 24 * variablePixelWidth),
                                          child: CustomCalendarView(
                                            labelText: translation(context)
                                                .dateOfExpiry,
                                            hintText: translation(context)
                                                .selectDateFormat,
                                            icon: Icon(
                                              Icons.calendar_month_outlined,
                                              color: AppColors.grey,
                                            ),
                                            calendarType: AppConstants
                                                .singleSelectionCalenderType,
                                            dateFormat: "dd/MM/yyyy",
                                            errorText: "",
                                            initialDateSelection: DateTime(
                                                DateTime.now().year,
                                                DateTime.now().month,
                                                DateTime.now().day + 1),
                                            calendarStartDate: DateTime(
                                                DateTime.now().year,
                                                DateTime.now().month,
                                                DateTime.now().day + 1),
                                            calendarEndDate:
                                                DateTime(2050, 12, 31),
                                            singleDateEditController:
                                                dateOfExpiryController,
                                            onDateSelected: (selectedDate) {
                                              print("view1 ${selectedDate}");
                                              dateOfExpiryController.text =
                                                  selectedDate;
                                              DateTime selectedDateObject =
                                                  DateFormat("dd/MM/yyyy")
                                                      .parse(selectedDate);
                                              initialSelectedDate =
                                                  selectedDateObject;
                                              checkTextFieldStatus();
                                            },
                                            onDateRangeSelected:
                                                (startDate, endDate) {
                                              print(
                                                  "view2 ${startDate}- ${endDate}");
                                            },
                                          )),
                                    ),
                                  ],
                                ),
                                const VerticalSpace(height: 24),
                                Container(
                                  margin: EdgeInsets.only(
                                      left: 24 * variablePixelWidth,
                                      right: 24 * variablePixelWidth),
                                  child: Text(
                                    translation(context).uploadPassport,
                                    style: GoogleFonts.poppins(
                                      color: AppColors.hintColor,
                                      fontSize: 12 * textFontMultiplier,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.10,
                                    ),
                                  ),
                                ),
                                const VerticalSpace(height: 16),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: 24 * variablePixelWidth),
                                            height: 108 * variablePixelHeight,
                                            width: 167 * variablePixelWidth,
                                            color: AppColors.lumiLight5,
                                            child: Stack(
                                              children: [
                                                DottedBorder(
                                                  color:
                                                      AppColors.lumiBluePrimary,
                                                  strokeWidth:
                                                      1 * variablePixelWidth,
                                                  borderType: BorderType.RRect,
                                                  radius: Radius.circular(
                                                      4 * pixelMultiplier),
                                                  dashPattern: [6, 3],
                                                  child: Container(),
                                                ),
                                                !isPhotoClickedFront
                                                    ? Positioned(
                                                        child: Center(
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              IconButton(
                                                                icon: Icon(
                                                                  Icons.add,
                                                                  size: 24 *
                                                                      pixelMultiplier,
                                                                  color: AppColors
                                                                      .lumiBluePrimary,
                                                                ),
                                                                onPressed: () {
                                                                  showUploadBottomSheet(
                                                                      context,
                                                                      translation(
                                                                              context)
                                                                          .uploadPassportFront,
                                                                      (String
                                                                          imageCaptured) {
                                                                    setState(
                                                                        () {
                                                                      imagePathFront =
                                                                          imageCaptured;
                                                                    });
                                                                    if (imagePathFront
                                                                        .isNotEmpty) {
                                                                      isPhotoClickedFront =
                                                                          true;
                                                                      checkTextFieldStatus();
                                                                    }
                                                                  });
                                                                },
                                                              ),
                                                              Text(
                                                                translation(
                                                                        context)
                                                                    .addFrontImage,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    GoogleFonts
                                                                        .poppins(
                                                                  color: AppColors
                                                                      .lumiBluePrimary,
                                                                  fontSize: 12 *
                                                                      textFontMultiplier,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  letterSpacing:
                                                                      0.50,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    : Stack(
                                                        children: [
                                                          Positioned(
                                                            child: Center(
                                                              child: Container(
                                                                padding: EdgeInsets.fromLTRB(
                                                                    10 *
                                                                        variablePixelWidth,
                                                                    10 *
                                                                        variablePixelHeight,
                                                                    10 *
                                                                        variablePixelWidth,
                                                                    10 *
                                                                        variablePixelHeight),
                                                                width: double
                                                                    .infinity,
                                                                height: double
                                                                    .infinity,
                                                                child:
                                                                    Image.file(
                                                                  File(
                                                                      imagePathFront),
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Positioned(
                                                            top: 20 *
                                                                variablePixelHeight,
                                                            right: 20 *
                                                                variablePixelWidth,
                                                            child: InkWell(
                                                                onTap: () {
                                                                  showUploadBottomSheet(
                                                                      context,
                                                                      translation(
                                                                              context)
                                                                          .uploadPassportFront,
                                                                      (String
                                                                          imageCaptured) {
                                                                    setState(
                                                                        () {
                                                                      imagePathFront =
                                                                          imageCaptured;
                                                                    });
                                                                    if (imagePathFront
                                                                        .isNotEmpty) {
                                                                      isPhotoClickedFront =
                                                                          true;
                                                                      checkTextFieldStatus();
                                                                    }
                                                                  });
                                                                },
                                                                child: SvgPicture
                                                                    .asset(
                                                                        "assets/mpartner/network/image_edit.svg")),
                                                          ),
                                                        ],
                                                      ),
                                              ],
                                            ),
                                          ),
                                          const VerticalSpace(height: 8),
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: 24 * variablePixelWidth),
                                            child: Text(
                                              imagePathFront.isNotEmpty
                                                  ? File(imagePathFront)
                                                      .path
                                                      .split("/")
                                                      .last
                                                  : "Untitled 1.jpeg",
                                              style: GoogleFonts.poppins(
                                                color: AppColors.grayText,
                                                fontSize:
                                                    12 * textFontMultiplier,
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: 0.10,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const HorizontalSpace(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(
                                                right: 24 * variablePixelWidth),
                                            height: 108 * variablePixelHeight,
                                            width: 167 * variablePixelWidth,
                                            color: AppColors.lumiLight5,
                                            child: Stack(
                                              children: [
                                                DottedBorder(
                                                  color:
                                                      AppColors.lumiBluePrimary,
                                                  strokeWidth:
                                                      1 * variablePixelWidth,
                                                  borderType: BorderType.RRect,
                                                  radius: Radius.circular(
                                                      4 * pixelMultiplier),
                                                  dashPattern: [6, 3],
                                                  child: Container(),
                                                ),
                                                !isPhotoClickedBack
                                                    ? Positioned(
                                                        child: Center(
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              IconButton(
                                                                icon: Icon(
                                                                  Icons.add,
                                                                  size: 24 *
                                                                      pixelMultiplier,
                                                                  color: AppColors
                                                                      .lumiBluePrimary,
                                                                ),
                                                                onPressed: () {
                                                                  showUploadBottomSheet(
                                                                      context,
                                                                      translation(
                                                                              context)
                                                                          .uploadPassportBack,
                                                                      (String
                                                                          imageCaptured) {
                                                                    setState(
                                                                        () {
                                                                      imagePathBack =
                                                                          imageCaptured;
                                                                    });
                                                                    if (imagePathBack
                                                                        .isNotEmpty) {
                                                                      isPhotoClickedBack =
                                                                          true;
                                                                      checkTextFieldStatus();
                                                                    }
                                                                  });
                                                                },
                                                              ),
                                                              Text(
                                                                translation(
                                                                        context)
                                                                    .addBackImage,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    GoogleFonts
                                                                        .poppins(
                                                                  color: AppColors
                                                                      .lumiBluePrimary,
                                                                  fontSize: 12 *
                                                                      textFontMultiplier,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  letterSpacing:
                                                                      0.50,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    : Stack(
                                                        children: [
                                                          Positioned(
                                                            child: Center(
                                                              child: Container(
                                                                padding: EdgeInsets.fromLTRB(
                                                                    10 *
                                                                        variablePixelWidth,
                                                                    10 *
                                                                        variablePixelHeight,
                                                                    10 *
                                                                        variablePixelWidth,
                                                                    10 *
                                                                        variablePixelHeight),
                                                                width: double
                                                                    .infinity,
                                                                height: double
                                                                    .infinity,
                                                                child:
                                                                    Image.file(
                                                                  File(
                                                                      imagePathBack),
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Positioned(
                                                            top: 20 *
                                                                variablePixelHeight,
                                                            right: 20 *
                                                                variablePixelWidth,
                                                            child: InkWell(
                                                                onTap: () {
                                                                  showUploadBottomSheet(
                                                                      context,
                                                                      translation(
                                                                              context)
                                                                          .uploadPassportBack,
                                                                      (String
                                                                          imageCaptured) {
                                                                    setState(
                                                                        () {
                                                                      imagePathBack =
                                                                          imageCaptured;
                                                                    });
                                                                    if (imagePathBack
                                                                        .isNotEmpty) {
                                                                      isPhotoClickedBack =
                                                                          true;
                                                                      checkTextFieldStatus();
                                                                    }
                                                                  });
                                                                },
                                                                child: SvgPicture
                                                                    .asset(
                                                                        "assets/mpartner/network/image_edit.svg")),
                                                          ),
                                                        ],
                                                      ),
                                              ],
                                            ),
                                          ),
                                          const VerticalSpace(height: 8),
                                          Container(
                                            margin: EdgeInsets.only(
                                                right: 24 * variablePixelWidth),
                                            child: Text(
                                              imagePathBack.isNotEmpty
                                                  ? File(imagePathBack)
                                                      .path
                                                      .split("/")
                                                      .last
                                                  : "Untitled 2.jpeg",
                                              style: GoogleFonts.poppins(
                                                color: AppColors.grayText,
                                                fontSize:
                                                    12 * textFontMultiplier,
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: 0.10,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const VerticalSpace(height: 32),
                                  ],
                                ),
                                const VerticalSpace(height: 20),
                              ],
                            ),
                          ]),
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: CommonButton(
                        onPressed: () {
                          showConfirmationAlertBottomSheet(
                              context,
                              translation(context).alert,
                              translation(context).passportUploadAlertText,
                              translation(context).sureToContinue, () async {
                            await postUserPanDetails(
                                passportNoController.text,
                                nationalityController.text,
                                genderController.text,
                                firstNameController.text,
                                lastNameController.text,
                                placeOfIssueController.text,
                                dateOfBirthController.text,
                                placeOfBirthController.text,
                                dateOfIssueController.text,
                                dateOfExpiryController.text,
                                imagePathFront,
                                imagePathBack);
                            // Navigator.of(context).popUntil(
                            //     ModalRoute.withName(AppRoutes.userprofile));
                            // Navigator.of(context)
                            //     .popAndPushNamed(AppRoutes.userprofile);
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserProfileScreen()),
                            );
                          });
                        },
                        isEnabled: isSubmitEnabled,
                        containerBackgroundColor: AppColors.white,
                        buttonText: translation(context).submit),
                  ),
                ],
              ))),
    );
  }
}
