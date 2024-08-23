import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../data/models/network_management_model/dealer_electrician_details_model.dart';
import '../../../../../state/contoller/dealer_electrician_view_detailController.dart';
import '../../../../../state/contoller/dealer_wise_summary_controller.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/enums.dart';
import '../../../../../utils/localdata/language_constants.dart';
import '../../../report_management/report_management_utils/report_management_utils.dart';
import '../../../report_management/screens/secondary_report/distributor/secondary_report_product_detail_screen.dart';
import 'common_network_utils.dart';

class PerformanceDealerElectricianViewWidget extends StatefulWidget {
  final DealerElectricianDetail item;
  final int index;
  final bool isVisible;
  final Function(int) onItemSelected;

  const PerformanceDealerElectricianViewWidget(
      this.item, this.index, this.onItemSelected, this.isVisible,
      {super.key});

  @override
  State<PerformanceDealerElectricianViewWidget> createState() =>
      _PerformanceDealerElectricianViewWidgetState();
}

class _PerformanceDealerElectricianViewWidgetState
    extends State<PerformanceDealerElectricianViewWidget> {
  DealerElectricianViewDetailsController controller = Get.find();
  DealerSummaryController dealerSummaryController = Get.find();

  @override
  void initState() {
    print("ITEMM --> ${widget.item}");
    dealerSummaryController.fetchSecondaryReportSummaryDistributor(
        dealerCode: widget.item.code ?? "" /*"9900000063" */);
    super.initState();
  }

  Map<String, dynamic> fetchProductsList(
      DealerSummaryController dealerSummaryController, int index) {
    if (dealerSummaryController.dealerSummaryList.isNotEmpty) {
      final Map<String, dynamic> productItems =
          dealerSummaryController.dealerSummaryList[index];

      final Map<String, dynamic> totalProductsMap = {
        getProductCategoryName(ProductsCategory.battery):
            productItems['battery'],
        getProductCategoryName(ProductsCategory.hkva): productItems['hkva'],
        getProductCategoryName(ProductsCategory.hups): productItems['hups'],
        getProductCategoryName(ProductsCategory.nxg): productItems['nxg'],
        getProductCategoryName(ProductsCategory.solarBattery):
            productItems['solarBattery'],
        getProductCategoryName(ProductsCategory.gti): productItems['gti'],
        getProductCategoryName(ProductsCategory.regalia):
            productItems['regalia'],
        getProductCategoryName(ProductsCategory.cruze): productItems['cruze'],
        getProductCategoryName(ProductsCategory.solarPanel):
            productItems['solarPanel'],
        getProductCategoryName(ProductsCategory.autoBattery):
            productItems['autoBattery'],
        getProductCategoryName(ProductsCategory.pcu): productItems['pcu']
      };
      final Map<String, dynamic> filteredProductsMap = Map.fromEntries(
          totalProductsMap.entries
              .where((entry) => entry.value != null && entry.value != 0));

      return filteredProductsMap;
    }
    return {};
  }

  @override
  Widget build(BuildContext context) {
    var variablePixelMultiplier =
        DisplayMethods(context: context).getPixelMultiplier();
    final variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    final variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    var textMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 10 * variablePixelWidth),
          margin: EdgeInsets.only(top: 12.0 * variablePixelWidth),
         // height: variablePixelHeight * 26,
          width: (controller.userType == UserType.dealer)
              ? 140 * variablePixelWidth
              : 160 * variablePixelWidth,
          decoration: BoxDecoration(
            color: AppColors.lumiLight4,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(4 * variablePixelMultiplier),
              topLeft: Radius.circular(4 * variablePixelMultiplier),
            ),
          ),
          child: Text(
            (controller.userType == UserType.dealer)
                ? translation(context).dealerDetails.toString()
                : translation(context).electricianDetails.toString(),
            textAlign: TextAlign.left,
            style: GoogleFonts.poppins(
              fontSize: 14.0 * textMultiplier,
              letterSpacing: 0.10,
              fontWeight: FontWeight.w500,
              color: AppColors.blackText,
            ),
          ),
        ),
        Container(
          height: (widget.isVisible == false)
              ? variablePixelHeight * 90
              : variablePixelHeight * 110,
          decoration: BoxDecoration(
            color: AppColors.white,
            border: Border.all(color: AppColors.grayText.withOpacity(0.3)),
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(12 * variablePixelMultiplier),
                bottomLeft: Radius.circular(12 * variablePixelMultiplier),
                bottomRight: Radius.circular(12 * variablePixelMultiplier)),
          ),
          child: Padding(
            padding: EdgeInsets.only(left: 10 * variablePixelWidth),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 12 * variablePixelHeight,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.item.code ?? "",
                      style: GoogleFonts.poppins(
                        fontSize: 14.0 * textMultiplier,
                        letterSpacing: 0.10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blackText,
                      ),
                    ),
                    Container(
                      width:  (widget.item.status == "1" ||
                          widget.item.status == "Active")
                          ?70 * variablePixelWidth:80 * variablePixelWidth,
                     // height: 24 * variablePixelHeight,
                      margin: EdgeInsets.only(right: 10 * variablePixelWidth),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: (widget.item.status == "1" ||
                                  widget.item.status == "Active")
                              ? AppColors.green10
                              : AppColors.red10,
                          borderRadius: BorderRadius.all(
                              Radius.circular(12 * variablePixelMultiplier))),
                      padding: EdgeInsets.only(
                          right: 10 * variablePixelWidth,
                          bottom: 4 * variablePixelHeight,
                          top: 2 * variablePixelHeight,
                          left: 10 * variablePixelWidth),
                      child: Text(
                        (widget.item.status == "1" ||
                                widget.item.status == "Active")
                            ? translation(context).active
                            : translation(context).inActive,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 12.0 * textMultiplier,
                          letterSpacing: 0.10,
                          fontWeight: FontWeight.w500,
                          color: (widget.item.status == "1" ||
                                  widget.item.status == "Active")
                              ? AppColors.successGreen
                              : AppColors.errorRed,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 12 * variablePixelHeight,
                ),
                Text(
                  "${(widget.item.name ?? "").length > 25 ? widget.item.name!.substring(0, 18) + "..." : widget.item.name ?? ""}      ${widget.item.phoneNo ?? ""}",
                  style: GoogleFonts.poppins(
                    fontSize: 12.0 * textMultiplier,
                    letterSpacing: 0.10,
                    height: 0.10,
                    fontWeight: FontWeight.w400,
                    color: AppColors.blackText,
                  ),
                ),
                Visibility(
                    visible: widget.isVisible,
                    child: SizedBox(
                      height: 4 * textMultiplier,
                    )),
                Expanded(
                  child: Visibility(
                    visible: widget.isVisible,
                    child: InkWell(
                      onTap: () {
                        Map<String, dynamic> productsList =
                            fetchProductsList(dealerSummaryController, 0);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  SecondaryReportProductDetail(
                                    id: widget.item.code ?? "" /*"9900000063"*/,
                                    name: widget.item.name ?? "",
                                    address: widget.item.city ?? "",
                                    totalProducts: (dealerSummaryController
                                            .dealerSummaryList.isEmpty)
                                        ? "0"
                                        : dealerSummaryController
                                            .dealerSummaryList[0]
                                                ['totalProduct']
                                            .toString(),
                                    productsList: productsList,
                                    productTypesString: "",
                                  )),
                        );
                      },
                      child: Container(
                        alignment: Alignment.centerLeft,
                        height: 36 * variablePixelHeight,
                        margin: EdgeInsets.only(top: 5*variablePixelHeight,bottom: 5*variablePixelHeight),
                        child: Text(
                          translation(context).viewSecondaryDetails,
                          style: GoogleFonts.poppins(
                            fontSize: 14.0 * textMultiplier,
                            letterSpacing: 0.10,
                            height: 0.10,
                            fontWeight: FontWeight.w500,
                            color: AppColors.lumiBluePrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 16 * variablePixelHeight,
        ),
      ],
    );
  }
}
