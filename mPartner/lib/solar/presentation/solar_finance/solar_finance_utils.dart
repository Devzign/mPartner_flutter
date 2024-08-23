  import 'package:flutter/material.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/localdata/language_constants.dart';

Map<String, IconData> statusIcons = {
    'approved': Icons.check_circle_rounded,
    'rejected': Icons.cancel_rounded,
    'in progress': Icons.access_time_filled,
  };

    Color getStatusColor(String status) {
    switch (status) {
      case 'approved':
        return AppColors.successGreen;
      case 'rejected':
        return AppColors.errorRed;
      case 'in progress':
        return AppColors.inProgressColor;
      default :
        return AppColors.pendingYellow;
    }
  }

  String getStatusString(String status, BuildContext context) {
    switch (status) {
      case 'approved':
        return translation(context).approved;
      case 'rejected':
        return translation(context).rejected;
      case 'in progress':
        return translation(context).inProgress;
      default :
        return "";
    }
  }
