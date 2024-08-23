import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../utils/app_colors.dart';

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.dividerColor
      ..strokeWidth = 1;

    var max = size.width;
    var dashWidth = 15;
    var dashSpace = 7;
    double startX = 0;

    while (max >= 0) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      final space = (startX + dashWidth) + dashSpace;
      if (space < max) {
        startX = space;
      } else {
        break;
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}