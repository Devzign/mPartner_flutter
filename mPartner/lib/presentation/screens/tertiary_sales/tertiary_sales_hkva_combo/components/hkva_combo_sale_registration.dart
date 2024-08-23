import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../data/datasource/mpartner_remote_data_source.dart';
import '../../../../../state/contoller/language_controller.dart';
import '../../../../../state/contoller/tertiary_sales_combo_controller.dart';
import '../../../../../state/contoller/warranty_controller.dart';
import '../../../../../utils/app_constants.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';
import '../../../../../utils/requests.dart';
import '../../../../../utils/utils.dart';
import '../../../../widgets/headers/sales_header_widget.dart';
import 'hkva_combo_sale_mastercard.dart';
import '../../../userprofile/user_profile_widget.dart';
import '../../../../../utils/app_colors.dart';

import '../../../../widgets/common_button.dart';
import '../../../tertiarysalessingleproduct/components/help_and_support_widget.dart';
import 'package:get/get.dart';
import '../../../../../state/contoller/user_data_controller.dart';
import 'dart:convert';
import '../../../../../network/api_constants.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HkvaComboSaleRegistration extends StatefulWidget {
  final String status;
  final String statusMsg;
  final String creditInfo;
  final String cash;
  final String cashStatus;
  final String remark;
  final String otpStatus;
  final String coin;
  final String coinStatus;
  final String transactionType;
  final String? userType;
  final String serialNumber;
  final String productType;
  final String model;
  final String name;
  final String date;
  final String mobileNumber;
  final String serialNumbersForWarranty;
  // final bool verifiedWithOtp;
  // final String serialNumber;
  // final String mobileNumber;
  // final String date;
  // final String otpEntered;
  // final String transID;

  const HkvaComboSaleRegistration(
      {super.key,
      required this.status,
      required this.statusMsg,
      required this.creditInfo,
      required this.cash,
      required this.cashStatus,
      required this.transactionType,
      required this.remark,
      required this.otpStatus,
      required this.coin,
      required this.coinStatus,
      this.userType,
      required this.serialNumber,
      required this.productType,
      required this.model,
      required this.name,
      required this.date,
      required this.mobileNumber,
      required this.serialNumbersForWarranty});

  @override
  State<HkvaComboSaleRegistration> createState() =>
      _HkvaComboSaleRegistration();
}

class _HkvaComboSaleRegistration extends State<HkvaComboSaleRegistration> {
  UserDataController controller = Get.find();
  TertiarySalesHKVAcombo tertiarySalesHKVAcombo = Get.find();
  String? token;
  String? user_id;
  String? userType;
  WarrantyController warrantyController = Get.find();
  @override
  void initState() {
    getTokenAndSapId();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
warrantyController.getWarrantyPdfUrl(widget.serialNumber);
    });
  }

  Future<void> getTokenAndSapId() async {
    await _initializeData();
  }

  Future<void> _initializeData() async {
    token = controller.token;
    user_id = controller.sapId;
    userType = controller.userType;
  }

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double textFontMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();

    return WillPopScope(
      onWillPop: () async {
        warrantyController.getWarrantyPdfUrl(widget.serialNumbersForWarranty);
        Navigator.of(context).pop();
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: Column(
            children: [
              HeadingRegisterSales(
                icon: Icon(
                  Icons.arrow_back_outlined,
                  color: AppColors.iconColor,
                  size: 24 * textFontMultiplier,
                ),
                heading: translation(context).tertiarySaleRegistration,
                headingSize: AppConstants.FONT_SIZE_LARGE,
                onPressed: () {
                  warrantyController.getWarrantyPdfUrl(widget.serialNumbersForWarranty);
                  Navigator.of(context).pop();
                },
              ),
              Expanded(
                child: SingleChildScrollView(
                    child: Column(
                  children: [
                    UserProfileWidget(),
                    HkvaComboMastercard(
                        userType: userType,
                        status: widget.status,
                        statusMsg: widget.statusMsg,
                        creditInfo: widget.creditInfo,
                        cash: widget.cash,
                        cashStatus: widget.cashStatus,
                        transactionType: widget.transactionType,
                        remark: widget.remark,
                        otpStatus: widget.otpStatus,
                        coin: widget.coin,
                        coinStatus: widget.coinStatus,
                        serialNumber: widget.serialNumber,
                        productType: widget.productType,
                        model: widget.model,
                        name: widget.name,
                        date: widget.date,
                        mobileNumber: widget.mobileNumber),
                    const Center(child: HelpAndSupportWidget()),
                    if (widget.status.toLowerCase() == "accepted" ||
                        widget.status.toLowerCase() == "pending")
                      Obx(
                      () => Visibility(
                        visible: !warrantyController.isPdfLoading.value,
                        replacement:
                            const Center(child: CircularProgressIndicator()),
                        child: warrantyController.pdfExist.value
                        ? CommonButton(
                          onPressed: () async {
                            await launchUrlString(
                                warrantyController.urlToDownload.value);
                          },
                          backGroundColor: AppColors.lumiBluePrimary,
                          textColor: AppColors.lightWhite,
                          buttonText: translation(context).downloadWarrantyCard,
                          isEnabled: true,
                          containerBackgroundColor: AppColors.lightWhite1,
                        )
                        : SizedBox()
                      ),
                    ),
                  ],
                )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
