import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/routes/app_routes.dart';
import '../../../../utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../presentation/screens/base_screen.dart';
import '../../../presentation/screens/userprofile/user_profile_widget.dart';
import '../../../presentation/widgets/buttons/primary_button.dart';
import '../../../presentation/widgets/buttons/secondary_button.dart';
import '../../../presentation/widgets/common_bottom_sheet.dart';
import '../../../presentation/widgets/horizontalspace/horizontal_space.dart';
import '../../../presentation/widgets/verticalspace/vertical_space.dart';
import '../../state/controller/gem_maf_home_page_controller.dart';
import '../../state/controller/maf_registration_details_controller.dart';
import '../../utils/gem_default_widget/loading_bar.dart';
import 'component/gem_term_condition_bottom_sheet.dart';
import 'component/heading_maf.dart';
import 'component/registration_details_card.dart';
import 'component/submit_success_bottom_sheet.dart';
import 'gem_maf_homepage.dart';
import 'maf_listinghome_page.dart';

class MafRegistrationDetails extends StatefulWidget {
  final String bidNumber;
  final String gstNumber;
  final String pubDate;
  final String dueDate;
  final String participantType;
  final String comments;
  final String doc;

  const MafRegistrationDetails({
    required this.bidNumber,
    required this.gstNumber,
    required this.pubDate,
    required this.dueDate,
    required this.participantType,
    required this.comments,
    required this.doc,
    super.key,
  });

  @override
  State<MafRegistrationDetails> createState() => _MafRegistrationDetailsState();
}

class _MafRegistrationDetailsState
    extends BaseScreenState<MafRegistrationDetails> {
  late double variablePixelHeight;
  late double variablePixelWidth;
  late double variablePixelMultiplier;
  late double textMultiplier;
  MafRegistrationDetailsController controller = Get.find();
  bool isTermsAndConditionAccepted = false;
  bool onSubmitButtonEnable = false;
  bool isCancelEnable = true;

  @override
  void initState() {
    controller.isDataRender.value = false;
    controller.reset();
    controller.getRegistrationDetails();
    super.initState();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed
    controller.clearRegistrationWiseDetailsState();
    super.dispose();
  }

  void showTermConditionPopup() {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      enableDrag: true,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return GemTermConditionBottomSheet(
          firstAppearance: false,
        );
      },
    );
  }

  void showSuccessBottomSheet() {
    var variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    var variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    CommonBottomSheet.show(
        context,
        SubmitSuccessBottomSheet(
          onItemSelected: () {
            GemHomePageController controller = Get.find();
            Navigator.of(context).pop();
            Navigator.pop(context, true);
            controller.getdata(context);
            //Navigator.pushNamed(context, AppRoutes.gemSupportMafHomePage);
          },
          contentTiltle: translation(context).successContent,
        ),
        variablePixelHeight,
        variablePixelWidth);
  }

  @override
  Widget baseBody(BuildContext context) {
    variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    variablePixelMultiplier =
        DisplayMethods(context: context).getPixelMultiplier();
    textMultiplier = DisplayMethods(context: context).getTextFontMultiplier();
    return WillPopScope(
      onWillPop: () async {
        controller.dispose();
        return true;
      },
      child: Scaffold(
        body:

        Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: 24 * variablePixelWidth,
                  vertical: 24 * variablePixelHeight),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                SizedBox(height: variablePixelHeight * 34),
                HeadingMaf(
                  icon: Icon(
                    Icons.arrow_back_outlined,
                    color: AppColors.iconColor,
                    size: 24 * variablePixelMultiplier,
                  ),
                  heading: translation(context).mafRegistration,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                UserProfileWidget(
                  horizontalPadding: 0,
                  top: 20 * variablePixelHeight,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Obx(() {
                          if (controller.isDataRender.value) {
                            DateTime pubDate =
                            DateFormat("yyyy-MM-dd").parse(widget.pubDate);
                            String formattedPubDate =
                            DateFormat("MMM dd, yyyy").format(pubDate);
                            DateTime dueDate =
                            DateFormat("yyyy-MM-dd").parse(widget.dueDate);
                            String formattedDueDate =
                            DateFormat("MMM dd, yyyy").format(dueDate);
                            return RegistrationDetailsCard(
                                widget.participantType,
                                widget.bidNumber,
                                widget.gstNumber,
                                formattedPubDate,
                                formattedDueDate,
                                widget.comments,
                                widget.doc);
                          }
                          return Container();
                        }),
                      ],
                    ),
                  ),
                ),
                const VerticalSpace(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    translation(context).termsAndConditions,
                    style: GoogleFonts.poppins(
                      color: AppColors.titleColor,
                      fontSize: 14 * textMultiplier,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const VerticalSpace(height: 10),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                          onTap: () async {
                            if (controller.isReadTerms.value == true) {
                              setState(() {
                                isTermsAndConditionAccepted =
                                !isTermsAndConditionAccepted;
                                onSubmitButtonEnable = isTermsAndConditionAccepted;
                              });
                            } else {
                              await CommonBottomSheet.OpenTermsAndConditions(
                                  context, "GEMMAF")
                                  .then((value) {
                                if (value == true) {
                                  controller.isReadTerms.value = value;
                                }
                              });
                            }
                          },
                          child: isTermsAndConditionAccepted == true
                              ? Icon(
                            Icons.check_box,
                            color: AppColors.lumiBluePrimary,
                          )
                              : Icon(Icons.check_box_outline_blank_outlined)),
                      const HorizontalSpace(width: 8),
                      Expanded(
                        // Added Expanded to ensure the text takes remaining space
                        child: GestureDetector(
                          onTap: () async {
                            // showTermConditionPopup();
                            await CommonBottomSheet.OpenTermsAndConditions(
                                context, "GEMMAF")
                                .then((value) {
                              if (value == true) {
                                controller.isReadTerms.value = value;
                              }
                            });
                          },
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              translation(context).acceptTermsConditions,
                              style: GoogleFonts.poppins(
                                color: AppColors.lumiBluePrimary,
                                fontSize: 12 * textMultiplier,
                                fontWeight: FontWeight.w500,
                                height: 20 / 12,
                                letterSpacing: 0.10 * variablePixelWidth,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const VerticalSpace(height: 20),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SecondaryButton(
                      buttonText: translation(context).back,
                      onPressed: () => {Navigator.pop(context)},
                      buttonHeight: 48 * variablePixelHeight,
                      isEnabled: isCancelEnable,
                    ),
                    SizedBox(width: 10 * variablePixelWidth),
                    PrimaryButton(
                      buttonText: translation(context).submit,
                      onPressed: () async {
                        try {
                          setState(() {
                            //isTermsAndConditionAccepted = false;
                            isCancelEnable = false;
                            onSubmitButtonEnable = false;
                          });
                          var isValidResponse = await controller.postMafBidRegData(
                            widget.participantType,
                            widget.bidNumber,
                            widget.gstNumber,
                            widget.pubDate,
                            widget.dueDate,
                            widget.comments,
                            widget.doc,
                          );

                          // Handle the response here
                          if (isValidResponse == 'success') {
                            await CommonBottomSheet.openSuccessSheet(
                                context,
                                "Submit successfully",
                                translation(context).successContent);

                            GemHomePageController controller = Get.find();
                            controller.getdata(context);
                            Navigator.pushAndRemoveUntil(
                                context, MaterialPageRoute(
                                builder: (context) => GemMafHomePage()),
                                    (Route<dynamic> route) => route.isFirst);

                            //showSuccessBottomSheet();
                          } else {
                            Utils().showToast(isValidResponse.toString(), context);
                            setState(() {
                              //isTermsAndConditionAccepted = true;
                              onSubmitButtonEnable = true;
                              isCancelEnable = true;
                            });
                            Utils().showToast(isValidResponse!, context);
                            // Registration failed
                          }
                        } catch (error) {
                          setState(() {
                            //isTermsAndConditionAccepted = true;
                            onSubmitButtonEnable = false;
                            isCancelEnable = true;
                          });
                          // Handle errors here
                          print('Error: $error');
                        }
                      },
                      buttonHeight: 48 * variablePixelHeight,
                      isEnabled: onSubmitButtonEnable ?? false,
                    ),
                  ],
                ),
              ]),
            ),

        Obx(() {
          if(controller.isApiLoading.value==true)return LoadingBar();
          return Container();
        }),


          ],
        ),
      ),
    );
  }
}
