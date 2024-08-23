
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../../../../state/contoller/language_controller.dart';
import '../../../../../../../state/contoller/user_data_controller.dart';
import '../../../../../../../utils/app_colors.dart';
import '../../../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../../../utils/localdata/language_constants.dart';
import '../../../../../presentation/screens/cashredemption/widgets/continue_button.dart';
import '../../../../../utils/app_constants.dart';
import '../../../../utils/gem_app_constants.dart';


class GemSupportRequestForm extends StatefulWidget {
  final void Function(bool) onFieldsUpdate;

  Function(String)getGstNumber;

  GemSupportRequestForm({required this.onFieldsUpdate,required this.getGstNumber});

  @override
  State<GemSupportRequestForm> createState() => _GemSupportRequestFormState();
}

class _GemSupportRequestFormState extends State<GemSupportRequestForm> {
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
/*  TextEditingController _mobileNumberController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _referralCodeController = TextEditingController();*/
  String currentDateFormatted = DateFormat('dd/MM/yyyy').format(DateTime.now());
  /*late TextEditingController _dateController = TextEditingController(text: currentDateFormatted);*/
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
    super.initState();
  }
  void checkAnyFieldFilled() {
    setState(() {
      if (_nameController.text.isNotEmpty ||selectedTertiarySaleType != null) {
        widget.onFieldsUpdate(true);
      } else {
        widget.onFieldsUpdate(false);
      }
    });
  }
  void validateGST(String name) {
    RegExp regexGSTIN = GemAppConstants.VALIDATE_GSTIN_REGEX;
    if (name.isEmpty) {
      setState(() {
        validationInfoName = translation(context).required;
        isValidName = false;
        widget.onFieldsUpdate(false);
        isButtonEnabledContinue=false;
        setState(() {
        });
        print("empty");
      });
    } else if (!regexGSTIN.hasMatch(name)) {
      setState(() {
        validationInfoName = translation(context).invalidGstin;
        isValidName = false;
        widget.onFieldsUpdate(false);
        isButtonEnabledContinue=false;
        setState(() {

        });
        print("Not Valid");
      });
    }else {
      widget.onFieldsUpdate(true);
      isValidName = true;
      validationInfoName="";
      isButtonEnabledContinue=true;
      setState(() {

      });
    }
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
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
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
                    keyboardType: TextInputType.text,
                    onChanged: (value) {
                      validateGST(value);

                      // checkAnyFieldFilled();
                    },
                    maxLength: GemAppConstants.nameInputMaxLength,
                    decoration: InputDecoration(
                        label: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: translation(context).enterGstNumber,
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
                        counterText: "",
                        hintText: translation(context).gstNumber,
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
                          fontSize: labelFontSize,
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
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                ContinueButton(
                  containerBackgroundColor: Colors.white,
                  isEnabled: isButtonEnabledContinue ?? false,
                  onPressed: () {
                    widget.getGstNumber(_nameController.text.toString());
                    logger.d(_nameController.text);
                  }, buttonText: translation(context).proceed,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


}
