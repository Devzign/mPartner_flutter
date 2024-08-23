import 'package:flutter/cupertino.dart';

String removeExtraLeadingZeros(String str) {
    String sign = '';
    if (str.startsWith('-') || str.startsWith('+')) {
      sign = str.substring(0, 1);
      str = str.substring(1);
    }
    if (str.startsWith('0')) {
      str = str.replaceFirst(RegExp(r'^0+'), '');
      if (str.startsWith('.')) {
        str = '0' + str;
      }
    }
    return sign + str;
  }

Widget hSpace(double space) {
  return SizedBox(width: space);
}

Widget vSpace(double space) {
  return SizedBox(height: space);
}

getMobileHeight(BuildContext context) => MediaQuery.of(context).size.height;

getMobileWidth(BuildContext context) => MediaQuery.of(context).size.width;