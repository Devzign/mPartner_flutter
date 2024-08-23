import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_as.dart';
import 'app_localizations_be.dart';
import 'app_localizations_en.dart';
import 'app_localizations_gu.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_kn.dart';
import 'app_localizations_ml.dart';
import 'app_localizations_mr.dart';
import 'app_localizations_or.dart';
import 'app_localizations_pa.dart';
import 'app_localizations_ta.dart';
import 'app_localizations_te.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
//  import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
    Locale('gu'),
    Locale('as'),
    Locale('be'),
    Locale('te'),
    Locale('ta'),
    Locale('pa'),
    Locale('or'),
    Locale('mr'),
    Locale('ml'),
    Locale('kn'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'IRB'**
  ///

// Tabbar
  String get home;

  String get iSmart;

  String get goSolar;

  String get network;

  String get menu;

  String get enterPhoneNoHint;

  String get getLoginTitle;

  String get nextButtonText;

  String get mobileNumber;

  String get pleaseEnterNumber;

  String get enterAvalidNumber;

  String get enterYourMobileNumberToLogIn;

  String get sendOTP;

  String get verifyOTP;

  String get attemptAlert;

  String get resendOTPin;

  String get incorrectOTP;

  String get enterTheOTPSentTo;

  String get loginAlert;

  String get ourProducts;

  String get catalogue;

  String get priceList;

  String get scheme;

// advertisement
  String get createYourAdvertisement;

//Dashboard
  String get whatsNew;

  String get luminousEnergySolutions;

  String get iSmartScanAndEarn;

  String get availableCash;

  String get availableCoins;

  String get registerSales;

  String get solar;

  String get calculator;

  String get leadManagement;

  String get options;

  String get consumerEmi;

  String get serviceEscalation;

  String get quicklinks;

  String get batteryManagement;

  String get reportManagement;

  String get luminousYoutube;

  String get promotionalVideos;

  String get discoverNewFeaturesAndLatestProducts;

// I-Smart Section
  String get cashSummary;

  String get coinsSummary;

  String get redeemYourCash;

  String get redeemYourCoins;

  String get availableCoinsBalance;

  String get availableCashBalance;

  String get earned;

  String get redeemed;

  String get cashEarned;

  String get yourmPartnerWallet;

// Battery Management
  String get locateCollectionServiceCentre;

  String get state;

  String get selectState;

  String get city;

  String get selectCity;

// iSamrt Widget
  String get earnRewardsOnEveryScan;

  String get checkWarrantyStatus;

//Service Escallation
  String get customerComplaints;

  String get serviceInstallation;

// Cash detailed history
  String get history;

  String get coins;

  String get cash;

  String get pending;

  String get search;

  String get transactionSummary;

// User Profile
  String get sapPhoneNumber;

  String get emailAddress;

  String get address;

  String get secondaryDevice1;

  String get secondaryDevice2;

  String get download;

  String get certificateOfAppreciation;

  String get proceed;

  String get verify;

  String get loggingOut;

  String get yes;

  String get since;

  String get logout;

  String get profile;

  String get mobile;

// Date Picker Widget
  String get cancel;

  String get confirm;

// Common QR widget
  String get scanBarCode;

  String get centerTheBarCodeWithinTheBox;

// Notification
  String get myActivity;

  String get promotional;

  String get updatesOnAllYourActivitiesWillAppearHere;

  String get updatesOnNewFeaturesAnnouncementsOffersAndPromotionsWillAppearHere;

  String get notifications;

  String get noMoreNotificationsToShow;

  String get nothingHereyet;

//PopUp, Survey Form, Agreement
  String get agreement;

  String get clickToViewAnnexure;

  String get acceptAllTheTermsAndConditionsOfLuminousFSEAgreement;

  String get video;

  String get image;

  String get surveyForm;

  String get pleaseProvideYourFeedbackItHelpsUsToImprove;

  String get feedback;

  String get back;

  String get submit;

  String get radioButton;

  String get starRating;

  String get checkbox;

  String get confirmationAlert;

  String get surveyFormOnceClosedWillNotSaveYourResponses;

  String get areYouSureYouWantToClose;

  String get no;

  String get selectPhoto;

  String get allPhotos;

  String get writeYourFeedbackHere;

  String get attachImage;

  String get question;

  String get continueButtonText;

//Help and Support
  String get helpAndSupport;

  String get viewCompanyInfo;

  String get writeToUs;

  String get writeYourMsgHere;

  String get attachFiles;

  String get imageAttached;

  String get imagesAttached;

  String get msgDelivered;

  String get deliveredMsgText;

  String get preview;

  String get delete;

  String get uploadAgain;

  String get companyInfo;

  String get goToHelpAndSupport;

  String get supportedFormat;

  String get invalidFileType;

  String get discardEdits;

  String get closeAndLoseEdits;

  String get sureToContinue;

  String get discard;

  String get keepEditing;

  String get selectlanguage;

  String get language;

  String get createAd;

  String get edit;

  String get addText;

  String get colors;

  String get styling;

  String get alignment;

  String get casing;

  String get dealersList;

  String get electricianList;

  String get newDealersStatus;

  String get newElectricianStatus;

  String get active;

  String get inActive;

  String get newDealer;

  String get newElectrician;

  String get userType;

  String get createdOn;

  String get lastUpdatedOn;

  String get remarks;

  String get verificationStatus;

  String get firmDetails;

  String get pan;

  String get panUpload;

  String get addFrontImage;

  String get idTypeHint;

  String get idNumber;

  String get idNumberHint;

  String get uploadId;

  String get uploadIdFront;

  String get uploadIdBack;

  String get addBackImage;

  String get conditionCheck1;

  String get conditionCheck2;

  String get govtIdType;

  String get dealerPerformance;

  String get electricianPerformance;

  String get property;

  String get dealerFirmName;

  String get dealerFirmShopname;

  String get ownerName;

  String get enterOwnerName;

  String get emailId;

  String get enterEmailId;

  String get address1;

  String get address2;

  String get pastalCode;

  String get enterYourPostalCode;

  String get chooseState;

  String get district;

  String get chooseDistrict;

  String get chooseCity;

  String get personalDetails;

  String get fullName;

  String get enterFullName;

  String get dob;

  String get selectDate;

  String get houseNo;

  String get enterHouseNo;

  String get apartment;

  String get enterAreaName;

  String get camera;

  String get chooseFiles;

  String get step;

  String get reUpload;

  String get submittedSuccessfully;

  String get successContent;

  String get checkStatus;

  String get panCardNumber;

  String get blockRedumption;

  String get dealerCode;

  String get viewPanCard;

  String get dealercodeCreatedSuccessfully;

  String get uploadDocuments;

  String get verifyDealer;

  String get verifyElectrician;

  String get alertContentDealer;

  String get alertContentElectrician;

  String get notSubmitted;

  String get view;

  String get electricianCode;

  String get addressDetails;

  String get dealerFirmPropertyName;

  String get cityListed;

  String get searchCity;

  String get submitData;

  String get selectanOption;

  String get noDataFound;

  String get selectDateValue;

  String get purchaseVerifiedwithOtp;

  String get dealerDetails;

  String get electricianDetails;

  String get viewSecondaryDetails;

  String get redeemAnyReward;

  String get districtListed;

  String get selectUserType;

  String get awaitApproval;

  String get enterOtpSentTo;

  String get electricanCodeCreatedSuccessfully;

//omnisearch
  String get searchByFeatureName;

  String get goToHomePage;

  String get videos;

  String get comingSoon;

  String get underDevelopment;

  String get training;

  String get newUser;

  String get signUp;

//Paytm and UPI
  String get paytm;

  String get transferAmount;

  String get enterTransferAmount;

  String get transactionFailureMessage;

  String get txnPinelabPendingMessage;

  String get txnPaytmPendingMessage;

  String get txnUPIPendingMessage;

  String get enterValidTransferAmount;

  String get enterRegisteredMobileNumber;

  String get upi;

  String get enterUpiId;

  String get enterYourUpiId;

  String get beneficiaryDetails;

  String get transferAmountValidation;

  String get enterAgain;

  String get beneficiaryName;

  String get upiId;

  String get ifscCode;

  String get available;

  String get infoMessage;

  String get registeredNumber;

  String get noGstCertificate;

  String get updateGST;

  String get ofTransferAmount;

  String get grossAmountAfterDeduction;

  String get applicableTds;

  String get ofGrossAmountAfterDeduction;

  String get netTransferAmount;

  String get transferringTo;

  String get successful;

  String get failed;

  String get transaction;

  String get transactionDate;

  String get transactionId;

  String get exploreMoreOptionsToRedeem;

//Register Sales
  String get sale;

  String get selectSaleType;

//Secondary Sales
  String get selectDealer;

  String get dateOfPurchase;

  String get saleToDealer;

  String get dealerName;

  String get goingBackWillDelete;

  String get registration;

  String get earningStatus;

  String get scanNext;

  String get dealersListed;

  String get productWith;

  String get willBeRemoved;

  String get entriesRegCantChanged;

  String get clickingSubmit;

  String get scanFailed;

  String get scanFailedRemarks;

  String get serialNoInvalid;

  String get batchEntries;

  String get serialNoLimitWarning;

  String get accepted;

  String get rejected;

  String get productName;

  String get status;

  String get remark;

  String get forSaleTo;

  String get chooseYour;

  String get dealer;

  String get electrician;

  String get creditedToMPartnerWallet;

  String get creditPending;

  String get creditRejected;

  String get reflectSoon;

  String get downloadWarrantyCard;

  String get secondarySaleToDealer;

  String get tertiarySaleToCustomer;

  String get intermediarySaleToElectrician;

  String get purchaseVerified;

  String get withText;

  String get withoutText;

  String get registeredOn;

  String get docUploadWarning;

  String get uploadValidPurchaseOrder;

  String get saleRegisteringTo;

  String get verifySale;

  String get continueWithoutVerification;

  String get uploadPurchaseOrder;

  String get selectElectrician;

  String get electricianName;

  String get saleDate;

  String get selectDateFormat;

  String get saleToElectrician;

  String get electricianListed;

  String get buttonOkay;

  String get buttonOkayWithoutExclamation;

  String get tertiarySales;

  String get secondarySales;

  String get intermediarySales;

  String get bulkCorporateSales;

  String get note;

  String get supportedformatPDFFile;

  String get maxFileSize5MB;

  String get selectReportType;

  String get reportType;

  String get primaryReport;

  String get secondaryReport;

  String get tertiaryReport;

  String get dealerNameCode;

  String get detailedReport;

  String get overallSummary;

  String get chooseYourDealers;

  String get chooseYourCustomers;

  String get selectDateRange;

//Redeem Coins to Trips

  String get details;

  String get tripDetails;

  String get travellerDetails;

  String get added;

  String get bookNow;

  String get verifyTripDetails;

  String get addTraveller;

  String get passportNo;

  String get enterPassportNumber;

  String get enterName;

  String get mobileNo;

  String get addMobileNo;

  String get enterRelation;

  String get name;

  String get selectTraveller;

  String get addDetails;

  String get beforeClickingContinue;

  String get traveller;

  String get passport;

  String get selectNumberofTravellers;

  String get youCanSelectMaximum;

  String get travellers;

  String get noDefaultUserFound;

  String get trips;

  String get upcoming;

  String get booked;

  String get all;

  String get downloadTripDetails;

  String get bookedOn;

  String get expiredOn;

  String get seatsAvailable;

  String get acceptAndProceed;

  String get iAcceptAllTheTermsAndConditions;

  String get termsAndConditons;

  String get sorryWeHaveNoSavedTravellers;

  String get searchSavedTraveller;

  String get duration;

  String get date;

  String get coinsAvailed;

  String get bookingOnceDoneCannotBeCancelled;

  String get alert;

  String get relation;

//Consumer EMI
  String get headerTagLine;

  String get enterConsumerMobNo;

  String get enterPincode;

  String get enterPincodeOfShop;

  String get consumerEmiRequest;

  String get enterConMobNoToRaiseReq;

  String get searchNearbyRepresentative;

  String get enterPincodeToSearchRepresentative;

  String get representativeDetails;

  String get custom;

  String get startDate;

  String get endDate;

  String get productsCategory;

  String get totalProductsSold;

  String get selectAll;

  String get secondaryDateRange;

//Logout bottom sheet
  String get areYouSureYouWantToLogOut;

  String get noIAmNot;

  String get addedOn;

//Snackbar
  String get secondaryDeviceUpdated;

//Secondary Device
  String get information;

  String get relationshipWithOwner;

  String get fatherSonEmployee;

  String get enterConMobNo;

  String get addSecDev1;

  String get addSecDev2;

  String get noAlreadyExists;

//warranty
  String get scanQrCode;

  String get heading;

  String get error;

  String get checkSerialNumber;

  String get productWarrantyDetails;

  String get couldNotLaunch;

  String get warranty;

  String get manufacturingDate;

  String get productType;

  String get modelName;

  String get primaryCustomer;

  String get primaryBilledDate;

  String get tertiaryDealerName;

  String get tertiaryCustomerName;

  String get tertiaryCustomerNo;

  String get tertiaryDate;

  String get tertiaryCity;

  String get imgURL;

  String get pDFURL;

  String get invoiceNumber;

  String get warrantyExpiryDate;

  String get cashbackDetails;

  String get transferCoins;

  String get applicableRate;

  String get coinsConversionRate;

  String get totalCashReward;

  String get redeemableCoins;

  String get acceptTermsConditions;

  String get offers;

  String get termsAndConditions;

  String get registerSalesFloating;

  String get validEmailError;

  String get validNumberError;

  String get validPostalCodeError;

  String get validAadharError;

  String get validDrivingLicenceError;

//Sales
  String get tertiarySale;

  String get enterWarrantyVerificationCodeSentTo;

  String get saleToCustomer;

  String get tertiarySaleRegistration;

  String get coinsEarned;

  String get okIUnderstand;

  String get coinsLowerCase;

  String get creditedToYourMPartnerWallet;

  String get withoutOTP;

  String get withOTP;

  String get noCoinCashRewardEarned;

  String get noCashRewardEarned;

  String get redemptionViaPaytmWallet;

  String get redemptionViaPinelabWallet;

  String get redemptionViaUPI;

  String get issuedViaCN;

  String get coinsConvertedToCash;

  String get redemptionViaTrips;

  String get redemptionViaGifts;

  String get productNotBilledMessage;

  String get verifySales;

  String get insufficientCoinBalanceMessage;

  String get upcomingFeature;

  String get resendOTP;

  String get redeemCoins;

  String get redeemYouCoinsHere;

  String get authorizedCertificate;

  String get certificates;

  String get pleaseSelectYourSAPID;

  String get goToSettings;

  String get mockLocationMsg;

  String get locationDenied;

  String get locationDisabled;

  String get locationDeniedPlAllow;

  String get locationDisabledPlEnable;

  String get locationPermissionDenied;

  String get addBattery;

  String get basedOnInverterCapacityPleaseScan;

  String get scanAnInverterFirst;

  String get noPermission;

  String get rescan;

  String get wrongProductScan;

  String get required;

  String get invalidName;

  String get nameShouldBeAtleast5CharactersLong;

  String get invalidMobileNumber;

  String get customerName;

  String get addName;

  String get customerAddress;

  String get addAddress;

  String get customerMobileno;

  String get referralCodeOptional;

  String get code;

  String get typeOfTertiarySale;

  String get registeredSapPhoneNo;

  String get filter;

  String get transactionType;

  String get saleType;

  String get category;

  String get redemptionMode;

  String get reset;

  String get apply;

//Pinelab
  String get pinelabs;

//menu
  String get ourProductsWithLineBreak;

  String get serviceEscalationWithLineBreak;

  String get reportManagementWithLineBreak;

  String get batteryManagementWithLineBreak;

  String get consumerEmiWithLineBreak;

  String get luminousYoutubeWithLineBreak;

  String get advertisementImageLoadErrorMessage;

  String get cashback;

  String get enterCoins;

  String get enterCoinsToTransfer;

  String get transactionOnceProcessed;

  String get enterMultiplesOf100;

  String get transactionFailedExclamation;

  String get transactionSuccessfulExclamation;

  String get coinsRedeemed;

  String get numberNotRegisteredAlertMessage;

  String get redemptionAlert;

  String get goBack;

  String get totalProducts;

  String get serialNo;

  String get goingBackWillRestartProcess;

  String get areYouSureYouWantToLeave;

  String get continueWithoutOTPVerification;

  String get noSchemesFound;

  String get noSchemesFoundMsg1;

  String get noSchemesFoundMsg2;

  String get somethingWentWrong;

  String get experiencingSomeTechnicalDifficulties;

  String get customerNameCode;

  String get noWarrantyInformationForThisSerialNumber;

  String get reportNotFound;

  String get enterAValidEmail;

  String get passportNoAlreadyExists;

  String get saleRegisteredTo;

  String get from;

  String get to;

  String get tertiaryDateRange;

  String get cashRejected;

  String get coinsRejected;

  String get cashPending;

  String get coinsPending;

  String get pinelabNumberVerification;

  String get sellingDate;

  String get primarySaleDate;

  String get secondarySaleDate;

  String get intermediarySaleDate;

  String get tertiarySaleDate;

  String get perCoin;

  String get dealerStatusNoFilter;

  String get electricianStatusNoFilter;

  String get emptyData;

  String get dealerListNoFilter;

  String get electricianListNoFilter;

  String get dataNotFound;

  String get accessDenied;

  String get secondaryUserAlertMessage;

  String get noCatalog;

  String get noPricelist;

  String get noSchemes;

  String get uploadProfilePicture;

  String get myDetails;

  String get cameraPermission;

  String get grantCameraAccess;

  String get goTosettings;

  String get secondaryDeviceNumber;

//new Warranty

  String get noTripText1;

  String get noTripText2;

  String get noTripText3;

  String get playStoreString;

  String get appStoreString;

  String get updateVal;

  String get updateNewVersionVal;

  String get primarySale;

  String get secondarySale;

  String get intermediarySale;

  String get warrantyStatus;

  String get productDetails;

  String get saleJourney;

  String get doneOn;

  String get soldTo;

  String get soldBy;

  String get scanQRCodeOrEnterSerialNumberToCheckWarrantyStatus;

  String get numberNotRegisteredAlertMessageUPI;

  String get currentlyNoTripsInThisSection;

  String get enteredCoinsMoreThanRedeemable;

  String get bookMore;

  String get relationExist;

  String get whatToExplore;

  String get travellerInfo;

  String get appLanguage;

  String get change;

  String get issuedOn;

  String get selectGender;

  String get male;

  String get female;

  String get preferNotToSay;

  String get userDetails;

  String get travelDocuments;

  String get gstCertificate;

  String get gstNumber;

  String get viewDetails;

  String get upload;

  String get fieldCantContainSpecialCharacters;

  String get enterGstNumber;

  String get uploadGstCertificate;

  String get gstUploadAlertText;

  String get enterPanCardNumber;

  String get uploadPanCard;

  String get uploadPanCardFront;

  String get panUploadAlertText;

  String get fieldCantContainNoOrSpecialCharacters;

  String get passportDetails;

  String get enterYourPassNo;

  String get nationality;

  String get enterNationality;

  String get gender;

  String get select;

  String get firstName;

  String get enterYourFirstName;

  String get lastName;

  String get enterYourLastName;

  String get placeOfIssue;

  String get enterPlaceOfIssue;

  String get placeOfBirth;

  String get enterPlace;

  String get dateOfIssue;

  String get dateOfExpiry;

  String get uploadPassport;

  String get uploadPassportFront;

  String get uploadPassportBack;

  String get passportUploadAlertText;

  String get front;

  String get maxAmountLimitMessage;

  String get noWarrantyDataReceived;

  String get imageBeingSavedToGallery;

  String get productPrimaryDate;

  String get productSecondaryDate;

  String get productTertiaryDate;

  String get batteryOfTheSamemodel;

  String get panValidation;

  String get gstValidation;

  String get passportValidation;

  String get expired;

  String get yourTransferAmountShouldBeLessThanAvailableCash;

  String get alreadyAdded;

  String get errorUploadingImage;

  String get maxImagesCount;

  String get month;

  String get selectMonth;

  String get products;

  String get productAlreadyScanned;

  String get uploadTaxInvoice;

  String get fileExtensionError;

  String get fileSizeError;

  String get alreadyBooked;

  String get exploreFeature;

  String get bonusCoins;

  String get bonusIncluded;

  String get somethingWentWrongPleaseRetry;

  String get storagePermission;

  String get grantStorageAccess;

  String get bonusByLuminous;

  String get noSearchRecordFound;

  String get tooManyOtpAttempt;

  String get coinHistory;

  String get tripRedemption;

  String get warrantyCheck;

  String get currentStatus;

  String get bookingDate;

  String get bookingSuccessful;

  String get bookingPending;

  String get bookingFailed;

  String get noMoreBookingMessage;

  String get totalCoinsReserved;

  String get coinsRedeem;

  String get coinPending;

  String get relationship;

  String get bookingStatus;

  String get secondaryReportDateFilterText;

  String get secondaryReportDateFilterErrorText;

  String get travellersSummary;

  String get manufacturedIn;

  String get userAlreadyExists;

  String get errorText;

  String get finance;

  String get totalFinanceRequests;

  String get digitalSiteSurvey;

  String get totalDesignRequests;

  String get inProgress;

  String get addCustomerProjectDetails;

  String get projectType;

  String get commercial;

  String get residential;

  String get companyName;

  String get contactPersonFirmName;

  String get contactPersonName;

  String get contactPersonMobileNumber;

  String get enterMobileNumber;

  String get contactPersonEmailId;

  String get addSecondaryUser;

  String get removeSecondaryUser;

  String get secondaryContactName;

  String get secondaryContactMobileNumber;

  String get secondaryContactEmailId;

  String get enterSecondaryContactName;

  String get enterSecondaryContactMobileNumber;

  String get enterSecondaryContactEmailId;

  String get projectName;

  String get enterProjectName;

  String get projectAddress;

  String get enterAddress;

  String get projectLandmark;

  String get enterLandmark;

  String get projectCurrentLocation;

  String get enterLocationGeoCoordinates;

  String get projectPincode;

  String get solutionType;

  String get selectSolutionType;

  String get preferredDateOfVisit;

  String get customerProjectDetails;

  String get firmName;

  String get pincode;

  String get theRequest;

  String get hasBeenSentForDesignAndProposal;

  String get done;

  String get uniqueId;

  String get view3dModel;

  String get writeYourReasonHere;

  String get solutionDesigning;

  String get digitalDesigning;

  String get physicalDesigning;

  String get designsShared;

  String get designsPending;

  String get designsReassigned;

  String get raisePhysicalDesignRequest;

  String get raiseDigitalDesignRequest;

  String get raiseDesignRequest;

  String get designStatus;

  String get reassign;

  String get reassignRequest;

  String get pleaseProvideReasonForReassigning;

  String get enterMin5Char;

  String get invalidFormat;

  String get invalidPincode;

  String get averageEnergyConsumption;

  String get avgEnergyConsumption;

  String get enterEnergyConsumptioninkWh;

  String get averageMonthlyBill;

  String get enterMonthlyBillAmountinRupees;

  String get uploadLatestElectricityBill;

  String get selectImage;

  String get addBill;

  String get totalEnquiry;

  String get approved;

  String get raiseFinanceRequest;

  String get residentialAndCommercial;

  String get viewAllBanking;

  String get financeStatus;

  String get approvedBank;

  String get financingOptions;

  String get financingRequests;

//Solar Financing

  String get financeRequest;

  String get projectCapacity;

  String get enterCapacity;

  String get unit;

  String get selectUnit;

  String get projectCost;

  String get enterProjectCost;

  String get preferredBank;

  String get selectPreferredBank;

  String get firmGstinNumber;

  String get enterCustomerFirmGstinNumber;

  String get firmPanNumber;

  String get enterCustomerFirmPanNumber;

  String get panNumber;

  String get enterPanNumber;

//Banking Partners

  String get bankingPartners;

  String get choosePartnerBank;

  String get bankPartner;

  String get selectPartnerBank;

  String get geocodeInstructions;

  String get onlineGuidance;

  String get projectExecution;

  String get endToEndDeployment;

  String get getEndToEndExecution;

  String get getOnlineGuidance;

  String get getOnsiteGuidance;

  String get onsiteGuidance;

  String get preferredDateOfConsultation;

  String get preferredDateOfRevisit;

  String get provideRescheduleDate;

  String get raiseRequest;

  String get reasonForSupport;

  String get remarkAdded;

  String get rescheduled;

  String get reschedule;

  String get reschedulesuccessMessage;

  String get resolved;

  String get selectReasonForSupport;

  String get selectSubCategory;

  String get subCategory;

  String get supportStatus;

  String get totalRequests;

  String get uploadAnyDocument;

  String get addDocument;

  String get invalidValue;

  String get energyConsumptionValidation;

  String get billAmountValidation;

  String get contactPersonMobile;

  String get secondaryContactMobile;

  String get hasBeenSentForVerificationAndApproval;

  String get projectCapacityKwValidation;

  String get projectCapacityMwValidation;

  String get projectCostValidation;

  String get invalidEmailId;

  String get addImage;

  String get tryAgain;

  String get totalExecutionRequests;

  String get hasBeenSentForRedesigning;

  String get physicalVisitAndDesigning;

  String get getPhysicalVisitAndDesigningDone;

  String get designShared;

  String get designPending;

  String get designReassigned;

  String get selectDesignType;

  String get notApplicable;

  String get hasBeenSentForOnline;

  String get hasBeenSentForOnsite;

  String get hasBeenSentForEndToEnd;

  String get selectPEType;

  String get projectOnlineSupport;

  String get projectOnsiteSupport;

  String get projectEndtoEndSupport;

  String get designLayoutAndBos;

  String get gemRequestCode;

  String get authorization;

  String get enterDetail;

  String get invalidGstin;

  String get gstinShouldBeAtleast15CharactersLong;

  String get gemSupportAuthorizationCode;

  String get mafText;

  //tender
  String get gemSupport;

  String get tenders;

  String get selectOption;

  String get centralpsu;

  String get digitalserveyprop;

  String get addcustprojDetails;

  //maf
  String get mafRegistration;

  String get mafDetails;

  String get participateType;

  String get chooseparticipateType;

  String get bidNumber;

  String get enterbidNumber;

  String get bidPubDate;

  String get bidDueDate;

  String get addFile;

  String get location;

  String get tenderDocuments;

  String get authorizationcodestatus;

  String get received;

  String get mafauthorizationform;

  String get raisemafrequest;

  String get gstinnumber;

  String get enterfirmgstin;

  String get uploadtenderdocuments;

  String get pannumber;

  String get mafreqstatus;

  String get bidstatus;

  String get win;

  String get lost;

  String get authorizationcodeDetails;

  String get codevaliditydate;

  String get requestAuthorizationCode;

  String get noRecordFound;

  String get postedOn;

  String get issued;

  String get unableToDownload;

  String get unableToNavigate;

  String get unableToShare;

  String get validity;

  String get solutions;

  String get requestTracking;

  String get requestDate;

  String get lastUpdateDate;

  String get assignedISP;

  String get actionTaken;

  String get reason;

  String get deleteTravellar;

  String get travellerDeleteMessage;

  String get productRequirement;

  String get getStarted;

  String get bidValidationText;

  String get enterAuthcodeText;

  String get installationText;

  String get totalInstallationRequestText;

  String get physicaldesignLayoutAndBos;

  String get featuredText;

  String get deleteOptionText;

  String get requestUnderProcess;

  String get sureAccountDelete;

  String get removeOrUnmapDealer;

  String get removeOrUnmapDealerconfirmationmessage;

  String get submitRequest;

  String get dealerundoconfirmationmessage;

  String get undorequest;

  String get titleSerialNumber;

  String get titleTertiarySalesDate;

  String get titleViewAll;

  String get titleViewLess;

  String get titleEnterNumber;

  String get titleEnterProductSerialNumber;

  String get titleVerificationRules;

  String get titleAcceptContinue;

  String get titleUnableScan;

  String get titleRetry;
  String get unblock_redeption;

  String get unblock_redeptionmessage;


  String get titleInternetConnectionIssue;

  String get transferDetails;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'en',
        'hi',
        'gu',
        'as',
        'be',
        'te',
        'ta',
        'pa',
        'or',
        'mr',
        'ml',
        'kn'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
// Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
    case 'gu':
      return AppLocalizationsGu();
    case 'as':
      return AppLocalizationsAs();
    case 'be':
      return AppLocalizationsBe();
    case 'te':
      return ApplocalizationsTe();
    case 'ta':
      return ApplocalizationsTa();
    case 'pa':
      return ApplocalizationsPa();
    case 'or':
      return ApplocalizationsOr();
    case 'mr':
      return ApplocalizationsMr();
    case 'ml':
      return ApplocalizationsMl();
    case 'kn':
      return ApplocalizationsKn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
