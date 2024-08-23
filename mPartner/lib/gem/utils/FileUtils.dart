import 'package:flutter/cupertino.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../utils/localdata/language_constants.dart';
import '../../utils/utils.dart';

class FileUtils {

  static Future<void> downloadPdf(var pdfUrl,BuildContext context) async {
    if(pdfUrl.isNotEmpty){
      if (await canLaunchUrlString(pdfUrl)) {
        await launchUrlString(pdfUrl,mode: LaunchMode.externalApplication);
      } else {
        Utils().showToast(translation(context).unableToDownload, context);
      }
    }
    else{
      Utils().showToast(translation(context).unableToDownload, context);
    }
  }

  static  sharePdf(var pdfUrl,BuildContext context) async {
    if (pdfUrl != "") {
      Share.shareUri(Uri.parse(pdfUrl));
    } else {
      Utils().showToast(translation(context).somethingWentWrongPleaseRetry, context);
    }
  }
}