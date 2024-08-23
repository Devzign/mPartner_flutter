import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../state/contoller/coin_to_trips_redemption_controller.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';
import '../../../../widgets/radio_list/common_radio_list.dart';
import '../../../../widgets/buttons/primary_button.dart';
import '../../../../widgets/verticalspace/vertical_space.dart';
import '../../../our_products/components/title_bottom_modal.dart';

class SelectNumberOfTravellers extends StatefulWidget {
  SelectNumberOfTravellers({super.key, required this.size, required this.curr});
  final int size;
  int curr;
  @override
  State<SelectNumberOfTravellers> createState() =>
      _SelectNumberOfTravellersState();
}

class _SelectNumberOfTravellersState extends State<SelectNumberOfTravellers> {
  @override
  Widget build(BuildContext context) {
    CoinsToTripController c = Get.find();
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    return Padding(
      padding: EdgeInsets.fromLTRB(24 * w, 0, 24 * w, 32 * h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          titleBottomModal(
              title: translation(context).selectNumberofTravellers,
              onPressed: () => {Navigator.pop(context)}),
          VerticalSpace(height: 8),
          ListView.separated(
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: CommonRadioListTile(
                    label: '${index + 1}',
                    groupValue: widget.curr,
                    value: index + 1,
                    onChanged: (value) => {
                      setState(() {
                        widget.curr = value ?? 1;
                      })
                    },
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  VerticalSpace(height: 4),
              itemCount: widget.size),
          VerticalSpace(height: 8),
          Row(
            children: [
              PrimaryButton(
                  buttonText: translation(context).submit,
                  buttonHeight: 48,
                  onPressed: () => {
                        // c.travellers.clear(),
                        // c.currNumberOfTravellers.value = 0,
                        // c.selectedNumberOfTravellers.value = widget.curr,
                        // c.updateSelectedNumberOfTraveller(widget.curr),
                        c.onChangeOfSelectedNumberOfTravellers(widget.curr),
                        Navigator.pop(context)
                      },
                  isEnabled: true)
            ],
          )
        ],
      ),
    );
  }
}
