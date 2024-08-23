import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../data/datasource/mpartner_remote_data_source.dart';
import '../../../../data/models/upi_beneficiary_model.dart';
import '../../../../services/services_locator.dart';
import '../../../../state/contoller/user_data_controller.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../../utils/localdata/shared_preferences_util.dart';
import '../../../widgets/common_button.dart';
import '../../../widgets/something_went_wrong_widget.dart';
import '../../../widgets/verticalspace/vertical_space.dart';
import '../../base_screen.dart';
import '../../userprofile/user_profile_widget.dart';
import '../widgets/beneficiary_details_card.dart';
import '../../../widgets/headers/header_widget_with_cash_info.dart';
import '../widgets/info_widget.dart';
import '../widgets/registered_num_widget.dart';
import '../widgets/verification_failed_alert.dart';
import 'enter_amount_screen_upi.dart';

class EnterUPIScreen extends StatefulWidget {
  const EnterUPIScreen({super.key});

  @override
  State<EnterUPIScreen> createState() {
    return _EnterUPIScreen();
  }
}

class _EnterUPIScreen extends BaseScreenState<EnterUPIScreen> {
  bool isLoading = true;
  bool isVerified = false;
  bool _isVerificationAlertShown = false;
  bool somethingWentWrong = false;
  UPIBeneficiaryModel beneficiaryDetails = UPIBeneficiaryModel.empty();
  bool handshakeEstablished = false;

  @override
  void initState() {
    super.initState();
    logger.d("initState in UPI screen");
    if (_isVerificationAlertShown) Navigator.pop(context);
    setState(() {
      isLoading = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      BaseMPartnerRemoteDataSource mPartnerRemoteDataSource =
          sl<BaseMPartnerRemoteDataSource>();
      UserDataController userDataController = Get.find();

      // logger.d('[UPI_RA] fetching geo code.... ');
      // await determineGeoCode();
      // logger.d('[UPI_RA] Fetching address.... ');
      // await getAddress();
      // logger.d('[UPI_RA] checking handshake flag?  ${userDataController.userProfile[0].handshakeFlag}');

      int? handshakeFlag = 0;
      await SharedPreferencesUtil.getUpiHandShakeFlag().then((value) {
        handshakeFlag = value;
      });
      logger.d('----- handshakeFlag : $handshakeFlag -------');

      if (userDataController.userProfile[0].handshakeFlag == 1 ||
          handshakeFlag == 1) {
        // updating local flag
        handshakeEstablished = true;
      } else {
        logger.d('----- NO HANDSHAKE Flag Found -------');
        final handshake =
            await mPartnerRemoteDataSource.UPIClientSecretHandshake();
        handshake.fold((l) {
          logger.e(l);
          SharedPreferencesUtil.setUpiHandShakeFlag(0);
          setState(() {
            somethingWentWrong = true;
          });
        }, (r) {
          if (r.status == '200') {
            logger.d('[UPI_RA] NEW Handshake Established');
            handshakeEstablished = true;
            // update controller
            SharedPreferencesUtil.setUpiHandShakeFlag(1);
          } else {
            setState(() {
              somethingWentWrong = true;
            });
            SharedPreferencesUtil.setUpiHandShakeFlag(0);
          }
        });
      }

      if (handshakeEstablished == true) {
        logger.d('----- handshake Established -------');
        logger.e('[UPI_RA] Check VPA api called....');
        final response =
            await mPartnerRemoteDataSource.initialNumUpiVerification();
        response.fold((l) {
          logger.e(l);
          setState(() {
            isLoading = false;
            somethingWentWrong = true;
          });
        }, (r) {
          //print('response is ${r.status}');
          if (r.status == '200' && r.handleavailable == 'Y') {
            logger.d("Response received... ${r.status}");
            setState(() {
              isVerified = true;
              isLoading = false;
            });
            beneficiaryDetails = r;
          } else {
            setState(() {
              isLoading = false;
              isVerified = false;
            });
            _isVerificationAlertShown = true;
            showVerificationFailedAlert(
                (r.message != '') ? r.message : r.apimessage,
                context,
                DisplayMethods(context: context).getVariablePixelHeight(),
                DisplayMethods(context: context).getVariablePixelWidth(),
                DisplayMethods(context: context).getTextFontMultiplier(),
                DisplayMethods(context: context).getPixelMultiplier());
          }
        });
      } else {
        setState(() {
          isLoading = false;
          somethingWentWrong = true;
        });
      }
    });
  }

  @override
  Widget baseBody(BuildContext context) {
    UserDataController userDataController = Get.find();

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double pixelMultiplier =
        DisplayMethods(context: context).getPixelMultiplier();
    double textMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
              children: [
                HeaderWidgetWithCashInfo(
                  heading: translation(context).upi,
                  onPressBack: () {
                    Navigator.of(context).pop();
                  }, icon: Icon(
                  Icons.arrow_back_outlined,
                  color: AppColors.iconColor,
                  size: 24 * pixelMultiplier,
                ),
                ),
                UserProfileWidget(top: 8*variablePixelHeight),
                (isLoading)
                    ? const Expanded(
                        child: Center(child: CircularProgressIndicator()))
                    : (somethingWentWrong)
                        ? const SomethingWentWrongWidget()
                        : Expanded(
                          child: ListView(
                            padding: EdgeInsets.zero,
                            children: [
                              RegisteredNumberWidget(
                                number: userDataController.phoneNumber,
                                verified: isVerified,
                              ),
                              const VerticalSpace(height: 8),
                              (isVerified)
                                  ? InfoWidget(
                                      message: beneficiaryDetails.upiMessage,
                                    )
                                  : Container(),
                              (isVerified)
                                  ? Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          24 * variablePixelWidth,
                                          32 * variablePixelHeight,
                                          24 * variablePixelWidth,
                                          0),
                                      child: Container(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          translation(context)
                                              .beneficiaryDetails,
                                          style: GoogleFonts.poppins(
                                            color: AppColors.darkGreyText,
                                            fontSize: 16 * textMultiplier,
                                            height: 24 / 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(),
                              (isVerified)
                                  ? BeneficiaryDetailsCard(
                                      beneficiaryDetails: beneficiaryDetails)
                                  : Container(),
                            ],
                          ),
                        ),
            if (!somethingWentWrong && !isLoading)
              Container(
                padding: EdgeInsets.fromLTRB(
                    1 * variablePixelWidth, 0, 1 * variablePixelWidth, 0),
                alignment: Alignment.center,
                child: CommonButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => EnterAmountUPIScreen(
                              beneficiaryDetails: beneficiaryDetails)));
                    },
                    isEnabled: isVerified,
                    containerBackgroundColor: AppColors.white,
                    buttonText: translation(context).continueButtonText),
              ),
          ],
        ),
      ),
    );
  }
}
