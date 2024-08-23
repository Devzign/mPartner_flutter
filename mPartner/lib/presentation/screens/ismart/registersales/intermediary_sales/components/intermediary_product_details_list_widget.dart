import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../../../data/models/get_sale_details_list_model.dart';
import '../../../../../../services/services_locator.dart';
import '../../../../../../utils/app_colors.dart';
import '../../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../../utils/enums.dart';
import '../../../../../../utils/localdata/language_constants.dart';
import '../../../../../../utils/utils.dart';
import '../../../../../widgets/rupee_with_sign_widget.dart';
import '../../components/product_details_card_widget.dart';
import '../../uimodels/electrician_info.dart';
import '../../uimodels/product_details.dart';
import '../bloc/intermediary_sales_product_details_bloc.dart';

class IntermediaryProductDetailsListWidget extends StatefulWidget {
  final String serialNo;
  final DateTime selectedDate;
  final ElectricianInfo selectedElectrician;

  final Function(ProductDetails) onProductSelected;

  const IntermediaryProductDetailsListWidget({
    required this.onProductSelected,
    required this.serialNo,
    required this.selectedDate,
    required this.selectedElectrician,
    super.key,
  });

  @override
  State<IntermediaryProductDetailsListWidget> createState() =>
      _IntermediaryProductDetailsListWidgetState();
}

class _IntermediaryProductDetailsListWidgetState extends State<IntermediaryProductDetailsListWidget> {
  String? _longPressedStatus;
  late List<ProductDetails> filteredProductList;

  ProductDetails _convertToProductDetails(SaleData saleData) {
    return ProductDetails(
      status: saleData.status ?? "",
      serialNoCount: saleData.serialNoCount ?? "",
      remark: saleData.remark ?? "",
      productName: "${saleData.productType ?? ""}_${saleData.modelName ?? ""}",
      primaryDetail: '',
      productType: '',
      modelName: saleData.modelName ?? "",
      wrsPoint: saleData.wrsPoint ?? 0,
      registeredOn: '',
    );
  }

  void _handleOnProductSelected(dealer) {
    widget.onProductSelected(dealer);
  }

  void _getFilteredProductDetails(List<SaleData> productDetailsListData) {
    List<ProductDetails> productDetailsList =
        productDetailsListData.map(_convertToProductDetails).toList();

    if (_longPressedStatus == null) {
      filteredProductList = productDetailsList;
    } else {
      filteredProductList = productDetailsList
          .where((product) => product.status == _longPressedStatus)
          .toList();
    }
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return AppColors.successGreen;
      case 'pending':
        return AppColors.pendingYellow;
      case 'rejected':
        return AppColors.errorRed;
      default:
        return AppColors.grayText;
    }
  }

  Map<String, Map<String, int>> sumWrsPointsByStatus(productDetailsList) {
    Map<String, Map<String, int>> wrsPointsSum = {};

    for (var saleData in productDetailsList) {
      if (saleData.status != null && saleData.wrsPoint != null) {
        wrsPointsSum.update(saleData.status!, (currentData) {
          currentData['sum'] =
              ((currentData['sum'] ?? 0) + saleData.wrsPoint!).toInt();
          currentData['count'] = (currentData['count'] ?? 0) + 1;
          return currentData;
        }, ifAbsent: () => {'sum': saleData.wrsPoint!, 'count': 1});
      }
    }
    wrsPointsSum.removeWhere((key, value) => value['count'] == 0);
    return wrsPointsSum;
  }

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double variablePixelMultiplier =
        DisplayMethods(context: context).getPixelMultiplier();
    double variableTextMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();

    Widget buildStatusCard(
        String status, int totalPoints, int totalCount, Color statusColor) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 4*variablePixelWidth),
        constraints: BoxConstraints(
            maxHeight: 75 * variablePixelHeight,
            maxWidth: 110 * variablePixelWidth),
        decoration: BoxDecoration(
          color: AppColors.lightWhite1,
          borderRadius: BorderRadius.circular(12 * variablePixelMultiplier),
          border: Border.all(
              color: AppColors.white_234, width: 1 * variablePixelWidth),
          boxShadow: _longPressedStatus == status
              ? [
                  BoxShadow(
                    color: AppColors.darkGrey,
                    blurRadius: 4.0,
                    offset: Offset(0, 0),
                  ),
                ]
              : [],
        ),
        child: Padding(
          padding: EdgeInsets.all(10 * variablePixelMultiplier),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              RupeeWithSignWidget(
                  cash: double.tryParse("$totalPoints") ?? 0,
                  color: AppColors.lumiBluePrimary,
                  size: 16,
                  weight: FontWeight.w600,
                  width: 150),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   children: [
              //     Icon(
              //       Icons.currency_rupee,
              //       color: AppColors.lumiBluePrimary,
              //       weight: 600,
              //       size: 16 * variableTextMultiplier,
              //     ),
              //     Text(
              //       rupeeNoSign.format(totalPoints),
              //       textAlign: TextAlign.center,
              //       maxLines: 1,
              //       style: GoogleFonts.poppins(
              //         color: AppColors.lumiBluePrimary,
              //         fontSize: 16 * variableTextMultiplier,
              //         fontWeight: FontWeight.w600,
              //       ),
              //     ),
              //   ],
              // ),
              Text(
                '${status} (${totalCount})',
                style: GoogleFonts.poppins(
                  color: statusColor,
                  fontSize: 12 * variableTextMultiplier,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget _buildStatusCards(Map<String, Map<String, int>> statusWrsPoints,
        List<SaleData> productDetailsListData) {
      int numberOfStatuses = statusWrsPoints.length;

      List<Widget> statusCards = statusWrsPoints.entries.map((entry) {
        String status = entry.key;
        int totalPoints = entry.value['sum'] ?? 0;
        int totalCount = entry.value['count'] ?? 0;
        Color statusColor = getStatusColor(status);

        return GestureDetector(
          onTap: () {
            setState(() {
              _longPressedStatus = status;
            });
          },
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              buildStatusCard(status, totalPoints, totalCount, statusColor),
              Visibility(
                visible: _longPressedStatus == status,
                child: Positioned(
                  right: 0,
                  top: -12,
                  child: GestureDetector(
                    onTap: (){
                      setState(() {
                        _longPressedStatus=null;
                        _getFilteredProductDetails(productDetailsListData);
                      });
                    },
                    child: Container(
                      height: 24 * variablePixelHeight,
                      width: 24 * variablePixelWidth,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.lightGrey2,
                      ),
                      child: SizedBox(
                        child: Icon(Icons.close, color: AppColors.iconColor),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      }).toList();

      if (numberOfStatuses <= 2) {
        return Center(
          child: Wrap(
            spacing: 16 * variablePixelWidth,
            children: statusCards,
          ),
        );
      } else {
        return Container(
          height: 80 * variablePixelHeight,
          padding: EdgeInsets.symmetric(horizontal: 16 * variablePixelWidth),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: statusCards,
          ),
        );
      }
    }

    return BlocProvider(
      create: (context) => sl<IntermediarySalesProductDetailsBloc>()
        ..add(GetIntermediaryProductDetailsListEvent(
            serialNo: widget.serialNo,
            electricianCode: widget.selectedElectrician.disCode,
            saleDate: DateFormat('dd/MM/yyyy')
                .format(widget.selectedDate)
                .toString())),
      child: BlocBuilder<IntermediarySalesProductDetailsBloc,
          IntermediarySalesProductDetailsState>(
        builder: (context, state) {
          return BlocConsumer<IntermediarySalesProductDetailsBloc,
              IntermediarySalesProductDetailsState>(
            listener: (context, state) {},
            builder: (context, state) {
              switch (state.productDetailsListState) {
                case RequestState.loading:
                  return SizedBox(
                    height: 174 * variablePixelHeight,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                case RequestState.loaded:
                  final stateWrsPointsMap =
                      sumWrsPointsByStatus(state.productDetailsListData);
                  _getFilteredProductDetails(state.productDetailsListData);
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStatusCards(
                          stateWrsPointsMap, state.productDetailsListData),
                      Container(
                        padding: EdgeInsets.fromLTRB(
                            24 * variablePixelWidth,
                            10 * variablePixelHeight,
                            24 * variablePixelWidth,
                            0),
                        width: variablePixelWidth * 393,
                        child: Text(
                          '${translation(context).forSaleTo} ${widget.selectedElectrician.electricianName} (${widget.selectedElectrician.disCode})',
                          style: GoogleFonts.poppins(
                            color: AppColors.darkGreyText,
                            fontSize: 12 * variableTextMultiplier,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      Container(
                        height: variablePixelHeight * 500,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemCount: filteredProductList.length,
                          itemBuilder: (context, index) {
                            final productDetails = filteredProductList[index];
                            return InkWell(
                              onTap: () =>
                                  _handleOnProductSelected(productDetails),
                              child: Container(
                                width: variablePixelHeight * 392,
                                padding: EdgeInsets.symmetric(
                                    vertical: 10 * variablePixelWidth),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ProductDetailsCardWidget(
                                        productDetails: productDetails)
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  );
                case RequestState.error:
                  return SizedBox(
                    height: 174 * variablePixelHeight,
                    child: Center(
                      child: Text(state.productDetailsListMessage),
                    ),
                  );
              }
            },
          );
        },
      ),
    );
  }
}
