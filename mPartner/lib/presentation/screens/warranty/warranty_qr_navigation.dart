import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../state/contoller/warranty_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/displaymethods/display_methods.dart';
import '../../../utils/localdata/language_constants.dart';
import '../../widgets/headers/back_button_header_widget.dart';
import '../network_management/dealer_electrician/components/custom_calender.dart';
import '../userprofile/user_profile_widget.dart';
import 'warranty_customer_not_part_of_sale_journey.dart';
import 'warranty_error.dart';
import 'warranty_new_ui.dart';

class WarrantyQrNavigation extends StatelessWidget {
  WarrantyQrNavigation({super.key, required this.showManualWarrantyButton});
  final bool showManualWarrantyButton;

  final WarrantyController controller = Get.find();

  void initialize(context) {
    final String serialNo =
        ModalRoute.of(context)!.settings.arguments as String;
    controller.fetchWarranty(serialNo);
  }

  Widget outputScreen() {
    String status = controller.newWarranty.value.status.toLowerCase();
    switch (status) {
      case "error":
        return WarrantyError(
            showManualWarrantyButton: showManualWarrantyButton,
            message: controller.newWarranty.value.message);
      case "invalid user":
        return CustomerNotPartOfJourney(
          message: controller.newWarranty.value.message,
        );
      case "success":
        return WarrantyNewUI(data: controller.newWarranty.value);
      default:
        return WarrantyError(
          showManualWarrantyButton: showManualWarrantyButton,
          message: controller.newWarranty.value.message,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
      initialize(context);
      return Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
            child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              HeaderWidgetWithBackButton(
                onPressed: () => {Navigator.pop(context)},
                heading: translation(context).heading,
              ),
              UserProfileWidget(),
              Obx(
            () => controller.isLoading.value
                    ? Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [CircularProgressIndicator()],
                        ),
                      )
                    : Expanded(child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24 * variablePixelWidth),
                      child: outputScreen(),
                    )),
              ),
            ]))

        //     child: Obx(
        //   () => controller.isLoading.value
        //       ? Center(child: CircularProgressIndicator())
        //       : outputScreen(),
        // )),
      );
    
  }
}
