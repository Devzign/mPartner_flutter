import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../../../../../data/models/get_tertiary_bulk_details_list_model.dart';
import '../../../../../../services/services_locator.dart';
import '../../../../../../state/contoller/tertiary_sales_combo_controller.dart';
import '../../../../../../state/contoller/user_data_controller.dart';
import '../../../../../../state/contoller/warranty_controller.dart';
import '../../../../../../utils/app_colors.dart';
import '../../../../../../utils/app_constants.dart';
import '../../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../../utils/enums.dart';
import '../../../../../../utils/localdata/language_constants.dart';
import '../../../../../../utils/routes/app_routes.dart';
import '../../../../../../utils/utils.dart';
import '../../../../../widgets/coin_with_image_widget.dart';
import '../../../../../widgets/common_button.dart';
import '../../../../../widgets/common_confirmation_alert.dart';
import '../../../../../widgets/horizontalspace/horizontal_space.dart';
import '../../../../../widgets/rupee_with_sign_widget.dart';
import '../../../../../widgets/something_went_wrong_screen.dart';
import '../../../../../widgets/verticalspace/vertical_space.dart';
import '../../../../userprofile/user_profile_widget.dart';
import '../../../../../widgets/headers/sales_header_widget.dart';
import '../../components/product_details_card_widget.dart';
import '../../components/single_product_details.dart';
import '../../uimodels/customer_info.dart';
import '../../uimodels/product_details.dart';
import '../bloc/tertiary_sales_product_save_details_bloc.dart';

class TertiaryProductDetailsSaveListWidget extends StatefulWidget {
  final String serialNo;
  final CustomerInfo customerInfo;
  final bool isVerified;
  final bool isOTPVerified;
  final String otp;
  final String? transactionID;

  final Function(ProductDetails)? onProductSelected;

  const TertiaryProductDetailsSaveListWidget({
    this.onProductSelected,
    required this.otp,
    this.transactionID,
    required this.serialNo,
    required this.customerInfo,
    required this.isVerified,
    required this.isOTPVerified,
    super.key,
  });

  @override
  State<TertiaryProductDetailsSaveListWidget> createState() =>
      _TertiaryProductDetailsSaveListWidgetState();
}

class _TertiaryProductDetailsSaveListWidgetState
    extends State<TertiaryProductDetailsSaveListWidget> {
  String? _longPressedStatus;
  late List<ProductDetails> filteredProductList;
  TertiarySalesHKVAcombo controller = Get.find();
  UserDataController userDataController= Get.find();
  WarrantyController warrantyController = Get.find();

  @override
  void initState() {
    super.initState();
  }

  String fetchSerialsWarranty(List<TertiarySaleData> productDetailsList){
    String forWarranty = '';
    for(final item in productDetailsList){
      if((item.status.toLowerCase() == "accepted" || item.status.toLowerCase() == "pending")){
        forWarranty+='${item.serialNo},';
      }
    }
    return forWarranty;
  }

  ProductDetails _convertToProductDetails(TertiarySaleData saleData) {
    return ProductDetails(
      status: saleData.status ?? "",
      serialNoCount: saleData.serialNo ?? "",
      remark: saleData.remark ?? "",
      productName: saleData.model ?? "",
      primaryDetail: '',
      productType: saleData.productType ?? '',
      modelName: saleData.model ?? "",
      wrsPoint: saleData.wrsPoint ?? 0,
      coinPoint: saleData.coinPoints,
      registeredOn: '',
    );
  }

  void _navigateToIndividualProductDetailsScreen(
      ProductDetails productDetails, List<TertiarySaleData> productDetailsList) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SingleProductDetails(
                serialNos: widget.serialNo,
                productDetails: productDetails,
                customerInfo: widget.customerInfo,
                saleType: "Tertiary",
                isOTPVerified: widget.isOTPVerified,
                serialNumbersForWarranty : fetchSerialsWarranty(productDetailsList),
                )));
  }

  void _getFilteredProductDetails(
      List<TertiarySaleData> productDetailsListData) {
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
        return Colors.red;
      default:
        return Colors.grey;
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

  Map<String, Map<String, int>> sumCoinPointsByStatus(productDetailsList) {
    Map<String, Map<String, int>> coinPointsSum = {};

    for (var saleData in productDetailsList) {
      if (saleData.status != null && saleData.coinPoints != null) {
        coinPointsSum.update(saleData.status!, (currentData) {
          currentData['sum'] =
              ((currentData['sum'] ?? 0) + saleData.coinPoints!).toInt();
          currentData['count'] = (currentData['count'] ?? 0) + 1;
          return currentData;
        }, ifAbsent: () => {'sum': saleData.coinPoints!, 'count': 1});
      }
    }
    coinPointsSum.removeWhere((key, value) => value['count'] == 0);
    return coinPointsSum;
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
        String status, int totalPoints, int totalCoinPoints,int totalCount, Color statusColor) {
      return Container(
        padding: EdgeInsets.all(4*variablePixelMultiplier),
        margin: EdgeInsets.symmetric(horizontal: 4 * variablePixelWidth),
        constraints: BoxConstraints(
            // maxHeight: widget.isOTPVerified
            //     ? 105 * variablePixelHeight
            //     : 50 * variablePixelHeight,
            maxWidth: 110 * variablePixelWidth),
        decoration: BoxDecoration(
          color: AppColors.lightWhite1,
          borderRadius: BorderRadius.circular(12 * variablePixelMultiplier),
          border: Border.all(
              color: AppColors.white_234, width: 1 * variablePixelWidth),
          boxShadow: _longPressedStatus == status
              ? [
                  const BoxShadow(
                    color: AppColors.darkGrey,
                    blurRadius: 4.0,
                    offset: Offset(0, 0),
                  ),
                ]
              : [],
        ),
        child: Padding(
          padding: EdgeInsets.all(8 * variablePixelMultiplier),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            // mainAxisAlignment: widget.isOTPVerified == true
            //     ? MainAxisAlignment.spaceAround
            //     : MainAxisAlignment.center,
            children: [
              widget.isOTPVerified == true
                  ? Column(children: [
                  (userDataController.userType=='DEALER')?
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  
                  children: [
                    CoinWithImageWidget(
                      coin: double.parse(
                          totalCoinPoints.toString().replaceAll(',', '')),
                      color: AppColors.goldCoin,
                      width: 220,
                      weight: FontWeight.w600,
                      size: 16,
                    )
                  ],
                ):Container(),
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
                )
              ],) : SizedBox(),
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

    Widget _buildStatusCards(Map<String, Map<String, int>> statusCoinPoints,
    Map<String, Map<String, int>> statusWrsPoints,
        List<TertiarySaleData> productDetailsListData) {
      int numberOfStatuses = statusWrsPoints.length;

      Map<String, int> totalCoinPointList = statusCoinPoints.map((key,value)
      {
          return MapEntry(key, value['sum'] ?? 0);
      });

      List<Widget> statusCards = statusWrsPoints.entries.map((entry) {
        String status = entry.key;
        int totalPoints = entry.value['sum'] ?? 0;
        int totalCount = entry.value['count'] ?? 0;
        int totalCoinPoints = totalCoinPointList[status] ?? 0;
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
              buildStatusCard(status, totalPoints, totalCoinPoints, totalCount, statusColor),
              Visibility(
                visible: _longPressedStatus == status,
                child: Positioned(
                  right: 0,
                  top: -12,
                  child: GestureDetector(
                    onTap: () {
                          setState(() {
                            _longPressedStatus = null;
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

    return WillPopScope(
      onWillPop: () async{
        Navigator.of(context).popUntil(ModalRoute.withName(AppRoutes.registerSales));
        Navigator.of(context).pop();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              HeadingRegisterSales(
                icon: Icon(
                  Icons.close,
                  color: AppColors.iconColor,
                  size: 24 * variablePixelMultiplier,
                ),
                heading: "${translation(context).tertiarySales} ${translation(context).registration}",
                headingSize: AppConstants.FONT_SIZE_LARGE,
                onPressed: () {
                  Navigator.of(context).popUntil(ModalRoute.withName(AppRoutes.registerSales));
                  Navigator.of(context).pop();
                },
              ),
              UserProfileWidget(top:8*variablePixelHeight),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      widget.isOTPVerified
                      ? Text(
                          '${translation(context).earningStatus}',
                          style: GoogleFonts.poppins(
                            color: AppColors.blackTextHeading,
                            fontSize: 16 * variablePixelMultiplier,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.normal,
                            letterSpacing: 1,
                          ),
                        )
                      : SizedBox(),
                  BlocProvider(
                    create: (context) => sl<TertiarySalesProductSaveDetailsBloc>()
                      ..add(GetTertiaryBulkProductSaveEvent(
                        eW_ViaVerified:
                            widget.isOTPVerified ? "WITH_OTP" : "WITHOUT_OTP",
                        eW_OTP: widget.isOTPVerified ? widget.otp : "",
                        transId: widget.transactionID!,
                        serialNo: widget.serialNo,
                        customerInfo: widget.customerInfo,
                      )),
                    child: BlocBuilder<TertiarySalesProductSaveDetailsBloc,
                        TertiarySalesProductSaveDetailsState>(
                      builder: (context, state) {
                        return BlocConsumer<TertiarySalesProductSaveDetailsBloc,
                            TertiarySalesProductSaveDetailsState>(
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
                                final stateWrsPointsMap = sumWrsPointsByStatus(
                                    state.productDetailsListData);
                                final stateCoinPointsMap = sumCoinPointsByStatus(
                                    state.productDetailsListData);
                                _getFilteredProductDetails(
                                    state.productDetailsListData);
                          
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    widget.isOTPVerified
                                        ? Padding(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 10 * variablePixelHeight,
                                            ),
                                            child: _buildStatusCards(
                                                stateCoinPointsMap,
                                                stateWrsPointsMap,
                                                state.productDetailsListData),
                                          )
                                        : SizedBox(),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 24 * variablePixelWidth,
                                        vertical: 0 * variablePixelHeight,
                                      ),
                                      width: variablePixelWidth * 393,
                                      child: (widget.isOTPVerified)?Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '${translation(context).forSaleTo} ${widget.customerInfo.customerName} (+91-${widget.customerInfo.mobileNo})',
                                            maxLines: 2,
                                            style: GoogleFonts.poppins(
                                              color: AppColors.darkGrey,
                                              fontSize: 14 * variableTextMultiplier,
                                              fontStyle: FontStyle.normal,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ],
                                      ):
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            translation(context).saleRegisteredTo,
                                            style: GoogleFonts.poppins(
                                              color: AppColors.grayText,
                                              fontSize: 14 * variableTextMultiplier,
                                              fontStyle: FontStyle.normal,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 1,
                                            ),
                                          ),
                                          Text(
                                            ' ${widget.customerInfo.customerName}'
                                            ' (+91-${widget.customerInfo.mobileNo})',
                                            style: GoogleFonts.poppins(
                                              color: AppColors.darkGreyText,
                                              fontSize: 14 * variableTextMultiplier,
                                              fontStyle: FontStyle.normal,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 1,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 16 * variablePixelHeight,
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                        width: variablePixelWidth * 190,
                                        height: variablePixelHeight * 30,
                                        decoration: BoxDecoration(
                                          color: AppColors.lumiLight5,
                                          borderRadius: BorderRadius.circular(
                                              100.0 * variablePixelMultiplier),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${translation(context).purchaseVerified} ${widget.isOTPVerified != true ? '${translation(context).withoutText} OTP' : '${translation(context).withText} OTP'}',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.poppins(
                                                color: AppColors.lumiBluePrimary,
                                                fontSize: 10 * variableTextMultiplier,
                                                fontWeight: FontWeight.w500,
                                                height: 0.16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    widget.isOTPVerified != true
                                        ? Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 16 * variablePixelHeight),
                                            child: _buildStatusCards(
                                              stateCoinPointsMap,
                                                stateWrsPointsMap,
                                                state.productDetailsListData),
                                          )
                                        : SizedBox(),
                                        VerticalSpace(height: 8),
                                    Container(
                                      height: (userDataController.userProfile[0].userType=='DEALER') 
                                      ? (widget.isOTPVerified)
                                        ? variablePixelHeight * 392 
                                        : variablePixelHeight * 432 
                                      : (widget.isOTPVerified)
                                        ? variablePixelHeight * 422 
                                        : variablePixelHeight * 432,
                                      child: ListView.builder(
                                        padding: EdgeInsets.zero,
                                        physics: ClampingScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: filteredProductList.length,
                                        itemBuilder: (context, index) {
                                          final productDetails =
                                              filteredProductList[index];
                                          return InkWell(
                                            onTap: () =>
                                                _navigateToIndividualProductDetailsScreen(
                                                    productDetails, state.productDetailsListData),
                                            child: Container(
                                              width: variablePixelHeight * 392,
                                              padding: EdgeInsets.symmetric(
                                                vertical: 10 * variablePixelHeight,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  ProductDetailsCardWidget(
                                                      productDetails: productDetails)
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                     Obx(
                          () => Visibility(
                                          visible: !warrantyController.isPdfLoading.value,
                                          replacement: const Center(child: CircularProgressIndicator()),
                                          child: warrantyController.pdfExist.value
                                          ? CommonButton(
                                              onPressed: () async {
                                                print('url is ${warrantyController.urlToDownload.value}');
                                                await launchUrlString(
                            warrantyController.urlToDownload.value);
                                              },
                                              backGroundColor: AppColors.lumiBluePrimary,
                                              textColor: AppColors.lightWhite,
                                              buttonText: translation(context).downloadWarrantyCard,
                                              isEnabled: true,
                                              containerBackgroundColor: AppColors.lightWhite1,
                                            )
                                          : SizedBox()),
                      ),
                    ],                          );
                    
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
                  )
                            ],
                          ),
                ),
              ),
                ]),
        ),
    ));
  }
}
