import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/routes/app_routes.dart';
import '../../../../widgets/horizontalspace/horizontal_space.dart';

import '../../../../../utils/localdata/language_constants.dart';

class CheckWarrantyStatusWidget extends StatefulWidget {
  const CheckWarrantyStatusWidget({super.key});

  @override
  State<CheckWarrantyStatusWidget> createState() =>
      _CheckWarrantyStatusWidgetState();
}

class _CheckWarrantyStatusWidgetState extends State<CheckWarrantyStatusWidget> {
  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double pixelMultiplier = DisplayMethods(context: context).getPixelMultiplier();
    double fontMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();

    const String svgString = '''
<svg width="29" height="29" viewBox="0 0 29 29" fill="none" xmlns="http://www.w3.org/2000/svg">
<rect width="29" height="29" rx="14.5" fill="#5670BE"/>
<mask id="mask0_3568_46176" style="mask-type:alpha" maskUnits="userSpaceOnUse" x="6" y="6" width="17" height="17">
<rect x="6.5" y="6" width="16" height="17" fill="#D9D9D9"/>
</mask>
<g mask="url(#mask0_3568_46176)">
<path d="M12.5501 17.5107L14.5001 16.2534L16.4501 17.5107L15.9335 15.1555L17.6668 13.5617L15.3835 13.3669L14.5001 11.1357L13.6168 13.3669L11.3335 13.5617L13.0668 15.1555L12.5501 17.5107ZM14.5001 22.5044L12.2668 20.1669H9.1668V16.8732L6.9668 14.5003L9.1668 12.1273V8.83359H12.2668L14.5001 6.49609L16.7335 8.83359H19.8335V12.1273L22.0335 14.5003L19.8335 16.8732V20.1669H16.7335L14.5001 22.5044ZM14.5001 20.5211L16.1668 18.7503H18.5001V16.2711L20.1668 14.5003L18.5001 12.7294V10.2503H16.1668L14.5001 8.47943L12.8335 10.2503H10.5001V12.7294L8.83346 14.5003L10.5001 16.2711V18.7503H12.8335L14.5001 20.5211Z" fill="white"/>
</g>
</svg>
''';

    return GestureDetector(
      onTap: () => {Navigator.pushNamed(context, AppRoutes.warranty)},
      child: Container(
        padding: EdgeInsets.only(
            top: 14 * variablePixelHeight, bottom: 14 * variablePixelHeight),
        margin: EdgeInsets.only(
            left: 24 * variablePixelWidth,
            right: 24 * variablePixelWidth,
            top: 24 * variablePixelHeight,
            bottom: 24 * variablePixelHeight),
        width: double.infinity,
        // height: 56 * variablePixelHeight,
        decoration: ShapeDecoration(
          color: AppColors.lumiLight5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.string(
              svgString,
              width: 29 * fontMultiplier,
              height: 29 * fontMultiplier,
            ),
            const HorizontalSpace(width: 10),
            Text(
              translation(context).checkWarrantyStatus,
              style: GoogleFonts.poppins(
                  color: AppColors.lumiBluePrimary,
                  fontSize: 16 * fontMultiplier,
                  fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }
}
