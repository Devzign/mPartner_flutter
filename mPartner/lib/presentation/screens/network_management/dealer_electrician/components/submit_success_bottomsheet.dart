import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../state/contoller/create_dealer_electrician_controller.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';
import 'search_header.dart';
import 'submit_button.dart';

class SubmitSuccessWidget extends StatefulWidget {
  final Function() onItemSelected;
  final String? contentTiltle;
  final String? content;
  final String? mobileNumber;

  const SubmitSuccessWidget(
      {required this.onItemSelected,
      this.contentTiltle = "",
      this.mobileNumber,
      this.content,
      super.key});

  @override
  State<SubmitSuccessWidget> createState() => _SubmitSuccessWidgetState();
}

class _SubmitSuccessWidgetState extends State<SubmitSuccessWidget> {
  TextEditingController _searchController = TextEditingController();

  String contentTiltle = "";
  CreateDealerElectricianController controller = Get.find();

  @override
  void initState() {
    contentTiltle = widget.contentTiltle!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    var textMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Container(
        margin: EdgeInsets.only(left: 10 * variablePixelWidth),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          SizedBox(
            height: 24 * variablePixelHeight,
          ),
          SearchHeaderWidget(
            title: contentTiltle,
          ),
          Container(
            width: variablePixelHeight * 392,
            padding: EdgeInsets.symmetric(horizontal: 10 * variablePixelHeight),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20 * variablePixelHeight,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: variablePixelHeight * 50,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: (widget.content?.isNotEmpty == true)
                              ? widget.content
                              : translation(context).successContent,
                          style: GoogleFonts.poppins(
                            color: AppColors.blackText.withOpacity(0.8),
                            fontStyle: FontStyle.normal,
                            fontSize: 16 * textMultiplier,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 5 * variablePixelHeight,
                ),
                submitButtonWidget(),
                SizedBox(
                  height: 12 * variablePixelHeight,
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Widget submitButtonWidget() {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    return Container(
      height: 100 * variablePixelHeight,
      padding: EdgeInsets.fromLTRB(
          1 * variablePixelWidth, 0, 1 * variablePixelWidth, 0),
      alignment: Alignment.center,
      child: SubmitButton(
          onPressed: () {
            widget.onItemSelected();
          },
          isEnabled: true,
          containerBackgroundColor: AppColors.white,
          paddingLR: 0,
          buttonText: (widget.content?.isNotEmpty == true)
              ? translation(context).continueButtonText
              : translation(context).checkStatus),
    );
  }
}
