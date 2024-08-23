import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';


import '../../../../../../utils/routes/app_routes.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_constants.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../widgets/verticalspace/vertical_space.dart';
import '../../redeem_coins_Cashback/redeem_coins_to_cashback.dart';

class RedeemChipWidget extends StatelessWidget {
  String iconUrl;
  String text;

  RedeemChipWidget({super.key, required this.iconUrl, required this.text});

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double fontMultiplier =
    DisplayMethods(context: context).getTextFontMultiplier();
    double pixelMultiplier =
    DisplayMethods(context: context).getPixelMultiplier();

    logger.e("iconUrl: ${iconUrl}");

    return Expanded(
        child: Column(
          children: [
            CachedNetworkImage(
              width: 40 * variablePixelWidth,
              height: 40 * variablePixelHeight,
              imageUrl: iconUrl,
              placeholder: (context, url) => SvgPicture.asset("assets/mpartner/ic_icon_placeholder.svg"),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            VerticalSpace(height: 8*variablePixelHeight),
            Text(
              text,
              style: GoogleFonts.poppins(
                  color: AppColors.darkGreyText,
                  fontSize: 12*fontMultiplier,
                  fontWeight: FontWeight.w400),
            )
          ],
        ));
  }
}
