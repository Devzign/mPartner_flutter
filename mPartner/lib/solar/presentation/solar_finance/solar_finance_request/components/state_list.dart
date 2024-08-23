import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../presentation/screens/report_management/widgets/report_type_text.dart';
import '../../../../../presentation/widgets/verticalspace/vertical_space.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';
import '../../../../state/controller/solar_design_request_controller.dart';

class StatesList extends StatelessWidget {
  final Function(String, String) onStateSelected;

  const StatesList({Key? key, required this.onStateSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    String capitalizeEachWord(String text) {
      List<String> words = text.split(' ');
      for (int i = 0; i < words.length; i++) {
        if (words[i].isNotEmpty) {
          // Special case for "And"
          if (words[i].toLowerCase() == 'and') {
            words[i] = '&';
          } else {
            words[i] = words[i][0].toUpperCase() + words[i].substring(1).toLowerCase();
          }
        }
      }
      return words.join(' ');
    }
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
        final bool isDataEmpty = solarDesignRequestController.stateList.isEmpty;
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
                for (var item in solarDesignRequestController.stateList)
                  ReportTypeTextWidget(
                    text: capitalizeEachWord(item.stateName) ?? "",
                    onTap: () => onStateSelected(item.stateName, item.stateId),
                  ),
                const VerticalSpace(height: 12),
              ],
            ),
          );
        }
      }
    });
  }
}