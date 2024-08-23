import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../data/models/network_management_model/dealer_electrician_status_data_model.dart';
import '../../../../../state/contoller/new_dealer_electrician_status_controller.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';

class DealerElectricianStatusListItemPage extends StatefulWidget {
  final StatusData item;
  final int index;
  final Function(int) onItemSelected;

  const DealerElectricianStatusListItemPage(
      this.item, this.index, this.onItemSelected,
      {super.key});

  @override
  State<DealerElectricianStatusListItemPage> createState() =>
      _DealerElectricianStatusListPageItemState();
}

class _DealerElectricianStatusListPageItemState
    extends State<DealerElectricianStatusListItemPage> {
  NewDealerElectricianStatusController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    var variablePixelMultiplier =
        DisplayMethods(context: context).getPixelMultiplier();
    final variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    final variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    return InkWell(
      onTap: () {
        widget.onItemSelected(widget.index);
      },
      child: Container(
        margin: EdgeInsets.only(top: 12.0 * variablePixelWidth),
        height: variablePixelHeight * 64,
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.grayText.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(12 * variablePixelMultiplier),
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
                    "${(widget.item.status != "Accepted" && widget.item.status != "Completed") ? "# ${(widget.item.dealerCode!.isEmpty) ? widget.item.dealerId : widget.item.dealerCode!}" : widget.item.dealerCode}",
                    style: GoogleFonts.poppins(
                      fontSize: 14.0 * variablePixelHeight,
                      letterSpacing: 0.10,
                      height: 0.10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackText,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 10 * variablePixelWidth),
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        (widget.item.status == "Pending")
                            ? SvgPicture.asset(
                                "assets/mpartner/network/error.svg")
                            : (widget.item.status == "Accepted" ||
                                    widget.item.status == "Completed")
                                ? SvgPicture.asset(
                                    "assets/mpartner/network/check_circle.svg")
                                : SvgPicture.asset(
                                    "assets/mpartner/network/cancel.svg"),
                        SizedBox(
                          width: 5 * variablePixelWidth,
                        ),
                        Text(
                          (widget.item.status == "Pending")
                              ? translation(context).pending
                              : (widget.item.status == "Accepted" ||
                                      widget.item.status == "Completed")
                                  ? translation(context).accepted
                                  : translation(context).rejected,
                          style: GoogleFonts.poppins(
                            fontSize: 12.0 * variablePixelHeight,
                            letterSpacing: 0.10,
                            height: 0.10,
                            fontWeight: FontWeight.w600,
                            color: (widget.item.status == "Pending")
                                ? AppColors.goldCoin
                                : (widget.item.status == "Accepted" ||
                                        widget.item.status == "Completed")
                                    ? AppColors.successGreen
                                    : AppColors.errorRed,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: 10 * variablePixelHeight,
                    top: 10 * variablePixelHeight),
                child: Row(
                  children: [
                    Text(
                      (widget.item.dealerName??"").length>20?widget.item.dealerName!.substring(0,19)+"...":
                      "${widget.item.dealerName}",
                      style: GoogleFonts.poppins(
                        fontSize: 12.0 * variablePixelHeight,
                        letterSpacing: 0.10,
                        height: 0.10,
                        fontWeight: FontWeight.w400,
                        color: AppColors.blackText,
                      ),
                    ),
                    SizedBox(
                      width: 15 * variablePixelWidth,
                    ),
                    Text(
                      "${widget.item.phoneNo}",
                      style: GoogleFonts.poppins(
                        fontSize: 12.0 * variablePixelHeight,
                        letterSpacing: 0.10,
                        height: 0.10,
                        fontWeight: FontWeight.w400,
                        color: AppColors.blackText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
