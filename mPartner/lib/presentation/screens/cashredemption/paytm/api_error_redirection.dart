import 'package:flutter/material.dart';

import '../../../../utils/localdata/language_constants.dart';
import '../../../../utils/routes/app_routes.dart';
import '../../ismart/ismart_homepage/ismart_homepage.dart';
import '../widgets/transaction_status_screen.dart';

//enter transactionMode as Paytm, PineLab or UPI
void FailureRedirection(BuildContext context, String amount, String date,
    String paytmInitId, String transactionMode,
    {String? message}) {
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(
      builder: (context) => TransactionStatusDetail(
        status: 'Failed',
        transactionMode: transactionMode,
        amount: amount,
        redeemStatus: '',
        message: message ?? translation(context).transactionFailureMessage,
        transactionDate: date,
        transactionId: paytmInitId,
        onClickClose: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute<void>(
                builder: (BuildContext context) => const IsmartHomepage()),
            ModalRoute.withName(AppRoutes.ismartHomepage),
          );
        },
      ),
    ),
  );
}
