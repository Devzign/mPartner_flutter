import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

import '../../../data/models/company_info_model.dart';
import '../../../data/models/help_support_send_suggestion_model.dart';
import '../../../state/contoller/help_and_support_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/displaymethods/display_methods.dart';
import '../../../utils/localdata/language_constants.dart';
import '../../../utils/routes/app_routes.dart';
import '../../../utils/utils.dart';
import '../../widgets/headers/back_button_header_widget.dart';
import '../../widgets/common_button.dart';
import '../../widgets/common_divider.dart';
import '../../widgets/verticalspace/vertical_space.dart';
import '../base_screen.dart';
import '../userprofile/user_profile_widget.dart';
import 'components/company_info_bottom_sheet.dart';

class HelpAndSupport extends StatefulWidget {
  final String? previousRoute;

  const HelpAndSupport({
    super.key,
    this.previousRoute,
  });

  @override
  State<HelpAndSupport> createState() => _HelpAndSupportState();
}

class _HelpAndSupportState extends BaseScreenState<HelpAndSupport> {
  HelpAndSupportController helpAndSupportController = Get.find();
  double variablePixelHeight = 0.0;
  double variablePixelWidth = 0.0;
  double pixelMultiplier = 0.0;
  double textFontMultiplier = 0.0;
  bool isButtonEnabled = false;
  List<String> imagePaths = [];
  TextEditingController msgController = TextEditingController();
  bool showLoader = false;
  Map<String, dynamic> contactDetail = {};

  @override
  void initState() {
    super.initState();
    imagePaths.add('');
    helpAndSupportController.clearHelpAndSupportController();
    getCompanyDetails();
  }

  @override
  void dispose() {
    msgController.dispose();
    super.dispose();
  }

  void getCompanyDetails() {
    helpAndSupportController.fetchCompanyInfo().then((_) {
      if (helpAndSupportController.contactUsDetails.isNotEmpty) {
        CompanyInfoModel result =
            helpAndSupportController.contactUsDetails.first;
        if (result.status == '200') {
          List<CompanyData> details = result.data.toList();
          for (var detail in details) {
            Map<String, dynamic> jsonMap = {
              'contactus_title': detail.contactus_title,
              'address': detail.address,
              'phoneno': detail.phoneno,
              'sales_support_phoneno': detail.sales_support_phoneno,
              'email': detail.email,
            };
            contactDetail.addAll(jsonMap);
          }
        }
      }
    });
  }

  @override
  Widget baseBody(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double pixelMultiplier =
        DisplayMethods(context: context).getPixelMultiplier();
    double textFontMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();
    this.variablePixelHeight = variablePixelHeight;
    this.variablePixelWidth = variablePixelWidth;
    this.textFontMultiplier = textFontMultiplier;
    this.pixelMultiplier = pixelMultiplier;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: Column(
            children: [
              HeaderWidgetWithBackButton(
                  heading: translation(context).helpAndSupport,
                  onPressed: () {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    } else {
                      Navigator.of(context).pushReplacementNamed(AppRoutes.homepage);
                    }
                  }),
              UserProfileWidget(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.only(right: 24 * variablePixelWidth),
                        child: GestureDetector(
                          onTap: () async {
                            showCompanyInfoBottomSheet(
                                context,
                                variablePixelWidth,
                                variablePixelHeight,
                                pixelMultiplier,
                                textFontMultiplier,
                                contactDetail);
                          },
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              translation(context).viewCompanyInfo,
                              style: GoogleFonts.poppins(
                                color: AppColors.lumiBluePrimary,
                                fontSize: 14 * textFontMultiplier,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.50 * variablePixelWidth,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const VerticalSpace(height: 16),
                      Padding(
                        padding: EdgeInsets.only(left: 24 * variablePixelWidth),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            translation(context).writeToUs,
                            textAlign: TextAlign.left,
                            style: GoogleFonts.poppins(
                              color: AppColors.black,
                              fontSize: 16 * textFontMultiplier,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.50 * variablePixelWidth,
                            ),
                          ),
                        ),
                      ),
                      const VerticalSpace(height: 12),
                      Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                                left: 24 * variablePixelWidth,
                                right: 24 * variablePixelWidth),
                            child: TextFormField(
                              controller: msgController,
                              onTapOutside: (event) {
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                              onChanged: (value) {
                                setState(() {
                                  if (msgController.text.isNotEmpty) {
                                    isButtonEnabled = true;
                                  } else {
                                    isButtonEnabled = false;
                                  }
                                });
                              },
                              minLines: 6,
                              maxLines: null,
                              maxLength: 500,
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(
                                    left: 12 * variablePixelWidth,
                                    right: 12 * variablePixelWidth,
                                    top: 12 * variablePixelHeight,
                                    bottom: 12 * variablePixelHeight),
                                border: const OutlineInputBorder(),
                                hintText: translation(context).writeYourMsgHere,
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
                          Padding(
                            padding: EdgeInsets.only(
                                right: 24 * variablePixelWidth,
                                top: 12 * variablePixelHeight),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Text(
                                "${msgController.text.length}/500",
                                style: GoogleFonts.poppins(
                                  color: AppColors.dividerColor,
                                  fontSize: 12 * textFontMultiplier,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.50 * variablePixelWidth,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const VerticalSpace(height: 12),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 24 * variablePixelWidth,
                                  right: 24 * variablePixelWidth),
                              child: Text(
                                imagePaths.length == 1
                                    ? translation(context).attachFiles
                                    : imagePaths.length == 2
                                        ? '${imagePaths.length - 1}  ${translation(context).imageAttached}'
                                        : '${imagePaths.length - 1} ${translation(context).imagesAttached}',
                                style: GoogleFonts.poppins(
                                  color: AppColors.darkGreyText,
                                  fontSize: 12 * textFontMultiplier,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.10 * variablePixelWidth,
                                ),
                              ),
                            ),
                            const VerticalSpace(height: 4),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 24 * variablePixelWidth,
                                  right: 24 * variablePixelWidth),
                              child: Text(
                                translation(context).supportedFormat,
                                style: GoogleFonts.poppins(
                                  color: AppColors.hintColor,
                                  fontSize: 12 * textFontMultiplier,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            const VerticalSpace(height: 12),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                childAspectRatio: (166.5 * variablePixelWidth) /
                                    (108.0 * variablePixelHeight),
                                crossAxisCount: 2,
                                crossAxisSpacing: 12.0 * variablePixelWidth,
                                mainAxisSpacing: 12.0 * variablePixelHeight,
                              ),
                              itemCount: imagePaths.length,
                              padding: EdgeInsets.fromLTRB(
                                  24 * variablePixelWidth,
                                  0,
                                  24 * variablePixelWidth,
                                  24 * variablePixelHeight),
                              itemBuilder: (BuildContext context, int index) {
                                return _buildContainer(index, context);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              CommonButton(
                  onPressed: () {
                    helpAndSupportController.clearHelpAndSupportController();
                    setState(() {
                      showLoader = true;
                    });
                    helpAndSupportController
                        .postSuggestionsHelpAndSupport(
                          msgController.text, imagePaths, widget.previousRoute)
                        .then((_) {
                      if (helpAndSupportController.postSuggestion.isNotEmpty) {
                        SendSuggestion result =
                            helpAndSupportController.postSuggestion.first;
                        if (result.status == '200') {
                          setState(() {
                            showLoader = false;
                          });
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            isDismissible: false,
                            enableDrag: false,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(25.0 * pixelMultiplier),
                              ),
                            ),
                            builder: (context) => WillPopScope(
                              onWillPop: () async {
                                setState(() {
                                  msgController.text = '';
                                  imagePaths = [];
                                  imagePaths.add('');
                                  isButtonEnabled = false;
                                });
                                // Navigator.pop(context);
                                Navigator.pop(context);
                                return false;
                              },
                              child: Padding(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                child: Wrap(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const VerticalSpace(height: 36),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 24.0 * variablePixelWidth,
                                              right: 24 * variablePixelWidth,
                                              top: 16 * variablePixelHeight),
                                          child: Text(
                                            translation(context).msgDelivered,
                                            style: GoogleFonts.poppins(
                                              color: AppColors.titleColor,
                                              fontSize: 20 * textFontMultiplier,
                                              fontWeight: FontWeight.w600,
                                              height:
                                                  0.06 * variablePixelHeight,
                                              letterSpacing:
                                                  0.50 * variablePixelWidth,
                                            ),
                                          ),
                                        ),
                                        const VerticalSpace(height: 16),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 24 * variablePixelWidth,
                                              right: 24 * variablePixelWidth),
                                          child: const CustomDivider(
                                              color: AppColors.dividerColor),
                                        ),
                                        const VerticalSpace(height: 24),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 24 * variablePixelWidth,
                                              right: 24 * variablePixelWidth),
                                          child: Text(
                                              translation(context)
                                                  .deliveredMsgText,
                                              style: GoogleFonts.poppins(
                                                color: AppColors.darkGreyText,
                                                fontSize:
                                                    16 * textFontMultiplier,
                                                fontWeight: FontWeight.w400,
                                                letterSpacing:
                                                    0.50 * variablePixelWidth,
                                              )),
                                        ),
                                        const VerticalSpace(height: 24),
                                        CommonButton(
                                          onPressed: () {
                                            setState(() {
                                              msgController.text = '';
                                              imagePaths = [];
                                              imagePaths.add('');
                                              isButtonEnabled = false;
                                            });
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pop();
                                          },
                                          isEnabled: true,
                                          buttonText: translation(context)
                                              .buttonOkayWithoutExclamation,
                                          backGroundColor:
                                              AppColors.lumiBluePrimary,
                                          textColor: AppColors.white,
                                          defaultButton: true,
                                          containerBackgroundColor:
                                              AppColors.white,
                                        ),
                                        const VerticalSpace(height: 32),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        } else {
                          setState(() {
                            showLoader = false;
                          });
                          Utils()
                              .showToast('Data not sent successfully', context);
                        }
                      } else {
                        Utils().showToast('Some error occurred', context);
                      }
                    });
                  },
                  isEnabled: isButtonEnabled & !showLoader,
                  showLoader: showLoader,
                  containerBackgroundColor: AppColors.white,
                  buttonText: translation(context).submit),
            ],
          ),
        ));
  }

  Widget _buildContainer(int currentIndex, BuildContext context) {
    final picker = ImagePicker();
    return Stack(
      clipBehavior: Clip.none,
      children: [
        DottedBorder(
          color: AppColors.lumiBluePrimary,
          strokeWidth: 1 * variablePixelWidth,
          borderType: BorderType.RRect,
          radius: Radius.circular(4 * pixelMultiplier),
          dashPattern: [6 * pixelMultiplier, 3 * pixelMultiplier],
          child: Stack(
            children: [
              currentIndex == 0
                  ? GestureDetector(
                      onTap: () async {
                        if (imagePaths.length > AppConstants.maxImagesCount) {
                          Utils().showLongToast(
                              translation(context).maxImagesCount, context);
                        } else {
                          final pickedFile = await picker.pickImage(
                            source: ImageSource.gallery,
                            imageQuality: AppConstants.imageCompressPercentage,
                          );

                          if (pickedFile != null) {
                            final mimeType = lookupMimeType(pickedFile.path);
                            if (mimeType != null &&
                                (mimeType == 'image/jpeg' ||
                                    mimeType == 'image/png')) {
                              setState(() {
                                imagePaths.add(pickedFile.path);
                              });
                            } else {
                              Utils().showLongToast(
                                  translation(context).invalidFileType,
                                  context);
                            }
                          }
                        }
                      },
                      child: Container(
                        width: 175 * variablePixelWidth,
                        height: 110 * variablePixelHeight,
                        decoration: ShapeDecoration(
                          color: AppColors.lumiLight5,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                                width: 1 * variablePixelWidth,
                                color: AppColors.white),
                            borderRadius:
                                BorderRadius.circular(4 * pixelMultiplier),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.add),
                              color: AppColors.lumiBluePrimary,
                              onPressed: () async {
                                if (imagePaths.length >
                                    AppConstants.maxImagesCount) {
                                  Utils().showLongToast(
                                      translation(context).maxImagesCount,
                                      context);
                                } else {
                                  final pickedFile = await picker.pickImage(
                                    source: ImageSource.gallery,
                                    imageQuality:
                                        AppConstants.imageCompressPercentage,
                                  );

                                  if (pickedFile != null) {
                                    final mimeType =
                                        lookupMimeType(pickedFile.path);
                                    if (mimeType != null &&
                                        (mimeType == 'image/jpeg' ||
                                            mimeType == 'image/png')) {
                                      setState(() {
                                        imagePaths.add(pickedFile.path);
                                      });
                                    } else {
                                      Utils().showLongToast(
                                          translation(context).invalidFileType,
                                          context);
                                    }
                                  }
                                }
                              },
                            ),
                            Text(
                              translation(context).attachImage,
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
                    )
                  : GestureDetector(
                      onTap: () async {
                        final result = await Navigator.pushNamed(
                          context,
                          AppRoutes.previewImage,
                          arguments: {
                            'path': imagePaths[currentIndex],
                            'onDeletePressed': () => removeImage(currentIndex),
                          },
                        ) as Map<String,
                            dynamic>?; // Cast to Map<String, dynamic>

                        if (result != null && result.containsKey('path')) {
                          setState(() {
                            imagePaths[currentIndex] = result['path'];
                          });
                        }
                      },
                      child: Container(
                        width: 175 * variablePixelWidth,
                        height: 110 * variablePixelHeight,
                        decoration: ShapeDecoration(
                          color: AppColors.lumiLight5,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                                width: 1 * variablePixelWidth,
                                color: AppColors.white),
                            borderRadius:
                                BorderRadius.circular(4 * pixelMultiplier),
                          ),
                        ),
                        child: Stack(
                          children: [
                            Center(
                              child: Container(
                                width: 45 * variablePixelWidth,
                                height: 98 * variablePixelHeight,
                                child: Image.file(
                                  File(imagePaths[currentIndex]),
                                  fit: BoxFit.scaleDown,
                                ),
                              ),
                            ),
                            Center(
                              child: Center(
                                child: GestureDetector(
                                  onTap: () async {
                                    final result = await Navigator.pushNamed(
                                      context,
                                      AppRoutes.previewImage,
                                      arguments: {
                                        'path': imagePaths[currentIndex],
                                        'onDeletePressed': () =>
                                            removeImage(currentIndex),
                                      },
                                    ) as Map<String,
                                        dynamic>?; // Cast to Map<String, dynamic>

                                    if (result != null &&
                                        result.containsKey('path')) {
                                      setState(() {
                                        imagePaths[currentIndex] =
                                            result['path'];
                                      });
                                    }
                                  },
                                  child: Container(
                                    height: 24 * variablePixelHeight,
                                    width: 24 * variablePixelWidth,
                                    padding: EdgeInsets.fromLTRB(
                                        4 * variablePixelWidth,
                                        4 * variablePixelHeight,
                                        4 * variablePixelWidth,
                                        4 * variablePixelHeight),
                                    decoration: BoxDecoration(
                                      color: AppColors.lumiBluePrimary,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(4 * pixelMultiplier)),
                                    ),
                                    child: Icon(
                                      Icons.remove_red_eye_outlined,
                                      color: AppColors.white,
                                      size: 16 * pixelMultiplier,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
            ],
          ),
        ),
        if (currentIndex != 0)
          Positioned(
            top: -8 * variablePixelHeight,
            right: -5 * variablePixelWidth,
            child: GestureDetector(
              onTap: () {
                // currentIndex to remove the specific container
                removeImage(currentIndex);
              },
              child: Container(
                height: 24 * variablePixelHeight,
                width: 24 * variablePixelWidth,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.lumiBluePrimary,
                ),
                child: InkWell(
                  onTap: () {
                    // currentIndex to remove the specific container
                    removeImage(currentIndex);
                  },
                  child: Icon(
                    Icons.close,
                    color: AppColors.white,
                    size: 15 * pixelMultiplier,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  void removeImage(int index) {
    setState(() {
      if (index > 0) {
        imagePaths.removeAt(index);
      }
    });
  }
}
