import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../utils/app_colors.dart';
import '../../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/localdata/language_constants.dart';
import '../../../../../utils/utils.dart';
import '../../../data/models/maf_bid_details_response_model.dart';
import '../../../network/api_constants.dart';
import '../../../utils/FileUtils.dart';
import '../../../utils/gem_default_widget/gem_imageview_dialog.dart';
import '../../../utils/levelwithvalue.dart';

class MefDataDetailsPageWidget extends StatelessWidget {
  MafBidDetailsResponseModel? datalist;
  String? authcode;
  MefDataDetailsPageWidget(this.datalist, this.authcode);

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double textMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();

    String? statusTitle = "";
    if (datalist!.status.toString() == "Approved") {
      statusTitle = "MAF Issued";
    } else {
      statusTitle = datalist!.status.toString();
    }

    return Container(
      margin: EdgeInsets.fromLTRB(
          24 * variablePixelWidth,
          24 * variablePixelHeight,
          24 * variablePixelWidth,
          24 * variablePixelHeight),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(
                10 * variablePixelWidth,
                10 * variablePixelHeight,
                10 * variablePixelWidth,
                10 * variablePixelHeight),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: AppColors.grey97,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Row(
                    children: [
                      Expanded(
                          child: Container(
                              child: Text(translation(context).mafDetails,
                                  style: GoogleFonts.poppins(
                                    color: AppColors.darkText2,
                                    fontSize: 15 * textMultiplier,
                                    fontWeight: FontWeight.w600,
                                  )))),
                      if (datalist!.status.toString() == "Approved") ...[
                        InkWell(
                          child: Container(
                            height: 25,
                            width: 25,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(
                                    width: 1, color: AppColors.grey)),
                            child: Icon(
                              Icons.download,
                              color: AppColors.grey,
                              size: 15,
                            ),
                          ),
                          onTap: () {
                            String url = datalist!.mafDocumentShareUrl.toString();
                            if (url.contains('.pdf')) {
                              // It's a PDF
                              FileUtils.downloadPdf(url, context);
                            } else {
                              Utils().showToast(translation(context).somethingWentWrong, context);
                            }


                          },
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        InkWell(
                          child: Container(
                            height: 25,
                            width: 25,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100),
                              border:
                                  Border.all(width: 1, color: AppColors.grey),
                            ),
                            child: const Icon(
                              Icons.share,
                              color: AppColors.grey,
                              size: 15,
                            ),
                          ),
                          onTap: () {
                            // String shareUrl = GemApiConstants.imageBaseUrl +
                            //     datalist!.mafDocumentShareUrl.toString();
                            // if (kDebugMode) {
                            //   print('share_url  : $shareUrl');
                            // }
                            FileUtils.sharePdf(datalist!.mafDocumentShareUrl.toString(), context);
                          },
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  height: 1,
                  color: AppColors.grey,
                ),
                SizedBox(
                  height: 10,
                ),

                LevelWithValue(
                  lavel: translation(context).firmName,
                  value: datalist!.firmName.toString(),
                ),

                LevelWithValue(
                  lavel: translation(context).emailId,
                  value: datalist!.emailId.toString(),
                ),

                LevelWithValue(
                  lavel: translation(context).code,
                  value: datalist!.code.toString(),
                ),

                LevelWithValue(
                  lavel: translation(context).address,
                  value: datalist!.address.toString(),
                ),
                LevelWithValue(
                  lavel: translation(context).state,
                  value: datalist!.state.toString(),
                ),
                LevelWithValue(
                  lavel: translation(context).city,
                  value: datalist!.location.toString(),
                ),

                LevelWithValue(
                  lavel: translation(context).bidNumber,
                  value: datalist!.bidNumber.toString(),
                ),
                LevelWithValue(
                    lavel: translation(context).bidPubDate,
                    value: Utils().getFormattedDateMonth(
                        datalist!.bidPublishDate.toString())),

                LevelWithValue(
                    lavel: translation(context).bidDueDate,
                    value: Utils().getFormattedDateMonth(
                        datalist!.bidDueDate.toString())),
                LevelWithValue(
                    lavel: translation(context).gstinnumber,
                    value: datalist!.gstNumber.toString()),
                LevelWithValue(
                    lavel: translation(context).pannumber,
                    value: datalist!.panNumber.toString()),
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
                        fontSize: 12 * textMultiplier,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.10,
                      ),
                    ),
                    // Right side: Name value

                    GestureDetector(
                      onTap: () {
                        String image_url = GemApiConstants.imageBaseUrl +
                            datalist!.tenderDocument.toString();
                        print('image_url:' + image_url);
                        GemImageViewDialog(context, imagePath: image_url);
                        //show image in box.
                        //controller.mafRegistrationData.value[0].data[0].location,
                      },
                      child: datalist!.tenderDocument.toString().isNotEmpty
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
                SizedBox(
                  height: 5,
                ),
                // LevelWithValue(lavel:translation(context).tenderDocuments, value:datalist!.tenderDocument.toString()!=""?"Document link":""),
                LevelWithStatus(
                    lavel: translation(context).mafreqstatus,
                    value: statusTitle.toString()),
                if (datalist!.status.toString() == "Approved" &&
                    datalist!.bidStatus.isNotEmpty)
                  LevelWithStatus(
                      lavel: translation(context).bidstatus,
                      value: datalist!.bidStatus.toString()),
                if (datalist!.status.toString() == "Approved" ||
                    datalist!.status.toString() == "Rejected" &&
                        datalist!.reason.isNotEmpty)
                  LevelWithValue(
                      lavel: translation(context).reason,
                      value: datalist!.reason.toString()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
