import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../data/models/network_management_model/dealer_electrician_status_data_model.dart';
import '../../../../../state/contoller/new_dealer_electrician_status_controller.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_constants.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';
import 'search_header.dart';

class VerificationStatusDetailsWidget extends StatefulWidget {
  final Function(String) onItemSelected;
  final String? contentTiltle;
  final int? selectedIndex;
  final List<StatusData>? filteredStateList;

  const VerificationStatusDetailsWidget(
      {required this.onItemSelected,
      this.contentTiltle,
      this.selectedIndex,
      this.filteredStateList,
      super.key});

  @override
  State<VerificationStatusDetailsWidget> createState() =>
      _VerificationStatusDetailsWidgetState();
}

class _VerificationStatusDetailsWidgetState
    extends State<VerificationStatusDetailsWidget> {
  NewDealerElectricianStatusController controlller = Get.find();
  String contentTiltle = "";
  int index = 0;

  @override
  void initState() {
    contentTiltle = widget.contentTiltle!;
    index = widget.selectedIndex!;
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
    // var textMultiplier =
    //     DisplayMethods(context: context).getTextFontMultiplier();

    return Container(
      margin: EdgeInsets.only(left: 10 * variablePixelWidth),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        SearchHeaderWidget(
          title: contentTiltle,
          onClose: () => Navigator.of(context).pop(),
        ),
        Container(
          width: MediaQuery.of(context).size.width* variablePixelWidth,
          padding: EdgeInsets.symmetric(horizontal: 10 * variablePixelHeight),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20 * variablePixelHeight,
              ),
              headerWidget(
                  "${(widget.filteredStateList![index].status == "Pending" || widget.filteredStateList![index].status == "Rejected") ? "#${(widget.filteredStateList![index]!.dealerCode!.isEmpty) ? "4000007${index}" : ""}" : ""}${widget.filteredStateList![index].dealerCode} \n${widget.filteredStateList![index].dealerName}",
                  variablePixelWidth,
                  variablePixelHeight),
              SizedBox(
                height: 16 * variablePixelHeight,
              ),
              rowWidget(
                  translation(context).mobileNumber,
                  "${widget.filteredStateList![index].phoneNo}",
                  variablePixelWidth,
                  variablePixelHeight),
              SizedBox(
                height: 16 * variablePixelHeight,
              ),
              rowWidget(
                  translation(context).createdOn,
                  widget.filteredStateList![index].createdOn!,
                  variablePixelWidth,
                  variablePixelHeight),
              Visibility(
                  visible:
                      (widget.filteredStateList![index].status != "Pending"),
                  child: SizedBox(
                    height: 16 * variablePixelHeight,
                  )),
              Visibility(
                  visible:
                      (widget.filteredStateList![index].status != "Pending"),
                  child: rowWidget(
                      translation(context).lastUpdatedOn,
                      widget.filteredStateList![index].updatedOn!,
                      variablePixelWidth,
                      variablePixelHeight)),
              SizedBox(
                height: 16 * variablePixelHeight,
              ),
              rowWidget(
                  translation(context).remarks,
                  (widget.filteredStateList![index].status == "Pending")
                      ? translation(context).awaitApproval
                      :/* (widget.filteredStateList![index].status ==
                                  "Accepted" ||
                              widget.filteredStateList![index].status ==
                                  "Completed")
                          ? "Dealer code created successfully!"
                          :*/ widget.filteredStateList![index].remarks ?? "",
                  variablePixelWidth,
                  variablePixelHeight),
              SizedBox(
                height: 36 * variablePixelHeight,
              ),
            ],
          ),
        ),
      ]),
    );
  }

  Widget headerWidget(
      String idName, double variablePixelWidth, double variablePixelHeight) {
    var textMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();

    return Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child:   Text(
          idName,
          style: GoogleFonts.poppins(
            fontSize: 14.0 * textMultiplier,
            letterSpacing: 0.10,
            fontWeight: FontWeight.w600,
            color: AppColors.blackText,
          ),
        ),),

        Row(
          children: [
            (widget.filteredStateList![index].status == "Pending")
                ? SvgPicture.asset("assets/mpartner/network/error.svg")
                : (widget.filteredStateList![index].status == "Accepted")
                    ? SvgPicture.asset(
                        "assets/mpartner/network/check_circle.svg")
                    : SvgPicture.asset("assets/mpartner/network/cancel.svg"),
            SizedBox(
              width: 5 * variablePixelWidth,
            ),
            Text(
              (widget.filteredStateList![index].status == "Pending")
                  ? translation(context).pending
                  : (widget.filteredStateList![index].status == "Accepted")
                      ? translation(context).accepted
                      : translation(context).rejected,
              style: GoogleFonts.poppins(
                fontSize: 12.0 * textMultiplier,
                letterSpacing: 0.10,
                height: 0.10,
                fontWeight: FontWeight.w600,
                color: (widget.filteredStateList![index].status == "Pending")
                    ? AppColors.goldCoin
                    : (widget.filteredStateList![index].status == "Accepted")
                        ? AppColors.successGreen
                        : AppColors.errorRed,
              ),
            ),
          ],
        )
      ],
    ));
  }

  Widget rowWidget(String data1, String data2, double variablePixelWidth,
      double variablePixelHeight) {
    var textMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();

    return Container(
      child: Row(
       children: [
          Container(
            width: 110*variablePixelWidth,
            child: Text(
              data1,
              style: GoogleFonts.poppins(
                fontSize: 12.0 * textMultiplier,
                letterSpacing: 0.10,
                fontWeight: FontWeight.w500,
                color: AppColors.blackText,
              ),
            ),
          ),
          Expanded(
            child: Text(
              data2.isEmpty?"-":data2,
              textAlign: TextAlign.end,
              style: GoogleFonts.poppins(
                fontSize: 12.0 * textMultiplier,
                letterSpacing: 0.10,
                fontWeight: FontWeight.w600,
                color: AppColors.blackText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
