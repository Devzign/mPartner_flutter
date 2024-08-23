import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../data/models/traveller_model.dart';
import '../../../../../state/contoller/coin_to_trips_redemption_controller.dart';
import '../../../../../state/contoller/relationship_controller.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_constants.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';
import '../../../../../utils/textfield_input_handler.dart';
import '../../../../widgets/buttons/primary_button.dart';
import '../../../../widgets/verticalspace/vertical_space.dart';

class AddNewOrEditTravellerTab extends StatefulWidget {
  AddNewOrEditTravellerTab({
    super.key,
    required this.traveller,
    required this.indexOfCurrent,
    required this.indexOfSaved,
    required this.tripID,
  });
  Traveller traveller;
  int? indexOfCurrent;
  int? indexOfSaved;
  int tripID;
  @override
  State<AddNewOrEditTravellerTab> createState() =>
      _AddNewOrEditTravellerTabState();
}

class _AddNewOrEditTravellerTabState extends State<AddNewOrEditTravellerTab> {
  bool isEditable = true;
  bool addNewTraveller = false;

  CoinsToTripController c = Get.find();

  void areTextFieldEditable() {
    if (widget.traveller.name.isEmpty && widget.traveller.relation.isEmpty) {
      isEditable = true;
      addNewTraveller = true;
      return;
    }
    if (c.indexOfSavedTraveller(
            widget.traveller.name, widget.traveller.relation) !=
        null) {
      isEditable = false;
    }
    c.isSavedTravellerBeingEdited.value = !isEditable;
  }

  @override
  void initState() {
    super.initState();
    areTextFieldEditable();
    c.addTextListeners();
    c.intializeEditingController(widget.traveller);
  }

  final formKey = GlobalKey<FormState>();
  late TextStyle customHintStyle, customPrefixStyle, textStyle;
  late OutlineInputBorder focusedOutlineInputBorder,
      enabledOutlineInputBorder,
      errorOutlineInputBorder;

  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();

    customHintStyle = GoogleFonts.poppins(
        fontSize: 14 * f,
        fontWeight: FontWeight.w500,
        height: 24 / 14,
        letterSpacing: 0.50,
        color: AppColors.lightGrey1);

    customPrefixStyle = GoogleFonts.poppins(
      fontSize: 14 * f,
      fontWeight: FontWeight.w500,
      height: 24 / 14,
      letterSpacing: 0.50,
    );

    textStyle = GoogleFonts.poppins(
      fontSize: 14 * f,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.50,
    );

    focusedOutlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(4.0 * r)),
      borderSide: const BorderSide(color: AppColors.lumiBluePrimary),
    );

    enabledOutlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(4.0 * r)),
      borderSide: const BorderSide(color: AppColors.dividerColor),
    );
    errorOutlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(4.0 * r)),
      borderSide: const BorderSide(color: AppColors.errorRed),
    );

    return Obx(
      () => GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const VerticalSpace(height: 24),
                TextFieldName(
                    isEnabled: isEditable,
                    f: f,
                    w: w,
                    focusedOutlineInputBorder: focusedOutlineInputBorder,
                    enabledOutlineInputBorder: enabledOutlineInputBorder,
                    errorOutlineInputBorder: errorOutlineInputBorder,
                    customHintStyle: customHintStyle,
                    customPrefixStyle: customPrefixStyle,
                    controller: c.nameController,
                    indexOfCurrent: widget.indexOfCurrent,
                    indexOfSaved: widget.indexOfSaved,
                    h: h),
                const VerticalSpace(height: 20),
                TextFieldEmailId(
                  isEnabled: isEditable,
                  f: f,
                  w: w,
                  focusedOutlineInputBorder: focusedOutlineInputBorder,
                  enabledOutlineInputBorder: enabledOutlineInputBorder,
                  errorOutlineInputBorder: errorOutlineInputBorder,
                  customHintStyle: customHintStyle,
                  customPrefixStyle: customPrefixStyle,
                  h: h,
                  controller: c.emailController,
                ),
                const VerticalSpace(height: 20),
                TextFieldMobileNo(
                  isEnabled: true,
                  f: f,
                  w: w,
                  focusedOutlineInputBorder: focusedOutlineInputBorder,
                  enabledOutlineInputBorder: enabledOutlineInputBorder,
                  errorOutlineInputBorder: errorOutlineInputBorder,
                  customHintStyle: customHintStyle,
                  customPrefixStyle: customPrefixStyle,
                  h: h,
                  controller: c.mobileNoController,
                ),
                const VerticalSpace(height: 20),
                RelationshipDropdown(
                  f: f,
                  w: w,
                  h: h,
                  r: r,
                  isEditable: isEditable,
                  indexOfCurrent: widget.indexOfCurrent,
                ),
                
                addNewTraveller
                    ? VerticalSpace(height: 40)
                    : VerticalSpace(
                        height: MediaQuery.of(context).viewInsets.bottom > 0.0
                            ? 40
                            : 100),
                Row(
                  children: [
                    PrimaryButton(
                        isLoading: c.isLoading.value,
                        buttonText: addNewTraveller
                            ? translation(context).continueButtonText
                            : translation(context).updateVal,
                        buttonHeight: 48,
                        onPressed: () => {
                              if (formKey.currentState!.validate())
                                {
                                  if (addNewTraveller)
                                    {
                                      c.addTraveller(
                                        Traveller(
                                            name: c.nameController.text,
                                            relation: c.relationshipController,
                                            mobileNo: c.mobileNoController.text,
                                            passport: c.passportController.text,
                                            email: c.emailController.text),
                                      )
                                    }
                                  else
                                    {
                                      if (isEditable)
                                        {
                                          c.updateTraveller(
                                            Traveller(
                                              name: c.nameController.text,
                                              relation:
                                                  c.relationshipController,
                                              mobileNo:
                                                  c.mobileNoController.text,
                                              passport:
                                                  c.passportController.text,
                                              email: c.emailController.text,
                                            ),
                                            widget.indexOfCurrent,
                                            widget.indexOfSaved,
                                          ),
                                        }
                                      else
                                        {
                                          c.UpdateMobileNumber(
                                            Traveller(
                                                name: c.nameController.text,
                                                relation:
                                                    c.relationshipController,
                                                mobileNo:
                                                    c.mobileNoController.text,
                                                passport:
                                                    c.passportController.text,
                                                email: c.emailController.text),
                                            widget.indexOfCurrent,
                                            widget.indexOfSaved,
                                            widget.tripID,
                                            context,
                                          ),
                                        }
                                    },
                                  Navigator.pop(context),
                                }
                            },
                        isEnabled: c.isFormCompleted.value),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TextFieldMobileNo extends StatefulWidget {
  const TextFieldMobileNo({
    super.key,
    this.isEnabled = true,
    required this.f,
    required this.w,
    required this.focusedOutlineInputBorder,
    required this.enabledOutlineInputBorder,
    required this.errorOutlineInputBorder,
    required this.customHintStyle,
    required this.customPrefixStyle,
    required this.h,
    required this.controller,
  });
  final bool isEnabled;
  final double f;
  final double w;
  final OutlineInputBorder focusedOutlineInputBorder;
  final OutlineInputBorder enabledOutlineInputBorder, errorOutlineInputBorder;
  final TextStyle customHintStyle;
  final TextStyle customPrefixStyle;
  final double h;
  final TextEditingController controller;

  @override
  State<TextFieldMobileNo> createState() => _TextFieldMobileNoState();
}

class _TextFieldMobileNoState extends State<TextFieldMobileNo> {
  @override
  String errorMessagePhoneNumberValidity = "";
  void validateMyPhoneNumber(String value) {
    if (value.length >= 7) {
      setState(() {
        String presentNumber = value.substring(7);
        print(presentNumber);
        if (presentNumber.isEmpty) {
          errorMessagePhoneNumberValidity = translation(context).required;
        } else if (!presentNumber.isPhoneNumber) {
          errorMessagePhoneNumberValidity =
              translation(context).invalidMobileNumber;
        } else {
          errorMessagePhoneNumberValidity = "";
        }
      });
    }
  }

  Widget build(BuildContext context) {
    // print(AppConstants.countryCode.length);
    return TextFormField(
      style: GoogleFonts.poppins(
          height: 24 / 14,
          fontSize: 14 * widget.f,
          letterSpacing: 0.5,
          fontWeight: FontWeight.w500),
      enabled: widget.isEnabled,
      controller: widget.controller,
      keyboardType: TextInputType.phone,
      maxLength: 16,
      onChanged: (value) {
        validateMyPhoneNumber(value);
      },
      decoration: InputDecoration(
          label: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: translation(context).mobileNo,
                  style: GoogleFonts.poppins(
                    color: AppColors.darkGreyText,
                    fontSize: 12 * widget.f,
                    height: 16 / 12,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.40,
                  ),
                ),
                TextSpan(
                  text: '*',
                  style: GoogleFonts.poppins(
                    color: AppColors.errorRed,
                    fontSize: 12 * widget.f,
                    height: 16 / 12,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.40,
                  ),
                ),
              ],
            ),
          ),
          hintText: translation(context).addMobileNo,
          counterText: "",
          focusedBorder: widget.focusedOutlineInputBorder,
          enabledBorder: widget.enabledOutlineInputBorder,
          errorBorder: widget.errorOutlineInputBorder,
          focusedErrorBorder: widget.errorOutlineInputBorder,
          errorText: errorMessagePhoneNumberValidity.isNotEmpty
              ? errorMessagePhoneNumberValidity
              : null,
          errorMaxLines: 2,
          labelStyle: GoogleFonts.poppins(
            color: widget.isEnabled ? AppColors.titleColor : AppColors.grayText,
            fontWeight: FontWeight.w500,
            height: 16 / 12,
            letterSpacing: 0.40,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintStyle: widget.customHintStyle,
          prefixStyle: widget.customPrefixStyle,
          contentPadding: EdgeInsets.fromLTRB(
              16 * widget.w, 12 * widget.h, 8 * widget.w, 12 * widget.h)),
    );
  }
}

class TextFieldEmailId extends StatefulWidget {
  TextFieldEmailId({
    super.key,
    this.isEnabled = true,
    required this.f,
    required this.w,
    required this.focusedOutlineInputBorder,
    required this.enabledOutlineInputBorder,
    required this.errorOutlineInputBorder,
    required this.customHintStyle,
    required this.customPrefixStyle,
    required this.h,
    required this.controller,
  });
  final bool isEnabled;
  final double f;
  final double w;
  final OutlineInputBorder focusedOutlineInputBorder;
  final OutlineInputBorder enabledOutlineInputBorder, errorOutlineInputBorder;
  final TextStyle customHintStyle;
  final TextStyle customPrefixStyle;
  final double h;
  final TextEditingController controller;

  @override
  State<TextFieldEmailId> createState() => _TextFieldEmailIdState();
}

class _TextFieldEmailIdState extends State<TextFieldEmailId> {
  CoinsToTripController c = Get.find();

  String errorMessageEmail = "";

  void validateMyEmailID(String value) {
    setState(() {
      // if (value.isEmpty) {
      //   errorMessageEmail = translation(context).required;
      // } else
      if (value.isNotEmpty && !value.isEmail) {
        errorMessageEmail = translation(context).enterAValidEmail;
      } else {
        errorMessageEmail = "";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: GoogleFonts.poppins(
          height: 24 / 14,
          fontSize: 14 * widget.f,
          letterSpacing: 0.5,
          fontWeight: FontWeight.w500),
      enabled: widget.isEnabled,
      keyboardType: TextInputType.emailAddress,
      controller: widget.controller,
      maxLength: 50,
      onChanged: (value) => {
        validateMyEmailID(value),
      },
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r'\s')),
      ],
      decoration: InputDecoration(
          label: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: translation(context).emailId,
                  style: GoogleFonts.poppins(
                    color: AppColors.darkGreyText,
                    fontSize: 12 * widget.f,
                    height: 16 / 12,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.40,
                  ),
                ),
                TextSpan(
                  text: ' (Optional)',
                  style: GoogleFonts.poppins(
                    color: AppColors.darkGreyText,
                    fontSize: 12 * widget.f,
                    height: 16 / 12,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.40,
                  ),
                ),
              ],
            ),
          ),
          hintText: translation(context).enterEmailId,
          counterText: "",
          disabledBorder: widget.enabledOutlineInputBorder,
          focusedBorder: widget.focusedOutlineInputBorder,
          enabledBorder: widget.enabledOutlineInputBorder,
          focusedErrorBorder: widget.errorOutlineInputBorder,
          errorText: errorMessageEmail.isEmpty ? null : errorMessageEmail,
          errorBorder: widget.errorOutlineInputBorder,
          labelStyle: GoogleFonts.poppins(
            color: widget.isEnabled ? AppColors.titleColor : AppColors.grayText,
            fontWeight: FontWeight.w500,
            height: 16 / 12,
            letterSpacing: 0.40,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintStyle: widget.customHintStyle,
          prefixStyle: widget.customPrefixStyle,
          contentPadding: EdgeInsets.fromLTRB(
              16 * widget.w, 12 * widget.h, 8 * widget.w, 12 * widget.h)),
    );
  }
}

class TextFieldName extends StatefulWidget {
  const TextFieldName(
      {super.key,
      this.isEnabled = true,
      required this.f,
      required this.w,
      required this.focusedOutlineInputBorder,
      required this.enabledOutlineInputBorder,
      required this.errorOutlineInputBorder,
      required this.customHintStyle,
      required this.customPrefixStyle,
      required this.h,
      required this.indexOfCurrent,
      required this.indexOfSaved,
      required this.controller});

  final double f;
  final double w;
  final OutlineInputBorder focusedOutlineInputBorder;
  final OutlineInputBorder enabledOutlineInputBorder, errorOutlineInputBorder;
  final bool isEnabled;
  final TextStyle customHintStyle;
  final TextStyle customPrefixStyle;
  final double h;
  final TextEditingController controller;
  final int? indexOfCurrent;
  final int? indexOfSaved;
  @override
  State<TextFieldName> createState() => _TextFieldNameState();
}

class _TextFieldNameState extends State<TextFieldName> {
  String validationInfoName = "";
  bool isValidName = true;

  void validateName(String name) {
    RegExp regex = AppConstants.VALIDATE_NAME_REGEX;
    CoinsToTripController coinsToTripController = Get.find();

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
    }
    // else if (name.length < 5) {
    //   setState(() {
    //     validationInfoName =
    //         translation(context).nameShouldBeAtleast5CharactersLong;
    //     isValidName = false;
    //   });
    // }
    else {
      setState(() {
        validationInfoName = '';
        isValidName = true;
      });
    }
  }

  void removeLeadingSpaces(String str) {
    // str.replaceAll(RegExp(r"\s+"), " ");
    widget.controller.text = str.trimLeft();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: GoogleFonts.poppins(
          height: 24 / 14,
          fontSize: 14 * widget.f,
          letterSpacing: 0.5,
          fontWeight: FontWeight.w500),
      enabled: widget.isEnabled,
      controller: widget.controller,
      maxLength: 50,
      validator: (value) {
        CoinsToTripController coinsToTripController = Get.find();
        if (!coinsToTripController.isNameAndRelationshipUniqueness(
                widget.indexOfCurrent, widget.indexOfSaved) &&
            widget.isEnabled) {
          return translation(context).userAlreadyExists;
        }
        return null;
      },
      onChanged: (value) {
        validateName(value);
        removeLeadingSpaces(value);
      },
      textCapitalization: TextCapitalization.words,
      inputFormatters: [
        HandleFirstSpaceAndDotInputFormatter(),
        FilteringTextInputFormatter.allow(AppConstants.VALIDATE_NAME_REGEX),
      ],
      decoration: InputDecoration(
          label: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: translation(context).name,
                  style: GoogleFonts.poppins(
                    color: AppColors.darkGreyText,
                    fontSize: 12 * widget.f,
                    height: 16 / 12,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.40,
                  ),
                ),
                TextSpan(
                  text: '*',
                  style: GoogleFonts.poppins(
                    color: AppColors.errorRed,
                    fontSize: 12 * widget.f,
                    height: 16 / 12,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.40,
                  ),
                ),
              ],
            ),
          ),
          hintText: translation(context).enterName,
          counterText: "",
          focusedBorder: widget.focusedOutlineInputBorder,
          enabledBorder: widget.enabledOutlineInputBorder,
          errorBorder: widget.errorOutlineInputBorder,
          focusedErrorBorder: widget.errorOutlineInputBorder,
          errorText: isValidName ? null : validationInfoName,
          labelStyle: GoogleFonts.poppins(
            color: widget.isEnabled ? AppColors.titleColor : AppColors.grayText,
            fontWeight: FontWeight.w500,
            height: 16 / 12,
            letterSpacing: 0.40,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintStyle: widget.customHintStyle,
          prefixStyle: widget.customPrefixStyle,
          disabledBorder: widget.enabledOutlineInputBorder,
          contentPadding: EdgeInsets.fromLTRB(
              16 * widget.w, 12 * widget.h, 8 * widget.w, 12 * widget.h)),
    );
  }
}

class RelationshipDropdown extends StatefulWidget {
  const RelationshipDropdown({
    Key? key,
    required this.f,
    required this.w,
    required this.h,
    required this.r,
    required this.isEditable,
    required this.indexOfCurrent,
  }) : super(key: key);

  final double f, w, h, r;
  final bool isEditable;
  final int? indexOfCurrent;

  @override
  _RelationshipDropdownState createState() => _RelationshipDropdownState();
}

class _RelationshipDropdownState extends State<RelationshipDropdown> {
  CoinsToTripController c = Get.find();
  RelationshipContoller relationshipListController = Get.find();
  late String selectedRelationship;
  bool showRelationErrorText = false;
  @override
  void initState() {
    super.initState();
    if (c.relationshipController != '') {
      selectedRelationship = c.relationshipController;
    } else {
      selectedRelationship = "Enter Relation";
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.indexOfCurrent != null) {
      List.from(relationshipListController.relationshipList)
          .removeAt(widget.indexOfCurrent!);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: 24 * widget.f + 24 * widget.h,
              width: double.infinity,
              padding: EdgeInsets.only(right: 8 * widget.w, left: 8 * widget.w),
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: showRelationErrorText
                        ? AppColors.errorRed
                        : AppColors.dividerColor,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(4 * widget.r)),
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  style: GoogleFonts.poppins(
                      color: AppColors.titleColor,
                      fontSize: 14 * widget.f,
                      fontWeight: FontWeight.w500),
                  menuMaxHeight: 240 * widget.h,
                  dropdownColor: AppColors.white,
                  onChanged: widget.isEditable
                      ? (String? relation) {
                        print("RELATIONSHIP VALUE --> ${c.relationshipController}");
                          setState(() {
                            selectedRelationship = relation!;
                            var relationshipCount = relationshipListController
                                .relationshipListWithCount
                                .firstWhere((relationship) =>
                                    relationship['relationShipName'] ==
                                    relation);
                            int travellersCountAllowed =
                                relationshipCount['count'];
                            int countInTravellers;
                            if (widget.indexOfCurrent == null) {
                              countInTravellers = c.travellers
                                  .where((traveler) =>
                                      traveler.relation == relation)
                                  .length;
                            } else {
                              countInTravellers = c.travellers
                                  .asMap()
                                  .entries
                                  .where((entry) =>
                                      entry.key != widget.indexOfCurrent &&
                                      entry.value.relation == relation)
                                  .length;
                            }
                            if (countInTravellers < travellersCountAllowed) {
                              showRelationErrorText = false;
                              selectedRelationship = relation!;
                              if (relationshipListController.relationshipList
                                  .contains(selectedRelationship)) {
                                c.relationshipController = selectedRelationship;
                              }
                            } else {
                              setState(() {
                                showRelationErrorText = true;
                                c.relationshipController = "";
                                c.isFormCompleted.value = false;
                              });
                            }
                            c.checkForm();
                          });
                        } 
                      : null,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: relationshipListController.relationshipList
                      .map((String items) {
                    return DropdownMenuItem<String>(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                ),
              ),
            ),
            Positioned(
              left: 16 * widget.w,
              top: -7.5 * widget.f,
              child: Container(
                color: AppColors.white,
                child: Row(
                  children: [
                    Text(
                      translation(context).relation,
                      style: GoogleFonts.poppins(
                        color: showRelationErrorText
                            ? AppColors.errorRed
                            : AppColors.darkGrey,
                        fontSize: 10 * widget.f,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      " *",
                      style: GoogleFonts.poppins(
                        color: AppColors.errorRed,
                        fontSize: 10 * widget.f,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (selectedRelationship != null &&
                selectedRelationship!.isNotEmpty)
              Positioned(
                left: 16 * widget.w,
                top: 12 * widget.h,
                child: Text(
                  selectedRelationship ?? "",
                  style: GoogleFonts.poppins(
                      color: relationshipListController.relationshipList
                                  .contains(selectedRelationship) &&
                              widget.isEditable
                          ? AppColors.darkGrey
                          : AppColors.lightGrey1,
                      fontSize: 14 * widget.f,
                      height: 24 / 14,
                      fontWeight: FontWeight.w500),
                ),
              ),
          ],
        ),
        Visibility(
          visible: showRelationErrorText,
          child: Text(
            translation(context).relationExist,
            style: GoogleFonts.poppins(
                fontSize: 10 * widget.f,
                color: AppColors.errorRed,
                fontWeight: FontWeight.w400),
          ),
        )
      ],
    );
  }
}
