import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';
import '../../../../presentation/screens/home/widgets/section_headings.dart';
import '../../../../presentation/widgets/verticalspace/vertical_space.dart';
import '../../../state/controller/maf_registration_details_controller.dart';
import '../../../utils/gem_default_widget/gem_imageview_dialog.dart';
import '../../../utils/levelwithvalue.dart';

class RegistrationDetailsCard extends StatefulWidget {
  final String bidNumber;
  final String gstNumber;
  final String pubDate;
  final String dueDate;
  final String participantType;
  final String comments;
  final String doc;
  const RegistrationDetailsCard(this.participantType, this.bidNumber,
      this.gstNumber, this.pubDate, this.dueDate, this.comments, this.doc,
      {super.key});

  @override
  State<RegistrationDetailsCard> createState() => _SummaryCardWidgetState();
}

class _SummaryCardWidgetState extends State<RegistrationDetailsCard> {
  final MafRegistrationDetailsController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double pixelMultipler =
        DisplayMethods(context: context).getPixelMultiplier();

    double f = DisplayMethods(context: context).getTextFontMultiplier();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
          horizontal: 8 * variablePixelWidth,
          vertical: 8 * variablePixelHeight),
      decoration: ShapeDecoration(
        color: AppColors.lightWhite,
        shape: RoundedRectangleBorder(
          side: BorderSide(
              width: 1 * variablePixelWidth, color: AppColors.white_234),
          borderRadius: BorderRadius.circular(12 * pixelMultipler),
        ),
      ),
      child: controller.mafRegistrationData.value.isNotEmpty &&
              controller.mafRegistrationData.value[0].data.isNotEmpty
          ? Column(
              children: [
                SectionHeading(
                  text: translation(context).mafDetails,
                  fontWeight: FontWeight.w600,
                  showChevronRight: false,
                ),

                VerticalSpace(height: 10),
                const PopupMenuDivider(height: 1),

                ////new items
                SizedBox(
                  height: 12 * variablePixelHeight,
                ),

                LevelWithValue(
                  lavel: translation(context).firmName,
                  value: controller
                      .mafRegistrationData.value[0].data[0].firmName
                      .toString(),
                ),

                LevelWithValue(
                  lavel: translation(context).emailId,
                  value: controller
                      .mafRegistrationData.value[0].data[0].email_ID
                      .toString(),
                ),

                LevelWithValue(
                  lavel: translation(context).code,
                  value: controller.mafRegistrationData.value[0].data[0].code
                      .toString(),
                ),

                LevelWithValue(
                  lavel: translation(context).address,
                  value: controller.mafRegistrationData.value[0].data[0].address
                      .toString(),
                ),

                LevelWithValue(
                  lavel: translation(context).state,
                  value: controller.mafRegistrationData.value[0].data[0].state
                      .toString(),
                ),

                LevelWithValue(
                  lavel: translation(context).location,
                  value: controller
                      .mafRegistrationData.value[0].data[0].location
                      .toString(),
                ),

                LevelWithValue(
                  lavel: translation(context).participateType,
                  value: widget.participantType.toString(),
                ),

                LevelWithValue(
                  lavel: translation(context).bidNumber,
                  value: widget.bidNumber.toString(),
                ),

                LevelWithValue(
                  lavel: translation(context).bidPubDate,
                  value: widget.pubDate.toString(),
                ),

                LevelWithValue(
                  lavel: translation(context).bidDueDate,
                  value: widget.dueDate.toString(),
                ),

                LevelWithValue(
                  lavel: translation(context).gstinnumber,
                  value: widget.gstNumber.toString(),
                ),

                LevelWithValue(
                  lavel: translation(context).pannumber,
                  value: controller
                      .mafRegistrationData.value[0].data[0].paN_Number
                      .toString(),
                ),

                SizedBox(
                  height: 5,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceBetween, // Align items to start and end of the row
                  children: [
                    // Left side: Text Name
                    Text(
                      translation(context).tenderDocuments,
                      style: GoogleFonts.poppins(
                        color: AppColors.darkGreyText,
                        fontSize: 12 * f,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.10,
                      ),
                    ),
                    // Right side: Name value

                    GestureDetector(
                      onTap: () {
                        print('Error:' + widget.doc);
                        GemImageViewDialog(context, imagePath: widget.doc);
                        //show image in box.
                        //controller.mafRegistrationData.value[0].data[0].location,
                      },
                      child: widget.doc.isNotEmpty
                          ? Text(
                              'Document Link',
                              style: GoogleFonts.poppins(
                                color: Colors.indigo,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          : Text(
                              '',
                              style: TextStyle(
                                  fontSize:
                                      0), // Make text invisible if doc is empty
                            ),
                    ),
                  ],
                ),

                LevelWithValue(
                    lavel: translation(context).productRequirement,
                    value: widget.comments.toString() != ""
                        ? widget.comments.toString()
                        : "NA"),
              ],
            )
          : Container(
              // If the list or its nested data are empty, display an empty container
              width: 0,
              height: 0,
            ),
    );
  }
}
