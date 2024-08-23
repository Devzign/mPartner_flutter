import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/datasource/mpartner_remote_data_source.dart';
import '../../../data/models/terms_condition_model.dart';
import '../../../solar/data/datasource/solar_remote_data_source.dart';
import '../../../state/contoller/user_data_controller.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/displaymethods/display_methods.dart';
import '../../widgets/common_qr1.dart';
import '../../widgets/generic_error_widget.dart';
import '../cashredemption/widgets/continue_button.dart';
import '../tertiary_sales/tertiary_sales_hkva_combo/components/q_r_screen_back_button.dart';
import 'bloc/product_history_tnc_bloc.dart';
import 'bloc/product_history_tnc_state.dart';
import 'model/purchase_product_history_request_model.dart';
import 'product_history_items.dart';

import '../../../gem/utils/gem_default_widget/gem_header.dart';
import '../../../lms/utils/app_text_style.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_string.dart';
import '../../../utils/common_methods.dart';
import '../../../utils/localdata/language_constants.dart';

class ProductHistoryTncScreen extends StatefulWidget {
  ProductHistoryTncScreen({
    super.key,
    this.useFunction = false,
    this.isScanInverter = false,
    required this.routeWidget,
    this.subtitle,
    this.title,
    required this.showBottomModal,
    required this.onBackButtonPressedWithController,
    required this.onBackButtonPressed,
    required this.customerMobileNo,
  });

  final bool useFunction, isScanInverter;
  final String? subtitle, title, customerMobileNo;
  VoidCallback onBackButtonPressed;
  void Function(Function stopScanResults, Function startScanResults)
      onBackButtonPressedWithController;

  final Widget routeWidget;
  final bool showBottomModal;
  bool isApiLoading = false;

  @override
  ProductHistoryTncScreenState createState() => ProductHistoryTncScreenState();
}

class ProductHistoryTncScreenState extends State<ProductHistoryTncScreen> {
  bool isViewMore = false;
  UserDataController userDataController = Get.find();
  late ProductHistoryTncBloc productHistoryTncBloc;
  MPartnerRemoteDataSource baseMPartnerRemoteDataSource =
      MPartnerRemoteDataSource();
  SolarRemoteDataSource baseSolarRemoteDataSource = SolarRemoteDataSource();
  final ScrollController controller = ScrollController();
  int pageNum = 1;
  int pageSize = 10;

  @override
  void initState() {
    productHistoryTncBloc = BlocProvider.of<ProductHistoryTncBloc>(context);
    super.initState();
    callAPI(0);
    controller.addListener(_scrollListener);
  }

  @override
  void dispose() {
    super.dispose();
    controller.removeListener(_scrollListener);
  }

  void _scrollListener() {
    if (controller.position.extentAfter < 200.0 &&
        productHistoryTncBloc.isPageLoading == false &&
        productHistoryTncBloc.lastItemCount == pageSize &&
        isViewMore) {
      pageNum = pageNum + 1;
      callAPI(1);
    }
  }

  callAPI(var type) {
    var requestModel = PurchaseProductHistoryRequestModel();
    requestModel.userId = userDataController.sapId;
    requestModel.channel = AppConstants.channel;
    requestModel.osType = osType;
    requestModel.appVersion = AppConstants.appVersionName;
    requestModel.deviceId = deviceId;
    requestModel.phoneNo = userDataController.phoneNumber;
    requestModel.customerMobileNumber = widget.customerMobileNo;
    requestModel.pageSize = pageSize;
    requestModel.pageNumber = pageNum;
    if (type == 0) {
      productHistoryTncBloc.getPreviouslyPurchasedProduct(requestModel,
          baseMPartnerRemoteDataSource, baseSolarRemoteDataSource);
    } else {
      productHistoryTncBloc.getPreviouslyPurchasedProductLoadMore(requestModel,
          baseMPartnerRemoteDataSource, baseSolarRemoteDataSource);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: ContinueButton(
        containerBackgroundColor: AppColors.white,
        isEnabled: true,
        onPressed: () {
          double r = DisplayMethods(context: context).getPixelMultiplier();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BarcodeAndQRScanner(
                title: widget.title,
                subtitle: widget.subtitle,
                isScanInverter: widget.isScanInverter,
                onBackButtonPressed: () => {},
                onBackButtonPressedWithController:
                    (pauseCamera, resumeCamera) => {
                  pauseCamera(),
                  showModalBottomSheet(
                      isScrollControlled: false,
                      enableDrag: false,
                      useSafeArea: true,
                      isDismissible: false,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(28 * r),
                              topRight: Radius.circular(28 * r))),
                      showDragHandle: false,
                      backgroundColor: AppColors.white,
                      context: context,
                      builder: (BuildContext context) {
                        return PopScope(
                          canPop: false,
                          child: QRScreenBackButton(
                            resumeCamera: resumeCamera,
                          ),
                        );
                      }),
                },
                useFunction: widget.useFunction,
                routeWidget: widget.routeWidget,
                showBottomModal: widget.showBottomModal,
              ),
            ),
          );
        },
        buttonText: translation(context).titleAcceptContinue,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GemHeader(translation(context).registerSales),
          vSpace(10),
          Expanded(
            child: SingleChildScrollView(
              controller: controller,
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    children: [
                      buildUI(),
                    ],
                  )),
            ),
          )
        ],
      ),
    );
  }

  Widget tncView(List<TermsConditionData> data) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            translation(context).titleVerificationRules,
            style: AppTextStyle.getStyle(
                color: AppColors.darkText2,
                fontSize: 13,
                fontWeight: FontWeight.w600),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: data
              .map(
                (data) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: data.termsConditionData
                      .split('<p>')
                      .where((element) => element.trim().isNotEmpty)
                      .map(
                        (point) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${point.trim().replaceAll(RegExp('</p>'), '')}',
                              style: GoogleFonts.poppins(
                                color: AppColors.darkGreyText,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.10,
                              ),
                            ),
                            vSpace(15),
                          ],
                        ),
                      )
                      .toList(),
                ),
              )
              .toList(),
        ),
        vSpace(20),
      ],
    );
  }

  Widget pastProductListView(String discriptionMessage) {
    return Column(
      children: [
        Text(
          discriptionMessage,
          style: AppTextStyle.getStyle(
              color: AppColors.darkText2,
              fontSize: 13,
              fontWeight: FontWeight.w600),
        ),
        vSpace(15),
        ListView.builder(
            itemCount: productHistoryTncBloc.pastProductData.length > 2 &&
                    isViewMore == false
                ? 2
                : productHistoryTncBloc.pastProductData?.length,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return ProductHistoryItems(
                productModel:
                    productHistoryTncBloc.pastProductData[index].productModel ??
                        "",
                serialNo: productHistoryTncBloc
                        .pastProductData[index].productSerialNumber ??
                    "",
                onItemTap: () {},
                date:
                    productHistoryTncBloc.pastProductData[index].purchaseDate ??
                        "",
                isLast: productHistoryTncBloc.pastProductData.length > 2 &&
                        isViewMore == false
                    ? index == 1
                    : productHistoryTncBloc.pastProductData.length == index + 1,
              );
            }),
        vSpace(20),
        productHistoryTncBloc.pastProductData.length > 2
            ? Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.lumiBluePrimary,
                    ),
                    color: AppColors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(25))),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      if (isViewMore) {
                        isViewMore = false;
                      } else {
                        isViewMore = true;
                      }
                    });
                  },
                  child: Text(
                    isViewMore
                        ? ProductHistoryTNC.titleViewLess
                        : ProductHistoryTNC.titleViewAll,
                    style: AppTextStyle.getStyle(
                        color: AppColors.lumiBluePrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              )
            : const SizedBox(),
        vSpace(15),
      ],
    );
  }

  Widget buildUI() {
    return BlocBuilder<ProductHistoryTncBloc, ProductHistoryTncState>(
        builder: (context, state) {
      if (state is LoadingState) {
        return const Center(
            heightFactor: 20, child: CircularProgressIndicator());
      } else if (state is NoInternetConnection) {
        return  Center(
          heightFactor: 5,
          child: GenericErrorWidget(
            isInternetError: true,
              onTap: (){
                callAPI(0);
              },
              icon: Icons.signal_cellular_connected_no_internet_4_bar_sharp,
              errorText: ProductHistoryTNC.titleInternetConnectionIssue),
        );
      } else if (state is ErrorDataState) {
        return Center(
          heightFactor: 5,
          child:
              GenericErrorWidget(icon: Icons.error, errorText: state.errorMsg),
        );
      } else if (state is ErrorState) {
        return Center(
          heightFactor: 5,
          child:
              GenericErrorWidget(icon: Icons.error, errorText: state.errorMsg),
        );
      } else if (state is ProductHistoryTncResponseState) {
        if ((productHistoryTncBloc.pastProductData.isNotEmpty) ||
            (state.termsConditionsResponse != null &&
                state.termsConditionsResponse.data.isNotEmpty)) {
          return Column(
            children: [
              (productHistoryTncBloc.pastProductData.isNotEmpty)
                  ? pastProductListView(
                      state.responseModel.data?.discriptionMessage ?? "")
                  : const SizedBox(),
              (state.termsConditionsResponse != null &&
                      state.termsConditionsResponse.data.isNotEmpty)
                  ? tncView(state.termsConditionsResponse.data)
                  : const SizedBox(),
            ],
          );
        } else {
          return Center(
            heightFactor: 5,
            child: GenericErrorWidget(
                icon: Icons.hourglass_empty,
                errorText: translation(context).noRecordFound),
          );
        }
      } else {
        return Container();
      }
    });
  }
}
