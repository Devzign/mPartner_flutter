import 'package:flutter/material.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../../utils/routes/app_routes.dart';
import '../../base_screen.dart';
import '../../userprofile/user_profile_widget.dart';
import '../../../widgets/headers/sales_header_widget.dart';
import 'components/saletype_list_widget.dart';

class RegisterSales extends StatefulWidget {
  const RegisterSales({super.key});

  @override
  State<RegisterSales> createState() => _RegisterSalesState();
}

class _RegisterSalesState extends BaseScreenState<RegisterSales> {

  void _navigateToSecondarySalesScreen(saleType) {
    switch (saleType) {
      case 'Secondary Sale':
        Navigator.pushNamed(context, AppRoutes.secondarySales);
        break;
      case 'Tertiary Sale':
        Navigator.pushNamed(context, AppRoutes.tertiarySales);
        break;
      case 'Intermediary Sale':
        Navigator.pushNamed(context, AppRoutes.intermediarySales);
        break;
    }
  }

  @override
  Widget baseBody(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double variablePixelMultiplier =
        DisplayMethods(context: context).getPixelMultiplier();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            HeadingRegisterSales(
              icon: Icon(
                Icons.arrow_back_outlined,
                color: AppColors.iconColor,
                size: 24 * variablePixelMultiplier,
              ),
              heading: translation(context).registerSalesFloating,
              headingSize: AppConstants.FONT_SIZE_LARGE,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            UserProfileWidget(top: 8*variablePixelHeight,),
            SaleTypeListWidget(
                onSaleTypeSelected: _navigateToSecondarySalesScreen)
          ]),
        ),
      ),
    );
  }
}
