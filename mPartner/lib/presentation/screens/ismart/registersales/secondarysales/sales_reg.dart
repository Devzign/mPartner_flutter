import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../state/contoller/user_data_controller.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_constants.dart';
import '../../../../../utils/app_string.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';
import '../../../../../utils/routes/app_routes.dart';
import '../../../../widgets/common_bottom_sheet.dart';
import '../../../base_screen.dart';
import '../../../userprofile/user_profile_widget.dart';
import '../components/custom_alert_widget.dart';
import '../components/custom_bs_header.dart';
import '../../../../widgets/headers/sales_header_widget.dart';
import '../components/single_product_details.dart';
import '../intermediary_sales/components/intermediary_product_details_list_widget.dart';
import '../tertiarysalesbulkorder/components/tertiary_product_details_list_widget.dart';
import '../uimodels/customer_info.dart';
import '../uimodels/dealer_info.dart';
import '../uimodels/electrician_info.dart';
import '../uimodels/product_details.dart';
import 'components/product_details_list_widget.dart';

class SalesReg extends StatefulWidget {
  final DateTime? selectedDate;
  final String? saleTime;
  final String serialNoList;
  final String saleType;
  final DealerInfo? selectedDealer;
  final CustomerInfo? customer;
  final ElectricianInfo? electrician;

  const SalesReg(
      {super.key,
      this.selectedDate,
      this.saleTime,
      this.selectedDealer,
      this.electrician,
      required this.saleType,
      this.customer,
      required this.serialNoList});

  @override
  State<SalesReg> createState() => _SalesRegState();
}

class _SalesRegState extends BaseScreenState<SalesReg> {
  UserDataController userDataController = Get.find();

  void _navigateToIndividualProductDetailsScreen(
      ProductDetails productDetails) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SingleProductDetails(
                  serialNos: widget.serialNoList,
                  productDetails: productDetails,
                  customerInfo: widget.customer,
                  dealerInfo: widget.selectedDealer,
                  registerDate: widget.selectedDate,
                  saleTime: widget.saleTime,
                  saleType: widget.saleType,
                )));
  }

  @override
  Widget baseBody(BuildContext context) {
    double variableFontMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double variablePixelMultiplier =
        DisplayMethods(context: context).getPixelMultiplier();

    Widget _buildConfirmationAlertBS(
        title, description, promptQues, onPressedYes,
        {isSingleButton = false}) {
      return Column(
        children: [
          CustomBSHeaderWidget(
            title: title,
            onClose: () => Navigator.of(context).pop(),
          ),
          SizedBox(
            height: 8 * variablePixelHeight,
          ),
          CustomAlertWidget(
            description: description,
            promptQues: promptQues,
            onPressedYes: onPressedYes,
            isSingleButton: isSingleButton,
            onPressedNo: () => Navigator.of(context).pop(),
          )
        ],
      );
    }

    void _showConfirmationBSOnBackPressed(context) {
      CommonBottomSheet.show(
          context,
          _buildConfirmationAlertBS(
              translation(context).confirmationAlert,
              translation(context).goingBackWillDelete,
              translation(context).sureToContinue,
              () {
                if(userDataController.isFromHomePageRoute){
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.homepage,
                        (Route<dynamic> route) => false,
                  );
                }
                else{
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.ismartHomepage,
                        (Route<dynamic> route) => false,
                  );

                }

                  }),
          variablePixelHeight,
          variablePixelWidth);
    }

    void _handleBackPressed() {
     if (widget.saleType == 'Tertiary') {
        _showConfirmationBSOnBackPressed(context);
      } else {
       if(userDataController.isFromHomePageRoute){
         Navigator.pushNamedAndRemoveUntil(
           context,
           AppRoutes.homepage,
               (Route<dynamic> route) => false,
         );
       }
       else{
         Navigator.pushNamedAndRemoveUntil(
           context,
           AppRoutes.ismartHomepage,
               (Route<dynamic> route) => false,
         );

       }

      }
    }

    String getHeading() {
      String heading = "";
      switch (widget.saleType) {
        case 'Secondary':
          heading =
              "${translation(context).secondarySales} ${translation(context).registration}";
        case 'Tertiary':
          heading =
              "${translation(context).tertiarySales} ${translation(context).registration}";
        case 'Intermediary':
          heading =
              "${translation(context).intermediarySales} ${translation(context).registration}";
      }
      return heading;
    }

    Widget _buildProductDetailsListWidget() {
      Widget productDetailsWidget;
      switch (widget.saleType) {
        case 'Secondary':
          productDetailsWidget = ProductDetailsListWidget(
            selectedDealer: widget.selectedDealer!,
            onProductSelected: (productDetails) =>
                _navigateToIndividualProductDetailsScreen(productDetails),
            serialNo: widget.serialNoList,
            selectedDate: widget.selectedDate!,
          );
          break;
        case 'Tertiary':
          productDetailsWidget = TertiaryProductDetailsListWidget(
            isVerified: false,
            isOTPVerified: false,
            customerInfo: widget.customer!,
            onProductSelected: (productDetails) =>
                _navigateToIndividualProductDetailsScreen(productDetails),
            serialNo: widget.serialNoList,
          );
          break;
        case 'Intermediary':
          productDetailsWidget = IntermediaryProductDetailsListWidget(
            selectedElectrician: widget.electrician!,
            onProductSelected: (productDetails) =>
                _navigateToIndividualProductDetailsScreen(productDetails),
            serialNo: widget.serialNoList,
            selectedDate: widget.selectedDate!,
          );
          break;
        default:
          productDetailsWidget = SizedBox();
      }
      return productDetailsWidget;
    }

    return WillPopScope(
        onWillPop: () async {
          _handleBackPressed();
          return true;
        },
        child: Scaffold(
          backgroundColor: AppColors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                HeadingRegisterSales(
                  icon: Icon(
                    widget.saleType == 'Secondary'
                        ? Icons.close
                        : Icons.arrow_back_sharp,
                    color: AppColors.iconColor,
                    size: 24 * variablePixelMultiplier,
                  ),
                  heading: getHeading(),
                  headingSize: (widget.saleType == SaleTypeStrings.tertiarySaleType) ? AppConstants.FONT_SIZE_LARGE : AppConstants.FONT_SIZE_MEDIUM,
                  onPressed: () {
                    _handleBackPressed();
                  },
                ),
                UserProfileWidget(top:8*variablePixelHeight),
                widget.saleType != 'Tertiary'
                    ? Text(
                        translation(context).earningStatus,
                        style: GoogleFonts.poppins(
                          color: AppColors.blackTextHeading,
                          fontSize: 16 * variableFontMultiplier,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.normal,
                          letterSpacing: 1,
                        ),
                      )
                    : SizedBox(),
                SizedBox(
                    height: widget.saleType == 'Tertiary'
                        ? variablePixelHeight * 0
                        : variablePixelHeight * 24),
                _buildProductDetailsListWidget(),
              ]),
            ),
          ),
        ));
  }
}
