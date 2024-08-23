import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../data/models/network_management_model/state_city_district_info.dart';
import '../../../../../state/contoller/create_dealer_electrician_controller.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_constants.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';
import '../../../userprofile/upperCaseFormatter.dart';
import '../../network_home_page.dart';
import 'custom_check_box.dart';
import 'custom_text_fields.dart';
import 'dropddown_widget.dart';
import 'image_widget.dart';

class DocumentUploadForm extends StatefulWidget {
  final String selectedUserType;

  const DocumentUploadForm(this.selectedUserType, {super.key});

  @override
  State<DocumentUploadForm> createState() => _DocumentUploadFormState();
}

class _DocumentUploadFormState extends State<DocumentUploadForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  CreateDealerElectricianController controller = Get.find();

  late double variablePixelHeight;
  late double variablePixelWidth;

  @override
  Widget build(BuildContext context) {
    variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    var textMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus
                                    ?.unfocus(),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
              margin: EdgeInsets.only(top: 20.0 * variablePixelWidth),
              child: Obx(() {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomTextField(
                      controller: controller.panNumberController,
                      labelText: translation(context).pan,
                      hintText: translation(context).enterPanCardNumber,
                      errorText: controller.panNumberErrorText.value,
                      focusNode: controller.panFocusNode,
                      maxLength: AppConstants.panInputMaxLength,
                      inputFormatters: [
                        UpperCaseTextFormatter(),
                        FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]"))
                      ],
                      keyboardType: TextInputType.text,
                      isAllCaps: true,
                      onValueChanged: (value) {
                        checkisTextEmpty();
                        if (value.isNotEmpty) {
                          controller.validatePancard(value, context);
                        } else {
                          controller.panNumberErrorText.value = "";
                        }
                      },
                      isManditory: true,
                      context: context,
                    ),
                    SizedBox(
                      height: 24 * variablePixelHeight,
                    ),
                    Container(
                      child: Text(
                        translation(context).panUpload,
                        style: GoogleFonts.poppins(
                          fontSize: 14.0 * textMultiplier,
                          letterSpacing: 0.10,
                          height: 0.10,
                          fontWeight: FontWeight.w500,
                          color: AppColors.grayText,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 24 * variablePixelHeight,
                    ),
                    Obx(() {
                      checkisTextEmpty();
                      return ImageWidget(controller.panImagePath.value ?? "",
                          ImageTypeData.pan, translation(context).panUpload);
                    }),
                    SizedBox(
                      height: 30 * variablePixelHeight,
                    ),
                    DropdownWidget(
                        textEditController: controller.govtIdTypeController,
                        errorText: "",
                        labelText: translation(context).govtIdType,
                        hintText: translation(context).idTypeHint,
                        icon: Icon(Icons.keyboard_arrow_down),
                        dropDownType: "govt_id_type",
                        onDropDownSelected: (value, type) {
                          // _handleDateSelected(value, type);
                          checkisTextEmpty();
                          GovtIdTypeInfo selectedInfo = value as GovtIdTypeInfo;
                          controller.documentType.value = selectedInfo.name!!;
                          controller.govtIdNumberController.text="";
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
                    Obx(() => CustomTextField(
                          controller: controller.govtIdNumberController,
                          labelText: translation(context).idNumber,
                          hintText: "Enter ${controller.documentType} number",
                          maxLength: controller.documentType
                                  .toLowerCase()
                                  .contains("gst")
                              ? AppConstants.gstNumberInputMaxLength
                              : controller.documentType
                                      .toLowerCase()
                                      .contains("aadhar")
                                  ? AppConstants.aadharInputMaxLength
                                  : AppConstants.gstNumberInputMaxLength,
                          /* translation(context).idNumberHint,*/
                          inputFormatters: controller.documentType
                                  .toLowerCase()
                                  .contains("gst")
                              ? [
                                  UpperCaseTextFormatter(),
                                  FilteringTextInputFormatter.allow(
                                      RegExp("[0-9a-zA-Z]"))
                                ]
                              : controller.documentType
                                      .toLowerCase()
                                      .contains("aadhar")
                                  ? [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[0-9]')),
                                    ]
                                  : [
                                      UpperCaseTextFormatter(),
                                      FilteringTextInputFormatter.allow(
                                          RegExp("[0-9a-zA-Z]"))
                                    ],
                          errorText: controller.govtIdNumberErrorText.value,
                          keyboardType: TextInputType.text,
                          isAllCaps: true,
                          onValueChanged: (value) {
                            checkisTextEmpty();
                            controller.govtIdNumberErrorText.value = "";
                          },
                          isManditory: true,
                          context: context,
                        )),
                    SizedBox(
                      height: 24 * variablePixelHeight,
                    ),
                    Container(
                      child: Text(
                        "Upload ${controller.documentType} (front & back)",
                        style: GoogleFonts.poppins(
                          fontSize: 14.0 * textMultiplier,
                          letterSpacing: 0.10,
                          height: 0.10,
                          fontWeight: FontWeight.w500,
                          color: AppColors.grayText,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 24 * variablePixelHeight,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() {
                          checkisTextEmpty();
                          return Expanded(
                            child: ImageWidget(
                                controller.govtDocFrontImagePath.value ?? "",
                                ImageTypeData.govt_doc_front,
                                /* translation(context).uploadIdFront)*/
                                "Upload ${controller.documentType} (Front)"),
                          );
                        }),
                        SizedBox(
                          width: 15 * variablePixelWidth,
                        ),
                        Expanded(
                          child: Obx(() {
                            checkisTextEmpty();
                            return ImageWidget(
                                controller.govtDocBackImagePath.value ?? "",
                                ImageTypeData.govt_doc_back,
                                "Upload ${controller.documentType} (Back)");
                            /*translation(context).uploadIdBack);*/
                          }),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30 * variablePixelHeight,
                    ),
                    Obx(
                      () => InkWell(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        onTap: () {
                          controller.isCheckBoxChecked.value = !controller.isCheckBoxChecked.value;
                          checkisTextEmpty();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                          Container(
                          margin: EdgeInsets.only(
                              bottom: 10 * variablePixelHeight),
                          child: CustomCheckbox(
                            side: BorderSide(
                                color: AppColors.grayText.withOpacity(0.7),
                                width: 1.5),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            value: controller.isCheckBoxChecked.value,
                            activeColor: AppColors.lumiBluePrimary,
                            onChanged: (value) {
                              controller.isCheckBoxChecked.value =
                                  value ?? false;
                              checkisTextEmpty();
                            },
                          ),
                        ),
                        Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                                left: 10 * variablePixelWidth),
                            child: Text(
                              translation(context).conditionCheck1,
                              style: GoogleFonts.poppins(
                                fontSize: 14.0 * textMultiplier,
                                letterSpacing: 0.10,
                                height: 0.10,
                                fontWeight: FontWeight.w500,
                                color: AppColors.grayText,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 24 * variablePixelHeight,
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                left: 10 * variablePixelWidth,bottom: 10),
                            child: Text(
                              translation(context).conditionCheck2,
                              style: GoogleFonts.poppins(
                                fontSize: 14.0 * textMultiplier,
                                letterSpacing: 0.10,
                                height: 0.10,
                                fontWeight: FontWeight.w500,
                                color: AppColors.grayText,
                              ),
                            ),
                          ),
                        ],
                        ),
                      ],
                    ),
                  )
                )
                              ],
                            );
          })),
        ],
      ),
    );
  }

  void checkisTextEmpty() {
    if (controller.panNumberController.text.trim().isNotEmpty &&
        controller.govtIdNumberController.text.trim().isNotEmpty &&
        controller.govtIdTypeController.text.trim().isNotEmpty &&
        controller.panImagePath.trim().isNotEmpty &&
        controller.govtDocFrontImagePath.trim().isNotEmpty &&
        controller.govtDocBackImagePath.trim().isNotEmpty &&
        controller.isCheckBoxChecked.value) {
      controller.enableDocSubmit.value = true;
      // controller.emptyValidation();
    } else {
      controller.enableDocSubmit.value = false;
      //  controller.emptyValidation();
    }
  }
}
