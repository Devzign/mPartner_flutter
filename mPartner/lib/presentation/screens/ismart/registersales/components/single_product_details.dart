import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../../state/contoller/user_data_controller.dart';
import '../../../../../state/contoller/warranty_controller.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_constants.dart';
import '../../../../../utils/app_string.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';
import '../../../../../utils/utils.dart';
import '../../../../widgets/common_button.dart';
import '../../../../widgets/headers/sales_header_widget.dart';
import '../../../userprofile/user_profile_widget.dart';
import '../secondarysales/components/help_and_support_widget.dart';
import '../uimodels/customer_info.dart';
import '../uimodels/dealer_info.dart';
import '../uimodels/product_details.dart';
import 'single_product_details_master_card_widget.dart';

class SingleProductDetails extends StatefulWidget {
  final ProductDetails productDetails;
  final DealerInfo? dealerInfo;
  final CustomerInfo? customerInfo;
  final DateTime? registerDate;
  final String? saleTime;
  final String? saleType;
  final bool? isOTPVerified;
  final String? serialNos;
  final String? serialNumbersForWarranty;

  const SingleProductDetails({
    super.key,
    required this.productDetails,
    this.serialNos,
    this.dealerInfo,
    this.customerInfo,
    this.registerDate,
    this.saleTime,
    this.saleType,
    this.isOTPVerified,
    this.serialNumbersForWarranty,
  });

  @override
  State<SingleProductDetails> createState() => _SingleProductDetailsState();
}

class _SingleProductDetailsState extends State<SingleProductDetails> {
  String getStatusMsgDisty(String status, String wrsPoints) {
    String statusMsg = "";
    switch (status.toLowerCase()) {
      case 'accepted':
        statusMsg =
            "\u{20B9} ${rupeeNoSign.format(rupeeNoSign.parse(wrsPoints))} ${translation(context).creditedToMPartnerWallet}";
        break;
      case 'pending':
        statusMsg =
            "\u{20B9} ${rupeeNoSign.format(rupeeNoSign.parse(wrsPoints))} ${translation(context).creditPending}, ${translation(context).reflectSoon}";
        break;
      case 'rejected':
        statusMsg =
            "\u{20B9} ${rupeeNoSign.format(rupeeNoSign.parse(wrsPoints))} ${translation(context).creditRejected}";
        break;
      default:
        statusMsg = "not available";
    }
    return statusMsg;
  }

  String getStatusMsgDealer(
      String status, String wrsPoints, String coinPoints) {
    UserDataController userDataController = Get.find();
    print(" usertype: ${userDataController.userType}");
    String statusMsg = "";
    switch (status.toLowerCase()) {
      case 'accepted':
        statusMsg =
            "$coinPoints ${translation(context).coins} & \u{20B9} ${rupeeNoSign.format(rupeeNoSign.parse(wrsPoints))} ${translation(context).creditedToMPartnerWallet}";
        break;
      case 'pending':
        statusMsg =
            "$coinPoints ${translation(context).coins} & \u{20B9} ${rupeeNoSign.format(rupeeNoSign.parse(wrsPoints))} ${translation(context).creditPending}, ${translation(context).reflectSoon}";
        break;
      case 'rejected':
        statusMsg =
            "$coinPoints ${translation(context).coins} & \u{20B9} ${rupeeNoSign.format(rupeeNoSign.parse(wrsPoints))} ${translation(context).creditRejected}";
        break;
      default:
        statusMsg = "not available";
    }
    return statusMsg;
  }

  WarrantyController warrantyController = Get.find();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      warrantyController
          .getWarrantyPdfUrl(widget.productDetails.serialNoCount ?? " ");
    });
  }

  @override
  Widget build(BuildContext context) {
    UserDataController userDataController = Get.find();
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();

    double variablePixelMultiplier =
        DisplayMethods(context: context).getPixelMultiplier();
    Future<void> downloadPdf(String pdfUrl) async {
      if (await canLaunchUrlString(pdfUrl)) {
        await launchUrlString(pdfUrl);
      } else {
        throw 'Could not launch $pdfUrl';
      }
    }

    String getHeading() {
      String heading = "";
      switch (widget.saleType) {
        case 'Secondary':
          heading =
              "${translation(context).secondarySales} ${translation(context).registration}";
        case 'Tertiary':
          heading =
              "${translation(context).tertiarySales} ${translation(context).registration}";
        case 'Intermediary':
          heading =
              "${translation(context).intermediarySales} ${translation(context).registration}";
      }
      return heading;
    }

    return WillPopScope(
      onWillPop: () async {
        if (widget.serialNumbersForWarranty != null) {
          warrantyController
              .getWarrantyPdfUrl(widget.serialNumbersForWarranty!);
        }
        Navigator.of(context).pop();
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  HeadingRegisterSales(
                    heading: getHeading(),
                    headingSize:
                        (widget.saleType == SaleTypeStrings.tertiarySaleType)
                            ? AppConstants.FONT_SIZE_LARGE
                            : AppConstants.FONT_SIZE_MEDIUM,
                    icon: Icon(
                      Icons.arrow_back_outlined,
                      color: AppColors.iconColor,
                      size: 24 * variablePixelMultiplier,
                    ),
                    onPressed: () {
                      if (widget.serialNumbersForWarranty != null) {
                        warrantyController.getWarrantyPdfUrl(
                            widget.serialNumbersForWarranty ?? '');
                      }
                      Navigator.of(context).pop();
                    },
                  ),
                  UserProfileWidget(top: 8 * variablePixelHeight),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        SingleProductDetailsMasterCard(
                            stateMsg: (userDataController.userType == 'DEALER')
                                ? getStatusMsgDealer(
                                    widget.productDetails.status,
                                    widget.productDetails.wrsPoint.toString(),
                                    widget.productDetails.coinPoint.toString())
                                : getStatusMsgDisty(
                                    widget.productDetails.status,
                                    widget.productDetails.wrsPoint.toString()),
                            productDetails: widget.productDetails,
                            customerInfo: widget.customerInfo,
                            dealerInfo: widget.dealerInfo,
                            registerDate: widget.registerDate,
                            saleTime: widget.saleTime,
                            saleType: widget.saleType,
                            isOTPVerified: widget.isOTPVerified),
                        const Center(child: HelpAndSupportWidget()),
                      ],
                    ),
                  ),
                ],
              ),
              widget.saleType == 'Tertiary' &&
                      (widget.productDetails.status.toLowerCase() ==
                              "accepted" ||
                          widget.productDetails.status.toLowerCase() ==
                              "pending")
                  ? Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Obx(
                        () => Visibility(
                          visible: !warrantyController.isPdfLoading.value,
                          replacement:
                              const Center(child: CircularProgressIndicator()),
                          child: Align(
                              alignment: Alignment.bottomCenter,
                              child: warrantyController.pdfExist.value
                                  ? CommonButton(
                                      onPressed: () async {
                                        await launchUrlString(warrantyController
                                            .urlToDownload.value);
                                      },
                                      backGroundColor:
                                          AppColors.lumiBluePrimary,
                                      textColor: AppColors.lightWhite,
                                      buttonText: translation(context)
                                          .downloadWarrantyCard,
                                      isEnabled: true,
                                      containerBackgroundColor:
                                          AppColors.lightWhite1,
                                    )
                                  : const SizedBox()),
                        ),
                      ),
                    )
                  : const SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
