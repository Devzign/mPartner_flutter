import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/displaymethods/display_methods.dart';
import '../../../utils/localdata/language_constants.dart';
import '../../../utils/utils.dart';
import '../../widgets/headers/header_widget_with_right_align_action_button.dart';
import '../../widgets/horizontalspace/horizontal_space.dart';
import '../../widgets/verticalspace/vertical_space.dart';
import '../base_screen.dart';

class PreviewScreen extends StatefulWidget {
  const PreviewScreen({super.key});

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends BaseScreenState<PreviewScreen> {
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

    Map<String, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    String imagePath = arguments['path'] as String;
    Function onDeletePressed = arguments['onDeletePressed'] as Function;
    return Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: Column(
            children: [
              HeaderWidgetWithRightAlignActionButton(text: translation(context).preview),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 24 * variablePixelWidth,
                        right: 24 * variablePixelWidth),
                    child: Column(
                      children: [
                        Image.file(
                          File(imagePath),
                        ),
                        const VerticalSpace(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: 24 * variablePixelHeight,
                    right: 24 * variablePixelWidth,
                    left: 24 * variablePixelWidth,
                    bottom: 24 * variablePixelHeight),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        width: 165 * variablePixelWidth,
                        height: 48 * variablePixelHeight,
                        child: ElevatedButton(
                          onPressed: () {
                            onDeletePressed();
                            Navigator.pop(context);
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                AppColors.white),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    100 * pixelMultiplier),
                                side:
                                    const BorderSide(color: AppColors.errorRed),
                              ),
                            ),
                          ),
                          child: Text(
                            translation(context).delete,
                            style: GoogleFonts.poppins(
                              color: AppColors.errorRed,
                              fontSize: 14 * textFontMultiplier,
                              fontWeight: FontWeight.w500,
                              height: 0.10 * variablePixelHeight,
                              letterSpacing: 0.10 * variablePixelWidth,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const HorizontalSpace(width: 16),
                    Expanded(
                      child: SizedBox(
                        width: 165 * variablePixelWidth,
                        height: 48 * variablePixelHeight,
                        child: ElevatedButton(
                          onPressed: () async {
                            final pickedFile = await ImagePicker()
                                .pickImage(source: ImageSource.gallery);
                            if (pickedFile != null) {
                              final mimeType = lookupMimeType(pickedFile.path);
                              if (mimeType != null &&
                                  (mimeType == 'image/jpeg' ||
                                      mimeType == 'image/png')) {
                                Navigator.pop(
                                    context, {'path': pickedFile.path});
                              } else {
                                Utils().showLongToast(
                                    translation(context).invalidFileType,
                                    context);
                              }
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                AppColors.lumiBluePrimary),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    100 * pixelMultiplier),
                              ),
                            ),
                          ),
                          child: Text(
                            translation(context).uploadAgain,
                            style: GoogleFonts.poppins(
                              color: AppColors.white,
                              fontSize: 14 * textFontMultiplier,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.10 * variablePixelWidth,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
