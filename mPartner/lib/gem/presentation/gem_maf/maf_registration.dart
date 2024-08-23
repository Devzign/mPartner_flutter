
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/utils.dart';
import '../../../presentation/screens/base_screen.dart';
import '../../../presentation/screens/network_management/dealer_electrician/components/submit_button.dart';
import '../../../presentation/screens/userprofile/user_profile_widget.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../state/controller/maf_registrationform_controller.dart';

import 'component/heading_maf.dart';
import 'component/maf_registration_form.dart';
import 'maf_registration_details.dart';

class MafRegistration extends StatefulWidget {

  final String gstNumber;

  const MafRegistration({required this.gstNumber ,super.key});

  @override
  State<MafRegistration> createState() => _MafRegistrationState();
}

class _MafRegistrationState extends BaseScreenState<MafRegistration> {
  late double variablePixelHeight;
  late double variablePixelWidth;
  late double variablePixelMultiplier;
  late double textMultiplier;
  late String selectedUserType;
  MafRegistrationFormController controller = Get.find();

  @override
  void initState() {
    selectedUserType = "Gem Tender";
    controller.enableProceed.value = false;
    controller.reset();
    controller.participantController.text = "Gem Tender";
    print("GST NUMBER   " + widget.gstNumber);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
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
        backgroundColor: Colors.white,
        bottomNavigationBar: submitButtonWidget(),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 14*variablePixelWidth,vertical: 14*variablePixelHeight),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            SizedBox(height: variablePixelHeight * 24),
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

            UserProfileWidget(horizontalPadding:0,top: 20*variablePixelHeight,),
            titleWidget(textMultiplier, variablePixelMultiplier),
            Expanded(
              child: Container(
                  child:  MafRegistrationForm(selectedUserType, widget.gstNumber)),
            )
          ]),
        ),
      ),
    );
  }

  Widget titleWidget(double textMultiplier, double variablePixelMultiplier) {
    return Container(
      height: 40 * variablePixelMultiplier,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: ()async{

            },
            child: Text(
             translation(context).mafDetails,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: AppColors.darkText2,
                fontSize: 15 * textMultiplier,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget submitButtonWidget() {
    return Obx(() {
      return Container(
        height: 100 * variablePixelHeight,
        padding: EdgeInsets.fromLTRB(
            1 * variablePixelWidth, 0, 1 * variablePixelWidth, 0),
        alignment: Alignment.center,
        child: SubmitButton(
            onPressed: () async {
              FocusScope.of(context).unfocus();

              String? error = controller.validateTextFirmField(context);

              if(error != null){
                if(error == translation(context).invalidGstin) {
                  controller.gstNumberErrorText.value = error;
                }else{
                  Utils().showToast(error, context);
                }
              }else{

                String bidNumber = controller.bidNumberController.text.trim();
                String gstNumber = controller.gstNumberController.text.trim();
                String bidPublishDate = controller.datePublishController.text.trim();
                String bidDueDate = controller.dateDueController.text.trim();
                String participantType = controller.participantType;
                String comments = controller.writeToUsController.text.trim();
                String doc = controller.docImagePath;
                DateTime pubDate = DateFormat("dd/MM/yyyy").parse(bidPublishDate);
                String formattedPubDate = DateFormat("yyyy-MM-dd").format(pubDate);
                DateTime dueDate = DateFormat("dd/MM/yyyy").parse(bidDueDate);
                String formattedDueDate = DateFormat("yyyy-MM-dd").format(dueDate);
                var res=await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>  MafRegistrationDetails(
                      bidNumber: bidNumber,
                      gstNumber: gstNumber,
                      pubDate: formattedPubDate,
                      dueDate: formattedDueDate,
                      participantType: participantType,
                      comments: comments,
                      doc: doc,
                    ),
                  ),
                );
               print(res);

              }
            },
            isEnabled: controller.enableProceed.value,
            //isEnabled:  true,
            containerBackgroundColor: AppColors.white,
            buttonText: translation(context).proceed),
      );
    });
  }

}