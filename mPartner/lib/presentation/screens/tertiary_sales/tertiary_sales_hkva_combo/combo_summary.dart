import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../data/models/hkva_item_post_sale_model.dart';
import '../../../../data/models/tertiary_sales_userinfo_model.dart';
import '../../../../network/api_constants.dart';
import '../../../../state/contoller/cash_summary_controller.dart';
import '../../../../state/contoller/coins_summary_controller.dart';
import '../../../../state/contoller/language_controller.dart';
import '../../../../state/contoller/tertiary_sales_combo_controller.dart';
import '../../../../state/contoller/user_data_controller.dart';
import '../../../../state/contoller/warranty_controller.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../../utils/requests.dart';
import '../../../../utils/routes/app_routes.dart';
import '../../../widgets/coin_with_image_widget.dart';
import '../../../widgets/common_button.dart';
import '../../../widgets/headers/sales_header_widget.dart';
import '../../../widgets/horizontalspace/horizontal_space.dart';
import '../../../widgets/rupee_with_sign_widget.dart';
import '../../../widgets/something_went_wrong_widget.dart';
import '../../../widgets/verticalspace/vertical_space.dart';
import '../../base_screen.dart';
import '../../userprofile/user_profile_widget.dart';
import 'components/combo_heading_and_card.dart';
import 'components/heading.dart';
import 'components/hkva_combo_sale_registration.dart';
import 'components/sale_registered.dart';

class hkvaComboSummaryScreen extends StatefulWidget {
  const hkvaComboSummaryScreen(
      {required this.otp, required this.transactionId, super.key});

  final String otp;
  final String transactionId;

  @override
  State<hkvaComboSummaryScreen> createState() {
    return _hkvaComboSummaryScreen();
  }
}

class _hkvaComboSummaryScreen extends BaseScreenState<hkvaComboSummaryScreen> {
  int _selectedValue = -1;
  TertiarySalesHKVAcombo salecontroller = Get.find();
  UserDataController usercontroller = Get.find();
  CoinsSummaryController coinsSummaryController = Get.find();
  CashSummaryController cashSummaryController = Get.find();

  dynamic ListPostSale = [];
  String message = '';
  List<HkvaItemPostSaleModel> _filteredList = [];
  bool somethingWentWrong = false;

  bool isLoading = true;

  WarrantyController warrantyController = Get.find();

  HvkaResponsePostSale apiResponse = HvkaResponsePostSale(
      message: '', status: '', token: '', data: [], data1: '');
  List<int> counts = [0, 0, 0];

  //counts[0]-> 'Accepted', counts[1] -> 'Pending', counts[2]-> 'Rejected'
  void filterItemsByStatus(String systemStatus) {
    setState(() {
      _filteredList = ListPostSale.where((item) {
        return item.systemStatus.toLowerCase() == systemStatus.toLowerCase();
      }).toList();
    });
  }
  String formatDate(String responseRegisteredOn){
    DateTime? originalRegisteredOn = (responseRegisteredOn != null)
      ? DateTime.parse(responseRegisteredOn!)?.toLocal()
      : null;
    String formattedRegisteredOn = (originalRegisteredOn != null)
      ? DateFormat(AppConstants.appDateFormatWithTime).format(originalRegisteredOn)
      : "Default Value";

    return formattedRegisteredOn;
  }

  void showTransactionStatusScreen(HkvaItemPostSaleModel item) {
    String userType = usercontroller.userType;
    String coinStatus='';
    String cashStatus='';
    if(widget.otp != ''){
      if (item.systemStatus.toLowerCase() == 'accepted') {
        cashStatus = translation(context).cashEarned;
        coinStatus = translation(context).coinsEarned;
      } else if (item.systemStatus.toLowerCase() == 'pending') {
        cashStatus = translation(context).cashPending;
        coinStatus = translation(context).coinsPending;
      }
      else {
        cashStatus = translation(context).cashRejected;
        coinStatus = translation(context).coinsRejected;
      }
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => HkvaComboSaleRegistration(
          status: item.systemStatus,
          statusMsg: item.systemStatus,
          creditInfo: (userType == 'DEALER')
              ? '${item.coinPoints} ${translation(context).coinsLowerCase} & \u{20B9} ${item.wrsPoint} ${translation(context).creditedToYourMPartnerWallet}'
              : '\u{20B9} ${item.wrsPoint} ${translation(context).creditedToYourMPartnerWallet}',
          cash: item.wrsPoint,
          cashStatus: cashStatus,
          transactionType: '',
          remark: item.status,
          otpStatus:
              '${translation(context).purchaseVerified} ${widget.otp == '' ? '${translation(context).withoutOTP}' : '${translation(context).withOTP}'}',
          coin: item.coinPoints,
          coinStatus: coinStatus,
          serialNumber: item.serialNo,
          productType: item.productType,
          model: item.modelName,
          name: salecontroller.userInfo.value.name,
          date: formatDate(item.registeredOn),
          mobileNumber: salecontroller.userInfo.value.mobileNumber,
          serialNumbersForWarranty: fetchSerialsWarranty(ListPostSale),
        ),
      ),
    );
  }

  Future<HvkaResponsePostSale> getListPostSale() async {
    TertiarySalesUserInfo userInfo = salecontroller.userInfo.value;
    String token = usercontroller.token;
    String sapId = usercontroller.sapId;
    String userType = usercontroller.userType;
    LanguageController languageController = Get.find();

    List<Map<String, dynamic>> serialNumbersData = [];

    for (int i = 0; i < salecontroller.hkvaItemModels.length; i++) {
      if (salecontroller.hkvaItemModels[i].serial.isEmpty) {
        continue;
      }

      Map<String, dynamic> serialData = {
        "productSerialNo": salecontroller.hkvaItemModels[i].serial,
        "distcode": sapId,
        "saledate": userInfo.date,
        "custphone": userInfo.mobileNumber.split(' - ')[1],
        "custname": userInfo.name,
        "custaddress": userInfo.address,
        "eW_isVerified": (widget.otp == '') ? false : true,
        "eW_ViaVerified": (widget.otp == '') ? "WITHOUT_OTP" : "WITH_OTP",
        "eW_VerifiedBy": sapId,
        "eW_OTP": widget.otp,
        "eW_IMEI": deviceId,
        "transID": widget.transactionId
      };

      serialNumbersData.add(serialData);
    }

    final Map<String, dynamic> body = {
      "user_Id": sapId,
      "token": token,
      "app_Version": AppConstants.appVersionName,
      "device_Id": deviceId,
      "os_Type": osType,
      "channel": AppConstants.channel,
      "device_Name": deviceName,
      "os_Version_Name": osVersionName,
      "os_Version_Code": osVersionCode,
      "ip_Address": ipAddress,
      "language": languageController.language,
      "screen_Name": "",
      "network_Type": networkType,
      "network_Operator": networkOperator,
      "time_Captured": DateTime.now().microsecondsSinceEpoch.toString(),
      "balance_Value": "",
      "data": serialNumbersData
    };
    try {
      final response = await Requests.sendPostRequest(
          ApiConstants.postHkvaCombinationEditSubmit, body);

      coinsSummaryController.fetchCoinsSummary();
      cashSummaryController.fetchCashSummary();

      if (response is! DioException && response.statusCode == 200) {
        setState(() {
          somethingWentWrong = false;
        });
        if (response.data['status'] == '200') {
          return HvkaResponsePostSale.fromJson(response.data);
        } else if (response.data['status'] == '201') {
          setState(() {
            message = response.data['data1'];
          });
        } else {
          setState(() {
            somethingWentWrong = true;
          });
        }
      } else {
        setState(() {
          somethingWentWrong = true;
        });
        logger.e('Failed with status ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        somethingWentWrong = true;
      });
      logger.e('Exception occurred: $e');
    }

    return HvkaResponsePostSale(
      message: '',
      status: '',
      token: '',
      data: [],
      data1: '',
    );
  }

  List<int> getCounts(List<HkvaItemPostSaleModel> ListPostSale) {
    List<int> counts = [0, 0, 0];

    for (final item in ListPostSale) {
      if (item.systemStatus.toLowerCase() == 'accepted') {
        counts[0]++;
      } else if (item.systemStatus.toLowerCase() == 'pending') {
        counts[1]++;
      } else if (item.systemStatus.toLowerCase() == 'rejected') {
        counts[2]++;
      }
    }
    return counts;
  }

  String fetchSerialsWarranty(List<HkvaItemPostSaleModel> ListPostSale) {
    String forWarranty = '';
    for (final item in ListPostSale) {
      if ((item.systemStatus.toLowerCase() == "accepted" ||
          item.systemStatus.toLowerCase() == "pending")) {
        forWarranty += '${item.serialNo},';
      }
    }
    return forWarranty;
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      HvkaResponsePostSale data = await getListPostSale();
      setState(() {
        isLoading = false;
        apiResponse = data;
        ListPostSale = apiResponse.data;
        _filteredList = ListPostSale;
        counts = getCounts(ListPostSale);
        warrantyController
            .getWarrantyPdfUrl(fetchSerialsWarranty(ListPostSale));
        message = (apiResponse.message != '') ? apiResponse.message : message;
        print("insideComboSummary:data${data.data}");
      });
    });
    super.initState();
  }

  @override
  Widget baseBody(BuildContext context) {
    TertiarySalesUserInfo userInfo = salecontroller.userInfo.value;
    String userType = usercontroller.userType;

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double r = DisplayMethods(context: context).getPixelMultiplier();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).popUntil(
          ModalRoute.withName(AppRoutes.registerSales),
        );
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
                  Icons.close,
                  color: AppColors.iconColor,
                  size: 24 * f,
                ),
                heading: translation(context).tertiarySaleRegistration,
                headingSize: AppConstants.FONT_SIZE_LARGE,
                onPressed: () {
                  Navigator.of(context)
                      .popUntil(ModalRoute.withName(AppRoutes.registerSales));
                  Navigator.of(context).pop();
                },
              ),
              if (!somethingWentWrong)
                UserProfileWidget(
                  top: 8 * variablePixelHeight,
                ),
              (somethingWentWrong)
                  ? SomethingWentWrongWidget()
                  : (!isLoading)
                      ? Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 24 * variablePixelWidth),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      (widget.otp == '')
                                          ? Container()
                                          : Text(
                                              translation(context).earningStatus,
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.poppins(
                                                color: AppColors.blackStatus,
                                                fontSize: 16 * f,
                                                fontWeight: FontWeight.w600,
                                                height: 28 / 16,
                                              ),
                                            ),
                                      VerticalSpace(height: 20),
                                      (widget.otp == '')
                                          ? Container()
                                          : Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Visibility(
                                                    visible: (counts[0] != 0),
                                                    child: filterCard(
                                                      value: 1,
                                                      coins: (ListPostSale
                                                              .isNotEmpty)
                                                          ? ListPostSale[
                                                                  ListPostSale
                                                                          .length -
                                                                      1]
                                                              .totalCoinsAccepted
                                                          : 0,
                                                      cash: (ListPostSale
                                                              .isNotEmpty)
                                                          ? ListPostSale[
                                                                  ListPostSale
                                                                          .length -
                                                                      1]
                                                              .totalWRSAccepted
                                                          : 0,
                                                      status: translation(context)
                                                          .accepted,
                                                      statusCount:
                                                          (counts.isNotEmpty)
                                                              ? counts[0]
                                                              : 0,
                                                      color:
                                                          AppColors.successGreen,
                                                      ontap: (value) {
                                                        setState(() {
                                                          if (_selectedValue ==
                                                              1) {
                                                            _selectedValue = -1;
                                                            _filteredList =
                                                                ListPostSale;
                                                          } else {
                                                            _selectedValue =
                                                                value;
                                                            filterItemsByStatus(
                                                                'accepted');
                                                          }
                                                          debugPrint(
                                                              value.toString());
                                                        });
                                                      },
                                                      groupValue: _selectedValue,
                                                      isSelected:
                                                          _selectedValue == 1,
                                                    )),
                                                HorizontalSpace(width: 6),
                                                Visibility(
                                                    visible: (counts[1] != 0),
                                                    child: filterCard(
                                                      value: 2,
                                                      coins: (ListPostSale
                                                              .isNotEmpty)
                                                          ? ListPostSale[
                                                                  ListPostSale
                                                                          .length -
                                                                      1]
                                                              .totalCoinsPending
                                                          : 0,
                                                      cash: (ListPostSale
                                                              .isNotEmpty)
                                                          ? ListPostSale[
                                                                  ListPostSale
                                                                          .length -
                                                                      1]
                                                              .totalWRSPending
                                                          : 0,
                                                      status: translation(context)
                                                          .pending,
                                                      statusCount:
                                                          (counts.isNotEmpty)
                                                              ? counts[1]
                                                              : 0,
                                                      color: AppColors.goldCoin,
                                                      ontap: (value) {
                                                        setState(() {
                                                          if (_selectedValue ==
                                                              2) {
                                                            _selectedValue = -1;
                                                            _filteredList =
                                                                ListPostSale;
                                                          } else {
                                                            _selectedValue =
                                                                value;
                                                            filterItemsByStatus(
                                                                'pending');
                                                          }
                                                          debugPrint(
                                                              value.toString());
                                                        });
                                                      },
                                                      groupValue: _selectedValue,
                                                      isSelected:
                                                          _selectedValue == 2,
                                                    )),
                                                HorizontalSpace(width: 6),
                                                Visibility(
                                                    visible: (counts[2] != 0),
                                                    child: filterCard(
                                                      value: 3,
                                                      coins: (ListPostSale
                                                              .isNotEmpty)
                                                          ? ListPostSale[
                                                                  ListPostSale
                                                                          .length -
                                                                      1]
                                                              .totalCoinsRejected
                                                          : 0,
                                                      cash: (ListPostSale
                                                              .isNotEmpty)
                                                          ? ListPostSale[
                                                                  ListPostSale
                                                                          .length -
                                                                      1]
                                                              .totalWRSRejected
                                                          : 0,
                                                      status: translation(context)
                                                          .rejected,
                                                      statusCount:
                                                          (counts.isNotEmpty)
                                                              ? counts[2]
                                                              : 0,
                                                      color: AppColors.errorRed,
                                                      ontap: (value) {
                                                        setState(() {
                                                          if (_selectedValue ==
                                                              3) {
                                                            _selectedValue = -1;
                                                            _filteredList =
                                                                ListPostSale;
                                                          } else {
                                                            _selectedValue =
                                                                value;
                                                            filterItemsByStatus(
                                                                'rejected');
                                                          }
                                                          debugPrint(
                                                              value.toString());
                                                        });
                                                      },
                                                      groupValue: _selectedValue,
                                                      isSelected:
                                                          _selectedValue == 3,
                                                    ))
                                              ],
                                            ),
                                      (widget.otp == '')
                                          ? Container()
                                          : const VerticalSpace(height: 20),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          (widget.otp == '')
                                              ? SaleRegistered(
                                                  text1: translation(context)
                                                      .saleRegisteredTo,
                                                  text2:
                                                      "${userInfo.name} (${userInfo.mobileNumber})",
                                                )
                                              : Text(
                                                  '${translation(context).forSaleTo} ${userInfo.name} (${userInfo.mobileNumber})',
                                                  style: TextStyle(
                                                    color: AppColors.darkGreyText,
                                                    fontSize: 14 * f,
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w600,
                                                    height: 16 / 14,
                                                  ),
                                                ),
                                          VerticalSpace(height: 12),
                                          Container(
                                            // height: 24 * variablePixelHeight,
                                            alignment: Alignment.center,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                padding: EdgeInsets.fromLTRB(
                                                    12 * variablePixelWidth,
                                                    4 * variablePixelHeight,
                                                    12 * variablePixelWidth,
                                                    4 * variablePixelHeight),
                                                minimumSize: Size.zero,
                                                elevation: 0,
                                                backgroundColor:
                                                    AppColors.lumiLight5,
                                                foregroundColor:
                                                    AppColors.lumiBluePrimary,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100.0 * r),
                                                ),
                                              ),
                                              onPressed: () {},
                                              child: Text(
                                                '${translation(context).purchaseVerified} ${widget.otp == '' ? '${translation(context).withoutOTP}' : '${translation(context).withOTP}'}',
                                                style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 10 * f,
                                                  height: 16 / 10,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      VerticalSpace(height: 16),
                                      (message != '')
                                          ? Center(
                                              child: Text(
                                                message,
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.poppins(
                                                  color: AppColors.errorRed,
                                                  fontSize: 14 * f,
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 1,
                                                ),
                                              ),
                                            )
                                          : Container(),
                                      (isLoading)
                                          ? Container()
                                          : ListView.builder(
                                              padding: EdgeInsets.zero,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: _filteredList.length,
                                              itemBuilder: (context, index) {
                                                return InkWell(
                                                  onTap: () =>
                                                      showTransactionStatusScreen(
                                                          _filteredList[index]),
                                                  child: Container(
                                                    width:
                                                        variablePixelHeight * 392,
                                                    padding: EdgeInsets.symmetric(
                                                      vertical: 10 *
                                                          variablePixelHeight,
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        ComboHeadingAndCard(
                                                          showCoinsAndCash: true,
                                                          productType: index == 0
                                                              ? _filteredList[
                                                                      index]
                                                                  .productType
                                                              : "${_filteredList[index].productType} ${index}",
                                                          serialNumber:
                                                              _filteredList[index]
                                                                  .serialNo,
                                                          productName:
                                                              _filteredList[index]
                                                                  .modelName,
                                                          remark:
                                                              _filteredList[index]
                                                                  .status,
                                                          status:
                                                              _filteredList[index]
                                                                  .systemStatus,
                                                          coins: (_filteredList[
                                                                          index]
                                                                      .coinPoints ==
                                                                  '')
                                                              ? 0
                                                              : int.parse(
                                                                  _filteredList[
                                                                          index]
                                                                      .coinPoints),
                                                          cashback: (_filteredList[
                                                                          index]
                                                                      .wrsPoint ==
                                                                  '')
                                                              ? 0
                                                              : int.parse(
                                                                  _filteredList[
                                                                          index]
                                                                      .wrsPoint),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                    ],
                                  ),
                                ),
                                Obx(
                                  () => Visibility(
                                      visible: !warrantyController
                                              .isPdfLoading.value &&
                                          !isLoading,
                                      replacement: const Center(
                                          child: CircularProgressIndicator()),
                                      child: warrantyController.pdfExist.value
                                          ? CommonButton(
                                              onPressed: () async {
                                                await launchUrlString(
                                                    warrantyController
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
                                          : SizedBox()),
                                ),
                              ],
                            ),
                          ),
                        )
                      : const Expanded(
                          child: Center(child: CircularProgressIndicator())),
            ],
          ),
        ),
      ),
    );
  }
}

class CoinAndCash extends StatelessWidget {
  CoinAndCash({
    required this.coins,
    required this.cash,
  });

  final int coins;
  final int cash;

  @override
  Widget build(BuildContext context) {
    UserDataController usercontroller = Get.find();
    String userType = usercontroller.userType;
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double r = DisplayMethods(context: context).getPixelMultiplier();
    double f = DisplayMethods(context: context).getTextFontMultiplier();

    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          (userType == 'DEALER')
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CoinWithImageWidget(
                        coin: double.tryParse("$coins") ?? 0,
                        color: AppColors.lumiBluePrimary,
                        size: 16,
                        weight: FontWeight.w600,
                        width: 160),
                  ],
                )
              : Container(),
          VerticalSpace(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: RupeeWithSignWidget(
                cash: double.tryParse(cash.toString()) ?? 0,
                color: AppColors.lumiBluePrimary,
                size: 16,
                weight: FontWeight.w600,
                width: 160),
          ),
        ],
      ),
    );
  }
}

class statusFilter extends StatelessWidget {
  statusFilter({
    required this.status,
    required this.statusCount,
    required this.color,
  });

  final String status;
  final int statusCount;
  final Color color;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double r = DisplayMethods(context: context).getPixelMultiplier();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    return Text(
      '$status (${statusCount.toString().padLeft(2, '0')})',
      textAlign: TextAlign.center,
      style: GoogleFonts.poppins(
        fontSize: 12 * f,
        height: 16 / 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: color,
      ),
    );
  }
}

class filterCard extends StatelessWidget {
  filterCard({
    required this.isSelected,
    required this.groupValue,
    required this.value,
    required this.coins,
    required this.cash,
    required this.status,
    required this.statusCount,
    required this.color,
    required this.ontap,
  });

  final int groupValue;
  final int value;
  final int coins;
  final int cash;
  final Color color;
  final String status;
  final int statusCount;
  final ValueChanged<int> ontap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double r = DisplayMethods(context: context).getPixelMultiplier();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    return Container(
      clipBehavior: Clip.none,
      child: InkWell(
        onTap: () => ontap(value),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8 * r),
                border: !isSelected
                    ? Border.all(color: AppColors.lightGrey2, width: 1)
                    : null,
                boxShadow: (isSelected && groupValue != -1)
                    ? [
                        const BoxShadow(
                          offset: Offset(0, 0),
                          blurRadius: 6,
                          spreadRadius: 3,
                          blurStyle: BlurStyle.outer,
                          color: AppColors.summaryShadowColor,
                        ),
                      ]
                    : [],
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    2 * variablePixelWidth,
                    6 * variablePixelHeight,
                    2 * variablePixelWidth,
                    6 * variablePixelHeight),
                child: Card(
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  color: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CoinAndCash(coins: coins, cash: cash),
                      VerticalSpace(height: 12),
                      statusFilter(
                          status: status,
                          color: color,
                          statusCount: statusCount),
                    ],
                  ),
                ),
              ),
            ),
            Visibility(
              visible: isSelected,
              child: Positioned(
                  top: -12,
                  right: 0,
                  child: GestureDetector(
                    onTap: () => ontap(-1),
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100 * r),
                        color: AppColors.lightGrey2,
                      ),
                      child: SizedBox(
                        width: 12 * r,
                        height: 12 * r,
                        child: Icon(
                          Icons.close,
                          color: AppColors.darkGreyText,
                        ),
                      ),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
