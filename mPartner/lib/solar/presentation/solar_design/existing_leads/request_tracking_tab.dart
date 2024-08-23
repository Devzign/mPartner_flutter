import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../state/contoller/user_data_controller.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../data/datasource/solar_remote_data_source.dart';
import '../../../data/models/request_tracking_model.dart';
import '../../../utils/solar_app_constants.dart';
import '../../common/leads_list_detail_cards/request_tracking_widget.dart';
import '../../common/something_went_wrong_solar_screen.dart';

class RequestTrackingTab extends StatefulWidget {
  final String projectId;
  final String categoryId;
  final bool isDigOrPhy;
  final String? isNavigatedFrom;

  const RequestTrackingTab({
    super.key,
    required this.projectId,
    required this.categoryId,
    required this.isDigOrPhy,
    this.isNavigatedFrom,
  });

  @override
  State<RequestTrackingTab> createState() => _RequestTrackingTabState();
}

class _RequestTrackingTabState extends State<RequestTrackingTab> {
  SolarRemoteDataSource solarRemoteDataSource = SolarRemoteDataSource();
  SolarRequestTracking? solarRequestTracking;
  UserDataController controller = Get.find();
  Map<String, List<Map<String, String>>> requestTrackingMap = {};
  bool isLoading = false;
  bool noDataFound = false;
  String formattedStatus = "";

  @override
  void initState() {
    super.initState();
    getRequestTrackingList(widget.projectId);
  }

  Color checkForStatusColor(String status) {
    if (status.toLowerCase() == "shared" ||  status.toLowerCase() == "design shared") {
      formattedStatus = translation(context).designShared;
      return AppColors.successGreen;
    } else if (status.toLowerCase() == "pending" ||  status.toLowerCase() == "design pending") {
      formattedStatus = translation(context).designPending;
      return AppColors.yellowStar;
    } else if (status.toLowerCase() == "reassigned" ||  status.toLowerCase() == "design reassigned") {
      formattedStatus = translation(context).designReassigned;
      return AppColors.orange;
    } else {
      formattedStatus = translation(context).designPending;
      return AppColors.yellowStar;
    }
  }

  getRequestTrackingList(String projectId) async {
    try{
      setState(() {
        isLoading=true;
      });
      final result = await solarRemoteDataSource.postRequestTracking(projectId);
      result.fold(
          (l) {
            Navigator.of(context).pop();
            Navigator.push(context, (MaterialPageRoute(builder: (context) => SomethingWentWrongSolarScreen(
              previousRoute: widget.isDigOrPhy
                  ? SolarAppConstants.digitalDesRouteName
                  : SolarAppConstants.physicalDesRouteName,
              onPressed: (){
                Navigator.pop(context);
              },
            ))));
        },
          (right) {
            setState(() {
              solarRequestTracking = right;
              isLoading=false;
            });

            if (solarRequestTracking!.data.isEmpty) {
              setState(() {
                noDataFound = true;
              });
            } else if(solarRequestTracking?.status == '200'){
              requestTrackingMap = {};

              for (var detail in solarRequestTracking!.data) {
                String createdOn = detail.createdOn;
                DateTime parsedDate = DateTime.parse(createdOn);
                String monthAndYear = DateFormat('MMMM yyyy').format(parsedDate);

                if (!requestTrackingMap.containsKey(monthAndYear)) {
                  requestTrackingMap[monthAndYear] = [];
                }

                requestTrackingMap[monthAndYear]!.add({
                  'status': detail.status,
                  'reason': detail.reason,
                  'createdOn': createdOn,
                });
              }
              logger.d(requestTrackingMap);
            } else {
              Navigator.of(context).pop();
              Navigator.push(context, (MaterialPageRoute(builder: (context) => SomethingWentWrongSolarScreen(
                previousRoute: widget.isDigOrPhy
                    ? SolarAppConstants.digitalDesRouteName
                    : SolarAppConstants.physicalDesRouteName,
                onPressed: (){
                  Navigator.pop(context);
                },
              ))));
            }
        },
      );
    }
    catch (e){
      logger.e('Error $e');
    }
    finally {
      setState(() {
        isLoading=false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: isLoading
          ? SizedBox(
              height: 420 * h,
              child: const Center(child: CircularProgressIndicator()))
          : noDataFound
            ? SizedBox(
              height: 420 * h,
              child: Center(child: Text(translation(context).dataNotFound)))
            : Column(
                children: [
                for (var entry in requestTrackingMap.entries)
                  RequestTrackingWidget(
                    labelData: {
                      for (var detail in entry.value)
                        detail['createdOn']! : LabelValue(
                          action: detail['reason'] ?? "",
                          statusColor: checkForStatusColor(detail['status'] ?? ""),
                          status: formattedStatus,
                        ),
                    },
                    monthAndYear: entry.key,
                  ),
                ],
            ),
      ),
    );
  }
}
