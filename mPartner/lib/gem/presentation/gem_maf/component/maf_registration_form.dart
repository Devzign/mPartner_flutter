import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mpartner/gem/presentation/gem_maf/component/textfield_design_gemform.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';
import '../../../../../utils/utils.dart';
import '../../../../presentation/screens/ismart/registersales/uimodels/dealer_info.dart';
import '../../../../presentation/screens/network_management/dealer_electrician/components/custom_text_fields.dart';
import '../../../../presentation/screens/userprofile/common_upload_bottom_sheet.dart';
import '../../../../presentation/widgets/calendar_widget/custom_calendar_view.dart';
import '../../../../presentation/widgets/horizontalspace/horizontal_space.dart';
import '../../../../presentation/widgets/verticalspace/vertical_space.dart';
import '../../../../utils/app_constants.dart';
import '../../../data/models/gem_option.dart';
import '../../../state/controller/maf_registrationform_controller.dart';
import '../../../utils/gem_app_constants.dart';


class MafRegistrationForm extends StatefulWidget {
  final String selectedUserType;
  final String gstNumber;

  const MafRegistrationForm(this.selectedUserType, this.gstNumber, {super.key});

  @override
  State<MafRegistrationForm> createState() => _GemMafRegistrationForm();
}

class _GemMafRegistrationForm extends State<MafRegistrationForm> {

  late Widget _pdfPreviewWidget;
  bool showPdfPreview = false;
  String? selectedImage;
  late Key _pdfPreviewKey;
  List<GemOption> participantTypeList = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  String saleTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  bool isPhotoClickedFront = false;
  late DealerInfo isParticipantType;
  MafRegistrationFormController controller = Get.find();
  DateTime selectedDateValue = DateTime.now();

  void _handleDateSelected(DateTime value, String type) {
    print('date is $value');
    setState(() {
      selectedDate = value;
      saleTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
      print('secondary saleTime is $saleTime');
    });
  }

  void _verifyBidNumber(String bidNumber, String gst) {
    FocusScope.of(context).unfocus();
    if (controller.validateBidNumberInputField(bidNumber)) {
        controller.verifyBidNumber(bidNumber, gst,  context);
    } else {
      Utils().showToast(translation(context).enterAvalidNumber, context);
    }
  }

  @override
  void initState() {
    super.initState();

    controller.participantType = controller.gemText;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        participantTypeList = controller.participentTypeList;
      });
      if(participantTypeList.isEmpty){
        controller.getParticipantList(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double textFontMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();

    double pixelMultiplier =
        DisplayMethods(context: context).getPixelMultiplier();

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
                    TextFieldDesignGemForm(
                      context: context,
                      controller: controller.participantController,
                      keyboardType: TextInputType.none,
                      isMandatory: true,
                      labelText: translation(context).participateType,
                      hintText: translation(context).chooseparticipateType,
                      trailingIcon:
                      const Icon(Icons.keyboard_arrow_down_outlined),
                      onChangedFunction: (value) {
                        print('selected value is   $value');
                        controller.participantType = value;
                      },
                      inputFormatters: [],
                      readOnly: true,
                      isSolutionTypeSelector: true,
                      solutionTypes: participantTypeList,
                    ),

                    SizedBox(
                      height: 24 * variablePixelHeight,
                    ),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              height: (controller.bidNumberErrorText.isNotEmpty
                                  ? (95 * variablePixelHeight)
                                  : (65 * variablePixelHeight)),
                              child: CustomTextField(
                                controller: controller.bidNumberController,
                                labelText: translation(context).bidNumber,
                                hintText: translation(context).enterbidNumber,
                                isEnabled: controller.isButtonEnabled.value,
                                errorText: controller.bidNumberErrorText.value,
                                keyboardType: TextInputType.text,
                                isAllCaps: true,
                                maxLength: GemAppConstants.bidNumberInputMaxLength,
                                onValueChanged: (value) {
                                  print('selected_value ==>>  $value');
                                  if (value.isNotEmpty) {
                                    controller.validateBidNumber(value, context);
                                  }else{
                                    controller.bidNumberErrorText.value = "";
                                  }
                                },
                                isManditory: true,
                                context: context,
                              ),
                            ),
                          ),
                          const HorizontalSpace(width: 20),
                          Container(
                            height: 55,
                            width: 55,
                            decoration: BoxDecoration(
                              color: controller.isButtonEnabled.value ? AppColors.lumiBluePrimary : AppColors.grey97,
                              //color: AppColors.lumiBluePrimary,
                              borderRadius: BorderRadius.circular(
                                  4), // Adjust border radius as needed
                            ),
                            child: IconButton(

                              onPressed: controller.isButtonEnabled.value
                                  ? () {
                                _verifyBidNumber(
                                    controller.bidNumberController.text.trim(), widget.gstNumber);
                              }
                                  : null,
                              icon: const Icon(Icons.arrow_forward),
                              color: controller.isButtonEnabled.value ? Colors.white : Colors.grey, // Adjust color based on state





                              // onPressed: () {
                              //   _verifyBidNumber(
                              //       controller.bidNumberController.text.trim(), widget.gstNumber);
                              //   // Add functionality for the arrow button
                              // },
                              // icon: const Icon(Icons.arrow_forward),
                              // color: Colors
                              //     .white, // You may adjust the color of the arrow icon
                            ),
                          ),
                        ]),
                    SizedBox(height: 24 * variablePixelHeight),
                    Visibility(
                      visible: controller.isvalidBidNumber
                          .value, // Assuming isvalidBidNumber is a RxBool
                      child: Column(
                        children: [
                          Container(),
                          SizedBox(
                            height: (controller.pubDateErrorText.isNotEmpty
                                ? (95 * variablePixelHeight)
                                : (65 * variablePixelHeight)),
                            child: CustomCalendarView(
                              labelText: translation(context).bidPubDate,
                              hintText: 'DD/MM/YYYY',
                              icon: const Icon(
                                Icons.calendar_month_outlined,
                                color: AppColors.grey,
                              ),
                              calendarType:
                              GemAppConstants.singleSelectionCalenderType,
                              dateFormat: "dd/MM/yyyy",
                              initialDateSelection: selectedDateValue,
                              errorText: "",
                              calendarStartDate: DateTime(1900),
                              calendarEndDate:
                                  selectedDate.add(Duration(days: 360)),
                              singleDateEditController:
                                  controller.datePublishController,
                              onDateSelected: (selectedDate) {
                                print("view1 ${selectedDate}");
                                setState(() {
                                  controller.datePublishController.text =
                                      selectedDate;
                                  controller.dateDueController.text = "";
                                  var inputFormat = DateFormat('dd/MM/yyyy');
                                  var currentSelctedDate =
                                      inputFormat.parse(selectedDate);
                                  selectedDateValue = currentSelctedDate;
                                  _handleDateSelected(
                                      currentSelctedDate, "DatePicker");
                                });
                              },
                              onDateRangeSelected: (startDate, endDate) {
                                print("view2 ${startDate}- ${endDate}");
                              },
                            ),
                          ),

                          Container(),
                          SizedBox(
                            height: 24 * variablePixelHeight,
                          ),
                          Container(),

                          SizedBox(
                            height: (controller.dueDateErrorText.isNotEmpty
                                ? (95 * variablePixelHeight)
                                : (65 * variablePixelHeight)),
                            child: CustomCalendarView(
                              labelText: translation(context).bidDueDate,
                              hintText: 'DD/MM/YYYY',
                              icon: const Icon(
                                Icons.calendar_month_outlined,
                                color: AppColors.grey,
                              ),
                              calendarType:
                              GemAppConstants.singleSelectionCalenderType,
                              dateFormat: "dd/MM/yyyy",
                              initialDateSelection: selectedDateValue,
                              errorText:
                                  '', //controller.dueDateErrorText.value,
                              calendarStartDate: selectedDateValue,
                              calendarEndDate: selectedDate.add(Duration(
                                  days:
                                  360)), // Initially set to 360 days from the current date

                              singleDateEditController:
                                  controller.dateDueController,
                              onDateSelected: (selectedDate) {
                                print("view1 ${selectedDate}");
                                setState(() {
                                  controller.dateDueController.text =
                                      selectedDate;
                                  var inputFormat = DateFormat('dd/MM/yyyy');
                                  var currentSelctedDate =
                                      inputFormat.parse(selectedDate);
                                  selectedDateValue = currentSelctedDate;
                                  _handleDateSelected(
                                      currentSelctedDate, "DatePicker");
                                });
                              },
                              onDateRangeSelected: (startDate, endDate) {
                                print("view2 ${startDate}- ${endDate}");
                              },
                            ),
                          ),
                          Container(),
                          SizedBox(
                            height: 24 * variablePixelHeight,
                          ),

                          Container(
                            height: (controller.gstNumberErrorText.isNotEmpty
                                ? (95 * variablePixelHeight)
                                : (65 * variablePixelHeight)),
                            child: CustomTextField(
                              controller: controller.gstNumberController,
                              labelText: translation(context).gstinnumber,
                              hintText: translation(context).enterfirmgstin,
                              keyboardType: TextInputType.text,
                              context: context,
                              isEnabled: !controller.isGstExist.value,
                              isAllCaps: true,
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(RegExp(r'\s')),
                              ],
                              maxLength: GemAppConstants.gstNumberInputMaxLength,
                              errorText: controller.gstNumberErrorText.value,
                              onValueChanged: (value) {
                                if (value.isNotEmpty) {
                                  bool status =
                                      controller.validateGST(value, context);
                                  if (status) {
                                    //controller.enableProceed.value = true;
                                    controller.gstNumberErrorText.value = "";
                                  } else {
                                    //controller.enableProceed.value = false;
                                    controller.gstNumberErrorText.value = translation(context).invalidGstin;
                                  }
                                }
                              },
                              isManditory: true,
                            ),
                          ),
                          SizedBox(
                            height: 10 * variablePixelHeight,
                          ),

                          Row(
                            children: [
                              Text(
                                translation(context).uploadtenderdocuments,
                                style: GoogleFonts.poppins(
                                  color: AppColors.blackText,
                                  fontSize: 12 * textFontMultiplier,
                                  fontWeight: FontWeight.w400,
                                  height: 12 / 12,
                                  letterSpacing: 0.40,
                                ),
                              ),
                              Text(
                                '*',
                                style: GoogleFonts.poppins(
                                  color: AppColors.errorRed,
                                  fontSize: 12 * textFontMultiplier,
                                  fontWeight: FontWeight.w500,
                                  height: 20 / 12,
                                  letterSpacing: 0.1,
                                ),
                              ),
                            ],
                          ),
                          const VerticalSpace(height: 12),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              margin: EdgeInsets.only(
                                            left: 8 * variablePixelWidth),
                              child: DottedBorder(
                                color: AppColors.lumiBluePrimary,
                                strokeWidth: 1 * variablePixelWidth,
                                borderType: BorderType.RRect,
                                radius: Radius.circular(4 * pixelMultiplier),
                                dashPattern: [6 * pixelMultiplier, 3 * pixelMultiplier],
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
                                              controller.docImagePath =imagePath;
                                              controller.enableProceed .value = true;
                                            });
                                          } else {
                                            setState(() {
                                              showPdfPreview = false;
                                              selectedImage = imagePath;
                                              controller.docImagePath =imagePath;
                                              controller.enableProceed .value = true;
                                            });
                                          }
                                          //checkAllFields();
                                          logger.d('selected image is $selectedImage');
                                        },
                                        isAllowedPDFAndImage:true
                                    );
                                  },
                                  child: Container(
                                    width: 175 * variablePixelWidth,
                                    height: 110 * variablePixelHeight,
                                    decoration: ShapeDecoration(
                                      color: AppColors.lumiLight5,
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            width: 1 * pixelMultiplier, color: AppColors.white),
                                        borderRadius: BorderRadius.circular(4 * pixelMultiplier),
                                      ),
                                    ),
                                    child: (showPdfPreview == true)
                                        ? Stack(
                                      children: [
                                        Positioned(
                                          child: Padding(
                                              padding: EdgeInsets.fromLTRB(5 * variablePixelWidth, 5 * variablePixelHeight, 5 * variablePixelWidth, 5 * variablePixelHeight),
                                              child: KeyedSubtree(
                                                key: _pdfPreviewKey,
                                                child: _pdfPreviewWidget,
                                              )),
                                        ),
                                        Positioned(
                                          top: 20 * variablePixelHeight,
                                          right: 20 * variablePixelWidth,
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
                                                          controller.docImagePath =imagePath;
                                                          controller.enableProceed .value = true;
                                                        });
                                                      } else {
                                                        setState(() {
                                                          showPdfPreview = false;
                                                          selectedImage = imagePath;
                                                          controller.docImagePath =imagePath;
                                                          controller.enableProceed .value = true;
                                                        });
                                                      }
                                                     // checkAllFields();
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
                                                  5 * variablePixelWidth, 5 * variablePixelHeight, 5 * variablePixelWidth, 5 * variablePixelHeight),
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
                                          top: 20 * variablePixelHeight,
                                          right: 20 * variablePixelWidth,
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
                                                          controller.docImagePath =imagePath;
                                                          controller.enableProceed .value = true;
                                                        });
                                                      } else {
                                                        setState(() {
                                                          showPdfPreview = false;
                                                          selectedImage = imagePath;
                                                          controller.docImagePath =imagePath;
                                                          controller.enableProceed .value = true;
                                                        });
                                                      }
                                                     // checkAllFields();
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
                                          translation(context).addDocument,
                                          style: GoogleFonts.poppins(
                                            color: AppColors.lumiBluePrimary,
                                            fontSize: 12 * textFontMultiplier,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 0.50 * variablePixelWidth,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (selectedImage != null)
                            const VerticalSpace(height: 8),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              selectedImage != null
                                  ? selectedImage!.split("/").last
                                  : "",
                              style: GoogleFonts.poppins(
                                color: AppColors.grayText,
                                fontSize: 12 * textFontMultiplier,
                                fontWeight: FontWeight.w500,
                                height: 16 / 12,
                                letterSpacing: 0.10,
                              ),
                            ),
                          ),
                          if (selectedImage != null)
                            const VerticalSpace(height: 16),

                          Padding(
                            padding: EdgeInsets.only(left: 2 * variablePixelWidth),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                translation(context).productRequirement,
                                style: GoogleFonts.poppins(
                                  color: AppColors.blackText,
                                  fontSize: 12 * textFontMultiplier,
                                  fontWeight: FontWeight.w400,
                                  height: 12 / 12,
                                  letterSpacing: 0.40,
                                ),
                              ),
                            ),
                          ),
                          const VerticalSpace(height: 12),
                          Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                    left: 5 * variablePixelWidth,
                                    right: 5 * variablePixelWidth),
                                child: TextFormField(
                                  controller: controller.writeToUsController,
                                  onTapOutside: (event) {
                                    FocusManager.instance.primaryFocus?.unfocus();
                                  },
                                  onChanged: (value) {
                                    // setState(() {
                                    //   if (controller.writeToUsController.text.isNotEmpty) {
                                    //     isButtonEnabled = true;
                                    //   } else {
                                    //     isButtonEnabled = false;
                                    //   }
                                    // });
                                  },
                                  minLines: 4,
                                  maxLines: null,
                                  keyboardType: TextInputType.multiline,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(
                                        left: 12 * variablePixelWidth,
                                        right: 12 * variablePixelWidth,
                                        top: 12 * variablePixelHeight,
                                        bottom: 12 * variablePixelHeight),
                                    border: const OutlineInputBorder(),
                                    hintText: translation(context).writeToUs,
                                    hintStyle: GoogleFonts.poppins(
                                      color: AppColors.dividerColor,
                                      fontSize: 12 * textFontMultiplier,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.50 * variablePixelWidth,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: AppColors.white_234,
                                        width: 1.0 * variablePixelWidth,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: AppColors.white_234,
                                        width: 1.0 * variablePixelWidth,
                                      ),
                                    ),
                                    counterText: "",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(),
                  ],
                ),
              );
            })));
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

  // void _handleParticipantSelected(DealerInfo value, String type) {
  //   setState(() {
  //     isParticipantType = value;
  //   });
  // }
}
