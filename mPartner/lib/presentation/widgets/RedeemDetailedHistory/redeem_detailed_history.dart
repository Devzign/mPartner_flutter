import 'package:flutter/material.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/displaymethods/display_methods.dart';
import '../../../utils/localdata/language_constants.dart';
import '../../../utils/routes/app_routes.dart';
import '../../screens/ismart/ismart_homepage/ismart_homepage.dart';
import '../../screens/ismart/redeem_coins_to_trips/components/alert_trip_booking_bottomsheet.dart';
import '../../screens/userprofile/user_profile_widget.dart';
import '../headers/back_button_header_widget.dart';
import '../headers/header_widget_with_coins_info.dart';
import 'master_card.dart';

class RedeemDetailedHistory extends StatelessWidget {
  final String state;
  final String stateMsg;
  final String cashOrCoinHistory;
  final String data1;
  final String data2;
  final String data3;
  final String data4;
  final String data5;
  final String transactionType;
  final onTap;
  final String urlForTripDownload;

  const RedeemDetailedHistory({
    super.key,
    required this.state,
    required this.stateMsg,
    required this.cashOrCoinHistory,
    required this.data1,
    required this.data2,
    required this.data3,
    required this.transactionType,
    required this.data4,
    required this.data5,
    required this.onTap,
    this.urlForTripDownload = "",
  });

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) =>
          onTap ??
          {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute<void>(
                  builder: (BuildContext context) => const IsmartHomepage()),
              ModalRoute.withName(AppRoutes.ismartHomepage),
            )
          },
      child: Scaffold(
        backgroundColor: AppColors.lightWhite1,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                HeaderWidgetWithCoinInfo(
                  heading: translation(context).transferDetails, onPressed: () { Navigator.pop(context); }, icon: const Icon(
                  Icons.close,
                  color: AppColors.iconColor,
                  size: 24,
                ),),
                UserProfileWidget(),
                MasterCard(
                  state: state,
                  stateMsg: stateMsg,
                  cashOrCoinHistory: cashOrCoinHistory,
                  data1: data1,
                  data2: data2,
                  data3: data3,
                  transactionType: transactionType,
                  data4: data4,
                  data5: data5,
                ),
                Visibility(
                  visible: urlForTripDownload.isNotEmpty,
                  child: Column(
                    children: [
                      TripDownloadButton(url: urlForTripDownload),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
