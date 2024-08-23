import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../data/datasource/mpartner_remote_data_source.dart';
import '../../../../network/api_constants.dart';
import '../../../../state/contoller/cash_summary_controller.dart';
import '../../../../state/contoller/coins_summary_controller.dart';
import '../../../../state/contoller/user_data_controller.dart';
import '../../../../state/contoller/language_controller.dart';
import '../../../../state/contoller/warranty_controller.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../../utils/requests.dart';
import '../../../../utils/utils.dart';
import '../../../widgets/common_button.dart';
import '../../../widgets/headers/sales_header_widget.dart';
import '../../../widgets/something_went_wrong_widget.dart';
import '../../base_screen.dart';
import '../../userprofile/user_profile_widget.dart';
import 'help_and_support_widget.dart';
import 'tertiary_sales_registration_master_card_widget.dart';

class TertiarySalesSingleProductRegistration extends StatefulWidget {
  final String state;
  final String stateMsg;
  final String cashOrCoinHistory;
  final String data1;
  final String data2;
  final String data3;
  final String data4;
  final String data5;
  final String data6;
  final String data7;
  final String transactionType;
  final String? userType;
  final String serialNumber;
  final String productType;
  final String model;
  final String name;
  final String date;
  final String mobileNumber;
  final String registeredOn;
  final bool showSomethingWentWrongScreen;

  const TertiarySalesSingleProductRegistration({
    super.key,
    required this.state,
    required this.stateMsg,
    required this.cashOrCoinHistory,
    required this.data1,
    required this.data2,
    required this.data3,
    required this.transactionType,
    required this.data4,
    required this.data5,
    required this.data6,
    required this.data7,
    this.userType,
    required this.serialNumber,
    required this.productType,
    required this.model,
    required this.name,
    required this.date,
    required this.mobileNumber,
    required this.registeredOn,
    required this.showSomethingWentWrongScreen
  });

  @override
  State<TertiarySalesSingleProductRegistration> createState() =>
      _TertiarySalesSingleProductRegistrationState();
}

class _TertiarySalesSingleProductRegistrationState
    extends BaseScreenState<TertiarySalesSingleProductRegistration> {
  UserDataController controller = Get.find();
  LanguageController languageController = Get.find();
  CoinsSummaryController coinsSummaryController = Get.find();
  CashSummaryController cashSummaryController = Get.find();
  WarrantyController warrantyController = Get.find();
  String? token;
  String? user_id;
  String? language;

  @override
  void initState() {
    getTokenAndSapId();
    super.initState();
  }

  Future<void> getTokenAndSapId() async {
    await _initializeData();
  }

  Future<void> _initializeData() async {
    token = controller.token;
    user_id = controller.sapId;
    language = languageController.language;
    coinsSummaryController.fetchCoinsSummary();
    cashSummaryController.fetchCashSummary();
    warrantyController.getWarrantyPdfUrl(widget.serialNumber);
  }

  Future<void> fetchWarrantyCard() async {
    final Map<String, dynamic> body = {
      "user_Id": user_id,
      "token": token,
      "app_Version": AppConstants.appVersionName,
      "device_Id": "",
      "os_Type": Platform.isAndroid ? "android":"ios",
      "channel": "App",
      "device_Name": "",
      "os_Version_Name": "8.1.0",
      "os_Version_Code": "27",
      "ip_Address": "",
      "language": language,
      "screen_Name": "",
      "network_Type": "",
      "network_Operator": "",
      "time_Captured": DateTime.now().microsecondsSinceEpoch.toString(),
      "browser": "",
      "browser_Version": "",
      "discode": "",
      "serialNo": widget.serialNumber
    };

    try {
      final response = await Requests.sendPostRequest(
        ApiConstants.postGetSerWRSPrimarySecTerDetailEndPoint,
        body
      );

      if (response is! DioException && response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;
        final List<dynamic> ewarrantyOptions = data['data'];
        final String pdfUrl = ewarrantyOptions[0]['pdf_url'];
        print(pdfUrl);
        //await downloadPdf(pdfUrl);
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (error) {
      print("Error fetching data: $error");
    }
  }

  Future<void> downloadPdf(String pdfUrl, BuildContext context) async {
    if (await canLaunchUrlString(pdfUrl)) {
      await launchUrlString(pdfUrl);
    } else {
      Utils().showToast(translation(context).reportNotFound, context);
      throw 'Could not launch $pdfUrl';
    }
  }

  @override
  Widget baseBody(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double textFontMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();
    double pixelMultiplier =
        DisplayMethods(context: context).getPixelMultiplier();

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: Column(
            children: [
              HeadingRegisterSales(
                icon: Icon(
                  Icons.close,
                  color: AppColors.iconColor,
                  size: 24 * textFontMultiplier,
                ),
                heading: translation(context).tertiarySaleRegistration,
                headingSize: AppConstants.FONT_SIZE_LARGE,
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
              if (widget.showSomethingWentWrongScreen)
                SomethingWentWrongWidget(),
              if (!widget.showSomethingWentWrongScreen)
                Expanded(
                  child: SingleChildScrollView(
                      child: Column(
                        children: [
                          UserProfileWidget(),
                          TertiarySalesRegistrationMasterCard(
                              state: widget.state,
                              stateMsg: widget.stateMsg,
                              cashOrCoinHistory: widget.cashOrCoinHistory,
                              data1: widget.data1,
                              data2: widget.data2,
                              data3: widget.data3,
                              transactionType: widget.transactionType,
                              data4: widget.data4,
                              data5: widget.data5,
                              data6: widget.data6,
                              data7: widget.data7,
                              userType: widget.userType,
                              name: widget.name,
                              model: widget.model,
                              serialNumber: widget.serialNumber,
                              productType: widget.productType,
                              mobileNumber: widget.mobileNumber,
                              date: widget.date,
                              registeredOn: widget.registeredOn),
                          const Center(child: HelpAndSupportWidget()),
                      if (widget.state == "Success" || widget.state == "Pending")
                          Obx(() =>
                             Visibility(
                               visible: !warrantyController.isPdfLoading.value,
                               replacement: const Center(child: CircularProgressIndicator()),
                               child: warrantyController.pdfExist.value ?
                                 CommonButton(
                                      onPressed: () async {
                                    await launchUrlString(warrantyController.urlToDownload.value);
                                  },
                                  backGroundColor: AppColors.lumiBluePrimary,
                                  textColor: AppColors.lightWhite,
                                  buttonText: translation(context).downloadWarrantyCard,
                                  isEnabled: true,
                                  containerBackgroundColor: AppColors.lightWhite1,
                                 )
                                 : const SizedBox()
                             ),
                          )
                        ],
                      )
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
