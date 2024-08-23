import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../data/datasource/mpartner_remote_data_source.dart';
import '../../../../data/models/tertiary_sales_userinfo_model.dart';
import '../../../../network/api_constants.dart';
import '../../../../state/contoller/language_controller.dart';
import '../../../../state/contoller/tertiary_sales_combo_controller.dart';
import '../../../../state/contoller/user_data_controller.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/requests.dart';
import '../../../../utils/textfield_input_handler.dart';
import '../../../../utils/utils.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../widgets/calendar_widget/custom_calendar_view.dart';
import '../../../widgets/common_bottom_sheet.dart';
import '../../../widgets/common_date_picker_widget.dart';
import '../../../widgets/common_qr1.dart';
import '../../ismart/registersales/tertiarysalesbulkorder/tertiary_sales_bulk.dart';
import '../../ismart/registersales/uimodels/customer_info.dart';
import '../../product_history_tnc/product_history_tnc_screen.dart';
import '../../tertiary_sales/components/continue_button_widget.dart';
import '../../tertiary_sales/tertiary_sales_hkva_combo/components/q_r_screen_back_button.dart';
import '../../tertiary_sales/tertiary_sales_hkva_combo/register_sale_combo.dart';
import '../../tertiarysalessingleproduct/tertiary_sales_verify_sales_sheet.dart';
import '../tertiary_sales_hkva_combo/components/combo_back_button.dart';

class TertiarySalesForm extends StatefulWidget {
  final void Function(bool) onFieldsUpdate;

  TertiarySalesForm({required this.onFieldsUpdate});

  @override
  State<TertiarySalesForm> createState() => _TertiarySalesFormState();
}

class _TertiarySalesFormState extends State<TertiarySalesForm> {
  UserDataController controller = Get.find();
  LanguageController languageController = Get.find();
  bool isButtonEnabledContinue = false;
  String validationInfoName = '';
  String validationInfoPhone = '';
  bool isTimerExpired = false;
  late Map<String, dynamic> responseDataUpdateData;
  bool isOtpValid = true;
  bool isValidName = false;
  bool isValidPhone = false;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _mobileNumberController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _referralCodeController = TextEditingController();
  String currentDateFormatted = DateFormat('dd/MM/yyyy').format(DateTime.now());
  late TextEditingController _dateController =
  TextEditingController(text: currentDateFormatted);
  String? selectedDate;
  String timerLimit = "0";
  FocusNode mobileNumberFocusNode = FocusNode();
  String mobileNumberWithoutPrefix = '';
  List listOfTypesOfTertiarySales = [];
  String? selectedTertiarySaleType;
  int? customerCount;
  String? token;
  String? user_id;
  String? language;
  bool isLoading = true;
  bool showEwarrantyOptions = false;
  DateTime selectedDateValue = DateTime.now();
  bool isSaleLimitReached = false;

  @override
  void initState() {
    _mobileNumberController.addListener(() {
      setState(() {});
    });
    mobileNumberFocusNode.addListener(() {
      if (!mobileNumberFocusNode.hasFocus) {
        String trimmedText = _mobileNumberController.text.trim();
        if (trimmedText.length < 7) {
          _mobileNumberController.text = '';
        } else if (trimmedText.isEmpty) {
          _mobileNumberController.text = '';
        }
      }
    });

    _getTypesOfTertiarySale();
    super.initState();
  }

  Future<void> _getTypesOfTertiarySale() async {
    await _initializeData();
    //await fetchEwarrantyOptions();
  }

  Future<void> _initializeData() async {
    token = controller.token;
    user_id = controller.sapId;
    language = languageController.language;
  }

  Future<void> fetchEwarrantyOptions() async {
    final Map<String, dynamic> body = {
      "user_Id": user_id,
      "token": token,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "os_Type": osType,
      "channel": AppConstants.channel,
      "device_Name": deviceName,
      "os_Version_Name": osVersionName,
      "os_Version_Code": osVersionCode,
      "ip_Address": ipAddress,
      "language": language,
      "screen_Name": "",
      "network_Type": networkType,
      "network_Operator": networkOperator,
      "time_Captured": DateTime.now().microsecondsSinceEpoch.toString(),
      "browser": "",
      "browser_Version": "",
      "Customer_Phone": mobileNumberWithoutPrefix
    };

    try {
      setState(() {
        isLoading = true;
      });
      final response = await Requests.sendPostRequest(
          ApiConstants.postGetEwarrantyOptionsEndPoint, body);
      logger.d("URL: ${ApiConstants.postDisclaimerEndPoint}");

      if (response is! DioException && response.statusCode == 200) {
        final List<dynamic> ewarrantyOptions = response.data['data'];

        listOfTypesOfTertiarySales.clear();

        setState(() {
          isLoading = false;
          listOfTypesOfTertiarySales = ewarrantyOptions
              .map((option) => option['name'].toString())
              .toList();
        });
      } else {
        setState(() {
          isLoading = false;
        });
        logger.d("Error: ${response.statusCode}");
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      Utils().showToast(
          translation(context).somethingWentWrongPleaseRetry, context);
      logger.d("Error fetching data: $error");
    }
  }

  void checkTextfieldStatus() {
    setState(() {
      if (_nameController.text.isNotEmpty &&
          _mobileNumberController.text.isNotEmpty &&
          _dateController.text.isNotEmpty &&
          isValidName &&
          isValidPhone &&
          selectedTertiarySaleType != null &&
          isSaleLimitReached == false) {
        isButtonEnabledContinue = true;
      } else {
        isButtonEnabledContinue = false;
      }
    });
  }

  void checkAnyFieldFilled() {
    setState(() {
      if (_nameController.text.isNotEmpty ||
          _mobileNumberController.text.isNotEmpty ||
          _dateController.text.isNotEmpty ||
          _addressController.text.isNotEmpty ||
          _referralCodeController.text.isNotEmpty ||
          selectedTertiarySaleType != null) {
        widget.onFieldsUpdate(true);
      } else {
        widget.onFieldsUpdate(false);
      }
    });
  }

  void validateName(String name) {
    RegExp regex = AppConstants.VALIDATE_NAME_REGEX;
    if (name.isEmpty) {
      setState(() {
        validationInfoName = translation(context).required;
        isValidName = false;
      });
    } else if (!regex.hasMatch(name)) {
      setState(() {
        validationInfoName = translation(context).invalidName;
        isValidName = false;
      });
    } else if (name.length < 5) {
      setState(() {
        validationInfoName =
            translation(context).nameShouldBeAtleast5CharactersLong;
        isValidName = false;
      });
    } else {
      setState(() {
        validationInfoName = '';
        isValidName = true;
      });
    }
  }

  void validateMobileNumber(String mobileNumber) {
    RegExp regex = RegExp(r'^[0-9]{10}$');
    if (mobileNumber.isEmpty) {
      setState(() {
        validationInfoPhone = translation(context).required;
        isValidPhone = false;
        showEwarrantyOptions = false;
        selectedTertiarySaleType = null;
        isSaleLimitReached = false;
      });
    } else if (!regex.hasMatch(mobileNumber)) {
      setState(() {
        validationInfoPhone = translation(context).invalidMobileNumber;
        isValidPhone = false;
        showEwarrantyOptions = false;
        selectedTertiarySaleType = null;
        isSaleLimitReached = false;
      });
    } else {
      setState(() {
        validationInfoPhone = '';
        isValidPhone = true;
        showEwarrantyOptions = true;
        apiCallFunction();
      });
    }
  }

  Future<void> apiCallFunction() async {
    await fetchEwarrantyOptions();
    if (listOfTypesOfTertiarySales.length == 1 &&
        listOfTypesOfTertiarySales[0] != AppConstants.singleProduct &&
        listOfTypesOfTertiarySales[0] != AppConstants.inverterBatteryCombo &&
        listOfTypesOfTertiarySales[0] != AppConstants.corporateBulkSale) {
      setState(() {
        isSaleLimitReached = true;
        selectedTertiarySaleType = null;
      });
    } else if (listOfTypesOfTertiarySales.length == 1) {
      setState(() {
        isSaleLimitReached = false;
        selectedTertiarySaleType = listOfTypesOfTertiarySales![0];
      });
    } else {
      setState(() {
        isSaleLimitReached = false;
        selectedTertiarySaleType = null;
      });
    }
    checkTextfieldStatus();
  }

  final OutlineInputBorder focusedOutlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(4.0)),
    borderSide: BorderSide(color: AppColors.lumiBluePrimary),
  );

  final OutlineInputBorder enabledOutlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(4.0)),
    borderSide: BorderSide(color: AppColors.dividerColor),
  );

  final OutlineInputBorder errorOutlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(4.0)),
    borderSide: BorderSide(color: AppColors.errorRed),
  );

  Widget build(BuildContext context) {
    double labelFontSize = DisplayMethods(context: context).getLabelFontSize();
    double variablePixelHeight =
    DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
    DisplayMethods(context: context).getVariablePixelWidth();
    double textFontMultiplier =
    DisplayMethods(context: context).getTextFontMultiplier();
    double variablePixelMultiplier =
    DisplayMethods(context: context).getPixelMultiplier();

    final TextStyle customHintStyle = GoogleFonts.poppins(
      fontSize: 14 * textFontMultiplier,
      fontWeight: FontWeight.w400,
      height: 0.12,
      letterSpacing: 0.50,
    );

    final TextStyle customPrefixStyle = GoogleFonts.poppins(
      fontSize: 14 * textFontMultiplier,
      fontWeight: FontWeight.w500,
      height: 0.12,
      letterSpacing: 0.50,
    );

    final TextStyle textStyle = GoogleFonts.poppins(
      fontSize: 14 * textFontMultiplier,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.50,
    );

    final TextStyle customErrorStyle = GoogleFonts.poppins(
      fontSize: 8 * textFontMultiplier,
      fontWeight: FontWeight.w500,
      height: 0.12,
      letterSpacing: 0.50,
    );

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(0),
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: 24 * variablePixelWidth,
                      right: 24 * variablePixelWidth,
                      top: 20 * variablePixelHeight),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _nameController,
                        style: textStyle,
                        inputFormatters: <TextInputFormatter>[
                          HandleFirstSpaceAndDotInputFormatter(),
                          HandleMultipleDotsInputFormatter(),
                          FilteringTextInputFormatter.allow(
                              AppConstants.VALIDATE_NAME_REGEX),
                        ],
                        onChanged: (value) {
                          validateName(value);
                          checkTextfieldStatus();
                          checkAnyFieldFilled();
                        },
                        maxLength: AppConstants.nameInputMaxLength,
                        decoration: InputDecoration(
                            label: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: translation(context).customerName,
                                    style: GoogleFonts.poppins(
                                      color: AppColors.darkGreyText,
                                      fontSize:
                                      labelFontSize * textFontMultiplier,
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 0.40,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '*',
                                    style: GoogleFonts.poppins(
                                      color: AppColors.errorRed,
                                      fontSize:
                                      labelFontSize * textFontMultiplier,
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 0.40,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            counterText: "",
                            hintText: translation(context).addName,
                            errorText: validationInfoName.isNotEmpty
                                ? validationInfoName
                                : null,
                            focusedBorder: focusedOutlineInputBorder,
                            enabledBorder: enabledOutlineInputBorder,
                            errorBorder: errorOutlineInputBorder,
                            focusedErrorBorder: errorOutlineInputBorder,
                            labelStyle: GoogleFonts.poppins(
                              color: _nameController.text.isEmpty
                                  ? AppColors.darkGreyText
                                  : AppColors.lumiBluePrimary,
                              fontSize: labelFontSize * textFontMultiplier,
                              fontWeight: FontWeight.w400,
                              height: 0.11,
                              letterSpacing: 0.40,
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintStyle: customHintStyle,
                            prefixStyle: customPrefixStyle,
                            errorStyle: customErrorStyle,
                            contentPadding: EdgeInsets.fromLTRB(
                                16 * variablePixelWidth,
                                18 * variablePixelHeight,
                                8 * variablePixelWidth,
                                18 * variablePixelHeight)),
                      ),
                      SizedBox(height: 20 * variablePixelHeight),
                      TextField(
                        controller: _addressController,
                        style: textStyle,
                        inputFormatters: [HandleFirstSpaceInputFormatter()],
                        onChanged: (value) {
                          checkAnyFieldFilled();
                        },
                        maxLength: AppConstants.addressInputMaxLength,
                        decoration: InputDecoration(
                            labelText: translation(context).customerAddress,
                            hintText: translation(context).addAddress,
                            //errorText:validationInfoName.isNotEmpty ? validationInfoName : null,
                            focusedBorder: focusedOutlineInputBorder,
                            enabledBorder: enabledOutlineInputBorder,
                            // errorBorder: errorOutlineInputBorder,
                            // focusedErrorBorder: errorOutlineInputBorder,
                            labelStyle: GoogleFonts.poppins(
                              color: AppColors.darkGreyText,
                              fontSize: labelFontSize * textFontMultiplier,
                              fontWeight: FontWeight.w400,
                              height: 0.11,
                              letterSpacing: 0.40,
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintStyle: customHintStyle,
                            counterText: "",
                            prefixStyle: customPrefixStyle,
                            //errorStyle: customErrorStyle,
                            contentPadding: EdgeInsets.fromLTRB(
                                16 * variablePixelWidth,
                                18 * variablePixelHeight,
                                8 * variablePixelWidth,
                                18 * variablePixelHeight)),
                      ),
                      SizedBox(height: 20 * variablePixelHeight),
                      TextField(
                        controller: _mobileNumberController,
                        focusNode: mobileNumberFocusNode,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\+91 - [0-9]*$'),
                              replacementString: _mobileNumberController.text),
                          FilteringTextInputFormatter.deny(
                            RegExp(r'^\+91 - [0-5]$'),
                          ),
                        ],
                        style: textStyle,
                        maxLength: 16,
                        onChanged: (value) {
                          if (!value.startsWith('+91 - ')) {
                            _mobileNumberController.text = '+91 - ';
                          }
                          if (value.startsWith('+91 - ') && value.length > 16) {
                            _mobileNumberController.text =
                                value.substring(0, 16);
                            value = value.substring(0, 16);
                          }
                          mobileNumberWithoutPrefix = value.startsWith('+91 - ')
                              ? value.substring('+91 - '.length)
                              : value;
                          validateMobileNumber(mobileNumberWithoutPrefix);
                          checkTextfieldStatus();
                          checkAnyFieldFilled();
                        },
                        onTap: () {
                          setState(() {
                            if (_mobileNumberController.text.isEmpty) {
                              _mobileNumberController.text = '+91 - ';
                            }
                          });
                        },
                        decoration: InputDecoration(
                            label: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: translation(context).customerMobileno,
                                    style: GoogleFonts.poppins(
                                      color: AppColors.darkGreyText,
                                      fontSize:
                                      labelFontSize * textFontMultiplier,
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 0.40,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '*',
                                    style: GoogleFonts.poppins(
                                      color: AppColors.errorRed,
                                      fontSize:
                                      labelFontSize * textFontMultiplier,
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 0.40,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            hintText: translation(context).addMobileNo,
                            errorText: validationInfoPhone.isNotEmpty
                                ? validationInfoPhone
                                : null,
                            counterText: "",
                            focusedBorder: focusedOutlineInputBorder,
                            enabledBorder: enabledOutlineInputBorder,
                            errorBorder: errorOutlineInputBorder,
                            focusedErrorBorder: errorOutlineInputBorder,
                            labelStyle: GoogleFonts.poppins(
                              color: _mobileNumberController.text.isEmpty
                                  ? AppColors.darkGreyText
                                  : AppColors.lumiBluePrimary,
                              fontSize: labelFontSize * textFontMultiplier,
                              fontWeight: FontWeight.w400,
                              height: 0.11,
                              letterSpacing: 0.40,
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintStyle: customHintStyle,
                            prefixStyle: customPrefixStyle,
                            errorStyle: customErrorStyle,
                            contentPadding: EdgeInsets.fromLTRB(
                                16 * variablePixelWidth,
                                18 * variablePixelHeight,
                                8 * variablePixelWidth,
                                18 * variablePixelHeight)),
                      ),
                      SizedBox(height: 20 * variablePixelHeight),
                      CustomCalendarView(
                        labelText: translation(context).dateOfPurchase,
                        hintText: translation(context).selectDateFormat,
                        icon: Icon(
                          Icons.calendar_month_outlined,
                          color: AppColors.grey,
                          size: 24 * variablePixelMultiplier,
                        ),
                        calendarType: AppConstants.singleSelectionCalenderType,
                        dateFormat: "dd/MM/yyyy",
                        initialDateSelection: selectedDateValue,
                        errorText: "",
                        calendarStartDate: DateTime(DateTime.now().year,
                            DateTime.now().month, DateTime.now().day - 6),
                        calendarEndDate: DateTime.now(),
                        singleDateEditController: _dateController,
                        onDateSelected: (selectedDate) {
                          logger.d("view1 ${selectedDate}");
                          setState(() {
                            _dateController.text = selectedDate;
                            var inputFormat = DateFormat('dd/MM/yyyy');
                            var currentSelctedDate =
                            inputFormat.parse(selectedDate);
                            selectedDateValue = currentSelctedDate;
                          });
                        },
                        onDateRangeSelected: (startDate, endDate) {
                          logger.d("view2 ${startDate}- ${endDate}");
                        },
                      ),
                      /*  TextField(
                        controller: _dateController,
                        readOnly: true,
                        style: textStyle,
                        onTap: () {
                          CommonBottomSheet.show(context,
                              CommonDatePickerWidget(onDateSelected:
                                  (selectedDate) {
                                setState(() {
                                  _dateController.text =
                                      '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}' ?? _dateController.text;
                                });
                              }, daysToEnable: 6,),
                              variablePixelHeight, variablePixelWidth);
                        },
                        onChanged: (value) {
                          //validateDate(value);
                          checkTextfieldStatus();
                          checkAnyFieldFilled();
                        },
                        decoration: InputDecoration(
                            label: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: translation(context).dateOfPurchase,
                                    style: GoogleFonts.poppins(
                                      color: AppColors.darkGreyText,
                                      fontSize: 12 * textFontMultiplier,
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 0.40,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '*',
                                    style: GoogleFonts.poppins(
                                      color: AppColors.errorRed,
                                      fontSize: 12 * textFontMultiplier,
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 0.40,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            suffixIcon: InkWell(
                              onTap: () {
                                CommonBottomSheet.show(context,
                                    CommonDatePickerWidget(onDateSelected:
                                        (selectedDate) {
                                      setState(() {
                                        _dateController.text =
                                            '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}' ?? _dateController.text;
                                      });
                                    },daysToEnable: 6,),
                                    variablePixelHeight, variablePixelWidth);
                              },
                              child: Icon(
                                Icons.calendar_month_outlined,
                                color: AppColors.darkGreyText,
                                size: 24 * variablePixelHeight,
                              ),
                            ),
                            //errorText:validationInfoDate.isNotEmpty ? validationInfoDate : null,
                            counterText: "",
                            focusedBorder: focusedOutlineInputBorder,
                            enabledBorder: enabledOutlineInputBorder,
                            //errorBorder: errorOutlineInputBorder,
                            //focusedErrorBorder: errorOutlineInputBorder,
                            labelStyle: GoogleFonts.poppins(
                              color: _dateController.text.isEmpty
                                  ? AppColors.darkGreyText
                                  : AppColors.lumiBluePrimary,
                              fontSize: labelFontSize,
                              fontWeight: FontWeight.w400,
                              height: 0.11,
                              letterSpacing: 0.40,
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintStyle: customHintStyle,
                            prefixStyle: customPrefixStyle,
                            //errorStyle: customErrorStyle,
                            contentPadding: EdgeInsets.fromLTRB(
                                16 * variablePixelWidth,
                                18 * variablePixelHeight,
                                8 * variablePixelWidth,
                                18 * variablePixelHeight)),
                      ),*/
                      SizedBox(height: 20 * variablePixelHeight),
                      TextField(
                        controller: _referralCodeController,
                        style: textStyle,
                        onChanged: (value) {
                          checkAnyFieldFilled();
                        },
                        inputFormatters: [HandleFirstSpaceInputFormatter()],
                        maxLength: AppConstants.referralCodeInputMaxLength,
                        decoration: InputDecoration(
                            labelText:
                            translation(context).referralCodeOptional,
                            hintText: translation(context).code,
                            //errorText:validationInfoName.isNotEmpty ? validationInfoName : null,
                            counterText: "",
                            focusedBorder: focusedOutlineInputBorder,
                            enabledBorder: enabledOutlineInputBorder,
                            //errorBorder: errorOutlineInputBorder,
                            //focusedErrorBorder: errorOutlineInputBorder,
                            labelStyle: GoogleFonts.poppins(
                              color: AppColors.darkGreyText,
                              fontSize: labelFontSize * textFontMultiplier,
                              fontWeight: FontWeight.w400,
                              height: 0.11,
                              letterSpacing: 0.40,
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintStyle: customHintStyle,
                            prefixStyle: customPrefixStyle,
                            //errorStyle: customErrorStyle,
                            contentPadding: EdgeInsets.fromLTRB(
                                16 * variablePixelWidth,
                                18 * variablePixelHeight,
                                8 * variablePixelWidth,
                                18 * variablePixelHeight)),
                      ),
                      SizedBox(height: 20 * variablePixelHeight),
                      Container(
                          alignment: Alignment.centerLeft,
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: translation(context).typeOfTertiarySale,
                                  style: GoogleFonts.poppins(
                                    color: AppColors.darkText2,
                                    fontSize:
                                    labelFontSize * textFontMultiplier,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.10,
                                  ),
                                ),
                                TextSpan(
                                  text: '*',
                                  style: GoogleFonts.poppins(
                                    color: AppColors.errorRed,
                                    fontSize:
                                    labelFontSize * textFontMultiplier,
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 0.40,
                                  ),
                                ),
                              ],
                            ),
                          )),
                      SizedBox(height: 10 * variablePixelHeight),
                      showEwarrantyOptions
                          ? Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.0 * variablePixelWidth),
                        child: isLoading
                            ? Center(
                          child: Container(
                            width: 20.0 * variablePixelWidth,
                            height: 20.0 * variablePixelHeight,
                            child: CircularProgressIndicator(),
                          ),
                        )
                            : isSaleLimitReached
                            ? SizedBox(
                          height: 10 * variablePixelHeight,
                        )
                            : ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: listOfTypesOfTertiarySales!
                              .length,
                          itemBuilder: (BuildContext context,
                              int index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedTertiarySaleType =
                                      listOfTypesOfTertiarySales[
                                      index]
                                          .toString();
                                  checkTextfieldStatus();
                                  checkAnyFieldFilled();
                                });
                              },
                              child: Row(
                                children: [
                                  Radio(
                                    activeColor: AppColors
                                        .lumiBluePrimary,
                                    value:
                                    listOfTypesOfTertiarySales![
                                    index],
                                    groupValue:
                                    selectedTertiarySaleType,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedTertiarySaleType =
                                            value.toString();
                                        checkTextfieldStatus();
                                        checkAnyFieldFilled();
                                      });
                                    },
                                    materialTapTargetSize:
                                    MaterialTapTargetSize
                                        .shrinkWrap,
                                    visualDensity:
                                    VisualDensity(
                                        horizontal: -2,
                                        vertical: -2),
                                  ),
                                  SizedBox(
                                      width: 4 *
                                          variablePixelWidth),
                                  Flexible(
                                    child: Text(
                                        listOfTypesOfTertiarySales![
                                        index],
                                        style:
                                        GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                            color: AppColors
                                                .darkText2,
                                            fontSize: 14 *
                                                textFontMultiplier,
                                            fontWeight:
                                            FontWeight.w400,
                                            letterSpacing: 0.25,
                                          ),
                                        )),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      )
                          : Container(
                        child: SizedBox(height: 10 * variablePixelHeight),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              SizedBox(height: 15 * variablePixelHeight),
              if (isSaleLimitReached)
                Center(
                  child: Container(
                    color: AppColors.white,
                    padding: EdgeInsets.only(
                        top: 10.0 * variablePixelHeight,
                        bottom: 10.0 * variablePixelHeight,
                        left: 24 * variablePixelWidth,
                        right: 24 * variablePixelWidth),
                    child: Text(listOfTypesOfTertiarySales[0],
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: AppColors.red,
                            fontSize: 14 * textFontMultiplier,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.25,
                          ),
                        )),
                  ),
                ),
              ContinueButton(
                isEnabled: isButtonEnabledContinue ?? false,
                onPressed: () {
                  if (_nameController.text.length < 5) {
                    Utils().showToast(
                        translation(context).nameShouldBeAtleast5CharactersLong,
                        context);
                    return;
                  }

                  MPartnerRemoteDataSource().clearPreTableData();

                  switch (selectedTertiarySaleType) {
                    case AppConstants.singleProduct:
                      goToQRScanner();
                      break;
                    case AppConstants.inverterBatteryCombo:
                      comboScenario();
                      break;
                    case AppConstants.corporateBulkSale:
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TertiarySalesBulk(
                                customerInfo: CustomerInfo(
                                    customerName: _nameController.text,
                                    custAddress: _addressController.text,
                                    mobileNo: _mobileNumberController.text
                                        .substring(
                                        max(
                                            0,
                                            _mobileNumberController
                                                .text.length -
                                                10),
                                        _mobileNumberController
                                            .text.length),
                                    saleDate: _dateController.text,
                                    saleTime: DateFormat('hh:mm a')
                                        .format(DateTime.now())
                                        .toString(),
                                    refCode: _referralCodeController.text,
                                    tertiarySaleType:
                                    selectedTertiarySaleType!))),
                      );
                      break;
                  }
                  logger.d(_nameController.text);
                  logger.d(_addressController.text);
                  logger.d(_mobileNumberController.text);
                  logger.d(_dateController.text);
                  logger.d(_referralCodeController.text);
                  logger.d(selectedTertiarySaleType);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  String formattedDateAndTime(DateTime originalRegisteredOn) {
    DateTime currentDatePart = DateTime(originalRegisteredOn.year,
        originalRegisteredOn.month, originalRegisteredOn.day);

    DateTime currentDateTime = DateTime.now();

    DateTime combinedDateTime = DateTime(
      currentDatePart.year,
      currentDatePart.month,
      currentDatePart.day,
      currentDateTime.hour,
      currentDateTime.minute,
      currentDateTime.second,
    );
    return DateFormat(AppConstants.appDateFormatWithTime)
        .format(combinedDateTime);
  }

  void comboScenario() {
    double r = DisplayMethods(context: context).getPixelMultiplier();
    DateTime? originalRegisteredOn = (_dateController.text != null)
        ? DateFormat("d/M/yyyy").parse(_dateController.text).toLocal()
        : null;
    String formattedRegisteredOn = (originalRegisteredOn != null)
        ? formattedDateAndTime(originalRegisteredOn)
        : "Default Value";



    TertiarySalesUserInfo userInfo = TertiarySalesUserInfo(
      name: _nameController.text,
      address: _addressController.text,
      mobileNumber: _mobileNumberController.text,
      date: _dateController.text,
      saleTime: formattedRegisteredOn,
      referralCode: _referralCodeController.text,
      tertiarySaleType: selectedTertiarySaleType ?? "Inverter & Battery Combo",
      transId: "",
      otp: "",
    );
    TertiarySalesHKVAcombo comboController = Get.find();
    comboController.updateUserInfo(userInfo);
    comboController.hkvaItemModels.clear();


    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProductHistoryTncScreen(
              title: "Tertiary Sales",
              subtitle: "Inverter & Battery combo",
              isScanInverter: true,
              onBackButtonPressed: () => {},
              onBackButtonPressedWithController: (pauseCamera, resumeCamera) =>
              {
                pauseCamera(),
                showModalBottomSheet(
                    isScrollControlled: false,
                    useSafeArea: true,
                    enableDrag: false,
                    isDismissible: false,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(28 * r),
                            topRight: Radius.circular(28 * r))),
                    showDragHandle: false,
                    backgroundColor: AppColors.white,
                    context: context,
                    builder: (BuildContext context) {
                      return PopScope(
                          canPop: false,
                          child: ComboBackButton(resumeCamera: resumeCamera));
                    }),
              },
              showBottomModal: false,
              routeWidget: ComboScreen(),
              useFunction: true,
              customerMobileNo: _mobileNumberController.text,
            )));

    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => BarcodeAndQRScanner(
    //               title: "Tertiary Sales",
    //               subtitle: "Inverter & Battery combo",
    //               isScanInverter: true,
    //               onBackButtonPressed: () => {},
    //               onBackButtonPressedWithController:
    //                   (pauseCamera, resumeCamera) => {
    //                 pauseCamera(),
    //                 showModalBottomSheet(
    //                     isScrollControlled: false,
    //                     useSafeArea: true,
    //                     enableDrag: false,
    //                     isDismissible: false,
    //                     shape: RoundedRectangleBorder(
    //                         borderRadius: BorderRadius.only(
    //                             topLeft: Radius.circular(28 * r),
    //                             topRight: Radius.circular(28 * r))),
    //                     showDragHandle: false,
    //                     backgroundColor: AppColors.white,
    //                     context: context,
    //                     builder: (BuildContext context) {
    //                       return PopScope(
    //                           canPop: false,
    //                           child:
    //                               ComboBackButton(resumeCamera: resumeCamera));
    //                     }),
    //               },
    //               showBottomModal: false,
    //               routeWidget: ComboScreen(),
    //               useFunction: true,
    //             )));
  }

  void goToQRScanner() {
    double r = DisplayMethods(context: context).getPixelMultiplier();
    String mobileNumberReceived = _mobileNumberController.text;
    int length = mobileNumberReceived.length;
    String mobileNumberSent =
    mobileNumberReceived.substring(max(0, length - 10), length);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductHistoryTncScreen(
          title: "Tertiary Sales",
          subtitle: "Single product",
          customerMobileNo: mobileNumberSent,
          onBackButtonPressed: () => {},
          useFunction: true,
          onBackButtonPressedWithController: (pauseCamera, resumeCamera) =>
          {
            pauseCamera(),
            showModalBottomSheet(
                isScrollControlled: false,
                enableDrag: false,
                useSafeArea: true,
                isDismissible: false,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(28 * r),
                        topRight: Radius.circular(28 * r))),
                showDragHandle: false,
                backgroundColor: AppColors.white,
                context: context,
                builder: (BuildContext context) {
                  return PopScope(
                    canPop: false,
                    child: QRScreenBackButton(
                      resumeCamera: resumeCamera,
                    ),
                  );
                }),
          },
          routeWidget: TertiarySalesVerifySalesSheet(
            name: _nameController.text,
            address: _addressController.text,
            mobileNumber: mobileNumberSent,
            date: _dateController.text,
            referralCode: _referralCodeController.text,
            tertiarySaleType: selectedTertiarySaleType,
          ),
          showBottomModal: true,
        ),
      ),
    );

    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => BarcodeAndQRScanner(
    //       title: "Tertiary Sales",
    //       subtitle: "Single product",
    //       onBackButtonPressed: () => {},
    //       useFunction: true,
    //       onBackButtonPressedWithController: (pauseCamera, resumeCamera) => {
    //         pauseCamera(),
    //         showModalBottomSheet(
    //             isScrollControlled: false,
    //             enableDrag: false,
    //             useSafeArea: true,
    //             isDismissible: false,
    //             shape: RoundedRectangleBorder(
    //                 borderRadius: BorderRadius.only(
    //                     topLeft: Radius.circular(28 * r),
    //                     topRight: Radius.circular(28 * r))),
    //             showDragHandle: false,
    //             backgroundColor: AppColors.white,
    //             context: context,
    //             builder: (BuildContext context) {
    //               return PopScope(
    //                 canPop: false,
    //                 child: QRScreenBackButton(
    //                   resumeCamera: resumeCamera,
    //                 ),
    //               );
    //             }),
    //       },
    //       routeWidget: TertiarySalesVerifySalesSheet(
    //         name: _nameController.text,
    //         address: _addressController.text,
    //         mobileNumber: mobileNumberSent,
    //         date: _dateController.text,
    //         referralCode: _referralCodeController.text,
    //         tertiarySaleType: selectedTertiarySaleType,
    //       ),
    //       showBottomModal: true,
    //     ),
    //   ),
    // );
  }
}
