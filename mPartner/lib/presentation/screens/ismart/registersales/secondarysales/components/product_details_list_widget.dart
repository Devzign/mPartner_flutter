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
import '../../../../../../utils/routes/app_routes.dart';
import '../../../../../widgets/rupee_with_sign_widget.dart';
import '../../../../../widgets/something_went_wrong_screen.dart';
import '../../../../../widgets/something_went_wrong_widget.dart';
import '../../components/product_details_card_widget.dart';
import '../../uimodels/dealer_info.dart';
import '../../uimodels/product_details.dart';
import '../bloc/secondary_sales_product_details_bloc.dart';

class ProductDetailsListWidget extends StatefulWidget {
  final String serialNo;
  final DateTime selectedDate;
  final DealerInfo selectedDealer;

  final Function(ProductDetails) onProductSelected;

  const ProductDetailsListWidget({
    required this.onProductSelected,
    required this.serialNo,
    required this.selectedDate,
    required this.selectedDealer,
    super.key,
  });

  @override
  State<ProductDetailsListWidget> createState() =>
      _ProductDetailsListWidgetState();
}

class _ProductDetailsListWidgetState extends State<ProductDetailsListWidget> {
  String? _longPressedStatus;
  late List<ProductDetails> filteredProductList;

  ProductDetails _convertToProductDetails(SaleData saleData) {
    return ProductDetails(
      status: saleData.status ?? "",
      serialNoCount: saleData.serialNoCount ?? "",
      remark: saleData.remark ?? "",
      productName: saleData.modelName ?? "",
      primaryDetail: '',
      productType: saleData.productType ?? '',
      modelName: saleData.modelName ?? "",
      wrsPoint: saleData.wrsPoint ?? 0,
      registeredOn: saleData.registeredOn ?? "",
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
            // maxHeight: 75 * variablePixelHeight,
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  RupeeWithSignWidget(
                    cash: double.parse(
                        totalPoints.toString().replaceAll(',', '')),
                    color: AppColors.lumiBluePrimary,
                    width: 220,
                    weight: FontWeight.w600,
                    size: 16,
                  )
                ],
              ),
              Text(
                '${status} (${totalCount})',
                maxLines: 1,
                softWrap: true,
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
                    child: Container(
                      height: 24 * variablePixelHeight,
                      width: 24 * variablePixelWidth,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.lightGrey2,
                      ),
                        child: Icon(
                          Icons.close, 
                          color: AppColors.iconColor
                          ),
                        ),
                    onTap: () {
                      setState(() {
                        _longPressedStatus = null;
                        _getFilteredProductDetails(productDetailsListData);
                      });
                    },
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
      create: (context) => sl<SecondarySalesProductDetailsBloc>()
        ..add(GetProductDetailsListEvent(
            serialNo: widget.serialNo,
            dealerCode: widget.selectedDealer.disCode,
            saleDate: DateFormat('dd/MM/yyyy')
                .format(widget.selectedDate)
                .toString())),
      child: BlocBuilder<SecondarySalesProductDetailsBloc,
          SecondarySalesProductDetailsState>(
        builder: (context, state) {
          return BlocConsumer<SecondarySalesProductDetailsBloc,
              SecondarySalesProductDetailsState>(
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
                  return Container(
                    color: AppColors.white,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
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
                            '${translation(context).forSaleTo} ${widget.selectedDealer.dealerName} (${widget.selectedDealer.disCode})',
                            textAlign: TextAlign.center,
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
                    ),
                  );
                case RequestState.error:
                WidgetsBinding.instance
                      .addPostFrameCallback((_) => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SomethingWentWrongScreen(
                              onPressed: () => {Navigator.of(context)
                        .popUntil(ModalRoute.withName(AppRoutes.registerSales)),
                    Navigator.of(context).pop(),},
                            ),
                          )));
                
                return Container();
                  // return SizedBox(
                  //   height: 174 * variablePixelHeight,
                  //   child: Center(
                  //     //child: SomethingWentWrongWidget(),
                  //     child: Text(state.productDetailsListMessage),
                  //   ),
                  // );
              }
            },
          );
        },
      ),
    );
  }
}
