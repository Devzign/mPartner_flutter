import 'package:get/get.dart';
import '../../data/datasource/mpartner_remote_data_source.dart';
import '../../data/models/report_type_model.dart';

class ReportTypeController extends GetxController {
  List<String?> reportType = [];
  List<String?> description = [];

  var isLoading = false.obs;
  var error = ''.obs;

  var reportTypeOptions = ReportType(reportType: "", description: "").obs;

  MPartnerRemoteDataSource mPartnerRemoteDataSource =
      MPartnerRemoteDataSource();

  void fetchReportTypes() async {
    try {
      isLoading(true);

      final result = await mPartnerRemoteDataSource.postReportType();
      result.fold(
        (failure) {
          // Handle failure (Left)
          error(
              'Failed to fetch report types: $failure');
        },
        (getReportTypeOptionsData) async {
          for (var option in getReportTypeOptionsData) {
            if (option.props.every((value) => value == 'NA')) {
              error('No report types available available.');
            } else {
              error('');
            }
            reportType =
                getReportTypeOptionsData.map((option) => option.reportType).toList();
            description =
                getReportTypeOptionsData.map((option) => option.description).toList();
            reportTypeOptions(option);
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
    fetchReportTypes();
    update();
  }

  clearReportTypeOptionsState() {
    reportType = [];
    description = [];

    isLoading = false.obs;
    error = ''.obs;

    reportTypeOptions =
        ReportType(reportType: "", description: "").obs;
  }
}
