import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:mpartner/presentation/screens/ismart/registersales/tertiarysalesbulkorder/components/tertiary_product_details_save_list_widget.dart';

import '../../../../../../data/datasource/mpartner_remote_data_source.dart';
import '../../../../../../services/services_locator.dart';
import '../../../../../../state/contoller/verify_otp_controller.dart';
import '../../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../../utils/enums.dart';
import '../../../../../../utils/localdata/language_constants.dart';
import '../../../../../widgets/common_bottom_sheet.dart';
import '../../components/custom_alert_widget.dart';
import '../../components/custom_bs_header.dart';
import '../../uimodels/customer_info.dart';
import '../bloc/otp_bloc.dart';
import 'verify_otp.dart';

class TertiaryBulkVerifySaleBS extends StatefulWidget {
  final CustomerInfo customerInfo;
  final String serialNo;

  const TertiaryBulkVerifySaleBS({
    required this.customerInfo,
    required this.serialNo
});

  @override
  State<TertiaryBulkVerifySaleBS> createState() => _TertiaryBulkVerifySaleSheetBSState();
}

class _TertiaryBulkVerifySaleSheetBSState extends State<TertiaryBulkVerifySaleBS> {
  String _otp = "";
  late String _transID;
  VerifyOtpController controller = Get.find();

  @override
  void initState() {
    super.initState();
  }

  void _onVerifyButtonClick(context,bool isOTPValid,String otp, String transId) async {
    if (isOTPValid) {

      MPartnerRemoteDataSource mPartnerRemoteDataSource = MPartnerRemoteDataSource();
      final result = await mPartnerRemoteDataSource
          .postVerifyOtpTertiaryBulk(
          widget.customerInfo,
          widget.serialNo,
          otp,
          transId);

      result.fold((l) => null, (r) { 
        if(r.status=='200'){
          if(r.data.code.toLowerCase() == "success") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TertiaryProductDetailsSaveListWidget(
                customerInfo: widget.customerInfo,
                isOTPVerified: true,
                otp: _otp,
                transactionID: _transID,
                isVerified: true,
                serialNo: widget.serialNo,
              ),
            ),
          );
        } else {
          controller.updateOtpValid(false);
        }
        }
      });
    }
  }

  void _onResendOtp(context) {
    BlocProvider.of<OTPBloc>(context).add(
      ResendOTPEvent(customerInfo: widget.customerInfo,
          serialNo: widget.serialNo),
    );
  }

  void _navigateToProductDetailsScreen(transId){
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TertiaryProductDetailsSaveListWidget(
              customerInfo: widget.customerInfo,
              isOTPVerified: false,
              transactionID:transId,
              isVerified: true,
              otp: "",
              serialNo: widget.serialNo,)
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
    DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
    DisplayMethods(context: context).getVariablePixelWidth();
    double variablePixelMultiplier =
    DisplayMethods(context: context).getPixelMultiplier();
    double variableTextMultiplier =
    DisplayMethods(context: context).getTextFontMultiplier();

    Widget _buildConfirmationAlertBS(title, description, promptQues, onPressedYes,
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

    void _showConfirmationBSOnContinueWithoutOTP(context,transId) {
      CommonBottomSheet.show(
          context,
          _buildConfirmationAlertBS(
              translation(context).confirmationAlert,
              translation(context).continueWithoutOTPVerification,
              translation(context).sureToContinue,
                  ()=>_navigateToProductDetailsScreen(transId)),
          variablePixelHeight,
          variablePixelWidth);
    }

    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child:BlocProvider(
      create: (context)=>sl<OTPBloc>()
        ..add(CreateOTPEvent(
            customerInfo: widget.customerInfo,
            serialNo: widget.serialNo
        )),
      child: BlocBuilder<OTPBloc, OTPState>(
        builder: (context,state){
          return BlocConsumer<OTPBloc,OTPState>(
            listener: (context,state){},
            builder: (context,state){
              switch(state.createOTPState){
                case RequestState.loading:
                  return SizedBox(
                    height: 174 * variablePixelHeight,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                case RequestState.loaded:
                  _transID = state.otpData!.data.transId;
                  return VerifyOtpPresentationWidget(
                      mobileNumber: widget.customerInfo.mobileNo,
                      mandatoryButton: VerifyOTPButton(
                        buttonText: translation(context).verifySale,
                        onClick: () async {
                          _onVerifyButtonClick(
                              context,
                              state.otpData!.data.code.toLowerCase() == "success",
                              _otp,
                              _transID
                          );
                        },
                      ),
                      optionalButton: VerifyOTPButton(
                        buttonText: translation(context).continueWithoutVerification,
                        onClick: () async {
                          _showConfirmationBSOnContinueWithoutOTP(context,state.otpData!.data.transId);
                        },
                      ),
                      header: translation(context).verifySales,
                      instructions: translation(context).enterWarrantyVerificationCodeSentTo,
                      resendOtpMethod: () async {
                        controller.updateOtpValid(true);
                        _onResendOtp(context);
                      },
                      timerLimit: "30",
                      showLoader: false,
                      showMaximumAttempsMessage: null,
                      maxAttempMessage: null,
                      updateOtp: (otp) => {
                        _otp = otp,
                      },
                      isOtpValid: (state.otpData!.status=='200' && state.otpData!.data.code.toLowerCase() == "success")
                          || _otp.length == 6,
                    );
                case RequestState.error:
                  return SizedBox(
                    height: 174 * variablePixelHeight,
                    child: Center(
                      child: Text(state.createOTPMessage),
                    ),
                  );
              }
            },
          );
        },
      ),
    ),);
  }
}

