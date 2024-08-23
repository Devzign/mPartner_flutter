import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'app_constants.dart';

class Utils {
  void showToast(String msg, BuildContext context) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black.withOpacity(0.8),
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  String getFormattedDate(String text) {
    String formattedDate = "";
    DateTime dateTime = DateTime.parse(text);
    formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);

    return formattedDate;
  }

  copyText(String text, BuildContext context) {
    Clipboard.setData(ClipboardData(text: text));
    showToast("Copied to clipboard", context);
  }

  String getFormattedDateMonth(String text) {
    if (text.isEmpty || text == 'null') {
      return "NA";
    } else if (text.toString().contains(':')) {
      String formattedDate = "";
      DateTime dateTime = DateTime.parse(text);
      formattedDate = DateFormat('MMM dd, yyyy').format(dateTime);
      return formattedDate;
    } else {
      return text;
    }
  }

  void showLongToast(String msg, BuildContext context) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black.withOpacity(0.8),
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Future<String> loadSvgAsset(String assetName) async {
    return await rootBundle.loadString(assetName);
  }

  Future<Widget> loadSvgImage(String assetName) async {
    final svgString = await loadSvgAsset(assetName);
    return SvgPicture.string(
      svgString,
      width: 100, // Adjust the width and height as needed
      height: 100,
    );
  }

  String getTodayDate() {
    var now = DateTime.now();
    var formatter = DateFormat('dd/MM/yyyy');
    String formattedDate = formatter.format(now);
    logger.d("Todays date: $formattedDate");
    return formattedDate;
  }

  String getSixMonthsBeforeDate() {
    var now = DateTime.now();
    var formatter = DateFormat('dd/MM/yyyy');
    DateTime myDateWithSixMonthsAdded = now.subtract(const Duration(days: 180));
    String formattedDate = formatter.format(myDateWithSixMonthsAdded);
    logger.d("6 Month old date: $formattedDate");
    return formattedDate;
  }
}

final rupee = NumberFormat.currency(
    locale: 'en-IN', decimalDigits: 0, symbol: '\u{20B9} ');
// final dollar =
//     NumberFormat.currency(locale: 'en-US', decimalDigits: 0, symbol: '\u{0024} ');
// final pound =
//     NumberFormat.currency(locale: 'en-GB', decimalDigits: 0, symbol: '\u{00A3} ');
// final yuan =
//     NumberFormat.currency(locale: 'zh-CN', decimalDigits: 0, symbol: '\u{00A5} ');
// final yen =
//     NumberFormat.currency(locale: 'ja-JP', decimalDigits: 0, symbol: '\u{00A5} ');
// final ruble =
//     NumberFormat.currency(locale: 'ru-RU', decimalDigits: 0, symbol: '\u{20BD} ');
// final won =
//     NumberFormat.currency(locale: 'ko-KR', decimalDigits: 0, symbol: '\u{20A9} ');

final rupeeNoSign =
    NumberFormat.currency(locale: 'en-IN', decimalDigits: 0, symbol: '');
// final dollarNoSign =
//     NumberFormat.currency(locale: 'en-US', decimalDigits: 0, symbol: '');
// final poundNoSign =
//     NumberFormat.currency(locale: 'en-GB', decimalDigits: 0, symbol: '');
// final yuanNoSign =
//     NumberFormat.currency(locale: 'zh-CN', decimalDigits: 0, symbol: '');
// final yenNoSign =
//     NumberFormat.currency(locale: 'ja-JP', decimalDigits: 0, symbol: '');
// final rubleNoSign =
//     NumberFormat.currency(locale: 'ru-RU', decimalDigits: 0, symbol: '');
// final wonNoSign =
//     NumberFormat.currency(locale: 'ko-KR', decimalDigits: 0, symbol: '');

final rupeeNoSignWithDecimal =
    NumberFormat.currency(locale: 'en-IN', decimalDigits: 2, symbol: '');

// input date format '01/01/2024'
String convertDateFormat(String inputDate) {
  // Parse the input date string into a DateTime object
  DateTime dateTime = DateFormat('dd/MM/yyyy').parse(inputDate);

  // Format the DateTime object into the desired format
  String formattedDate =
      DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").format(dateTime);

  return formattedDate;
}

// input date format '2024-03-22T23:53:44.057'
int getDateFromFullDate(String dateString) {
  DateTime dateTime = DateTime.parse(dateString);

  int milliseconds = dateTime.millisecondsSinceEpoch;

  return milliseconds;
}

String convertDateStringToFormatDate(String dateString) {
  if (dateString == null || dateString.isEmpty || 'null' == dateString) {
    return "";
  }
  try {
    var finalDate = dateString.split('.')[0].trim();
    DateTime originalDate = DateFormat("yyyy-MM-ddTHH:mm:ss").parse(finalDate);
    String displayDate =
        DateFormat("MMM dd, yyyy hh:mm a").format(originalDate);
    return displayDate;
  } catch (e) {
    return "";
  }
}
