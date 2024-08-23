import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../state/contoller/create_dealer_electrician_controller.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';
import '../../../../presentation/screens/network_management/dealer_electrician/components/search_header.dart';
import '../../../../presentation/screens/network_management/dealer_electrician/components/submit_button.dart';



class SubmitSuccessBottomSheet extends StatefulWidget {
  final Function() onItemSelected;
  final String? contentTiltle;

  const SubmitSuccessBottomSheet(
      {required this.onItemSelected,
        this.contentTiltle,
        super.key});

  @override
  State<SubmitSuccessBottomSheet> createState() => _SubmitSuccessBottomSheetState();
}

class _SubmitSuccessBottomSheetState extends State<SubmitSuccessBottomSheet> {

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
    var textMultiplier = DisplayMethods(context: context).getTextFontMultiplier();

    return Container(
      margin: EdgeInsets.only(left: 10 * variablePixelWidth),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
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
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                height: variablePixelHeight * 50,
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: translation(context).successContent,
                        style: GoogleFonts.poppins(
                          color: AppColors.blackText.withOpacity(0.8),
                          fontStyle: FontStyle.normal,
                          fontSize: 14 * textMultiplier,
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
          buttonText: translation(context).done),
    );
  }
}
