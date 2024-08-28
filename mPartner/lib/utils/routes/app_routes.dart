import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../presentation/screens/consumeremi/consumer_emi.dart';
import '../../../presentation/screens/language/select_language.dart';
import '../../../presentation/screens/login/login_screen.dart';
import '../../../presentation/screens/our_products/our_products_screen.dart';
import '../../../presentation/screens/redeemcash/redeem_cash_home.dart';
import '../../../presentation/screens/splash/splash_screen.dart';
import '../../gem/presentation/gem_maf/gem_maf_homepage.dart';
import '../../gem/presentation/gem_maf/maf_registration.dart';
import '../../gem/presentation/gem_support_auth/gem_bid_details/gem_bid_details.dart';
import '../../gem/presentation/gem_support_auth/get_auth_search/gem_auth_search.dart';
import '../../gem/presentation/gem_tender/gem_support_category.dart';
import '../../gem/presentation/gem_tender/gem_tender_category_details.dart';
import '../../gem/presentation/gem_tender/gem_tender_home.dart';
import '../../presentation/screens/advertisement/create_ad_screen.dart';
import '../../presentation/screens/battery_management/battery_management.dart';
import '../../presentation/screens/cashredemption/paytm/enter_mobile_screen_paytm.dart';
import '../../presentation/screens/cashredemption/pinelab/pinelab_redemption.dart';
import '../../presentation/screens/cashredemption/upi/enter_upi_id_screen.dart';
import '../../presentation/screens/cashredemption/upi/enter_upi_screen.dart';
import '../../presentation/screens/help_and_support/help_and_support.dart';
import '../../presentation/screens/help_and_support/preview_screen.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/ismart/cash_coins_history/cash_coin_history_screen.dart';
import '../../presentation/screens/ismart/ismart_homepage/ismart_homepage.dart';
import '../../presentation/screens/ismart/redeem_coins_Cashback/redeem_coins_to_cashback.dart';
import '../../presentation/screens/ismart/redeem_coins_to_trips/redeem_coins_to_trips.dart';
import '../../presentation/screens/ismart/registersales/intermediary_sales/intermediary_sales.dart';
import '../../presentation/screens/ismart/registersales/register_sales.dart';
import '../../presentation/screens/ismart/registersales/secondarysales/secondary_sales.dart';
import '../../presentation/screens/ismartdisclaimer/ismart_disclaimer_alert.dart';
import '../../presentation/screens/menu/luminous_videos/luminous_videos.dart';
import '../../presentation/screens/menu/menu_screen.dart';
import '../../presentation/screens/network_management/network_home_page.dart';
import '../../presentation/screens/notification/screens/notification_home.dart';
import '../../presentation/screens/omni_search/omni_search.dart';
import '../../presentation/screens/redeemcoins/redeem_coins.dart';
import '../../presentation/screens/report_management/screens/primary_report/primary_report_screen.dart';
import '../../presentation/screens/report_management/screens/secondary_report/dealer/secondary_report_dealer_screen.dart';
import '../../presentation/screens/report_management/screens/secondary_report/distributor/secondary_report_disty_screen.dart';
import '../../presentation/screens/report_management/screens/select_report_type.dart';
import '../../presentation/screens/report_management/screens/tertiary_report/tertiary_report_screen.dart';
import '../../presentation/screens/tertiary_sales/tertiary_sales.dart';
import '../../presentation/screens/tertiary_sales/tertiary_sales_hkva_combo/register_sale_combo.dart';
import '../../presentation/screens/userprofile/user_profile.dart';
import '../../presentation/screens/warranty/warranty.dart';
import '../../presentation/screens/welcome/welcome_screen.dart';
import '../../solar/presentation/go_solar/go_solar_home.dart';
import '../../solar/presentation/project_execution/common/common_dashboard/common_dashboard.dart';
import '../../solar/presentation/project_execution/project_execution_home_page.dart';
import '../../solar/presentation/solar_design/digital_survey_dashboard.dart';
import '../../solar/presentation/solar_design/solar_design.dart';
import '../../solar/presentation/solar_finance/solar_finance_dashboard.dart';
import '../../solar/utils/solar_app_constants.dart';
import '../localdata/language_constants.dart';
import '../app_string.dart';

class AppRoutes {
  static const String _roleDisty = "DISTY";
  static const String _roleDealer = "DEALER";
  static const String _roleElectrician = "ELECTRICIAN";

  static const _products = AppRoutesMap(
    '/products',
    'Products',
    'Products Screen',
    '<Description Not Yet>',
    [_roleDisty, _roleDealer, _roleElectrician],
    true,
  );

  static const _ismartpage = AppRoutesMap(
    '/ismart/ismartHomepage',
    'i-SMaRT',
    'i-SMaRT',
    '<Description Not Yet>',
    [_roleDisty, _roleDealer, _roleElectrician],
    true,
  );

  static const _ismartpage_1 = AppRoutesMap(
    '/ismart/ismartHomepage',
    'i-SMaRT',
    'iSMaRT',
    '<Description Not Yet>',
    [_roleDisty, _roleDealer, _roleElectrician],
    true,
  );

  static const _notificationHome = AppRoutesMap(
    '/notificationHome',
    'Notifications',
    'Notifications',
    '<Description Not Yet>',
    [_roleDisty, _roleDealer, _roleElectrician],
    true,
  );

  static const _coinToTripPage = AppRoutesMap(
    '/coinsToTrips',
    'i-SMaRT',
    'Coins To Trips',
    '<Description Not Yet>',
    [_roleDealer],
    false,
  );

  static const _cashDetailedHistory = AppRoutesMap(
    '/cashDetailedHistory',
    'i-SMaRT',
    'Cash Summary',
    '<Description Not Yet>',
    [_roleDisty, _roleDealer, _roleElectrician],
    false,
  );

  static const _coinDetailedHistory = AppRoutesMap(
    '/coinDetailedHistory',
    'i-SMaRT',
    'Coin Summary',
    '<Description Not Yet>',
    [_roleDealer],
    false,
  );

  static const _redeemCash = AppRoutesMap(
    '/redeemCashHome',
    'i-SMaRT',
    'Redeem Cash',
    '<Description Not Yet>',
    [_roleDisty, _roleDealer, _roleElectrician],
    false,
  );

  static const _userprofile = AppRoutesMap(
    '/userProfile',
    'User',
    'User Profile Screen',
    '<Description Not Yet>',
    [_roleDisty, _roleDealer, _roleElectrician],
    true,
  );

  static const _homepage = AppRoutesMap(
    '/homepage',
    'Home',
    'Home Screen',
    '<Description Not Yet>',
    [_roleDisty, _roleDealer, _roleElectrician],
    true,
  );

  static const _registerSales = AppRoutesMap(
    '/registerSales',
    'Register Sales',
    'Register Sales',
    '<Description Not Yet>',
    [_roleDisty, _roleDealer, _roleElectrician],
    true,
  );

  static const _tertiarySales = AppRoutesMap(
    '/tertiarySales',
    'Register Sales',
    'Tertiary Sales',
    '<Description Not Yet>',
    [_roleDisty, _roleDealer, _roleElectrician],
    true,
  );

  static const _secondarySales = AppRoutesMap(
    '/secondarySales',
    'Register Sales',
    'Secondary Sales',
    '<Description Not Yet>',
    [_roleDisty],
    true,
  );

  static const _intermediarySales = AppRoutesMap(
    '/intermediarySales',
    'Register Sales',
    'Intermediary Sales',
    '<Description Not Yet>',
    [_roleDisty, _roleDealer],
    true,
  );

  static const _consumerEMI = AppRoutesMap(
    '/consumeremi',
    'Home',
    'Consumer EMI',
    '<Description Not Yet>',
    [_roleDisty, _roleDealer, _roleElectrician],
    true,
  );

  static const _createAdvertisement = AppRoutesMap(
    '/createAdvertisement',
    'Menu',
    'Create Advertisement',
    '<Description Not Yet>',
    [_roleDisty, _roleDealer, _roleElectrician],
    true,
  );

  static const _redeemCoins = AppRoutesMap(
    '/redeemCoins',
    'Home',
    'Redeem Coins',
    '<Description Not Yet>',
    [_roleDealer],
    false,
  );

  static const _networkManagement = AppRoutesMap(
    '/viewdetails',
    'Network',
    'Network Management',
    '<Description Not Yet>',
    [_roleDisty, _roleDealer, _roleElectrician],
    true,
  );

  static const _primaryReport = AppRoutesMap(
    '/primaryReport',
    'Report Management',
    'Primary Report',
    '<Description Not Yet>',
    [_roleDisty],
    false,
  );

  static const _secondaryReportDistributor = AppRoutesMap(
    '/secondaryReportDistributor',
    'Report Management',
    'Secondary Report',
    '<Description Not Yet>',
    [_roleDisty],
    true,
  );

  static const _secondaryReportDealer = AppRoutesMap(
    '/secondaryReportDealer',
    'Report Management',
    'Secondary Dealer Report',
    '<Description Not Yet>',
    [_roleDealer],
    true,
  );

  static const _tertiaryReport = AppRoutesMap(
    '/tertiaryReport',
    'Report Management',
    'Tertiary Report',
    '<Description Not Yet>',
    [_roleDisty, _roleDealer, _roleElectrician],
    true,
  );

  static const _warranty = AppRoutesMap(
    '/warranty',
    'i-SMaRT',
    'Check Warranty Status',
    '<Description Not Yet>',
    [_roleDisty, _roleDealer, _roleElectrician],
    true,
  );

  static const _batteryManagement = AppRoutesMap(
    '/batteryManagement',
    'Menu',
    'Battery Management',
    '<Description Not Yet>',
    [_roleDisty, _roleDealer, _roleElectrician],
    true,
  );

  static const _helpAndSupportPage = AppRoutesMap(
    '/helpAndSupport',
    'Help And Support',
    'Help And Support',
    '<Description Not Yet>',
    [_roleDisty, _roleDealer, _roleElectrician],
    true,
  );

  static const _luminousVideo = AppRoutesMap(
    '/luminousVideoPage',
    'Luminous Video',
    'Luminous Video',
    '<Description Not Yet>',
    [_roleDisty, _roleDealer, _roleElectrician],
    true,
  );

  static const _coinToCashback = AppRoutesMap(
    'moreFeatures/coinsToCashback',
    'Redeem Coins',
    'Coins To Cashback',
    '<Description Not Yet>',
    [_roleDealer],
    false,
  );

  static const _productsCatalogue = AppRoutesMap(
    '/catalogue',
    'Products',
    'Catalogue',
    '<Description Not Yet>',
    [_roleDisty, _roleDealer, _roleElectrician],
    true,
  );

  static const _productsCatalogue_0 = AppRoutesMap(
    '/catalogue',
    'Products',
    'Inverter & Battery Catalogue',
    '<Description Not Yet>',
    [_roleDisty, _roleDealer, _roleElectrician],
    true,
  );

  static const _productsCatalogue_1 = AppRoutesMap(
    '/catalogue',
    'Products',
    'High Capacity Inverter Catalogue',
    '<Description Not Yet>',
    [_roleDisty, _roleDealer, _roleElectrician],
    true,
  );

  static const _productsCatalogue_2 = AppRoutesMap(
    '/catalogue',
    'Products',
    'Solar Products Catalogue',
    '<Description Not Yet>',
    [_roleDisty, _roleDealer, _roleElectrician],
    true,
  );

  static const _productsPriceList = AppRoutesMap(
    '/price_list',
    'Products',
    'Price List',
    '<Description Not Yet>',
    [_roleDisty, _roleDealer, _roleElectrician],
    true,
  );

  static const _productsPriceList_0 = AppRoutesMap(
    '/price_list',
    'Products',
    'Distributor Price List',
    '<Description Not Yet>',
    [_roleDisty, _roleDealer, _roleElectrician],
    true,
  );

  static const _productsPriceList_1 = AppRoutesMap(
    '/price_list',
    'Products',
    'Dealer & SI Price List',
    '<Description Not Yet>',
    [_roleDisty, _roleDealer, _roleElectrician],
    true,
  );

  static const _productsPriceList_2 = AppRoutesMap(
    '/price_list',
    'Products',
    'Electrician Price List',
    '<Description Not Yet>',
    [_roleDisty, _roleDealer, _roleElectrician],
    true,
  );

  static const _productsScheme = AppRoutesMap(
    '/scheme',
    'Products',
    'Scheme',
    '<Description Not Yet>',
    [_roleDisty, _roleDealer, _roleElectrician],
    true,
  );

  static const _productsScheme_0 = AppRoutesMap(
    '/scheme',
    'Products',
    'Distributor Scheme',
    '<Description Not Yet>',
    [_roleDisty, _roleDealer, _roleElectrician],
    true,
  );

  static const _productsScheme_1 = AppRoutesMap(
    '/scheme',
    'Products',
    'Dealer & SI Scheme',
    '<Description Not Yet>',
    [_roleDisty, _roleDealer, _roleElectrician],
    true,
  );

  static const _productsScheme_2 = AppRoutesMap(
    '/scheme',
    'Products',
    'Electrician Scheme',
    '<Description Not Yet>',
    [_roleDisty, _roleDealer, _roleElectrician],
    true,
  );

    static const _promotionalVideos = AppRoutesMap(
    '/luminousVideoPage',
    'Luminous Videos',
    'Promotional Videos',
    '<Description Not Yet>',
    [_roleDisty, _roleDealer, _roleElectrician],
    true,
  );

    static const _menu = AppRoutesMap(
    '/menu',
    'Menu',
    'Menu',
    '<Description Not Yet>',
    [_roleDisty, _roleDealer, _roleElectrician],
    true,
  );

  static const _gemSupportMafHomePage = AppRoutesMap(
    '/_gemSupportMafHomePage',
    'GeM',
    'Manufacturing Authorization Form',
    '<Description Not Yet>',
    [_roleDisty, _roleDealer, _roleElectrician],
    false,
  );

  static const _gemAuthCodeHomePage = AppRoutesMap(
    '/gemSupportAuthCode',
    'GeM',
    'Authorization Code',
    '<Description Not Yet>',
    [_roleDisty, _roleDealer, _roleElectrician],
    false,
  );

  static const _gemSupportCategory = AppRoutesMap(
    '/gemSupportCategory',
    'GeM',
    'GeM',
    '<Description Not Yet>',
    [_roleDisty, _roleDealer, _roleElectrician],
    false,
  );

  static const _gemSupportTenderHome = AppRoutesMap(
    '/gemSupportTenderHome',
    'GeM',
    'Tenders',
    '<Description Not Yet>',
    [_roleDisty, _roleDealer, _roleElectrician],
    false,
  );

  static const _gemSupportTenderDetails = AppRoutesMap(
    '/gemSupportTenderDetails',
    'GeM',
    'Tenders',
    '<Description Not Yet>',
    [_roleDisty, _roleDealer, _roleElectrician],
    false,
  );

  static const _gemMafRegistration = AppRoutesMap(
    '/_gemMafRegistration',
    'GeM',
    'Manufacturing Authorization Form',
    '<Description Not Yet>',
    [_roleDisty, _roleDealer, _roleElectrician],
    false,
  );


  static const _gemMafRegistrationDetails = AppRoutesMap(
    '/_gemMafRegistrationDetails',
    'MAF',
    'maf_registration',
    '<Description Not Yet>',
    [_roleDisty, _roleDealer, _roleElectrician],
    false,
  );

  static const _solarDesigning = AppRoutesMap(
    '/solarDesignDashboard',
    'Designing',
    'Designing',
    '<Description Not Yet>',
    [_roleDisty, _roleDealer, _roleElectrician],
    true,
  );

  static const _solarDigitalDesigning = AppRoutesMap(
    '/solarDigDesignDashboard',
    'Designing',
    'Digital Designing',
    '<Description Not Yet>',
    [_roleDisty, _roleDealer, _roleElectrician],
    true,
  );

  static const _solarPhysicalDesigning = AppRoutesMap(
    '/solarPhyDesignDashboard',
    'Designing',
    'Physical Designing',
    '<Description Not Yet>',
    [_roleDisty, _roleDealer, _roleElectrician],
    true,
  );

  static const _solarFinancing = AppRoutesMap(
    '/solarFinancingDashboard',
    'Financing',
    'Financing',
    '<Description Not Yet>',
    [_roleDisty, _roleDealer, _roleElectrician],
    true,
  );

  static const _onlineGuidance = AppRoutesMap(
    '/onlineGuidanceDashboard',
    'Installation',
    'Online Guidance',
    '<Description Not Yet>',
    [_roleDisty, _roleDealer, _roleElectrician],
    true,
  );
  static const _onsiteGuidance = AppRoutesMap(
    '/onsiteGuidanceDashboard',
    'Installation',
    'Onsite Guidance',
    '<Description Not Yet>',
    [_roleDisty, _roleDealer, _roleElectrician],
    true,
  );
  static const _endToEndDeployment = AppRoutesMap(
    '/endToEndDeploymentDashboard',
    'Installation',
    'Project Execution',
    '<Description Not Yet>',
    [_roleDisty, _roleDealer, _roleElectrician],
    true,
  );

  static const _projectExecutionDashboard = AppRoutesMap(
    '/projectExecutionDashboard',
    'Installation',
    'Installation',
    '<Description Not Yet>',
    [_roleDisty, _roleDealer, _roleElectrician],
    true,
  );

  static const _goSolarHome = AppRoutesMap(
    '/goSolarHome',
    'Solutions',
    'Energy Solutions',
    '<Description Not Yet>',
    [_roleDisty, _roleDealer, _roleElectrician],
    true,
  );

  static const splash = '/splash';
  static const language = '/language';
  static const login = '/login';
  static const qrscreen = '/qrscreen';
  static const welcome = '/welcome';
  static final products = _products.route;
  static final productsCatalogue = _productsCatalogue.route;
  static final productsPriceList = _productsPriceList.route;
  static final productsScheme = _productsScheme.route;
  static final luminousVideoPage = _luminousVideo.route;
  static final gemSupportMafHomePage = _gemSupportMafHomePage.route;


  // static final menu = _menu.route;
  static final userprofile = _userprofile.route;
  static final homepage = _homepage.route;
  static final ismartHomepage = _ismartpage.route;
  static final notificationHome = _notificationHome.route;

  // static const ismartHomepage = 'ismart/ismartHomepage';
  static final coinsToCashback = _coinToCashback.route;
  static final warranty = _warranty.route;
  static final tertiarySales = _tertiarySales.route;
  static final registerSales = _registerSales.route;
  static final secondarySales = _secondarySales.route;
  static final intermediarySales = _intermediarySales.route;
  static final consumeremi = _consumerEMI.route;
  static const comboScreen = 'registerSales/comboscreen';
  static final redeemCashHome = _redeemCash.route;

  // static const redeemCashHome = '/redeemCashHome';
  static final redeemCoins = _redeemCoins.route;
  static const hkvaSummary = '/hkvaSummary';
  static const paytmRedemption = '/paytmRedemption';
  static final coinsToTrip = _coinToTripPage.route;

  // static const coinsToTrip = '/coinsToTrips';
  static final viewDetails = _networkManagement.route;
  static const selectReportType = '/selectReportType';
  static const secondaryReportDistributor = '/secondaryReportDistributor';
  static final createAdvertisement = _createAdvertisement.route;
  static final coinDetailedHistory =
      _coinDetailedHistory.route; //  '/coinDetailedHistory';
  static final cashDetailedHistory =
      _cashDetailedHistory.route; // '/cashDetailedHistory';
  static const batteryManagement = '/batteryManagement';
  static const previewImage = '/previewImage';
  static final helpAndSupport = _helpAndSupportPage.route;

  // static const helpAndSupport = '/helpAndSupport';
  static const omniSearch = 'home/omniSearch';
  static const primaryReport = '/primaryReport';
  static const secondaryReportDealer = '/secondaryReportDealer';
  static const tertiaryReport = '/tertiaryReport';
  static const upiScreen = '/enterUPIScreen';
  static const upiIdScreen = '/enterUPIIdScreen';
  static const pinelabRedemption = '/pinelabRedemption';
  static const menu = '/menu';
  static const peDashboard = '/peDashboard';
  static final solarDigDesignDashboard = _solarDigitalDesigning.route;
  static final solarPhyDesignDashboard = _solarPhysicalDesigning.route;
  static final solarFinancingDashboard = _solarFinancing.route;
  static final solarDesignDashboard = _solarDesigning.route;
  static final onlineGuidanceDashboard = _onlineGuidance.route;
  static final onsiteGuidanceDashboard = _onsiteGuidance.route;
  static final endToEndDeploymentDashboard = _endToEndDeployment.route;
  static final projectExecutionDashboard = _projectExecutionDashboard.route;
  static final gemSupportCategory = _gemSupportCategory.route;
  static final gemSupportTenderHome = _gemSupportTenderHome.route;
  static final gemSupportTenderDetails = _gemSupportTenderDetails.route;

  static final gemMafRegistration = _gemMafRegistration.route;
  static final gemMafRegistrationDetails = _gemMafRegistrationDetails.route;
  static final gemSupportAuthCode =  _gemAuthCodeHomePage.route;
 // static const gemSupportAuthCode = '/gemSupportAuthCode';
  static const gemSupportAuthDetail = '/gemSupportAuthDetail';
  static const gemAuthSearch = '/gemAuthSearch';
  static const gemAuthfilter = '/gemAuthfilter';

  static final goSolarHome = _goSolarHome.route;

  // static const notificationHome = '/notificationHome';
  // static const notificationWebView = '/notificationWebView';

  static final Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    language: (context) => const SelectLanguage(),
    login: (context) => const LoginScreen(),
    // menu: (context) => const M(),
    // qrscreen: (context) => const CommonQR(),
    welcome: (context) => const WelcomeScreen(),
    products: (context) => Product(),
    userprofile: (context) => const UserProfileScreen(),
    homepage: (context) => const HomeScreen(),
    ismartHomepage: (context) => const ISmartDisclaimerAlert(screen: IsmartHomepage()),
    coinsToCashback: (context) => const RedeemCoinsToCashback(),
    warranty: (context) => const WarrantyScreen(),
    tertiarySales: (context) => const TertiarySales(),
    registerSales: (context) => const RegisterSales(),
    secondarySales: (context) => const SecondarySales(),
    intermediarySales: (context) => const IntermediarySales(),
    consumeremi: (context) => const ConsumerEmi(),
    comboScreen: (context) => ComboScreen(),
    redeemCashHome: (context) => const RedeemCashHome(),
    redeemCoins: (context) => const RedeemCoins(),
    paytmRedemption: (context) => const EnterMobileScreen(),
    coinsToTrip: (context) => const RedeemCoinsToTrip(),
    viewDetails: (context) => const NetworkHomePage(),
    selectReportType: (context) => SelectReportTypeWidget(),
    secondaryReportDistributor: (context) => const SecondaryReportDistributor(),
    createAdvertisement: (context) => const CreateAdvertisement(),
    coinDetailedHistory: (context) => const CashCoinHistoryScreen(cardType: FilterCashCoin.coinType),
    cashDetailedHistory: (context) => const CashCoinHistoryScreen(cardType: FilterCashCoin.cashType),
    batteryManagement: (context) => const BatteryManagement(),
    previewImage: (context) => const PreviewScreen(),
    omniSearch: (context) => const OmniSearch(),
    helpAndSupport: (context) => const HelpAndSupport(),
    primaryReport: (context) => PrimaryReportWidget(),
    secondaryReportDealer: (context) => const SecondaryReportDealer(),
    tertiaryReport: (context) => const TertiaryReportScreen(),
    upiScreen: (context) => const EnterUPIScreen(),
    upiIdScreen: (context) => const EnterUPIIDScreen(),
    pinelabRedemption: (context) => const PinelabRedemption(),
    menu: (context) => const Menu(),
    luminousVideoPage: (context) => LuminousVideos(),
    productsCatalogue: (context) => Product(initialIndex: 0),
    productsPriceList: (context) => Product(initialIndex: 1),
    productsScheme: (context) => Product(initialIndex: 2),
    notificationHome: (context) => const NotificationHome(),
    //peDashboard: (context) => const ProjectExecutionCommonDashboardPage(typeName: "", typeValue: ""),
    solarDesignDashboard : (context) => const SolarDesignHomePage(),
    solarDigDesignDashboard: (context)=> const DigitalSurveyDashboardPage(isDigOrPhy: true),
    solarPhyDesignDashboard: (context) => const DigitalSurveyDashboardPage(isDigOrPhy: false),

  solarFinancingDashboard: (context) => const SolarFinanceDashboard(),
  onlineGuidanceDashboard: (context) =>  ProjectExecutionCommonDashboardPage(typeName: translation(context).onlineGuidance,typeValue: SolarAppConstants.online),
  onsiteGuidanceDashboard: (context) =>  ProjectExecutionCommonDashboardPage(typeName: translation(context).onsiteGuidance,typeValue: SolarAppConstants.onsite),
  endToEndDeploymentDashboard: (context) =>  ProjectExecutionCommonDashboardPage(typeName: translation(context).endToEndDeployment,typeValue: SolarAppConstants.endToEnd),
  projectExecutionDashboard: (context) => const ProjectExecutionHomePage(),
  goSolarHome: (context)=> const GoSolarHome(),

    gemSupportMafHomePage: (context) => GemMafHomePage(),
    gemSupportCategory: (context) => const GemSupportCategory(),
    gemSupportTenderHome: (context) => const GemTenderHome(),
    gemSupportTenderDetails : (context) => const GemTenderCategoryDetails(initialIndex: 0),
    gemMafRegistration: (context) => const MafRegistration(gstNumber: '',),
    // gemMafRegistrationDetails: (context)  => const MafRegistrationDetails(bidNumber: '', gstNumber: ''),
    gemSupportAuthCode: (context) =>  GemBidDetails(),
    //gemSupportAuthDetail: (context) => GemSupportAuthrizationCodeDetail(id: 0,),
    gemAuthSearch: (context) => GemAuthSearch(Status: '',),
  };

  final List<AppRoutesMap> searchList = [
    _ismartpage,
    _products,
    _userprofile,
    _homepage,
    _networkManagement,
    _registerSales,
    _tertiarySales,
    _secondarySales,
    // _intermediarySales,
    _consumerEMI,
    _createAdvertisement,
    _redeemCoins,
    _primaryReport,
    _secondaryReportDistributor,
    _secondaryReportDealer,
    _tertiaryReport,
    _warranty,
    _batteryManagement,
    _coinToTripPage,
    _coinDetailedHistory,
    _cashDetailedHistory,
    _redeemCash,
    _helpAndSupportPage,
    _luminousVideo,
    _coinToCashback,
    _productsCatalogue,
    _productsCatalogue_0,
    _productsCatalogue_1,
    _productsCatalogue_2,
    _productsPriceList,
    _productsPriceList_0,
    _productsPriceList_1,
    _productsPriceList_2,
    _productsScheme,
    _productsScheme_0,
    _productsScheme_1,
    _productsScheme_2,
    _notificationHome,
    _ismartpage_1,
    _promotionalVideos,
    _menu,
    _solarDesigning,
    _solarDigitalDesigning,
    _solarPhysicalDesigning,
    _solarFinancing,
    _onlineGuidance,
    _onsiteGuidance,
    _endToEndDeployment,
    _projectExecutionDashboard,
    _goSolarHome,
    _gemSupportCategory,
    _gemSupportMafHomePage,
    _gemAuthCodeHomePage,
    _gemSupportTenderHome,

  ];
}

class AppRoutesMap extends Equatable {
  final String route;
  final String group;
  final String displayText;
  final String description;
  final List<String> supportedRoles;
  final bool isAvailableToSecondary;

  const AppRoutesMap(this.route, this.group, this.displayText, this.description,
      this.supportedRoles, this.isAvailableToSecondary);

  @override
  List<Object?> get props => [
        route,
        group,
        displayText,
        description,
        supportedRoles,
        isAvailableToSecondary
      ];
}
