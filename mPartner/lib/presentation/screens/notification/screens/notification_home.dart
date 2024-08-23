import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/localdata/language_constants.dart';
import '../../../../data/models/notification/notification_list_model.dart';
import '../../../../state/contoller/notification_controller.dart';
import '../../../../state/contoller/user_data_controller.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/displaymethods/display_methods.dart';
import '../../../widgets/common_bottom_sheet.dart';
import '../../../widgets/headers/notification_header_widget.dart';
import '../../../widgets/tab_widget.dart';
import '../../userprofile/user_profile_widget.dart';
import '../widgets/notification_clear_alert_bottom_sheet.dart';
import 'my_activity_tab.dart';
import 'promotional_notification_tab.dart';

List<TabData> tabs = [];

class NotificationHome extends StatefulWidget {
  const NotificationHome({
    super.key,
    this.initialIndex = 0,
  });

  final int initialIndex;

  @override
  State<NotificationHome> createState() => _NotificationHomeState();
}

class _NotificationHomeState extends State<NotificationHome> {
  UserDataController userDataController = Get.find();
  NotificationController notificationController = Get.find();
  var isUpdatedSuccess = false;

  tabsData(context) => [
        TabData(
            translation(context).myActivity, MyActivityTab(isUpdatedSuccess)),
        TabData(
            translation(context).promotional, PromotionalTab(isUpdatedSuccess)),
      ];

  @override
  Widget build(BuildContext context) {
    tabs = tabsData(context);
    double variableTextMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const HeadingNotificationWidget(isDynamic: false),
        backgroundColor: AppColors.white,
        leadingWidth: 0,
        automaticallyImplyLeading: false,
        actions: [
          PopupMenuButton<int>(
            padding: EdgeInsets.fromLTRB(
                16.0 * variablePixelWidth,
                24.0 * variablePixelHeight,
                16.0 * variablePixelWidth,
                0.0 * variablePixelHeight),
            surfaceTintColor: AppColors.white,
            shadowColor: AppColors.lumiBluePrimary,
            itemBuilder: (context) => [
              PopupMenuItem(
                padding: EdgeInsets.only(
                    left: 12 * variablePixelWidth,
                    bottom: 5 * variablePixelHeight,
                    right: 8 * variablePixelWidth,
                    top: 5 * variablePixelHeight),
                value: AppConstants.clearAll,
                height: 36 * variablePixelHeight,
                child: Row(
                  children: [
                    Text("Clear All",
                        style: GoogleFonts.poppins(
                          color: AppColors.black,
                          fontSize: 14 * variableTextMultiplier,
                          fontWeight: FontWeight.w500,
                        ))
                  ],
                ),
              ),
              // popupmenu item 2
              PopupMenuItem(
                padding: EdgeInsets.only(
                    left: 12 * variablePixelWidth,
                    bottom: 5 * variablePixelHeight,
                    right: 8 * variablePixelWidth),
                value: AppConstants.clearRead,
                height: 36 * variablePixelHeight,
                child: Row(
                  children: [
                    Text("Clear Read",
                        style: GoogleFonts.poppins(
                          color: AppColors.black,
                          fontSize: 14 * variableTextMultiplier,
                          fontWeight: FontWeight.w500,
                        ))
                  ],
                ),
              ),
              PopupMenuItem(
                padding: EdgeInsets.only(
                    left: 12 * variablePixelWidth,
                    bottom: 5 * variablePixelHeight,
                    right: 8 * variablePixelWidth),
                height: 36 * variablePixelHeight,
                value: AppConstants.clearUnread,
                // row has two child icon and text
                child: Row(
                  children: [
                    Text("Clear Unread",
                        style: GoogleFonts.poppins(
                          color: AppColors.black,
                          fontSize: 14 * variableTextMultiplier,
                          fontWeight: FontWeight.w500,
                        ))
                  ],
                ),
              ),
            ],
            offset: const Offset(-30, 15),
            color: AppColors.white,
            elevation: 3,
            onSelected: (value) {
              if (value == AppConstants.clearAll) {
                _showAlertDialog(context, variablePixelHeight,
                    variablePixelWidth, AppConstants.clearAll);
              } else if (value == AppConstants.clearRead) {
                _showAlertDialog(context, variablePixelHeight,
                    variablePixelWidth, AppConstants.clearRead);
              } else if (value == AppConstants.clearUnread) {
                _showAlertDialog(context, variablePixelHeight,
                    variablePixelWidth, AppConstants.clearUnread);
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserProfileWidget(top: 18 * variablePixelHeight),
              userDataController.isPrimaryNumberLogin == false
                  ? Expanded(child: PromotionalTab(isUpdatedSuccess))
                  : TabWidget(
                      initialIndex: widget.initialIndex,
                      tabs: tabs,
                    ),
            ]),
      ),
    );
  }

  void _showAlertDialog(BuildContext context, double variablePixelHeight,
      double variablePixelWidth, int value) {
    var tabType = "";
    if (notificationController.currentTabIndex == 0) {
      tabType = translation(context).myActivity;
    } else {
      tabType = translation(context).promotional;
    }
    var typeValue = "";
    if (value == AppConstants.clearAll) {
      typeValue = "Clear All";
    } else if (value == AppConstants.clearRead) {
      typeValue = "Clear Read";
    } else if (value == AppConstants.clearUnread) {
      typeValue = "Clear Unread";
    }
    CommonBottomSheet.show(
        context,
        NotificationClearAlertSheetWidget(
          onItemSelected: (selectedState) async {
            Navigator.of(context).pop();
            if (selectedState == "yes") {
              await notificationController.clearNotification(
                  notificationDeleteType: value,
                  isPromotional: tabType == translation(context).promotional
                      ? true
                      : false);
              setState(() {
                notificationController.isLoading.value = true;
              });
              if (!(tabType == translation(context).promotional)) {
                await notificationController.fetchNotificationsList(
                    notificationType: "MyActivity");
              } else {
                await notificationController.fetchPromoNotificationsList(
                    notificationType: NotificationType.promotional.name);
              }
              setState(() {
                notificationController.isLoading.value = false;
              });
            }
          },
          contentTitle:
              "Are you sure you want to ${typeValue.toLowerCase()} '$tabType' notifications?",
          message: "Notifications once deleted cannot be retrieved again !",
        ),
        variablePixelHeight,
        variablePixelWidth);
  }
}
