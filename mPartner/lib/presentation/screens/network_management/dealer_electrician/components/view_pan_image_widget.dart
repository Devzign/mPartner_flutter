import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../data/models/network_management_model/dealer_electrician_details_model.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';
import 'search_header.dart';

class ViewPanImageBottomSheetWidget extends StatefulWidget {
  final Function(String) onItemSelected;
  final String? contentTiltle;
  final DealerElectricianDetail? data;
  final double? height;
  final double? bottomsheetHeight;
  final bool? isVerticleScroll;

  const ViewPanImageBottomSheetWidget(
      {required this.onItemSelected,
      this.contentTiltle,
      this.data,
      this.height,
      this.bottomsheetHeight,
      this.isVerticleScroll,
      super.key});

  @override
  State<ViewPanImageBottomSheetWidget> createState() =>
      _ViewPanImageBottomSheetWidget();
}

class _ViewPanImageBottomSheetWidget
    extends State<ViewPanImageBottomSheetWidget> {
  String contentTiltle = "";

  @override
  void initState() {
    contentTiltle = widget.contentTiltle!;
    super.initState();
  }

  void _handleStateSelected(String stateInfo) {
    widget.onItemSelected(
        stateInfo); // Invoke the callback passed from the parent
  }

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    var variablePixelMultiplier =
        DisplayMethods(context: context).getPixelMultiplier();
    var variableFontPixelMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();
    return Container(
      margin: EdgeInsets.only(left: 10 * variablePixelWidth),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        SearchHeaderWidget(
          title: contentTiltle,
          onClose: () => Navigator.of(context).pop(),
        ),
        Container(
          width: variablePixelWidth * 392,
          height: widget.bottomsheetHeight,
          padding: EdgeInsets.symmetric(horizontal: 10 * variablePixelHeight),
          child: Column(
            children: [
              Container(
                height: widget.height,
                margin: EdgeInsets.only(top: 10),
                child: (widget.isVerticleScroll == true)? Scrollbar(
                  radius: Radius.circular(10),
                 thickness: 3,
                // trackVisibility: true,
                 thumbVisibility: true,
                 // isAlwaysShown: true,
                  scrollbarOrientation: ScrollbarOrientation.right,
                  child: scrollImageItem(variablePixelWidth,variablePixelHeight,variablePixelMultiplier,variableFontPixelMultiplier),
                ):scrollImageItem(variablePixelWidth,variablePixelHeight,variablePixelMultiplier,variableFontPixelMultiplier),
              ),
              Expanded(
                child: Column(
                  children: [
                    SizedBox(
                      height: 30 * variablePixelWidth,
                    ),
                    rowWidget(
                        translation(context).panCardNumber,
                        (widget.data?.panNumber ?? "").toString().toUpperCase(),
                        variablePixelWidth,
                        variablePixelHeight),
                    SizedBox(
                      height: 20 * variablePixelWidth,
                    ),
                    rowWidget(
                        translation(context).status,
                        translation(context).accepted,
                        variablePixelWidth,
                        variablePixelHeight),
                    SizedBox(
                      height: 20 * variablePixelWidth,
                    ),
                    rowWidget(
                        translation(context).remarks,
                        widget.data?.remarks ?? "",
                        variablePixelWidth,
                        variablePixelHeight),
                    Expanded(
                      child: SizedBox(
                        height: 30 * variablePixelWidth,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ]),
    );
  }

  Widget rowWidget(String data1, String data2, double variablePixelWidth,
      double variablePixelHeight) {
    var textMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();

    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            data1,
            style: GoogleFonts.poppins(
              fontSize: 14.0 * textMultiplier,
              letterSpacing: 0.10,
              fontWeight: FontWeight.w500,
              color: AppColors.lightGreyBorder,
            ),
          ),
          (data2 != translation(context).accepted)
              ? Text(
                  data2,
                  maxLines: 2,
                  style: GoogleFonts.poppins(
                    fontSize: 14.0 * textMultiplier,
                    letterSpacing: 0.10,
                    fontWeight: FontWeight.w500,
                    color: AppColors.blackText,
                  ),
                )
              : Row(
                  children: [
                    SvgPicture.asset(
                        "assets/mpartner/network/check_circle.svg"),
                    SizedBox(
                      width: 5 * variablePixelWidth,
                    ),
                    Text(
                      translation(context).accepted,
                      style: GoogleFonts.poppins(
                          fontSize: 14.0 * textMultiplier,
                          letterSpacing: 0.10,
                          fontWeight: FontWeight.w600,
                          color: AppColors.successGreen),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  scrollImageItem(double variablePixelWidth, double variablePixelHeight, double variablePixelMultiplier, double variableFontPixelMultiplier) {
    return ListView(
      children: [
        CachedNetworkImage(
          imageUrl: widget.data?.pan ?? "",
          imageBuilder: (context, imageProvider) {
            return Container(
              height: (widget.isVerticleScroll == true)
                  ? widget.bottomsheetHeight
                  : widget.height,
              width: 320 * variablePixelWidth,
              decoration: BoxDecoration(
                color: AppColors.lightGrey,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                image: DecorationImage(
                    image: imageProvider, fit: BoxFit.fitWidth),
              ),
            );
          },
          placeholder: (context, url) => Container(
              height: 310 * variablePixelHeight,
              child:
              const Center(child: CircularProgressIndicator())),
          errorWidget: (context, url, error) => Container(
            height: 310 * variablePixelHeight,
            //  width: 320 * variablePixelWidth,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(
                  Radius.circular(12 * variablePixelMultiplier)),
              border: Border.all(
                color: AppColors.lightGrey,
                width: 1.5 * variablePixelWidth,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/mpartner/network/hide_image.png",
                  height: 60 * variablePixelHeight,
                  width: 60 * variablePixelWidth,
                ),
                SizedBox(height: 12 * variablePixelHeight),
                Text(
                  translation(context).errorUploadingImage,
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                      fontSize: 12 * variableFontPixelMultiplier),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
