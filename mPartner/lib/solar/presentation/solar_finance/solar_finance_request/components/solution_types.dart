import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../presentation/screens/report_management/widgets/report_type_text.dart';
import '../../../../../presentation/widgets/verticalspace/vertical_space.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';
import '../../../../state/controller/solar_design_request_controller.dart';

class SolutionTypesList extends StatelessWidget {
  final Function(String, int) onSolutionTypeSelected;

  const SolutionTypesList({super.key, required this.onSolutionTypeSelected});

  @override
  Widget build(BuildContext context) {

    final SolarDesignRequestController solarDesignRequestController = Get.find();

    return Obx(() {
      if (solarDesignRequestController.isLoading.value) {
        return const Column(
          children: [
            Center(
              child: CircularProgressIndicator(),
            ),
            VerticalSpace(height: 24),
          ],
        );
      } else {
        final bool isDataEmpty = solarDesignRequestController.solutionTypeListFinance.isEmpty;
        if (isDataEmpty) {
          return Column(
            children: [
              Center(child: Text(translation(context).dataNotFound)),
              const VerticalSpace(height: 32),
            ],
          );
        } else {
          return Container(
            constraints: BoxConstraints(maxHeight: 500 * DisplayMethods(context: context).getVariablePixelHeight()),
            child: ListView(
              shrinkWrap: true,
              children: [
                for (var item in solarDesignRequestController.solutionTypeListFinance)
                  ReportTypeTextWidget(
                    text: item.name?? "",
                    onTap: () => onSolutionTypeSelected(item.name, item.id),
                  ),
                const VerticalSpace(height: 20),
              ],
            ),
          );
        }
      }
    });
  }
}