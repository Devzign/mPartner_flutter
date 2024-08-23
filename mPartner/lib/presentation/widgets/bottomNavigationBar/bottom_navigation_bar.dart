import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../solar/presentation/go_solar/go_solar_home.dart';
import '../../../state/contoller/app_setting_value_controller.dart';
import '../../../state/contoller/user_data_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/displaymethods/display_methods.dart';
import '../../screens/network_management/network_home_page.dart';
import '../../../utils/localdata/language_constants.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/ismart/ismart_homepage/ismart_homepage.dart';
import '../../screens/menu/menu_screen.dart';
import '../../screens/ismartdisclaimer/ismart_disclaimer_alert.dart';

class BottomNavigation extends StatefulWidget {
  final ValueChanged<int> onTabTapped;
  int currentIndex;
  bool show;

  BottomNavigation(
      {super.key, required this.onTabTapped,
      required this.currentIndex,
      this.show = true});

  @override
  _MyBottomNavigationState createState() => _MyBottomNavigationState();
}

class _MyBottomNavigationState extends State<BottomNavigation> {
  AppSettingValueController appSettingValueController = Get.find();
  void _onItemTapped(int index) {
    setState(() {
      widget.currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    UserDataController userDataController = Get.find();
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    return NotificationListener<ScrollEndNotification>(
      onNotification: (notification) {
        if (notification.metrics.pixels ==
            notification.metrics.maxScrollExtent) {
          setState(() {
            widget.show = true;
          });
        }
        return true;
      },
      child: SizedBox(
        height: widget.show ? 80 * variablePixelHeight : 0,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
          showUnselectedLabels: true,
          selectedItemColor: AppColors.lumiBluePrimary,
          unselectedItemColor: AppColors.grayText,
          currentIndex: widget.currentIndex,
          selectedLabelStyle: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          onTap: (index) {
            if (index != widget.currentIndex) {
              UserDataController userDataController = Get.find();
              if(appSettingValueController.solarviable=="1"){
                if (userDataController.isPrimaryNumberLogin) {
                  _onItemTapped(index);
                  switch (index) {
                    case 0:
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const HomeScreen()),
                            (route) => false,
                      );
                      break;
                    case 1:
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ISmartDisclaimerAlert(
                                screen: IsmartHomepage())),
                      );
                      break;
                    case 2:
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const GoSolarHome()),
                      );
                      break;
                    case 3:
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const NetworkHomePage()),
                      );
                      break;
                    case 4:
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const Menu()),
                      );
                      break;
                  }
                }
                else {
                  _onItemTapped(index);

                  switch (index) {
                    case 0:
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const HomeScreen()),
                      );
                      break;
                    case 1:
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ISmartDisclaimerAlert(
                                screen: IsmartHomepage())),
                      );
                      break;
                    case 2:
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => const GoSolarHome()));
                      break;
                    case 3:
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const NetworkHomePage()),
                      );
                      break;
                    case 4:
                      print('menu item is at index: $index');
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const Menu()),
                      );
                      break;
                  }
                }
              }else{
                if (userDataController.isPrimaryNumberLogin) {
                  _onItemTapped(index);
                  switch (index) {
                    case 0:
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const HomeScreen()),
                            (route) => false,
                      );
                      break;
                    case 1:
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ISmartDisclaimerAlert(
                                screen: IsmartHomepage())),
                      );
                      break;

                    case 2:
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const NetworkHomePage()),
                      );
                      break;
                    case 3:
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const Menu()),
                      );
                      break;
                  }
                }
                else {
                  _onItemTapped(index);

                  switch (index) {
                    case 0:
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const HomeScreen()),
                      );
                      break;
                    case 1:
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ISmartDisclaimerAlert(
                                screen: IsmartHomepage())),
                      );
                      break;

                    case 2:
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const NetworkHomePage()),
                      );
                      break;
                    case 3:
                      print('menu item is at index: $index');
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const Menu()),
                      );
                      break;
                  }
                }
              }


            }
          },
          items:appSettingValueController.solarviable=="1"?
          [

            _buildBottomNavigationBarItem(
                Icons.home_outlined, translation(context).home, 0),
            _buildBottomNavigationBarItem(
                Icons.redeem, translation(context).iSmart, 1),
            _buildBottomNavigationBarItem(
                Icons.solar_power_outlined, translation(context).solutions, 2),
            _buildBottomNavigationBarItem(Icons.manage_accounts_outlined,
                translation(context).network, 3),
            _buildBottomNavigationBarItem(
                Icons.segment_outlined, translation(context).menu, 4),
          ]:  [

            _buildBottomNavigationBarItem(
                Icons.home_outlined, translation(context).home, 0),
            _buildBottomNavigationBarItem(
                Icons.redeem, translation(context).iSmart, 1),
            _buildBottomNavigationBarItem(Icons.manage_accounts_outlined,
                translation(context).network, 2),
            _buildBottomNavigationBarItem(
                Icons.segment_outlined, translation(context).menu, 3),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(
      IconData icon, String label, int index) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    bool isSelected = index == widget.currentIndex;
    return BottomNavigationBarItem(
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10),
          color: isSelected ? AppColors.lightBlue : Colors.transparent,
        ),
        child: Icon(
          icon,
          color: isSelected ? AppColors.lumiBluePrimary : Colors.grey,
        ),
      ),
      label: label,
    );
  }
}
