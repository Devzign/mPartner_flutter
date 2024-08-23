import 'package:flutter/material.dart';

import '../../../lms/utils/app_text_style.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/common_methods.dart';
import '../../../utils/localdata/language_constants.dart';
import '../../../utils/utils.dart';

class ProductHistoryItems extends StatelessWidget {
  const ProductHistoryItems(
      {super.key,
      required this.productModel,
      required this.serialNo,
      required this.onItemTap,
      required this.date, required this.isLast});
  final String productModel;
  final String serialNo;
  final String date;
  final bool isLast;
  final VoidCallback? onItemTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration:  BoxDecoration(
              border: Border.all(color: AppColors.lightBlueD5E0F9),
              color: AppColors.white,
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          padding: const EdgeInsets.all(10),
          child: InkWell(
            onTap: onItemTap,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productModel,
                  style: AppTextStyle.getStyle(
                      color: AppColors.darkText2,
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                ),
                vSpace(5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            translation(context).titleSerialNumber,
                            style: AppTextStyle.getStyle(
                                color: AppColors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                          ),
                          vSpace(3),
                          Text(
                            serialNo,
                            style: AppTextStyle.getStyle(
                                color: AppColors.darkText2,
                                fontSize: 13,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            translation(context).titleTertiarySalesDate,
                            style: AppTextStyle.getStyle(
                                color: AppColors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                          ),
                          vSpace(3),
                          Text(
                            convertDateStringToFormatDate(date),
                            style: AppTextStyle.getStyle(
                                color: AppColors.darkText2,
                                fontSize: 13,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        isLast?vSpace(0):vSpace(10),
      ],
    );
  }
}
