import 'package:flutter/material.dart';

import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../../utils/routes/app_routes.dart';
import '../../../widgets/headers/header_widget_with_cash_info.dart';
import '../../ismart/ismart_homepage/ismart_homepage.dart';
import '../../userprofile/user_profile_widget.dart';
import '../../../../../../utils/app_colors.dart';
import 'cash_redemption_master_card.dart';

class TransactionStatusDetail extends StatelessWidget {
  final String status;
  final String amount;
  final String redeemStatus;
  final String message;
  final String transactionDate;
  final String transactionId;
  final String transactionMode;
  final Function() onClickClose;

  const TransactionStatusDetail({
    super.key,
    required this.status,
    required this.amount,
    required this.redeemStatus,
    required this.message,
    required this.transactionDate,
    required this.transactionId,
    required this.transactionMode,
    required this.onClickClose,
  });

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double pixelMultiplier = DisplayMethods(context: context).getPixelMultiplier();
    return WillPopScope(
      onWillPop: () async{
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute<void>(
              builder: (BuildContext context) =>
              const IsmartHomepage()),
          ModalRoute.withName(
              AppRoutes.ismartHomepage),
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.lightWhite1,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderWidgetWithCashInfo(
                heading: translation(context).transferDetails, icon: Icon(
                Icons.close,
                color: AppColors.iconColor,
                size: 24 * pixelMultiplier,
              ),
                onPressBack: onClickClose,
              ),
              UserProfileWidget(top: 8*variablePixelHeight),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      CashRedemptionMasterCard(
                        state: status,
                        transactionMode: transactionMode,
                        amount: amount,
                        redeemstatus: redeemStatus,
                        message: message,
                        transactionDate: transactionDate,
                        transactionId: transactionId,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
