import 'package:flutter/material.dart';

import '../../lms/utils/app_text_style.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_string.dart';
import '../../utils/localdata/language_constants.dart';

class GenericErrorWidget extends StatelessWidget {
  final String errorText;
  final IconData icon;
  final bool isInternetError;
  final VoidCallback? onTap;
  const GenericErrorWidget({
    super.key,
    required this.icon,
    required this.errorText,
    this.isInternetError = false,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon,size: 50),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(errorText.toUpperCase(),
              style: AppTextStyle.getStyle(
                  color: AppColors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500), textAlign: TextAlign.center),
        ),
        isInternetError?InkWell(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: AppColors.lumiBluePrimary),
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                color: AppColors.lumiBluePrimary
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 7),
            child: Text(translation(context).titleRetry,
                style: AppTextStyle.getStyle(
                    color: AppColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500), textAlign: TextAlign.center),
          ),
        ):const SizedBox(),
      ],
    );
  }
}
