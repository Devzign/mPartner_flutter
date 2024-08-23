import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../state/contoller/user_data_controller.dart';
import '../../../../utils/app_string.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../upload_gst_certificate.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../widgets/verticalspace/vertical_space.dart';
import '../common_row_travel_document.dart';
import '../upload_pan_card.dart';
import '../upload_passport.dart';
import '../view_details_widget.dart';

class TravelDocumentsWidget extends StatelessWidget {
  final String panImg;
  final String panNo;
  final String panStatus;
  final String panRemark;
  final String gstImg;
  final String gstNo;
  final String gstStatus;
  final String gstRemark;
  final String passportFront;
  final String passportBack;
  final String passportNo;
  final String passportStatus;
  final String passportRemark;

  const TravelDocumentsWidget({
    Key? key,
    required this.panImg,
    required this.panNo,
    required this.panStatus,
    required this.panRemark,
    required this.gstImg,
    required this.gstNo,
    required this.gstStatus,
    required this.gstRemark,
    required this.passportFront,
    required this.passportBack,
    required this.passportNo,
    required this.passportStatus,
    required this.passportRemark,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserDataController controller = Get.find();
    String user = controller.userType;

    double textFontMultiplier = DisplayMethods(context: context).getTextFontMultiplier();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            translation(context).travelDocuments,
            style: GoogleFonts.poppins(
              color: AppColors.darkGreyText,
              fontSize: 16 * textFontMultiplier,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.10,
            )
        ),
        (user == UserTypeString.disty) ? const SizedBox(height: 0)
            : const VerticalSpace(height: 24),
        (user == UserTypeString.disty) ? const SizedBox(height: 0)
            : CommonRowTravelDocument(label: translation(context).pan, status: panStatus,
         onViewDetails: () {
           viewDetailsBottomSheet(context,
               'PAN',
               translation(context).pan,
               panImg,
               null,
               translation(context).panCardNumber,
               panNo,
               translation(context).status,
               panStatus,
               translation(context).remarks,
               panRemark);
          },
         onUpload: () {
           Navigator.push(context,  MaterialPageRoute(builder: (context) => const PanCardUpload()));
         }),
        /*(user == UserTypeString.disty) ? const SizedBox(height: 0)
            : const VerticalSpace(height: 24),
        (user == UserTypeString.disty) ? const SizedBox(height: 0)
        : CommonRowTravelDocument(label: translation(context).gstCertificate, status: gstStatus,
            onViewDetails: () {
              viewDetailsBottomSheet(context,
                  'GST',
                  translation(context).gstCertificate,
                  gstImg,
                  null,
                  translation(context).gstNumber,
                  gstNo,
                  translation(context).status,
                  gstStatus,
                  translation(context).remarks,
                  gstRemark);
            },
            onUpload: () {
              Navigator.push(context,  MaterialPageRoute(builder: (context) => const GstCertificateUpload()));
            }),*/
        const VerticalSpace(height: 24),
        CommonRowTravelDocument(label: translation(context).passport, status: passportStatus,
            onViewDetails: () {
              viewDetailsBottomSheet(context,
                  'PASSPORT',
                  translation(context).passport,
                  passportFront,
                  passportBack,
                  translation(context).passportNo,
                  passportNo,
                  translation(context).status,
                  passportStatus,
                  translation(context).remarks,
                  passportRemark);
            },
            onUpload: () {
              Navigator.push(context,  MaterialPageRoute(builder: (context) => const PassportUpload()));
            }),
        const VerticalSpace(height: 24),
      ],
    );
  }
}
