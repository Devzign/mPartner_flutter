enum RequestState {
  loading,
  loaded,
  error,
}

enum NavigationState {
  homePage,
  welcomePage,
  httpFailure,
  responseFailure,
}

enum UserTypes {
  Distributor,
  Dealer,
  Electrician
}

enum TotalProductsField {
  totalBatteryProduct,
  totalHKVAProduct,
  totalHUPSProduct,
  totalNXGProduct,
  totalSolarBatteryProduct,
  totalCRUZEProduct,
  totalRegaliaProduct,
  totalAutoBatteryProduct,
  totalPCUProduct,
  totalGTIProduct,
  totalSolarPanelProduct,
}

enum ProductsCategory {
  battery,
  hkva,
  hups,
  nxg,
  solarBattery,
  regalia,
  cruze,
  pcu,
  solarPanel,
  gti,
  autoBattery,
}

enum ProductStatus {
  accepted,
  rejected,
  pending,
  unknown
}

enum PrimaryReportTypes {
 primaryBillingReport,
 customerLedgerReport,
 creditDebitNoteReport,
}

enum ProfileBottomSheetType {
  none,
  pan,
  secondaryDevice1,
  secondaryDevice2
}

enum SolutionTypes {
  SolarFinancingSolutionType,
  SolarDesignSolutionType,
  ProjectExecutionSolutionType
}

enum CardType { Coins, Cash }

enum TermsNConditionsType {
  SolarFinance,
  SolarDigDesign,
  SolarPhyDesign,
  SolarProjectExe,
  SolarPrjExeOnline,
  SolarPrjExeE2E
}

