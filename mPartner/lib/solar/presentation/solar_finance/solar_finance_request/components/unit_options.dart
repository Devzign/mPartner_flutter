import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../presentation/screens/report_management/widgets/report_type_text.dart';
import '../../../../../presentation/widgets/verticalspace/vertical_space.dart';
import '../../../../../utils/localdata/language_constants.dart';
import '../../../../state/controller/solar_finance_controller.dart';

class UnitOptions extends StatelessWidget {
  final Function(String, int) onUnitSelected;

  const UnitOptions({Key? key, required this.onUnitSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SolarFinanceController solarFinanceController = Get.find();

    return SingleChildScrollView(
      child: Obx(() {
        if (solarFinanceController.isLoading.value) {
          return const Column(
            children: [
              Center(
                child: CircularProgressIndicator(),
              ),
              VerticalSpace(height: 24),
            ],
          );
        } else if (solarFinanceController.error.isNotEmpty) {
          return Container();
        } else {
          final bool isDataEmpty = solarFinanceController.unitData.isEmpty;
          if (isDataEmpty) {
            return Column(
              children: [
                Center(child: Text(translation(context).dataNotFound)),
                const VerticalSpace(height: 32),
              ],
            );
          } else {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: solarFinanceController.unitData.length,
              itemBuilder: (BuildContext context, int index) {
                final bankData = solarFinanceController.unitData[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ReportTypeTextWidget(
                      text: bankData.unitName ?? "",
                      onTap: () => onUnitSelected(bankData.unitName, bankData.unitId),
                    ),
                    const VerticalSpace(height: 12),
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
