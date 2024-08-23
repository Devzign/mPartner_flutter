import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../utils/localdata/language_constants.dart';
import '../../widgets/common_button.dart';
import '../../widgets/common_divider.dart';
import '../../widgets/horizontalspace/horizontal_space.dart';
import '../../widgets/verticalspace/vertical_space.dart';
import 'components/common_detail_row_widget.dart';
import 'upload_gst_certificate.dart';
import 'upload_pan_card.dart';
import 'upload_passport.dart';

void viewDetailsBottomSheet(BuildContext context,
    String type,
    String title,
    String image1,
    String? image2,
    String documentType,
    String documentNumber,
    String status,
    String statusValue,
    String remark,
    String remarkValue){

  double variablePixelHeight = DisplayMethods(context: context).getVariablePixelHeight();
  double variablePixelWidth = DisplayMethods(context: context).getVariablePixelWidth();
  double textFontMultiplier = DisplayMethods(context: context).getTextFontMultiplier();
  double pixelMultiplier = DisplayMethods(context: context).getPixelMultiplier();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape:  RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(25.0 * pixelMultiplier),
      ),
    ),
    builder: (context) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Wrap(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const VerticalSpace(height: 16),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Center(
                  child: Container(
                    height: 5 * variablePixelHeight,
                    width: 50 * variablePixelWidth,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12 * pixelMultiplier),
                    ),
                  ),
                ),
              ),
              const VerticalSpace(height: 16),
              Container(
                margin: EdgeInsets.only(left: 10.0 * variablePixelWidth, right: 24 * variablePixelWidth),
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.close,
                    color: Colors.black,
                    size: 28 * pixelMultiplier,
                  ),
                ),
              ),
              const VerticalSpace(height: 12),
              Container(
                margin: EdgeInsets.only(left: 24.0 * variablePixelWidth, right: 24 * variablePixelWidth),
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    color: AppColors.titleColor,
                    fontSize: 20 * textFontMultiplier,
                    fontWeight: FontWeight.w600,
                    height: 0.06 * variablePixelHeight,
                    letterSpacing: 0.50,
                  ),
                ),
              ),
              const VerticalSpace(height: 16),
              Container(
                padding: EdgeInsets.only(right: 24 * variablePixelWidth, left: 24 * variablePixelWidth),
                child: const CustomDivider(color: AppColors.dividerColor),
              ),
              const VerticalSpace(height: 24),
              (type.toLowerCase() == 'pan' || type.toLowerCase() == 'gst') ?
              Padding(
                padding: EdgeInsets.only(right: 24 * variablePixelWidth, left: 24 * variablePixelWidth),
                child: ClipRRect(
                  borderRadius:  BorderRadius.circular(8 * pixelMultiplier),
                  child: Container(
                    width: double.infinity,
                    height: 214 * variablePixelHeight,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 1 * variablePixelWidth, color: AppColors.white_234),
                        borderRadius: BorderRadius.circular(8 * pixelMultiplier),
                      ),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: image1,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image_not_supported_outlined,
                            color: AppColors.lightGrey1,
                            size: 48 * pixelMultiplier,
                          ),
                          const VerticalSpace(height: 4),
                          Text(
                            translation(context).errorUploadingImage,
                            style: GoogleFonts.poppins(
                              color: AppColors.hintColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 12 * textFontMultiplier,
                              letterSpacing: 0.10 * variablePixelWidth,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ) : Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 24 * variablePixelWidth, left: 24 * variablePixelWidth),
                    child: ClipRRect(
                      borderRadius:  BorderRadius.circular(8 * pixelMultiplier),
                      child: Container(
                        width: double.infinity,
                        height: 214 * variablePixelHeight,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(width: 1 * variablePixelWidth, color: AppColors.white_234),
                            borderRadius: BorderRadius.circular(8 * pixelMultiplier),
                          ),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: image1,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) => Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.image_not_supported_outlined,
                                color: AppColors.lightGrey1,
                                size: 48 * pixelMultiplier,
                              ),
                              const VerticalSpace(height: 4),
                              Text(
                                translation(context).errorUploadingImage,
                                style: GoogleFonts.poppins(
                                  color: AppColors.hintColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12 * textFontMultiplier,
                                  letterSpacing: 0.10 * variablePixelWidth,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const VerticalSpace(height: 16),
                  Padding(
                    padding: EdgeInsets.only(right: 24 * variablePixelWidth, left: 24 * variablePixelWidth),
                    child: ClipRRect(
                      borderRadius:  BorderRadius.circular(8 * pixelMultiplier),
                      child: Container(
                        width: double.infinity,
                        height: 214 * variablePixelHeight,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(width: 1 * variablePixelWidth, color: AppColors.white_234),
                            borderRadius: BorderRadius.circular(8 * pixelMultiplier),
                          ),
                        ),
                        child:CachedNetworkImage(
                          imageUrl: image2!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) => Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.image_not_supported_outlined,
                                color: AppColors.lightGrey1,
                                size: 48 * pixelMultiplier,
                              ),
                              const VerticalSpace(height: 4),
                              Text(
                                translation(context).errorUploadingImage,
                                style: GoogleFonts.poppins(
                                  color: AppColors.hintColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12 * textFontMultiplier,
                                  letterSpacing: 0.10 * variablePixelWidth,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Container(
                padding: EdgeInsets.only(right: 24 * variablePixelWidth, left: 24 * variablePixelWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const VerticalSpace(height: 24),
                    CommonDetailRowWidget(label: documentType, value: documentNumber),
                    const VerticalSpace(height: 12),
                    CommonDetailRowWidget(label: status, value: getStatusWidget(statusValue, variablePixelWidth, variablePixelHeight, textFontMultiplier)),
                    const VerticalSpace(height: 12),
                    CommonDetailRowWidget(label: remark, value: remarkValue),
                    const VerticalSpace(height: 24),
                  ],
                ),
              ),
              if(statusValue.toLowerCase() == 'rejected')
                Column(
                  children: [
                    CommonButton(
                        onPressed: type.toLowerCase() == 'pan' ? (){
                          Navigator.pop(context);
                          Navigator.push(context,  MaterialPageRoute(builder: (context) => const PanCardUpload()));
                        } : type.toLowerCase() == 'gst' ? () {
                          Navigator.pop(context);
                          Navigator.push(context,  MaterialPageRoute(builder: (context) => const GstCertificateUpload()));
                        } : (){
                          Navigator.pop(context);
                          Navigator.push(context,  MaterialPageRoute(builder: (context) => const PassportUpload()));
                        },
                        isEnabled: true,
                        buttonText: 'Re-upload',
                        containerBackgroundColor: AppColors.white,
                    ),
                  ],
                )
            ],
          ),
        ],
      ),
    ),
  );
}

Widget getStatusWidget(String statusValue, double variablePixelWidth, double variablePixelHeight, double textFontMultiplier) {
  if (statusValue.toLowerCase() == 'accepted') {
    return Row(
      children: [
        SvgPicture.asset(
          'assets/mpartner/ismart/ic_accepted.svg',
          width: 16 * variablePixelWidth,
          height: 16 * variablePixelHeight,
        ),
        const HorizontalSpace(width: 6),
        Text(
          statusValue,
          style: GoogleFonts.poppins(
            color: AppColors.successGreen,
            fontSize: 12 * textFontMultiplier,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  } else if (statusValue.toLowerCase() == 'pending') {
    return Row(
      children: [
        SvgPicture.asset(
          'assets/mpartner/ismart/ic_pending.svg',
          width: 16 * variablePixelWidth,
          height: 16 * variablePixelHeight,
        ),
        const HorizontalSpace(width: 6),
        Text(
          statusValue,
          style: GoogleFonts.poppins(
            color: AppColors.pendingYellow,
            fontSize: 12 * textFontMultiplier,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  } else if (statusValue.toLowerCase() == 'rejected') {
    return Row(
      children: [
        SvgPicture.asset(
          'assets/mpartner/ismart/ic_cancel.svg',
          width: 16 * variablePixelWidth,
          height: 16 * variablePixelHeight,
        ),
        const HorizontalSpace(width: 6),
        Text(
          statusValue,
          style: GoogleFonts.poppins(
            color: AppColors.errorRed,
            fontSize: 12 * textFontMultiplier,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  } else {
    return Text(
      statusValue,
      style: GoogleFonts.poppins(
        color: AppColors.darkGreyText,
        fontSize: 14 * textFontMultiplier,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.50,
      ),
    );
  }
}
