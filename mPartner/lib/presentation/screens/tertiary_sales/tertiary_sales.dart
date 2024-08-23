import 'package:flutter/material.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/displaymethods/display_methods.dart';
import '../../../utils/localdata/language_constants.dart';
import '../../../utils/routes/app_routes.dart';
import '../../widgets/common_confirmation_alert.dart';
import '../base_screen.dart';
import '../../widgets/headers/sales_header_widget.dart';
import '../userprofile/user_profile_widget.dart';
import 'components/form_widget.dart';
import 'components/heading_tertiary_sales_widget.dart';
import '../ismart/ismart_homepage/components/subsection_header.dart';

class TertiarySales extends StatefulWidget {
  const TertiarySales({super.key});

  @override
  State<TertiarySales> createState() => _TertiarySalesState();
}

class _TertiarySalesState extends BaseScreenState<TertiarySales> {
  bool isMandatoryFielsFilled = true;
  bool anyFieldFilled = false;

  void updateFieldFilledStatus(bool newValue) {
    setState(() {
      anyFieldFilled = newValue;
    });
  }

  @override
  Widget baseBody(BuildContext context) {
    double labelFontSize = DisplayMethods(context: context).getLabelFontSize();
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double variablePixelMultiplier =
    DisplayMethods(context: context).getPixelMultiplier();

    return WillPopScope(
      onWillPop: () async {
        if (anyFieldFilled) {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return CommonConfirmationAlert(
                confirmationText1: translation(context).goingBackWillRestartProcess,
                confirmationText2: translation(context).areYouSureYouWantToLeave,
                onPressedYes: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              );
            },
          );
        } else {
          Navigator.pop(context);
        }
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                2.0 * variablePixelWidth, 0.0, 2.0 * variablePixelWidth, 0.0),
            child: Column(
              children: [
                HeadingRegisterSales(
                  icon: Icon(
                    Icons.arrow_back_outlined,
                    color: AppColors.iconColor,
                    size: 24 * variablePixelMultiplier,
                  ),
                  heading: "${translation(context).tertiarySale}",
                  headingSize: AppConstants.FONT_SIZE_LARGE,
                  onPressed: () {
                    if (anyFieldFilled) {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return CommonConfirmationAlert(
                            confirmationText1: translation(context).goingBackWillRestartProcess,
                            confirmationText2: translation(context).areYouSureYouWantToLeave,
                            onPressedYes: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                          );
                        },
                      );
                    } else {
                      Navigator.pop(context);
                    }
                  },
                ),
                UserProfileWidget(top: 8*variablePixelHeight,),
                SubsectionHeader(sectionHeader: translation(context).saleToCustomer),
                Expanded(
                  child: TertiarySalesForm(onFieldsUpdate: updateFieldFilledStatus,),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
