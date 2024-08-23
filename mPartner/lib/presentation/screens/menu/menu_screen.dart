import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../utils/displaymethods/display_methods.dart';
import '../../../state/contoller/app_setting_value_controller.dart';
import '../../../state/contoller/user_data_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/localdata/language_constants.dart';
import '../../../utils/routes/app_routes.dart';
import '../../screens/report_management/screens/select_report_type.dart';
import '../../widgets/CommonCards/menu_grid_Item_card.dart';
import '../../widgets/bottomNavigationBar/bottom_navigation_bar.dart';
import '../../widgets/headers/ismart_header_widget.dart';
import '../../widgets/verticalspace/vertical_space.dart';
import '../base_screen.dart';
import '../battery_management/battery_management.dart';
import '../consumeremi/consumer_emi.dart';
import '../our_products/our_products_screen.dart';
import '../userprofile/user_profile_widget.dart';
import 'components/create_advertisemet_menu_widget.dart';
import 'luminous_videos/luminous_videos.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends BaseScreenState<Menu> {
  AppSettingValueController appSettingValueController = Get.find();
  @override
  Widget baseBody(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        Navigator.pushNamed(context, AppRoutes.homepage);
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(children: [
            Padding(
              padding: EdgeInsets.fromLTRB(24 * w, 24 * h, 24 * w, 0),
              child: ISmartHeaderWidget(title: translation(context).menu),
            ),
            UserProfileWidget(top: 24 * h),
            Expanded(
              child: Container(
                padding: EdgeInsets.fromLTRB(24 * w, 8 * h, 24 * w, 0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      MenuGridVIew(w: w, h: h),
                      const VerticalSpace(height: 16),
                      const PlaceholderFetchImage(),
                      const VerticalSpace(height: 16),
                      const CallForAdvertisement(),
                      const VerticalSpace(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ]),
        ),

        bottomNavigationBar: BottomNavigation(
          currentIndex:appSettingValueController.solarviable=="1"? 4:3,
          onTabTapped: (value) =>appSettingValueController.solarviable=="1"? 4:3,
        ),
      ),
    );
  }
}

class MenuGridVIew extends StatelessWidget {
  MenuGridVIew({
    super.key,
    required this.w,
    required this.h,
  });

  final double w;
  final double h;

  UserDataController userDataController = Get.find();

  @override
  Widget build(BuildContext context) {
    double f = DisplayMethods(context: context).getTextFontMultiplier();
    List<Widget> menuItems = [
      MenuGridItemContainer(
        text: translation(context).ourProductsWithLineBreak,
        myIcon: iconContainer(
            myIcon: SvgPicture.asset('assets/mpartner/category.svg')),
        route: const Product(),
      ),
      // MenuGridItemContainer(
      //     text: translation(context).serviceEscalationWithLineBreak,
      //     myIcon: iconContainer(
      //       myIcon: SvgPicture.asset(
      //         'assets/mpartner/Products_assets/Service.svg',
      //       ),
      //     ),
      //     route: UpcomingFeatureScreen()),
      MenuGridItemContainer(
          text: translation(context).reportManagementWithLineBreak,
          myIcon: iconContainer(
              myIcon: SvgPicture.asset('assets/mpartner/assignment.svg')),
          route: SelectReportTypeWidget()),
      MenuGridItemContainer(
          text: translation(context).batteryManagementWithLineBreak,
          myIcon: iconContainer(
            myIcon: SvgPicture.asset(
              'assets/mpartner/Products_assets/RULES.svg',
            ),
          ),
          route: const BatteryManagement()),
      MenuGridItemContainer(
          text: translation(context).consumerEmiWithLineBreak,
          myIcon: iconContainer(
            myIcon: SvgPicture.asset(
              'assets/mpartner/Products_assets/EMI.svg',
            ),
          ),
          route: const ConsumerEmi()),
      MenuGridItemContainer(
          text: translation(context).luminousYoutubeWithLineBreak,
          myIcon: iconContainer(
              myIcon: SvgPicture.asset('assets/mpartner/play_circle.svg')),
          route: LuminousVideos()),
      // MenuGridItemContainer(
      //     text: "LMS",
      //     myIcon: iconContainer(
      //         myIcon: SvgPicture.asset('assets/mpartner/play_circle.svg')),
      //     route: TrainingCourseList()),
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(0),
      primary: false,
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16 * w,
        mainAxisSpacing: 16 * h,
        mainAxisExtent: 95 * h + 40 * f,
      ),
      itemCount: menuItems.length,
      itemBuilder: (context, index) {
        return menuItems[index];
      },
    );
  }
}

class PlaceholderFetchImage extends StatelessWidget {
  const PlaceholderFetchImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    return Container(
      height: 166 * h,
      decoration: ShapeDecoration(
        image: DecorationImage(
          image: Image.asset('assets/mpartner/menu.png').image,
          fit: BoxFit.cover,
        ),
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1 * w, color: AppColors.lightGrey1),
          borderRadius: BorderRadius.circular(12 * w),
        ),
      ),
    );
  }
}
