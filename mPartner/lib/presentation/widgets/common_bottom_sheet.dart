import 'package:flutter/material.dart';

import '../../gem/presentation/gem_support_auth/component/success_sheet.dart';
import '../../gem/presentation/gem_support_auth/gem_support_autcode/component_gem_support_auth/terms_and_conditions.dart';

class CommonBottomSheet {
  static Future<void> show(BuildContext context, Widget body,
      double variablePixelHeight, double variablePixelWidth,
      {bool? isDragEnabled}) {
    return showModalBottomSheet(
      isScrollControlled: true,
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
      showDragHandle: isDragEnabled ?? true,
      context: context,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              body,
            ],
          ),
        );
      },
    );
  }

  static Future<dynamic> OpenTermsAndConditions(
      BuildContext context, var dynamicPage) async {
    var IsScrolled;
    await showModalBottomSheet(
      isScrollControlled: true,
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height - 200),
      showDragHandle: true,
      context: context,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return TermsAndConditions(dynamicPage, isScrollToBottom: (bool) {
          IsScrolled = bool;
        });
      },
    );
    return IsScrolled;
  }

  static Future<void> openSuccessSheet(
      BuildContext context, String title, String message) {
    return showModalBottomSheet(
      isScrollControlled: true,
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height - 200),
      showDragHandle: true,
      context: context,
      isDismissible: false,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return Success_Sheet(title, message);
      },
    );
  }
}
