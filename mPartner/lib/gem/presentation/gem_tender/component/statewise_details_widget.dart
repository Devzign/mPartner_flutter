import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../../utils/localdata/language_constants.dart';

import '../../../../../utils/utils.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../presentation/widgets/verticalspace/vertical_space.dart';
import 'gem_comman_details_row.dart';

class StateWiseDetailsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> statewiseDetails;

  StateWiseDetailsWidget({required this.statewiseDetails});

  @override
  Widget build(BuildContext context) {
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: statewiseDetails.length,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: 24 * variablePixelWidth,
                  right: 24 * variablePixelWidth),
              child: Result(data: statewiseDetails[index]),
            ),
            // Add space between rows
            const VerticalSpace(height: 16),
          ],
        );
      },
    );
  }
}

class Result extends StatelessWidget {
  final Map<String, dynamic> data;

  Result({required this.data});

  String capitalizeEachWord(String text) {
    List<String> words = text.split(' ');
    for (int i = 0; i < words.length; i++) {
      if (words[i].isNotEmpty) {
        // Special case for "And"
        if (words[i].toLowerCase() == 'and') {
          words[i] = '&';
        } else {
          words[i] =
              words[i][0].toUpperCase() + words[i].substring(1).toLowerCase();
        }
      }
    }
    return words.join(' ');
  }

  @override
  Widget build(BuildContext context) {

    double variablePixelHeight = DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth = DisplayMethods(context: context).getVariablePixelWidth();
    double pixelMultipler = DisplayMethods(context: context).getPixelMultiplier();

    double textFontMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();
    //String title = "";
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
          horizontal: 8 * variablePixelWidth,
          vertical: 8 * variablePixelHeight),
      decoration: ShapeDecoration(
        color: AppColors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(
              width: 1 * variablePixelWidth, color: AppColors.white_234),
          borderRadius: BorderRadius.circular(12 * pixelMultipler),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data['nTetnderTitle'],
            style: GoogleFonts.poppins(
              color: AppColors.titleColor,
              fontSize: 16 * textFontMultiplier,
              fontWeight: FontWeight.w700,
            ),
          ),
          const VerticalSpace(height: 10),
          Text(
            data['dPostedOn'] != null && data['dPostedOn'] != ''
                ? translation(context).postedOn + ' ${Utils().getFormattedDate(data['dPostedOn'])}'
                : '', // Display empty string if dBidPublishDate is empty
            style: GoogleFonts.poppins(
              color: AppColors.titleColor,
              fontSize: 14 * textFontMultiplier,
              fontWeight: FontWeight.w400,
            ),
          ),
          const VerticalSpace(height: 16),
          GemCommanDetailsRow(
              label: translation(context).bidNumber,
              value: data['sBidNumber']),
          const VerticalSpace(height: 12),
          GemCommanDetailsRow(
            label: translation(context).bidPubDate,
            value: data['dBidPublishDate'] != null && data['dBidPublishDate'] != ''
                ? capitalizeEachWord(Utils().getFormattedDateMonth(data['dBidPublishDate']))
                : '', // Display empty string if dBidPublishDate is empty
          ),
          const VerticalSpace(height: 12),

          GemCommanDetailsRow(
            label: translation(context).bidDueDate,
            value: data['dBidDueDate'] != null && data['dBidDueDate'] != ''
                ? capitalizeEachWord(Utils().getFormattedDateMonth(data['dBidDueDate']))
                : '', // Display empty string if dBidPublishDate is empty
          ),

          // const VerticalSpace(height: 12),
          //
          // GemCommanDetailsRow(
          //   label: translation(context).category,
          //   value: data['category'] != null && data['category'] != ''
          //       ? capitalizeEachWord(data['category'])
          //       : 'NA', // Display empty string if dBidPublishDate is empty
          // ),

        ],
      ),
    );
  }
}
