import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../presentation/screens/report_management/widgets/common_bottom_modal.dart';
import '../../../../presentation/screens/userprofile/user_profile_widget.dart';
import '../../../../presentation/widgets/CommonCards/card_with_download_and_share.dart';
import '../../../../presentation/widgets/headers/back_button_header_widget.dart';
import '../../../../presentation/widgets/verticalspace/vertical_space.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../state/controller/banking_partners_controller.dart';
import '../../common/heading_solar.dart';
import '../solar_finance_request/components/drop_down_selection_list.dart';
import 'preferred_bank_options.dart';

class BankingPartners extends StatefulWidget {
  const BankingPartners({super.key});

  @override
  State<BankingPartners> createState() => _BankingPartnersState();
}

class _BankingPartnersState extends State<BankingPartners> {
  BankingPartnersController bankingPartnersController = Get.find();
  TextEditingController textFieldControllerSelectBank = TextEditingController();
  bool isNotEmpty = false;

  @override
  void initState() {
    bankingPartnersController.clearBankingPartnersController();
    bankingPartnersController.fetchPreferredBanksList();
    super.initState();
  }

  String formatDate(String inputDate) {
    DateTime date = DateTime.parse(inputDate);
    String formattedDate = '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight = DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth = DisplayMethods(context: context).getVariablePixelWidth();
    double textMultiplier = DisplayMethods(context: context).getTextFontMultiplier();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            HeadingSolar(
              heading: translation(context).bankingPartners,
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
                      Container(
                        margin: EdgeInsets.only(left: 24 * variablePixelWidth, right: 24 * variablePixelWidth),
                        child: Text(
                          translation(context).choosePartnerBank,
                          style: GoogleFonts.poppins(
                            color: AppColors.darkGrey,
                            fontSize: 16 * textMultiplier,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.10 * variablePixelWidth,
                          ),
                        ),
                      ),
                      const VerticalSpace(height: 24),
                      Padding(
                        padding: EdgeInsets.only(left: 24 * variablePixelWidth, right: 24 * variablePixelWidth),
                        child: DropDownSelectionWidget(
                          controller: textFieldControllerSelectBank,
                          labelText:  translation(context).bankPartner,
                          isMandatory: false,
                          placeholdertext: textFieldControllerSelectBank.text.isNotEmpty? textFieldControllerSelectBank.text : 'Select Bank',
                          icon: Icons.keyboard_arrow_down_outlined,
                          modalBody: CommonBottomModal(
                            modalLabelText:  translation(context).selectPartnerBank,
                            body: PreferredBankOptions(
                              onBankSelected: (bank, id) {
                                Navigator.pop(context);
                                if(bank.isNotEmpty){
                                  bankingPartnersController.loanScheme.value = [];
                                  setState(() {
                                    textFieldControllerSelectBank.text = bank;
                                    isNotEmpty = true;
                                  });
                                }
                                bankingPartnersController.fetchLoanScheme(id);
                              },
                              isBankingPartner: true,
                            ),
                          ),
                          textColor: AppColors.titleColor,
                        ),
                      ),
                      const VerticalSpace(height: 24),
                      isNotEmpty ? Obx(() {
                        if (bankingPartnersController.isSchemeLoading.value) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (bankingPartnersController.errorLoadingPdf.isNotEmpty) {
                          return Container();
                        } else {
                          final bool isDataEmpty = bankingPartnersController.loanScheme.first.data.isEmpty;
                          if (isDataEmpty) {
                            return Center(child: Text(translation(context).dataNotFound, style: GoogleFonts.poppins(
                                fontSize: 14 * textMultiplier,
                                fontWeight: FontWeight.w500
                            ),));
                          } else {
                            return  Container(
                              margin: EdgeInsets.only(left: 24 * variablePixelWidth, right: 24 * variablePixelWidth),
                              child:  ContainerWithImageCardAndPDFDownload(
                                title: bankingPartnersController.loanScheme.first.data.first.title,
                                subtitle: "Last updated on ${bankingPartnersController.loanScheme.first.data.first.lastUpdatedOn.isNotEmpty ? formatDate(bankingPartnersController.loanScheme.first.data.first.lastUpdatedOn) : ""}",
                                Uri: bankingPartnersController.loanScheme.first.data.first.thumbnail.isNotEmpty
                                    ? bankingPartnersController.loanScheme.first.data.first.thumbnail
                                    : "https://w7.pngwing.com/pngs/252/42/png-transparent-pdf-computer-icons-pdf-miscellaneous-text-rectangle-thumbnail.png",
                                pdfUri: bankingPartnersController.loanScheme.first.data.first.pdf,
                                showCardHeading: false,
                                height: 350 * variablePixelWidth,
                              ),
                            );
                         }
                       }
                      }) : Container(),
                    ]
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
