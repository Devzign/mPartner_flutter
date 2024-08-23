import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../state/contoller/create_dealer_electrician_controller.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../userprofile/common_upload_bottom_sheet.dart';
import '../../network_home_page.dart';
import 'dashed_rectangle_widget.dart';

class ImageWidget extends StatefulWidget {
  final String? path;
  final String? content;
  final ImageTypeData? type;

  const ImageWidget(this.path, this.type, this.content, {super.key});

  @override
  State<ImageWidget> createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {
  CreateDealerElectricianController controller = Get.find();
  late double variablePixelHeight;
  late double variablePixelWidth;

  @override
  Widget build(BuildContext context) {
    var variablePixelMultiplier =
        DisplayMethods(context: context).getPixelMultiplier();
    variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    var textMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        (widget.path!.isNotEmpty)
            ? Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 108 * variablePixelHeight,
                    width: 166 * variablePixelWidth,
                    child: DashedRect(
                        color: AppColors.lumiBluePrimary,
                        strokeWidth: 2.0,
                        gap: 5.0),
                  ),
                  ClipRRect(
                      borderRadius:
                          BorderRadius.circular(6.0 * variablePixelMultiplier),
                      child: Image.file(
                        File(widget.path!),
                        fit: BoxFit.cover,
                        height: 96 * variablePixelHeight,
                        width: 153 * variablePixelWidth,
                      )),
                  Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                          height: 30 * variablePixelHeight,
                          width: 30 * variablePixelWidth,
                          padding: EdgeInsets.all(3 * variablePixelMultiplier),
                          margin: EdgeInsets.only(
                              top: 10 * variablePixelHeight,
                              right: 10 * variablePixelWidth),
                          child: InkWell(
                              onTap: () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                showUploadBottomSheet(context, widget.content!,
                                    (String imageCaptured) {
                                  if (widget.type == ImageTypeData.pan) {
                                    controller.panImagePath.value =
                                        imageCaptured;
                                  } else if (widget.type ==
                                      ImageTypeData.govt_doc_front) {
                                    controller.govtDocFrontImagePath.value =
                                        imageCaptured;
                                  } else if (widget.type ==
                                      ImageTypeData.govt_doc_back) {
                                    controller.govtDocBackImagePath.value =
                                        imageCaptured;
                                  }
                                });
                              },
                              child: Container(
                                  child: SvgPicture.asset(
                                      "assets/mpartner/network/image_edit.svg"))))),
                ],
              )
            : InkWell(
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  showUploadBottomSheet(context, widget.content!,
                      (String imageCaptured) {
                    if (widget.type == ImageTypeData.pan) {
                      controller.panImagePath.value = imageCaptured;
                    } else if (widget.type == ImageTypeData.govt_doc_front) {
                      controller.govtDocFrontImagePath.value = imageCaptured;
                    } else if (widget.type == ImageTypeData.govt_doc_back) {
                      controller.govtDocBackImagePath.value = imageCaptured;
                    }
                  });
                },
                child: Container(
                  alignment: Alignment.centerLeft,
                  height: 108 * variablePixelHeight,
                  width: 166 * variablePixelWidth,
                  child: SvgPicture.asset(
                      (ImageTypeData.govt_doc_back == widget.type)
                          ? "assets/mpartner/network/add_back_image.svg"
                          : "assets/mpartner/network/add_front_image.svg"),
                )),
        SizedBox(
          height: 15 *variablePixelHeight,
        ),
        Container(
          child: Text(
            (widget.path != null && widget.path!.isNotEmpty)
                ? (widget.path!.split("/").last.length < 20)
                    ? widget.path!.split("/").last + ".jpg"
                    : widget.path!.split("/").last.substring(0, 20) + ".jpg"
                : "Untitled.jpeg",
            style: GoogleFonts.poppins(
              fontSize: 12.0 * textMultiplier,
              letterSpacing: 0.10,
              fontWeight: FontWeight.w500,
              color: AppColors.grayText,
            ),
          ),
        ),
      ],
    );
  }
}
