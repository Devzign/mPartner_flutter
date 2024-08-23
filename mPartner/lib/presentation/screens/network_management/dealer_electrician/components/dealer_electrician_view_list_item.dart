import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../data/models/network_management_model/dealer_electrician_details_model.dart';
import '../../../../../state/contoller/dealer_electrician_view_detailController.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';
import 'common_network_utils.dart';
import 'dropddown_widget.dart';

class DealerElectricianViewListItemPage extends StatefulWidget {
  final DealerElectricianDetail item;
  final int index;
  final Function(int) onItemSelected;


  const DealerElectricianViewListItemPage(this.item, this.index,this.onItemSelected,
      {super.key});

  @override
  State<DealerElectricianViewListItemPage> createState() =>
      _DealerElectricianViewListItemPageState();
}

class _DealerElectricianViewListItemPageState
    extends State<DealerElectricianViewListItemPage> {
  DealerElectricianViewDetailsController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    var variablePixelMultiplier =
    DisplayMethods(context: context).getPixelMultiplier();
    final variablePixelHeight =
    DisplayMethods(context: context).getVariablePixelHeight();
    final variablePixelWidth =
    DisplayMethods(context: context).getVariablePixelWidth();
    var textMultiplier = DisplayMethods(context: context).getTextFontMultiplier();

    return InkWell(
      onTap:(){ widget.onItemSelected(widget.index);},
      child: Container(
        margin: EdgeInsets.only(top: 12.0 * variablePixelWidth),
        height: variablePixelHeight * 80,
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.grayText.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(12*variablePixelMultiplier),
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 10 * variablePixelWidth),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    (controller.userType==UserType.dealer)? widget.item.code.toString():widget.item.code.toString(),
                    style: GoogleFonts.poppins(
                      fontSize: 14.0 * textMultiplier,
                      letterSpacing: 0.10,
                      height: 0.10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackText,
                    ),
                  ),
                  Container(
                    height: 20*variablePixelHeight,
                    margin: EdgeInsets.only(right: 14*variablePixelWidth),

                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color:  (widget.item.status =="1"||widget.item.status=="Active"||widget.item.requestStatus=="active")?AppColors.green10:AppColors.red10,
                        borderRadius: BorderRadius.all(Radius.circular(12*variablePixelMultiplier))
                    ),
                    padding: EdgeInsets.only(right: 10*variablePixelWidth,bottom:4*variablePixelHeight,top:2*variablePixelHeight,left: 10*variablePixelWidth),
                    child:  Text(
                      (widget.item.status =="1"||widget.item.status=="Active"||widget.item.requestStatus=="active")?"${translation(context).active}":"${translation(context).inActive}",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 12.0 * textMultiplier,
                        letterSpacing: 0.10,
                        height: 0.10,
                        fontWeight: FontWeight.w500,
                        color: (widget.item.status =="1"||widget.item.status=="Active"||widget.item.requestStatus=="active")? AppColors.successGreen:AppColors.errorRed,
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                "${((widget.item.name??"").length>20)?widget.item.name.toString().substring(0,19)+"...":widget.item.name}    ${widget.item.phoneNo}",
                style: GoogleFonts.poppins(
                  fontSize: 12.0 * textMultiplier,
                  letterSpacing: 0.10,
                  height: 1.5,
                  fontWeight: FontWeight.w400,
                  color: AppColors.blackText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
