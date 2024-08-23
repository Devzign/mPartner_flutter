import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../presentation/widgets/verticalspace/vertical_space.dart';
import '../../../../presentation/screens/report_management/widgets/report_type_text.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../state/controller/banking_partners_controller.dart';

class PreferredBankOptions extends StatelessWidget {
  final Function(String, int) onBankSelected;
  bool isBankingPartner;

  PreferredBankOptions({super.key, required this.onBankSelected, this.isBankingPartner = false});

  @override
  Widget build(BuildContext context) {
    final BankingPartnersController bankingPartnersController = Get.find();

    return SingleChildScrollView(
      child: Obx(() {
        if (bankingPartnersController.isLoading.value) {
          return const Column(
            children: [
              Center(
                child: CircularProgressIndicator(),
              ),
              VerticalSpace(height: 24),
            ],
          );
        } else if (bankingPartnersController.error.isNotEmpty) {
          return Container();
        } else {
          final bool isDataEmpty = bankingPartnersController.banksData.isEmpty;
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
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: bankingPartnersController.banksData.length,
                itemBuilder: (BuildContext context, int index) {
                  final bankData = bankingPartnersController.banksData[index];
                  if (isBankingPartner && (bankData.name.toLowerCase().contains('no') || bankData.name.toLowerCase().contains('preference'))) {
                    return const SizedBox.shrink();
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ReportTypeTextWidget(
                        text: bankData.name ?? "",
                        onTap: () => onBankSelected(bankData.name, bankData.id),
                      ),
                      const VerticalSpace(height: 12),
                    ],
                  );
                },
              ),
            );
          }
        }
      }),
    );
  }
}