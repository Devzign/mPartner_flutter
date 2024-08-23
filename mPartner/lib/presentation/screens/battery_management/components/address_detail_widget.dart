import 'package:flutter/material.dart';

import '../../../../utils/localdata/language_constants.dart';
import 'common_detail_row.dart';

import '../../../widgets/verticalspace/vertical_space.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../widgets/common_divider.dart';

class AddressDetailWidget extends StatelessWidget {
  final List<Map<String, dynamic>> addressDetails;

  AddressDetailWidget({required this.addressDetails});

  @override
  Widget build(BuildContext context) {
   double variablePixelWidth = DisplayMethods(context: context).getVariablePixelWidth();
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: addressDetails.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: EdgeInsets.only(left: 24 * variablePixelWidth, right: 24 * variablePixelWidth),
          child: Result(data: addressDetails[index]),
        );
      },
    );
  }
}

class Result extends StatelessWidget {
  final Map<String, dynamic> data;

  Result({required this.data});

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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonDetailRow(label: translation(context).mobile, value: data['dis_ContactNo'] == ''? '-' : '+91-${data['dis_ContactNo']}'),
        const VerticalSpace(height: 12),
        CommonDetailRow(label: translation(context).address, value: '${capitalizeEachWord(data['dis_Address1'])} ${capitalizeEachWord(data['dis_Address2'])}'),
        const VerticalSpace(height: 12),
        CommonDetailRow(label: translation(context).city, value: capitalizeEachWord(data['dis_City'])),
        const VerticalSpace(height: 12),
        CommonDetailRow(label: translation(context).state, value: capitalizeEachWord(data['dis_State'])),
        const VerticalSpace(height: 28),
        const CustomDivider(color: AppColors.dividerColor),
        const VerticalSpace(height: 28),
      ],
    );
  }
}
