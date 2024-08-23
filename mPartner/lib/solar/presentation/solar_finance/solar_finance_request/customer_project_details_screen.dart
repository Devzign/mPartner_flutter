import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../presentation/screens/userprofile/user_profile_widget.dart';
import '../../../../presentation/widgets/headers/back_button_header_widget.dart';
import '../../../../presentation/widgets/horizontalspace/horizontal_space.dart';
import '../../../../presentation/widgets/verticalspace/vertical_space.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/enums.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../../utils/routes/app_routes.dart';
import '../../../../utils/utils.dart';
import '../../../state/controller/solar_finance_controller.dart';
import '../../../state/controller/terms_and_condition_controller.dart';
import '../../../utils/solar_app_constants.dart';
import '../../common/heading_solar.dart';
import '../../common/leads_list_detail_cards/detailed_summary_card.dart';
import '../../common/something_went_wrong_solar_screen.dart';
import 'components/confirmation_bottomsheet.dart';
import 'components/terms_and_conditions_bottom_sheet.dart';

class CustomerProjectDetails extends StatefulWidget {
  final String category;
  final bool isAddSecondaryUserClicked;
  final String companyName;
  final String personName;
  final String mobileNumber;
  final String emailId;
  final String projectName;
  final String pincode;
  final String state;
  final String city;
  final String solutionType;
  final String projectCapacity;
  final String unit;
  final int unitId;
  final String projectCost;
  final String preferredBank;
  final int preferredBankId;
  final String gstinNumber;
  final String panNumber;
  final String secondaryContactName;
  final String secondaryContactMobileNo;
  final String secondaryContactEmailId;

  const CustomerProjectDetails({
    Key? key,
    required this.category,
    required this.isAddSecondaryUserClicked,
    required this.companyName,
    required this.personName,
    required this.mobileNumber,
    required this.emailId,
    required this.projectName,
    required this.pincode,
    required this.state,
    required this.city,
    required this.solutionType,
    required this.projectCapacity,
    required this.unit,
    required this.unitId,
    required this.projectCost,
    required this.preferredBank,
    required this.preferredBankId,
    required this.gstinNumber,
    required this.panNumber,
    required this.secondaryContactName,
    required this.secondaryContactMobileNo,
    required this.secondaryContactEmailId,
  }) : super(key: key);

  @override
  State<CustomerProjectDetails> createState() => _CustomerProjectDetailsState();
}

class _CustomerProjectDetailsState extends State<CustomerProjectDetails> {
  SolarFinanceController solarFinanceController = Get.find();
  TermsAndConditionController termsAndConditionController = Get.find();
  bool isChecked = false;
  bool isShowLoader = false;
  bool hasScrolledTerms = false;
  int counter = 0;

  @override
  void initState() {
    termsAndConditionController.clearTermsAndConditionController();
    termsAndConditionController.fetchTermsAndCondition(TermsNConditionsType.SolarFinance.name);
    super.initState();
  }

  String removeSpecialCharacters(String input) {
    return input.replaceAll(RegExp(r"[^0-9]"), '');
  }

  void openTermsAndConditionsBottomSheet() {
    showTermsAndConditionsBottomSheet(context, (bool isScrolled) {
      setState(() {
        hasScrolledTerms = isScrolled;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight = DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth = DisplayMethods(context: context).getVariablePixelWidth();
    double textFontMultiplier = DisplayMethods(context: context).getTextFontMultiplier();
    double pixelMultiplier = DisplayMethods(context: context).getPixelMultiplier();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            HeadingSolar(
              heading: translation(context).financeRequest,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            UserProfileWidget(
              top: 8 * variablePixelHeight,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24 *variablePixelWidth, vertical:  5 * variablePixelHeight),
                        child: DetailedSummaryCard(
                            labelData:{
                              translation(context).projectType: {"val": widget.category == "commercial" ? 'Commercial' : 'Residential', "type": "text"},
                              widget.category == "commercial" ?   translation(context).firmName : "": {"val": widget.companyName.isNotEmpty ? widget.companyName : "", "type": "text"},
                              translation(context).contactPersonName: {"val": widget.personName.isNotEmpty ? widget.personName : "", "type": "text"},
                              translation(context).contactPersonMobile: {"val":  widget.mobileNumber.isNotEmpty ? '+91-${widget.mobileNumber}' : "", "type": "text"},
                              translation(context).contactPersonEmailId: {"val": widget.emailId.isNotEmpty ? widget.emailId : "", "type": "text"},
                              widget.isAddSecondaryUserClicked ? translation(context).secondaryContactName : "": {"val":widget.secondaryContactName.isNotEmpty ? widget.secondaryContactName : "", "type": "text"},
                              widget.isAddSecondaryUserClicked ? translation(context).secondaryContactMobile : "": {"val": widget.secondaryContactMobileNo.isNotEmpty ? '+91-${widget.secondaryContactMobileNo}' : "", "type": "text"},
                              widget.isAddSecondaryUserClicked ? translation(context).secondaryContactEmailId : "": {"val": widget.secondaryContactEmailId.isNotEmpty ? widget.secondaryContactEmailId : "", "type": "text"},
                              translation(context).projectName: {"val": widget.projectName.isNotEmpty ? widget.projectName : "", "type": "text"},
                              translation(context).pincode: {"val": widget.pincode.isNotEmpty ? widget.pincode : "", "type": "text"},
                              translation(context).state: {"val": widget.state.isNotEmpty ? widget.state : "", "type": "text"},
                              translation(context).city: {"val": widget.city.isNotEmpty ? widget.city : "", "type": "text"},
                              translation(context).solutionType: {"val": widget.solutionType.isNotEmpty ? widget.solutionType : "", "type": "text"},
                              translation(context).projectCapacity: {"val": widget.projectCapacity.isNotEmpty && widget.unit.isNotEmpty ? "${widget.projectCapacity} ${widget.unit}" : "", "type": "text"},
                              translation(context).projectCost: {"val": widget.projectCost.isNotEmpty ? widget.projectCost : "", "type": "text"},
                              translation(context).preferredBank: {"val": widget.preferredBank.isNotEmpty ? widget.preferredBank : "", "type": "text"},
                              widget.category == "commercial" ? translation(context).firmGstinNumber : "": {"val": widget.gstinNumber.isNotEmpty ? widget.gstinNumber : "", "type": "text"},
                              widget.category == "commercial" ? translation(context).firmPanNumber : translation(context).panNumber: {"val": widget.panNumber.isNotEmpty ? widget.panNumber : "", "type": "text"},
                            }
                        ),
                      ),
                      const VerticalSpace(height: 24),
                      Padding(
                        padding: EdgeInsets.only(left: 24 * variablePixelWidth, right: 24 * variablePixelWidth),
                        child: Text(
                          translation(context).termsAndConditons,
                          style: GoogleFonts.poppins(
                            color: AppColors.darkGreyText,
                            fontSize: 14 * textFontMultiplier,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.10,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 12 * variablePixelWidth, right: 24 * variablePixelWidth),
                        child: GestureDetector(
                          onTap: openTermsAndConditionsBottomSheet,
                          child: Row(
                            children: [
                              Checkbox(
                                value: isChecked,
                                activeColor: AppColors.lumiBluePrimary,
                                side: MaterialStateBorderSide.resolveWith(
                                      (states) => BorderSide(width: isChecked ? 0.0 : 2.0, color: AppColors.dividerColor),
                                ),
                                onChanged: (bool? value) {
                                  if (hasScrolledTerms) {
                                    setState(() {
                                      isChecked = value!;
                                      isShowLoader = false;
                                    });
                                  } else {
                                    openTermsAndConditionsBottomSheet();
                                  }
                                },
                              ),
                              Text(
                                translation(context).acceptTermsConditions,
                                style: GoogleFonts.poppins(
                                  color: AppColors.lumiBluePrimary,
                                  fontSize: 14 * textFontMultiplier,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.10,
                                ),
                              ),
                              const VerticalSpace(height: 24),
                            ],
                          ),
                        ),
                      ),
                    ]
                ),
              ),
            ),
            Padding(
              padding:  EdgeInsets.only(top: 24 * variablePixelHeight, right: 24 * variablePixelWidth, left: 24 * variablePixelWidth, bottom: 24 * variablePixelHeight),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      width: 165 * variablePixelWidth,
                      height: 48 * variablePixelHeight,
                      child: ElevatedButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(AppColors.white),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100 * pixelMultiplier),
                              side: const BorderSide(color: AppColors.lumiBluePrimary),
                            ),
                          ),
                        ),
                        child: Text(translation(context).back,
                          style: GoogleFonts.poppins(
                            color: AppColors.lumiBluePrimary,
                            fontSize: 14 * textFontMultiplier,
                            fontWeight: FontWeight.w500,
                            height: 0.10 * variablePixelHeight,
                            letterSpacing: 0.10 * variablePixelWidth,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const HorizontalSpace(width: 16),
                  Expanded(
                    child: SizedBox(
                      width: 165 * variablePixelWidth,
                      height: 48 * variablePixelHeight,
                      child: ElevatedButton(
                        onPressed: isChecked  && !isShowLoader? ()  async {
                          counter++;
                          setState(() {
                            isShowLoader = true;
                          });
                          await solarFinanceController.saveProjectDetails(
                              widget.category,
                              widget.category == "commercial" ? widget.companyName : "",
                              widget.personName,
                              widget.mobileNumber,
                              widget.emailId,
                              widget.secondaryContactName,
                              widget.secondaryContactMobileNo,
                              widget.secondaryContactEmailId,
                              widget.projectName,
                              widget.pincode,
                              widget.state,
                              widget.city,
                              widget.projectCapacity,
                              widget.unitId,
                              removeSpecialCharacters(widget.projectCost),
                              widget.preferredBankId,
                              widget.gstinNumber,
                              widget.panNumber);
                            setState(() {
                              isShowLoader = false;
                            });
                            if(solarFinanceController.saveDetailsRes.isNotEmpty) {
                                  confirmationBottomSheet(context, translation(context).submittedSuccessfully, solarFinanceController.saveDetailsRes.first.data?.requestId);
                            }
                            else {
                              if(counter < 3) {
                                Utils().showToast(translation(context).somethingWentWrongPleaseRetry, context);
                              } else {
                                Navigator.push(
                                context,
                                MaterialPageRoute(
                                builder: (context) => SomethingWentWrongSolarScreen(
                                  previousRoute: SolarAppConstants.financeRouteName,
                                  onPressed: () {
                                    Navigator.popUntil(context, ModalRoute.withName(AppRoutes.solarFinancingDashboard));
                                    // Navigator.pop(context);
                                    // Navigator.pop(context);
                                    // Navigator.pop(context);
                                  },
                                )));
                              }
                            }
                        } : null,
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(isChecked && !isShowLoader ? AppColors.lumiBluePrimary : AppColors.primaryButtonDisabled),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100 * pixelMultiplier),
                            ),
                          ),
                        ),
                        child: isShowLoader ? const CircularProgressIndicator(color: AppColors.white)
                            :Text(translation(context).submit,
                          style: GoogleFonts.poppins(
                            color: AppColors.white,
                            fontSize: 14 * textFontMultiplier,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.10 * variablePixelWidth,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
