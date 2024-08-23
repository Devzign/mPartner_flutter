import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

class CommonDatePicker {
  static Future<String?> selectDate(BuildContext context,
      {int daysToEnable = 0}) async {
    DateTime selectedDate = DateTime.now();
    DateTime firstDate = daysToEnable != 0
        ? DateTime.now().subtract(Duration(days: daysToEnable))
        : DateTime(2021);
    DateTime lastDate = daysToEnable != 0 ? DateTime.now() : DateTime(2050);
    final DateTime? newSelectedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme:
                const ColorScheme.light(primary: AppColors.lumiBluePrimary),
          ),
          child: child!,
        );
      },
    );
    if (newSelectedDate != null) {
      selectedDate = newSelectedDate;
      return '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}';
    }
    return null;
  }
}
