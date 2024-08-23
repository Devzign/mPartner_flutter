import 'package:get/get.dart';
import '../../data/datasource/mpartner_remote_data_source.dart';
import '../../data/models/secondary_report_distributor_model.dart';
import '../../utils/app_constants.dart';

class DealerSummaryController extends GetxController {
  var dealerSummaryList = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  var error = ''.obs;
  String startRangeDate="";
  String endRangeDate="";
  RxString selectedDateFilter = ''.obs;
  RxString from = ''.obs;
  RxString to = ''.obs;

  var dealerWiseSecondarySummary = SecondaryReportDistributorModel(
          dlrName: "",
          dlrCity: "",
          dlrSapCode: "",
          battery: 0,
          gti: 0,
          regalia: 0,
          cruze: 0,
          solarPanel: 0,
          autoBattery: 0,
          pcu: 0,
          hkva: 0,
          hups: 0,
          nxg: 0,
          solarBattery: 0,
          totalProduct: 0,
          totalBatteryProduct: 0,
          totalGTIProduct: 0,
          totalRegaliaProduct: 0,
          totalSolarPanelProduct: 0,
          totalAutoBatteryProduct: 0,
          totalPCUProduct: 0,
          totalCRUZEProduct: 0,
          totalHkvaProduct: 0,
          totalHupsProduct: 0,
          totalNxgProduct: 0,
          totalSolarBatteryProduct: 0,
          totalProducts: 0)
      .obs;

  MPartnerRemoteDataSource mPartnerRemoteDataSource =
      MPartnerRemoteDataSource();

  Future<void> fetchSecondaryReportSummaryDistributor(
      {String dealerCode = "",
      String productType = "",
      String status = "",
      String fromDate = AppConstants.FROM_DATE,
      String toDate = AppConstants.TO_DATE}) async {
    try {
      isLoading(true);
      dealerSummaryList.clear();
      final result =
          await mPartnerRemoteDataSource.postSecondaryReportDistributor(dealerCode: dealerCode, productType: productType, status: status, fromDate: fromDate, toDate: toDate);
      result.fold(
        (failure) {
          // Handle failure (Left)
          error(
              'Failed to fetch Secondary report information for distributor: $failure');
        },
        (dealerSummary) async {
          for (SecondaryReportDistributorModel option
              in dealerSummary) {
            if (option.props.every((value) => value == 'NA')) {
              error('No summary available.');
            } else {
              error('');
            }
            dealerSummaryList.add(option.toJson());
            dealerWiseSecondarySummary(option);
          }
        },
      );
    } finally {
      isLoading(false);
    }
  }

  @override
  void onInit() async {
    super.onInit();
    update();
  }

  clearSecondaryReportDistributorState() {
    dealerSummaryList.clear();
    selectedDateFilter.value = "";
    from.value = "";
    to.value = "";
    isLoading = false.obs;
    error = ''.obs;
  }
}
