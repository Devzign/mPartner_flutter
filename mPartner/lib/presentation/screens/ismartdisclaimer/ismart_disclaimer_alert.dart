import 'package:flutter/material.dart';

import '../../../utils/localdata/shared_preferences_util.dart';
import '../home/home_screen.dart';
import 'components/ismart_termscondition_alert.dart';

class ISmartDisclaimerAlert extends StatefulWidget {
  final Widget screen;

  const ISmartDisclaimerAlert({required this.screen, super.key});

  @override
  State<ISmartDisclaimerAlert> createState() => _ISmartDisclaimerAlertState();
}

class _ISmartDisclaimerAlertState extends State<ISmartDisclaimerAlert> {
  bool? isTermsAndConditionAccepted;

  @override
  void initState() {
    super.initState();
    _getTermsConditionState();
  }

  Future<void> _getTermsConditionState() async {
    isTermsAndConditionAccepted =
        await SharedPreferencesUtil.getShowISmartDisclaimerAlert();
    isTermsAndConditionAccepted ??= false;
    if (isTermsAndConditionAccepted == false) {
      _initializeData();
    }
  }

  Future<void> _initializeData() async {
    _showTermsConditionBottomSheet();
  }

  @override
  Widget build(BuildContext context) {
    return widget.screen;
  }

  void _showTermsConditionBottomSheet() {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return WillPopScope(
            onWillPop: () async {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (BuildContext context) => const HomeScreen(),
                ),
              );
              return false;
            },
            child: TermsConditionsBottomSheet(
              firstAppearance: true,
            ));
      },
    );
  }
}
