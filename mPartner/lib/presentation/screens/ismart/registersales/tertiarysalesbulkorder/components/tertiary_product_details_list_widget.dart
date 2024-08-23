import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mpartner/presentation/screens/ismart/registersales/tertiarysalesbulkorder/components/tertiary_bulk_verify_sales.dart';
import '../../../../../../data/models/get_tertiary_bulk_details_list_model.dart';
import '../../../../../../services/services_locator.dart';
import '../../../../../../state/contoller/tertiary_sales_combo_controller.dart';
import '../../../../../../utils/app_colors.dart';
import '../../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../../utils/enums.dart';
import '../../../../../../utils/localdata/language_constants.dart';
import '../../../../../widgets/common_button.dart';
import '../../../../../widgets/verticalspace/vertical_space.dart';
import '../../components/product_details_card_widget.dart';
import '../../uimodels/customer_info.dart';
import '../../uimodels/product_details.dart';
import '../bloc/tertiary_sales_product_details_bloc.dart';

class TertiaryProductDetailsListWidget extends StatefulWidget {
  final String serialNo;
  final CustomerInfo customerInfo;
  final bool isVerified;
  final bool isOTPVerified;
  final String? otp;
  final String? transactionID;

  final Function(ProductDetails)? onProductSelected;

  const TertiaryProductDetailsListWidget({
    this.onProductSelected,
    this.otp,
    this.transactionID,
    required this.serialNo,
    required this.customerInfo,
    required this.isVerified,
    required this.isOTPVerified,
    super.key,
  });

  @override
  State<TertiaryProductDetailsListWidget> createState() =>
      _TertiaryProductDetailsListWidgetState();
}

class _TertiaryProductDetailsListWidgetState
    extends State<TertiaryProductDetailsListWidget> {
  String? _longPressedStatus;
  late List<ProductDetails> filteredProductList;
  TertiarySalesHKVAcombo controller = Get.find();

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
      registeredOn:'',
    );
  }

  void _getFilteredProductDetails(List<TertiarySaleData> productDetailsListData) {
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

  void _handleOnProductSelected(dealer) {
    widget.onProductSelected!(dealer);
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


    return BlocProvider(
      create: (context) => sl<TertiarySalesProductDetailsBloc>()
        ..add(GetTertiaryBulkProductDetailsListEvent(
            serialNo: widget.serialNo, customerInfo: widget.customerInfo)),
      child: BlocBuilder<TertiarySalesProductDetailsBloc,
          TertiarySalesProductDetailsState>(
        builder: (context, state) {
          return BlocConsumer<TertiarySalesProductDetailsBloc,
              TertiarySalesProductDetailsState>(
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
                  _getFilteredProductDetails(state.productDetailsListData);
                  return Container(
                    color: AppColors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                       Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 24 * variablePixelWidth,
                                  vertical: 0 * variablePixelHeight,
                                ),
                                width: variablePixelWidth * 393,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      translation(context).saleRegisteringTo,
                                      style: GoogleFonts.poppins(
                                        color: AppColors.grayText,
                                        fontSize: 12 * variableTextMultiplier,
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    Text(
                                      '${widget.customerInfo.customerName}'
                                      ' (+91 - ${widget.customerInfo.mobileNo})',
                                      style: GoogleFonts.poppins(
                                        color: AppColors.darkGreyText,
                                        fontSize: 12 * variableTextMultiplier,
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              VerticalSpace(height: 8),
                        Container(
                          height: variablePixelHeight * 500,
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            physics: ClampingScrollPhysics(),
                            itemCount: filteredProductList.length,
                            itemBuilder: (context, index) {
                              final productDetails = filteredProductList[index];
                              return Container(
                                width: variablePixelHeight * 392,
                                padding: EdgeInsets.symmetric(
                                  vertical: 10 * variablePixelHeight,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ProductDetailsCardWidget(
                                        productDetails: productDetails)
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 32*variablePixelHeight,),
                        Visibility(
                          visible: widget.isVerified == false,
                          child: CommonButton(
                            onPressed: () => {
                              showModalBottomSheet(
                                  showDragHandle: false,
                                  enableDrag: true,
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Container(
                                      child:  TertiaryBulkVerifySaleBS(
                                          customerInfo: widget.customerInfo,
                                          serialNo: widget.serialNo),
                                    );
                                  })
                            },
                            isEnabled: !widget.isVerified,
                            buttonText: translation(context).verifySale,
                            containerBackgroundColor: AppColors.white,
                            horizontalPadding: 24 * variablePixelWidth,
                            topPadding: 20*variablePixelHeight,
                            bottomPadding: 0,
                          ),
                        ),
                      ],
                    ),
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
