import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../utils/app_colors.dart';
import 'clock_widget.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/displaymethods/display_methods.dart';
import '../../../utils/routes/app_routes.dart';
import '../../../data/models/user_profile_model.dart';
import '../../widgets/horizontalspace/horizontal_space.dart';
import '../../../state/contoller/user_data_controller.dart';
import '../../widgets/verticalspace/vertical_space.dart';

class UserProfileWidget extends StatefulWidget {
  double top, bottom, horizontalPadding;
  UserProfileWidget(
      {super.key,
      this.top = 8.0,
      this.bottom = 24.0,
      this.horizontalPadding = 24});

  @override
  State<UserProfileWidget> createState() => _UserProfileWidgetState();
}

class _UserProfileWidgetState extends State<UserProfileWidget> {
  bool bottomSheetShown = false;
  bool isButtonEnabled = false;
  List<UserProfile> userProfileData = [];
  UserDataController controller = Get.find();

  @override
  void initState() {
    fetchUserDataFromSharedPref();
    super.initState();
  }

  Future<void> fetchUserDataFromSharedPref() async {
    userProfileData = controller.userProfile;
    controller.profileImg.value = userProfileData[0].profileImg;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    double variablePixelHeight = DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth = DisplayMethods(context: context).getVariablePixelWidth();
    double fontMultiplier = DisplayMethods(context: context).getTextFontMultiplier();
    double pixelMultiplier = DisplayMethods(context: context).getPixelMultiplier();

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.userprofile);
      },
      child: Container(
        color: AppColors.white,
        padding: EdgeInsets.fromLTRB(widget.horizontalPadding * variablePixelWidth, widget.top * variablePixelHeight, widget.horizontalPadding * variablePixelWidth, widget.bottom * variablePixelHeight),
        child: Row(
          children: [
            Obx(() => CircleAvatar(
              backgroundColor: AppColors.backgroundColor,
              radius: 20.0 * pixelMultiplier,
              child: controller.profileImg.value.isNotEmpty ? CachedNetworkImage(
                imageUrl: controller.profileImg.value,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
                placeholder: (context, url) => const CircularProgressIndicator(),
                errorWidget: (context, url, error) => Image.asset('assets/mpartner/Profile_placeholder.png'),
              ): CircleAvatar(
                backgroundColor: AppColors.backgroundColor,
                radius: 20.0 * pixelMultiplier,
                child: Image.asset('assets/mpartner/Profile_placeholder.png'),
              ),
            )),
            const HorizontalSpace(width: 8),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userProfileData.isNotEmpty
                            ? userProfileData[0].sap_Code
                            : '',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: AppColors.darkGreyText,
                          fontSize: 16 * fontMultiplier,
                          fontWeight: FontWeight.w600,
                          height: 0,
                          letterSpacing: 0.10 * variablePixelWidth,
                        ),
                      ),
                      Text(
                        userProfileData.isNotEmpty
                            ? userProfileData[0].name
                            : '',
                        style: TextStyle(
                          color: AppColors.lumiDarkBlack,
                          fontSize: 12 * fontMultiplier,
                          fontWeight: FontWeight.w400,
                          height: 0,
                          letterSpacing: 0.10 * variablePixelWidth,
                        ),
                      )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        DateFormat('MMM dd, yyyy').format(DateTime.now()),
                        style: GoogleFonts.poppins(
                          color: AppColors.darkGreyText,
                          fontSize: 12 * pixelMultiplier,
                          fontWeight: FontWeight.w500,
                          height: 0,
                          letterSpacing: 0.10 * variablePixelWidth,
                        ),
                      ),
                      const VerticalSpace(height: 2),
                      ClockWidget()
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
