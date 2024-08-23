import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:multi_image_picker_plus/multi_image_picker_plus.dart';

import '../../../../utils/app_constants.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/localdata/language_constants.dart';

class FeedbackOptionWidget extends StatefulWidget {
  final void Function(String) onFeedbackWritten;
  final void Function(List<Asset>) onImagesSelected;

  FeedbackOptionWidget({
    required this.onFeedbackWritten,
    required this.onImagesSelected,
  });

  @override
  State<FeedbackOptionWidget> createState() => _FeedbackOptionWidgetState();
}

class _FeedbackOptionWidgetState extends State<FeedbackOptionWidget> {
  String feedback = "";
  List<Asset> selectedImages = <Asset>[];
  TextEditingController _feedbackController = TextEditingController();
  final ImagePicker imagePicker = ImagePicker();
  bool showAttachImageButton = true;
  List<Asset> images = <Asset>[];
  List<Asset> resultList = <Asset>[];
  String error = '';

  Future<void> loadAssets() async {
    try {
      resultList = await MultiImagePicker.pickImages(
        selectedAssets: images,
        iosOptions: IOSOptions(
          doneButton:
          UIBarButtonItem(title: translation(context).confirm, tintColor: AppColors.lumiBluePrimary,),
          cancelButton:
          UIBarButtonItem(title: translation(context).cancel, tintColor: AppColors.lumiBluePrimary,),
          albumButtonColor: AppColors.lumiBluePrimary,
        ),
        androidOptions: AndroidOptions(
          actionBarColor: AppColors.lumiBluePrimary,
          actionBarTitleColor: AppColors.lumiBluePrimary,
          statusBarColor: AppColors.lumiBluePrimary,
          actionBarTitle: translation(context).selectPhoto,
          allViewTitle: translation(context).allPhotos,
          useDetailsView: false,
          selectCircleStrokeColor: AppColors.lumiBluePrimary,
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
      print(error);
    }
    if (!mounted) return;
    setState(() {
      images = resultList;
      error = error;
      showAttachImageButton = false;
      selectedImages = images;
      if (selectedImages.length == 0) {
        showAttachImageButton = true;
      }
    });
    widget.onImagesSelected(selectedImages);
  }

  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 345 * w,
            height: 145 * h,
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                    width: 1 * w,
                    color: AppColors.lightGrey2
                ),
                borderRadius: BorderRadius.circular(8 * r),
              ),
            ),
            child:TextField(
              onTapOutside: (event) {
                print('onTapOutside');
                FocusManager.instance.primaryFocus?.unfocus();
              },
              controller: _feedbackController,
              maxLines: null,
              maxLength: AppConstants.feedbackInputMaxLength,
              onChanged: (value) {
                feedback = _feedbackController.text;
                widget.onFeedbackWritten(feedback);
              },
              decoration: InputDecoration(
                hintText: translation(context).writeYourFeedbackHere,
                counterText: "",
                hintStyle: GoogleFonts.poppins(
                  color: AppColors.lightGrey1,
                  fontSize: 12 * f,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.50,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.lightWhite1,
                    width: 1.0 * w,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.lightWhite1,
                    width: 1.0 * w,
                  ),
                ),
                isCollapsed: true,
                contentPadding: EdgeInsets.symmetric(
                    vertical: 8 * h,
                    horizontal: 12 * w
                ),
              ),
            ),
          ),
          // if (showAttachImageButton)
            Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        if (showAttachImageButton)
                        IconButton(
                          padding: EdgeInsets.all(0),
                          icon: Icon(
                            Icons.attach_file,
                            color: AppColors.lumiBluePrimary,
                          ),
                          onPressed: () => {
                            loadAssets()
                          },
                          visualDensity: VisualDensity(
                            horizontal: VisualDensity.minimumDensity,
                          ),
                        ),
                        if (showAttachImageButton)
                        GestureDetector(
                          onTap: () {
                            loadAssets();
                          },
                          child: Text(
                              translation(context).attachImage,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color: AppColors.lumiBluePrimary,
                                fontSize: 14 * f,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.50,
                              )
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top : 8 * h,
                          left: 12 * w
                      ),
                      child: Text(
                        '${_feedbackController.text.length}/500',
                        style: GoogleFonts.poppins(
                            color: AppColors.hintColor,
                            fontSize: 12 * f,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.50,
                        ),
                      ),
                    ),
                  ],
                )
            ),
          if (!showAttachImageButton)
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(top: 12 * h),
                height: 180 * h,
                child: Column(
                  children: [
                    Expanded(
                      child: GridView.builder(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8 * w,
                            vertical: 8 * h
                        ),
                        shrinkWrap: true,
                        itemCount: images.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: (166.5 * w) / (108.0 * h),
                          crossAxisSpacing: 12.0 * w,
                          mainAxisSpacing: 12.0 * h,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          Asset asset = images[index];
                          return Stack(
                              clipBehavior: Clip.none,
                              children: [
                                DottedBorder(
                                  color: AppColors.lumiBluePrimary,
                                  strokeWidth: 1 * w,
                                  borderType: BorderType.RRect,
                                  radius: Radius.circular(4 * r),
                                  dashPattern: [6 * w, 3 * w],
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(4 * r),
                                    child: Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 4.08 * w,
                                          vertical: 4.08 * h
                                      ),
                                      child: FittedBox(
                                        fit: BoxFit.contain,
                                        child: AssetThumb(
                                          asset: asset,
                                          width: 300,
                                          height: 300,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: -6,
                                  right: -6,
                                  child: GestureDetector(
                                    onTap: () {
                                      removeImage(index);
                                    },
                                    child: Container(
                                      height: 19 * h,
                                      width: 19 * w,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.lumiBluePrimary,
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          removeImage(index);
                                        },
                                        child: Icon(
                                          Icons.close,
                                          color: AppColors.white,
                                          size: 15 * r,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ]
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ]
    );
  }

  void removeImage(int index) {
    setState(() {
      images.removeAt(index);
      if(images.length == 0)
        showAttachImageButton = true;
    });
  }
}