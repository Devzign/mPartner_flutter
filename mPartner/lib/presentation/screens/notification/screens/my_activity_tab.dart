import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/models/notification/notification_list_model.dart';
import '../../../../gem/presentation/gem_maf/maf_listinghome_page.dart';
import '../../../../gem/presentation/gem_support_auth/get_auth_search/gem_auth_search.dart';
import '../../../../solar/presentation/project_execution/common/common_project_view/common_project_view_tab.dart';
import '../../../../solar/presentation/solar_design/existing_leads/detailed_tab_view.dart';
import '../../../../solar/presentation/solar_finance/existing_leads/project_details_page.dart';
import '../../../../solar/utils/solar_app_constants.dart';
import '../../../../state/contoller/notification_controller.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/app_string.dart';
import '../../../../utils/enums.dart';
import '../../../../utils/fcm/notification_route.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../../home/home_screen.dart';
import '../../ismart/cash_coins_history/cash_coin_history_screen.dart';
import '../../ismart/cash_coins_history/credit_txn_notification_detail_screen.dart';
import '../../ismart/cash_coins_history/debit_txn_notification_detail_screen.dart';
import '../../ismart/ismart_homepage/ismart_homepage.dart';
import '../../ismart/redeem_coins_to_trips/tabBooked/booked_trip_details.dart';
import '../../network_management/dealer_electrician/components/common_network_utils.dart';
import '../../network_management/dealer_electrician/dealer_electrician_details.dart';
import '../../network_management/dealer_electrician/new_dealer_electrician_status_screen.dart';
import '../../network_management/network_home_page.dart';
import '../../our_products/our_products_screen.dart';
import '../../userprofile/user_profile.dart';
import '../widgets/item_notification_widget.dart';
import '../widgets/no_more_notification_widget.dart';
import '../widgets/nothing_here_yet_widget.dart';

class MyActivityTab extends StatefulWidget {
  final bool isUpdatedSuccess;

  const MyActivityTab(this.isUpdatedSuccess, {super.key});

  @override
  State<MyActivityTab> createState() => _MyActivityTabState();
}

class _MyActivityTabState extends State<MyActivityTab>
    with AutomaticKeepAliveClientMixin {
  NotificationController notificationController = Get.find();
  bool isDataPresent = false;
  List<NotificationData> notificationsList = [];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    notificationController.notificationsList.clear();
    fetchNotificationList();
  }

  fetchNotificationList() async {
    await notificationController.fetchNotificationsList(
        notificationType: "MyActivity");
    logger
        .d("MyActivity Noti. res: ${notificationController.notificationsList}");
    setState(() {
      notificationsList = notificationController.notificationsList;
    });
    logger.d(
        "Total My Activity Record: ${notificationController.notificationsList.length}");
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    notificationController.currentTabIndex = 0;
    notificationsList = notificationController.notificationsList;
    return Obx(() => Scaffold(
          backgroundColor: AppColors.white,
          body: notificationController.isLoading.isTrue
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
                                  .notificationsList[index].isRead = true;
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
    try {
      if (!notificationData.isRead) {
        logger.i('NOTI_D API Calling for mark is read...');
        await notificationController.updateNotificationAsRead(
            notificationId: notificationData.notificationId.toString() ?? "");
      }
    } catch (e) {
      e.printError();
    }
    // notificationController.isLoading.value=false;
    String? route = notificationData.navigationModule ?? "";
    String? notificationText = notificationData.notificationMessage ?? "";
    navigateToScreen(route, notificationText, notificationData);
  }

  void navigateToScreen(String route, String notificationText,
      NotificationData notificationData) {
    logger.e("RA_NOTI_Route is:::> (=) $route");
    logger.d("[RA_LOG] : notificationText: $notificationText");
    logger.e("NOTI_D transactionType: ${notificationData.transactionType}");

    if (route == NotificationRoute.homeScreen.name) {
      logger.i(
          "RA Notification[Help&Support] route is: HomeScreen::> (=) $route");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    } else if (route == NotificationRoute.secondaryDeviceScreen.name) {
      ProfileBottomSheetType profileBottomSheetType =
          ProfileBottomSheetType.none;
      if (notificationText.toString().toLowerCase().contains('device 1')) {
        profileBottomSheetType = ProfileBottomSheetType.secondaryDevice1;
      } else if (notificationText
          .toString()
          .toLowerCase()
          .contains('device 2')) {
        profileBottomSheetType = ProfileBottomSheetType.secondaryDevice2;
      }
      logger.i(
          "RA Notification[Secondary] route is: UserProfileScreen::> (=) $route");
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => UserProfileScreen(
                  showBottomSheet: true, type: profileBottomSheetType)));
    } else if (route == NotificationRoute.profileDocScreen.name) {
      ProfileBottomSheetType profileBottomSheetType =
          ProfileBottomSheetType.none;
      if (notificationText.toString().toLowerCase().contains('pan')) {
        profileBottomSheetType = ProfileBottomSheetType.pan;
      }
      logger.i(
          "RA Notification[Secondary] route is: UserProfileScreen::> (=) $route");
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => UserProfileScreen(
                  showBottomSheet: true, type: profileBottomSheetType)));
    } else if (route == NotificationRoute.saleCashTxnDetailScreen.name) {
      if (notificationData.transactionId.isEmpty ||
          notificationData.transactionType.isEmpty) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const CashCoinHistoryScreen(
                    cardType: FilterCashCoin.cashType)));
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CreditCoinCashDetailedScreen(
                      txnId: notificationData.transactionId,
                      txnType: notificationData.transactionType,
                      cashOrCoinHistory: "Cash",
                    )));
      }
    } else if (route == NotificationRoute.saleCoinTxnDetailScreen.name) {
      if (notificationData.transactionId.isEmpty ||
          notificationData.transactionType.isEmpty) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const CashCoinHistoryScreen(
                    cardType: FilterCashCoin.coinType)));
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CreditCoinCashDetailedScreen(
                      txnId: notificationData.transactionId,
                      txnType: notificationData.transactionType,
                      cashOrCoinHistory: "Coin",
                    )));
      }
    } else if (route == NotificationRoute.txnDetailScreen.name) {
      if (notificationData.transactionId.isEmpty ||
          notificationData.transactionType.isEmpty) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const CashCoinHistoryScreen(
                    cardType: FilterCashCoin.cashType)));
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DebitCoinCashDetailedNotification(
                      txnId: notificationData.transactionId,
                      txnType: notificationData.transactionType,
                      cashOrCoinHistory: "Cash",
                    )));
      }
    } else if (route == NotificationRoute.cashHistoryScreen.name) {
      logger.i("NOTI_D cashHistoryScreen: (=) $route");
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const CashCoinHistoryScreen(
                  cardType: FilterCashCoin.cashType)));
    } else if (route == NotificationRoute.coinsHistoryScreen.name) {
      logger.i("NOTI_D coinsHistoryScreen: (=) $route");
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const CashCoinHistoryScreen(
                  cardType: FilterCashCoin.coinType)));
    } else if (route == NotificationRoute.bookedTripScreen.name) {
      try {
        int tripID = int.parse(notificationData.transactionId);
        logger.e("NOTI_D bookedTripScreen: (=) $route");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BookedTripDetails(
                      tripID: tripID,
                    )));
      } catch (error) {
        logger.e(
            "Failed to parse trip ID ${notificationData.transactionId} by $error");
      }
    } else if (route.toLowerCase() ==
        NotificationRoute.solarDesignDetailScreen.name.toLowerCase()) {
      logger.i("NOTI_D solarDesignDetailScreen: (=) $route");

      String text = notificationData.notificationText.toString();
      bool isDigital = text.toLowerCase().contains('digital');
      bool isCategoryComm = text.toLowerCase().contains('commercial');
      String projectId =
          text.substring(text.indexOf('#') + 1, text.indexOf('#') + 1 + 14);

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailedTabView(
                    projectId: projectId,
                    categoryId: isCategoryComm
                        ? SolarAppConstants.commercialCategory
                        : SolarAppConstants.residentialCategory,
                    isDigOrPhy: isDigital,
                    isNavigatedFrom:
                        SolarAppConstants.fromNotificationActiveTab,
                  )));
    } else if (route.toLowerCase() ==
        NotificationRoute.solarFinancingDetailScreen.name.toLowerCase()) {
      String text = notificationData.notificationText.toString();
      bool isResidential = text.toLowerCase().contains('residential');
      bool isCommercial = text.toLowerCase().contains('commercial');
      String projectId =
          text.substring(text.indexOf('#') + 1, text.indexOf('#') + 1 + 14);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ProjectDetailsPage(
              isResidential: isResidential,
              isCommercial: isCommercial,
              projectId: projectId)));
    } else if (route.toLowerCase() ==
            NotificationRoute.solarOnlineDetailScreen.name.toLowerCase() ||
        route.toLowerCase() ==
            NotificationRoute.solarOnsiteDetailScreen.name.toLowerCase() ||
        route.toLowerCase() ==
            NotificationRoute.solarETEDDetailScreen.name.toLowerCase()) {
      logger.i("NOTI_D ${route.toLowerCase()} : (=) $route");

      String text = notificationData.notificationText.toString();
      String typeValue = "";
      if (route.toLowerCase() ==
          NotificationRoute.solarOnlineDetailScreen.name.toLowerCase()) {
        typeValue = SolarAppConstants.online;
      } else if (route.toLowerCase() ==
          NotificationRoute.solarOnsiteDetailScreen.name.toLowerCase()) {
        typeValue = SolarAppConstants.onsite;
      } else {
        typeValue = SolarAppConstants.endToEnd;
      }
      String projectId =
          text.substring(text.indexOf('#') + 1, text.indexOf('#') + 1 + 14);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CommonProjectDetailTabView(
                  projectId: projectId,
                  typeValue: typeValue,
                  isFrom: SolarAppConstants.fromNotificationActiveTab)));
    } else if (route == NotificationRoute.networkmgntScreen.name) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const NetworkHomePage()));
    } else if (route == NotificationRoute.dealerStatusScreen.name) {
      logger.i("RA Notification route is: Dealer Status Screen::> (=) $route");
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const NewDealerElectricianStatusScreen(
                  selectedUserType: UserType.dealer)));
    } else if (route == NotificationRoute.electricianStatusScreen.name) {
      logger.i(
          "RA Notification route is: electrician Status Screen::> (=) $route");
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const NewDealerElectricianStatusScreen(
                  selectedUserType: UserType.electrician)));
    } else if (route == NotificationRoute.dealerDetailsScreen.name) {
      logger.i(
          "RA Notification route is: dealer Block redemption Screen::> (=) $route");
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => DealerElectricianDetails(
                  selectedUserType: UserType.dealer,
                  id: notificationData.dealerElectricianCode)));
    } else if (route == NotificationRoute.electricianDetailsScreen.name) {
      logger.i(
          "RA Notification route is: dealer Block redemption Screen::> (=) $route");
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => DealerElectricianDetails(
                  selectedUserType: UserType.electrician,
                  id: notificationData.dealerElectricianCode)));
    } else if (route == NotificationRoute.iSmartHomeScreen.name) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const IsmartHomepage()));
    } else if (route == NotificationRoute.viewProductCatalogueScreen.name) {
      logger.i("viewProductCatalogueScreen: (=) $route");
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => Product(initialIndex: 0)));
    } else if (route == NotificationRoute.viewPriceListScreen.name) {
      logger.i("viewPriceListScreen: (=) $route");
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => Product(initialIndex: 1)));
    } else if (route == NotificationRoute.viewSchemeScreen.name) {
      logger.i("viewSchemeScreen: (=) $route");
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => Product(initialIndex: 2)));
    }

    else if (route == NotificationRoute.MAFRoute.name) {
      logger.i("viewGemMafListingScreen: (=) $route");
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => GemListingHomePage( status: "",
            bidstatus: "",)));
    }

    else if (route == NotificationRoute.ACRoute.name) {
      logger.i("viewGemAuthSearchScreen: (=) $route");
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => GemAuthSearch(Status: '')));
    }

    else {
      logger.i("NOTI_D Default should be HomeScreen: (=) $route");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    }
  }
}
