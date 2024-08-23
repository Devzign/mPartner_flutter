import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/models/notification/notification_list_model.dart';
import '../../../../state/contoller/notification_controller.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../widgets/item_notification_widget.dart';
import '../widgets/no_more_notification_widget.dart';
import '../widgets/nothing_here_yet_widget.dart';
import 'notification_detail_webview.dart';

class PromotionalTab extends StatefulWidget {
  final bool isUpdatedSuccess;

  const PromotionalTab(this.isUpdatedSuccess, {super.key});

  @override
  State<PromotionalTab> createState() => _PromotionalTabState();
}

class _PromotionalTabState extends State<PromotionalTab>
    with AutomaticKeepAliveClientMixin {
  NotificationController notificationController = Get.find();
  bool isDataPresent = false;
  List<NotificationData> notificationsList = [];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    notificationController.promoNotificationsList.clear();
    fetchNotificationList();
  }

  fetchNotificationList() async {
    await notificationController.fetchPromoNotificationsList(
        notificationType: NotificationType.promotional.name);
    setState(() {
      notificationsList = notificationController.promoNotificationsList;
    });
    logger.d(
        "NOTI_D Promo Noti count: ${notificationController.promoNotificationsList.length}");
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    notificationController.currentTabIndex = 1;
    notificationsList = notificationController.promoNotificationsList;
    return Obx(() => Scaffold(
          backgroundColor: AppColors.white,
          body: notificationController.isPromoLoading.isTrue
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : (notificationsList.isEmpty
                  ? NothingHereYetWidget(
                      textForNothingHereYet: translation(context)
                          .updatesOnAllYourActivitiesWillAppearHere,
                    )
                  : ListView.builder(
                      itemCount: notificationsList.length + 1,
                      // +1 for the NoMoreNotificationWidget
                      itemBuilder: (context, index) {
                        if (index == notificationsList.length) {
                          return const NoMoreNotificationWidget();
                        } else {
                          return NotificationItemViewWidget(
                            isMessageRead: notificationsList[index].isRead,
                            notificationTime:
                                notificationsList[index].createdOn,
                            notificationPreview:
                                notificationsList[index].notificationMessage,
                            imgUrl: notificationsList[index].imagePath,
                            onPressed: () {
                              handleClickEvent(notificationsList[index]);
                              notificationController
                                  .promoNotificationsList[index].isRead = true;
                              setState(() {
                                notificationsList[index].isRead = true;
                              });
                            },
                          );
                        }
                      },
                    )),
        ));
  }

  Future<void> handleClickEvent(NotificationData notificationData) async {
    logger.i('Id ${notificationData.notificationId} pressed');
    logger.i('NOTI_D Navigation Route ${notificationData.navigationModule}');
    try {
      if (!notificationData.isRead) {
        logger.i('NOTI_D API Calling for mark is read...');
        await notificationController.updateNotificationAsRead(
            notificationId: notificationData.notificationId.toString() ?? "");
      }
    } catch (e) {
      e.printError();
    }
    navigateToScreen(notificationData);
  }

  void navigateToScreen(NotificationData notificationData) {
    logger.e("NOTI_D Navigation Route: ${notificationData.externalLink}");
    if (notificationData.notificationDetailBody.isNotEmpty ||
        notificationData.externalLink.isNotEmpty) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => NotificationWebViewDetails(
                  isRouteFormNotification: false,
                  notificationId: notificationData.notificationId.toString(),
                  notificationData: notificationData)));
    }
  }
}
