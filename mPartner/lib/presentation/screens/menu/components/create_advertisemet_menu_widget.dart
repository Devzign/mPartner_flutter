import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../../../utils/routes/app_routes.dart';
import '../../../widgets/CommonCards/menu_grid_Item_card.dart';
import '../../../widgets/horizontalspace/horizontal_space.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
class CallForAdvertisement extends StatelessWidget {
  const CallForAdvertisement({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();

    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(AppRoutes.createAdvertisement);
      },
      child: Container(
        height: 72 * h,
        padding: EdgeInsets.all(16 * r),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: AppColors.lightGrey2),
            borderRadius: BorderRadius.circular(12 * r),
          ),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          iconContainer(myIcon: SvgPicture.asset('assets/mpartner/post_add.svg')),
          // iconContainer(myIcon: myIcon)
          const HorizontalSpace(width: 16),
          Text(
            translation(context).createYourAdvertisement,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: AppColors.darkText2,
              fontSize: 14 * f,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.50 * w,
            ),
          )
        ]),
      ),
    );
  }
}
