import '../../../../state/contoller/customer_wise_list_controller.dart';
import '../../../../state/contoller/dealer_wise_summary_controller.dart';
import '../../../../state/contoller/product_wise_details_controller.dart';
import '../../../../state/contoller/secondary_report_distributor_controller.dart';
import '../../../../state/contoller/tertiary_customer_wise_products_controller.dart';
import '../../../../utils/enums.dart';
import '../widgets/report_card.dart';

String getProductName(TotalProductsField field) {
  switch (field) {
    case TotalProductsField.totalBatteryProduct:
      return 'Battery';
    case TotalProductsField.totalHKVAProduct:
      return 'HKVA';
    case TotalProductsField.totalHUPSProduct:
      return 'HUPS';
    case TotalProductsField.totalNXGProduct:
      return 'NXG';
    case TotalProductsField.totalSolarBatteryProduct:
      return 'Solar Battery';
    case TotalProductsField.totalCRUZEProduct:
      return 'CRUZE';
    case TotalProductsField.totalRegaliaProduct:
      return 'Regalia';
    case TotalProductsField.totalGTIProduct:
      return 'GTI';
    case TotalProductsField.totalSolarPanelProduct:
      return 'Solar Panel';
    case TotalProductsField.totalAutoBatteryProduct:
      return 'Auto Battery';
    case TotalProductsField.totalPCUProduct:
      return 'PCU';
    default:
      return '';
  }
}

String getProductCategoryName(ProductsCategory category) {
  switch (category) {
    case ProductsCategory.battery:
      return 'Battery';
    case ProductsCategory.hkva:
      return 'HKVA';
    case ProductsCategory.hups:
      return 'HUPS';
    case ProductsCategory.nxg:
      return 'NXG';
    case ProductsCategory.solarBattery:
      return 'Solar Battery';
    case ProductsCategory.cruze:
      return 'CRUZE';
    case ProductsCategory.regalia:
      return 'Regalia';
    case ProductsCategory.gti:
      return 'GTI';
    case ProductsCategory.solarPanel:
      return 'Solar Panel';
    case ProductsCategory.autoBattery:
      return 'Auto Battery';
    case ProductsCategory.pcu:
      return 'PCU';
    default:
      return '';
  }
}

String truncateText(String text, int maxLength) {
  if (text.length <= maxLength) {
    return text;
  }
  return text.substring(0, maxLength) + '\n' + text.substring(maxLength);
}

Map<String, dynamic> fetchProductsList(
    DealerSummaryController dealerSummaryController, int index) {
  if (dealerSummaryController.dealerSummaryList.isNotEmpty) {
    final Map<String, dynamic> productItems =
        dealerSummaryController.dealerSummaryList[index];

    final Map<String, dynamic> totalProductsMap = {
      getProductCategoryName(ProductsCategory.battery): productItems['battery'],
      getProductCategoryName(ProductsCategory.hkva): productItems['hkva'],
      getProductCategoryName(ProductsCategory.hups): productItems['hups'],
      getProductCategoryName(ProductsCategory.nxg): productItems['nxg'],
      getProductCategoryName(ProductsCategory.solarBattery): productItems['solarBattery'],
      getProductCategoryName(ProductsCategory.gti): productItems['gti'],
      getProductCategoryName(ProductsCategory.regalia): productItems['regalia'],
      getProductCategoryName(ProductsCategory.cruze): productItems['cruze'],
      getProductCategoryName(ProductsCategory.solarPanel): productItems['solarPanel'],
      getProductCategoryName(ProductsCategory.autoBattery): productItems['autoBattery'],
      getProductCategoryName(ProductsCategory.pcu): productItems['pcu']

    };
    final Map<String, dynamic> filteredProductsMap = Map.fromEntries(
        totalProductsMap.entries
            .where((entry) => entry.value != null && entry.value != 0));

    return filteredProductsMap;
  }
  return {};
}

Map<ProductsCategory, dynamic> fetchProductsListForCustomer(
    CustomerWiseListController customerWiseListController, int index) {
  if (customerWiseListController.tertiarySaleList.isNotEmpty) {
    final Map<String, dynamic> productItems =
        customerWiseListController.tertiarySaleList[index];

    final Map<ProductsCategory, dynamic> totalProductsMap = {
      ProductsCategory.battery: productItems['battery'],
      ProductsCategory.hkva: productItems['hkva'],
      ProductsCategory.hups: productItems['hups'],
      ProductsCategory.nxg: productItems['nxg'],
      ProductsCategory.solarBattery: productItems['solarBattery'],
      ProductsCategory.gti: productItems['gti'],
      ProductsCategory.regalia: productItems['regalia'],
      ProductsCategory.cruze: productItems['cruze'],
      ProductsCategory.solarPanel: productItems['solarPanel'],
      ProductsCategory.autoBattery: productItems['autoBattery'],
      ProductsCategory.pcu: productItems['pcu']
    };
    final Map<ProductsCategory, dynamic> filteredProductsMap = Map.fromEntries(
        totalProductsMap.entries
            .where((entry) => entry.value != null && entry.value != 0));

    return filteredProductsMap;
  }
  return {};
}

String formatNameInReport(String name) {
  List<String> words = name.split(' ');
  List<String> formattedWords = [];

  for (String word in words) {
    if (word.isNotEmpty) {
      formattedWords
          .add(word[0].toUpperCase() + word.substring(1).toLowerCase());
    }
  }

  return formattedWords.join(' ');
}

Map<ProductsCategory, dynamic> fetchOriginalProductsList(
    ProductWiseDetailsController productWiseDetailsController, int index) {
  if (productWiseDetailsController.productWiseDetailsList.isNotEmpty) {
    final Map<String, dynamic> productItems =
        productWiseDetailsController.productWiseDetailsList[index];

    final Map<ProductsCategory, dynamic> totalProductsMap = {
      ProductsCategory.battery: productItems['battery'],
      ProductsCategory.hkva: productItems['hkva'],
      ProductsCategory.hups: productItems['hups'],
      ProductsCategory.nxg: productItems['nxg'],
      ProductsCategory.solarBattery: productItems['solarBattery'],
      ProductsCategory.gti: productItems['gti'],
      ProductsCategory.regalia: productItems['regalia'],
      ProductsCategory.cruze: productItems['cruze'],
      ProductsCategory.solarPanel: productItems['solarPanel'],
      ProductsCategory.autoBattery: productItems['autoBattery'],
      ProductsCategory.pcu: productItems['pcu']
    };
    final Map<ProductsCategory, dynamic> filteredProductsMap = Map.fromEntries(
        totalProductsMap.entries
            .where((entry) => entry.value != null && entry.value != 0));

    return filteredProductsMap;
  }
  return {};
}

Map<TotalProductsField, dynamic> fetchProductsDealerWise(
    ProductWiseDetailsController pc) {
  if (pc.productWiseDetailsList.isNotEmpty) {
    final Map<String, dynamic> firstItem = pc.productWiseDetailsList.first;

    final Map<TotalProductsField, dynamic> totalProductsMap = {
      TotalProductsField.totalBatteryProduct: firstItem['totalBatteryProduct'],
      TotalProductsField.totalHKVAProduct: firstItem['totalHKVAProduct'],
      TotalProductsField.totalHUPSProduct: firstItem['totalHUPSProduct'],
      TotalProductsField.totalNXGProduct: firstItem['totalNXGProduct'],
      TotalProductsField.totalSolarBatteryProduct:
          firstItem['totalSolarBatteryProduct'],
      TotalProductsField.totalGTIProduct: firstItem['totalGTIProduct'],
      TotalProductsField.totalRegaliaProduct: firstItem['totalRegaliaProduct'],
      TotalProductsField.totalSolarPanelProduct: firstItem['totalSolarPanelProduct'],
      TotalProductsField.totalAutoBatteryProduct: firstItem['totalAutoBatteryProduct'],
      TotalProductsField.totalPCUProduct: firstItem['totalPCUProduct'],
      TotalProductsField.totalCRUZEProduct: firstItem['totalCRUZEProduct']
    };
    final Map<TotalProductsField, dynamic> filteredProductsMap =
        Map.fromEntries(totalProductsMap.entries
            .where((entry) => entry.value != null && entry.value != 0));

    return filteredProductsMap;
  }
  return {};
}

Map<TotalProductsField, dynamic> fetchProductsCustomerWise(
     TertiaryCustomerWiseProduct tertiaryCustomerWiseProductController) {
  if (tertiaryCustomerWiseProductController.tertiaryCustomerWiseProductsList.isNotEmpty) {
    final Map<String, dynamic> firstItem = tertiaryCustomerWiseProductController.tertiaryCustomerWiseProductsList.first;

    final Map<TotalProductsField, dynamic> totalProductsMap = {
      TotalProductsField.totalBatteryProduct: firstItem['totalBatteryProduct'],
      TotalProductsField.totalHKVAProduct: firstItem['totalHKVAProduct'],
      TotalProductsField.totalHUPSProduct: firstItem['totalHUPSProduct'],
      TotalProductsField.totalNXGProduct: firstItem['totalNXGProduct'],
      TotalProductsField.totalSolarBatteryProduct:
          firstItem['totalSolarBatteryProduct'],
      TotalProductsField.totalCRUZEProduct:
          firstItem['totalCRUZEProduct'],
      TotalProductsField.totalRegaliaProduct:
          firstItem['totalRegaliaProduct'],
    };
    final Map<TotalProductsField, dynamic> filteredProductsMap =
        Map.fromEntries(totalProductsMap.entries
            .where((entry) => entry.value != null && entry.value != 0));

    return filteredProductsMap;
  }
  return {};
}

PrimaryReportTypes getReportTypeEnum(String reportTypeString) {
  switch (reportTypeString) {
    case 'Primary Billing Report':
      return PrimaryReportTypes.primaryBillingReport;
    case 'Customer Ledger Report':
      return PrimaryReportTypes.customerLedgerReport;
    case 'Credit/ Debit Note Report':
      return PrimaryReportTypes.creditDebitNoteReport;
    default:
      return PrimaryReportTypes.primaryBillingReport; // or handle default case accordingly
  }
}

String getReportTypeString(PrimaryReportTypes reportType) {
  switch (reportType) {
    case PrimaryReportTypes.primaryBillingReport:
      return 'Primary Billing Report';
    case PrimaryReportTypes.customerLedgerReport:
      return 'Customer Ledger Report';
    case PrimaryReportTypes.creditDebitNoteReport:
      return 'Credit Debit Note Report';
    default:
      return '';
  }
}
