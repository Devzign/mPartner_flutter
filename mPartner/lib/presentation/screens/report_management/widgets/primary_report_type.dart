import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mpartner/presentation/widgets/verticalspace/vertical_space.dart';
import 'package:mpartner/state/contoller/primary_report_types_controller.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../report_management/widgets/report_type_text.dart';

// ... Import statements

class PrimaryReportType extends StatefulWidget {
  final Function(String) onReportTypeSelected;
  PrimaryReportType({super.key, required this.onReportTypeSelected});

  @override
  State<PrimaryReportType> createState() => _PrimaryReportTypeState();
}

class _PrimaryReportTypeState extends State<PrimaryReportType> {
  late String selectedReportType;

  @override
  void initState() {
    super.initState();
    selectedReportType = "Select Report Type";
  }

  void onSelect(String reportType) {
    setState(() {
      selectedReportType = reportType;
      widget.onReportTypeSelected(reportType);
    });
  }

  @override
  Widget build(BuildContext context) {
    selectedReportType = translation(context).selectReportType;
    PrimaryReportTypeController primaryReportTypeController = Get.find();
    
    return SingleChildScrollView(
      child: Obx(() {
        if (primaryReportTypeController.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (primaryReportTypeController.error.isNotEmpty) {
          return Center(
            child: Text(
              'Error: ${primaryReportTypeController.error.value}',
              style: TextStyle(color: AppColors.errorRed),
            ),
          );
        } else {
          final bool isDataEmpty =
              primaryReportTypeController.primaryReportTypes.isEmpty;
          if (isDataEmpty) {
            return Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: primaryReportTypeController.primaryReportTypes.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ReportTypeTextWidget(
                      text: primaryReportTypeController.primaryReportTypes[index] ?? "",
                      onTap: () => onSelect(primaryReportTypeController.primaryReportTypes[index] ?? ""),
                    ),
                    VerticalSpace(height: 12),
                  ],
                );
              },
            );
          }
        }
      }),
    );
  }
}

