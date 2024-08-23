import 'package:flutter/material.dart';

import '../../../utils/displaymethods/display_methods.dart';

Future<void> showCustomBottomSheet(
    BuildContext context, Widget widget, dynamic data) async {
  double r = DisplayMethods(context: context).getPixelMultiplier();
  // Assuming calculatePixelMultiplier is an async function

  showModalBottomSheet(
    routeSettings: RouteSettings(arguments: data),
    isScrollControlled: true,
    useSafeArea: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(28 * r),
        topRight: Radius.circular(28 * r),
      ),
    ),
    backgroundColor: Colors.white,
    context: context,
    builder: (BuildContext ctx) {
      return widget;
    },
  );
}
