class SecondaryReportDistributorModel {
  String dlrName;
  String dlrCity;
  String dlrSapCode;
  int battery;
  int gti;
  int regalia;
  int cruze;
  int solarPanel;
  int autoBattery;
  int pcu;
  int hkva;
  int hups;
  int nxg;
  int solarBattery;
  int totalProduct;
  int totalBatteryProduct;
  int totalGTIProduct;
  int totalRegaliaProduct;
  int totalSolarPanelProduct;
  int totalAutoBatteryProduct;
  int totalPCUProduct;
  int totalCRUZEProduct;
  int totalHkvaProduct;
  int totalHupsProduct;
  int totalNxgProduct;
  int totalSolarBatteryProduct;
  int totalProducts;

  SecondaryReportDistributorModel({
    required this.dlrName,
    required this.dlrCity,
    required this.dlrSapCode,
    required this.battery,
    required this.gti,
    required this.regalia,
    required this.cruze,
    required this.solarPanel,
    required this.autoBattery,
    required this.pcu,
    required this.hkva,
    required this.hups,
    required this.nxg,
    required this.solarBattery,
    required this.totalProduct,
    required this.totalBatteryProduct,
    required this.totalGTIProduct,
    required this.totalRegaliaProduct,
    required this.totalSolarPanelProduct,
    required this.totalAutoBatteryProduct,
    required this.totalPCUProduct,
    required this.totalCRUZEProduct,
    required this.totalHkvaProduct,
    required this.totalHupsProduct,
    required this.totalNxgProduct,
    required this.totalSolarBatteryProduct,
    required this.totalProducts,
  });

  @override
  List<Object?> get props => [
        dlrName,
        dlrCity,
        dlrSapCode,
        battery,
        gti,
        regalia,
        cruze,
        solarPanel,
        autoBattery,
        pcu,
        hkva,
        hups,
        nxg,
        solarBattery,
        totalProduct,
        totalBatteryProduct,
        totalHkvaProduct,
        totalHupsProduct,
        totalNxgProduct,
        totalSolarBatteryProduct,
        totalProducts
      ];

  factory SecondaryReportDistributorModel.fromJson(Map<String, dynamic> json) {
    return SecondaryReportDistributorModel(
      dlrName: json["dlr_Name"] ?? "",
      dlrCity: json["dlr_City"] ?? "",
      dlrSapCode: json["dlr_Sap_Code"] ?? "",
      battery: json["battery"] ?? 0,
      gti: json["gti"] ?? 0,
      regalia: json["regalia"] ?? 0,
      cruze:json["cruze"] ?? 0,
      solarPanel: json["solarPanel"] ?? 0,
      autoBattery: json['autoBattery'] ?? 0,
      pcu: json["pcu"] ?? 0,
      hkva: json["hkva"] ?? 0,
      hups: json["hups"] ?? 0,
      nxg: json["nxg"] ?? 0,
      solarBattery: json["solarBattery"] ?? 0,
      totalProduct: json["totalProduct"] ?? 0,
      totalBatteryProduct: json["totalBatteryProduct"] ?? 0,
      totalGTIProduct: json["totalGTIProduct"] ?? 0,
      totalRegaliaProduct: json["totalRegaliaProduct"] ?? 0,
      totalSolarPanelProduct: json["totalSolarPanelProduct"] ?? 0,
      totalAutoBatteryProduct: json["totalAutoBatteryProduct"] ?? 0,
      totalPCUProduct: json["totalPCUProduct"] ?? 0,
      totalCRUZEProduct: json["totalCRUZEProduct"] ?? 0,
      totalHkvaProduct: json["totalHKVAProduct"] ?? 0,
      totalHupsProduct: json["totalHUPSProduct"] ?? 0,
      totalNxgProduct: json["totalNXGProduct"] ?? 0,
      totalSolarBatteryProduct: json["totalSolarBatteryProduct"] ?? 0,
      totalProducts: json["totalProducts"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "dlr_Name": dlrName,
      "dlr_City": dlrCity,
      "dlr_Sap_Code": dlrSapCode,
      "battery": battery,
      "gti" : gti,
      "regalia": regalia,
      "cruze" : cruze,
      "solarPanel" : solarPanel,
      "autoBattery": autoBattery,
      "pcu": pcu,
      "hkva": hkva,
      "hups": hups,
      "nxg": nxg,
      "solarBattery": solarBattery,
      "totalProduct": totalProduct,
      "totalBatteryProduct": totalBatteryProduct,
      "totalGTIProduct" : totalGTIProduct,
      "totalRegaliaProduct" : totalRegaliaProduct,
      "totalSolarPanelProduct" : totalSolarPanelProduct,
      "totalAutoBatteryProduct" : totalAutoBatteryProduct,
      "totalPCUProduct" : totalPCUProduct,
      "totalCRUZEProduct" : totalCRUZEProduct,
      "totalHKVAProduct": totalHkvaProduct,
      "totalHUPSProduct": totalHupsProduct,
      "totalNXGProduct": totalNxgProduct,
      "totalSolarBatteryProduct": totalSolarBatteryProduct,
      "totalProducts": totalProducts,
    };
  }
}




class SecondaryReport {
  String message;
  String status;
  String token;
  List<SecondaryReportListData> data;
  String data1;

  SecondaryReport({
    required this.message,
    required this.status,
    required this.token,
    required this.data,
    required this.data1,
  });

  List<Object?> get props => [message, status, token, data, data1];

  factory SecondaryReport.fromJson(Map<String, dynamic> json) => SecondaryReport(
    message: json["message"] ?? "",
    status: json["status"] ?? "",
    token: json["token"] ?? "",
    data: List<SecondaryReportListData>.from(
        json["data"].map((x) => SecondaryReportListData.fromJson(x))) ??
        [],
    data1: json["data1"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "message": message ?? "",
    "status": status ?? "",
    "token": token ?? "",
    "data": List<dynamic>.from(data.map((x) => x.toJson())) ?? [],
    "data1": data1 ?? "",
  };
}

class SecondaryReportListData {
  String dealerName;
  String dealerCode;
  String productType;
  String customerAddress;
  String secondarySaleDate;

  SecondaryReportListData({
    required this.dealerName,
    required this.dealerCode,
    required this.customerAddress,
    required this.productType,
    required this.secondarySaleDate,
  });

  List<Object?> get props => [
    dealerName,
    dealerCode,
    customerAddress,
    productType,
    secondarySaleDate
  ];

  factory SecondaryReportListData.fromJson(Map<String, dynamic> json) =>
      SecondaryReportListData(
          dealerName: json["dlr_Name"] ??json["customer_Name"] ?? "",
          dealerCode: json["dlr_Sap_Code"] ?? "",
          customerAddress: json["dlr_City"] ??json["customer_Address"] ?? "",
          productType: json['product_Type'] ??json['product_type'] ?? "",
        secondarySaleDate: json['modDate'] ?? json["secondarySaleDate"]??"",
      );

  Map<String, dynamic> toJson() => {
    "customer_Name": dealerName,
    "dlr_Sap_Code": dealerCode,
    "customer_Address": customerAddress,
    "product_type": productType,
    "secondarySaleDate": secondarySaleDate,
  };
}


class DealerwiseListItem {
  String customerName = "";
  String dealerCode = "";
  String customerAddress = "";
  int totalProducts = 0;
  Map<String, int> products = {};

  DealerwiseListItem ({
    required this.customerName,
    required this.dealerCode,
    required this.customerAddress,
    required this.totalProducts,
    required this.products,
  });
}
