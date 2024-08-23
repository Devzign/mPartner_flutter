import 'dart:convert';

class ProductWiseDetails {
    String productModel;
    String productSerialNumber;
    String systemStatus;
    String systemRemark;
    String primaryDate;
    String secondaryDate;
    String tertiaryDate;
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

    ProductWiseDetails({
        required this.productModel,
        required this.productSerialNumber,
        required this.systemStatus,
        required this.systemRemark,
        required this.primaryDate,
        required this.secondaryDate,
        required this.tertiaryDate,
        required this.battery,
        required this.hkva,
        required this.gti,
        required this.regalia,
        required this.solarPanel,
        required this.autoBattery,
        required this.pcu,
        required this.cruze,
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
        productModel,
        productSerialNumber,
        systemStatus,
        systemRemark,
        primaryDate,
        secondaryDate,
        tertiaryDate,
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
        totalGTIProduct,
        totalRegaliaProduct,
        totalSolarPanelProduct,
        totalAutoBatteryProduct,
        totalPCUProduct,
        totalCRUZEProduct,
        totalHkvaProduct,
        totalHupsProduct,
        totalNxgProduct,
        totalSolarBatteryProduct,
        totalProducts
      ];

    factory ProductWiseDetails.fromJson(Map<String, dynamic> json) => ProductWiseDetails(
        productModel: json["product_Model"] ?? "",
        productSerialNumber: json["product_Serial_Number"] ?? "",
        systemStatus: json["systemStatus"] ?? "",
        systemRemark: json["systemRemark"] ?? "N/A",
        primaryDate: json["primary_Date"] ?? "N/A",
        secondaryDate: json["secondaryDate"] ?? "N/A",
        tertiaryDate: json["tertiaryDate"] ?? "N/A",
        battery: json["battery"] ?? 0,
        gti: json['gti'] ?? 0,
        regalia: json['regalia'] ?? 0,
        cruze: json['cruze'] ?? 0,
        solarPanel: json['solarPanel'] ?? 0,
        autoBattery: json['autoBattery'] ?? 0,
        pcu: json['pcu'] ?? 0,
        hkva: json["hkva"] ?? 0,
        hups: json["hups"] ?? 0,
        nxg: json["nxg"] ?? 0,
        solarBattery: json["solarBattery"] ?? 0,
        totalProduct: json["totalProduct"] ?? 0,
        totalBatteryProduct: json["totalBatteryProduct"] ?? 0,
        totalGTIProduct: json["totalGTIProduct"] ?? 0,
        totalRegaliaProduct: json["totalRegaliaProduct"] ?? 0,
        totalSolarPanelProduct: json["totalSolarPanelProduct"],
        totalAutoBatteryProduct: json["totalAutoBatteryProduct"] ?? 0,
        totalPCUProduct: json['totalPCUProduct'] ?? 0,
        totalCRUZEProduct: json['totalCRUZEProduct'],
        totalHkvaProduct: json["totalHKVAProduct"] ?? 0,
        totalHupsProduct: json["totalHUPSProduct"] ?? 0,
        totalNxgProduct: json["totalNXGProduct"] ?? 0,
        totalSolarBatteryProduct: json["totalSolarBatteryProduct"] ?? 0,
        totalProducts: json["totalProducts"],
    );

    Map<String, dynamic> toJson() => {
        "product_Model": productModel,
        "product_Serial_Number": productSerialNumber,
        "systemStatus": systemStatus,
        "systemRemark": systemRemark,
        "primary_Date": primaryDate,
        "secondaryDate": secondaryDate,
        "tertiaryDate": tertiaryDate,
        "battery": battery,
        "gti": gti,
        "regalia" : regalia,
        "cruze" : cruze,
        "solarPanel": solarPanel,
        "autoBattery" : autoBattery,
        "pcu" : pcu,
        "hkva": hkva,
        "hups": hups,
        "nxg": nxg,
        "solarBattery": solarBattery,
        "totalProduct": totalProduct,
        "totalBatteryProduct": totalBatteryProduct,
        "totalGTIProduct" : totalGTIProduct,
        "totalRegaliaProduct": totalRegaliaProduct,
        "totalCRUZEProduct": totalCRUZEProduct,
        "totalSolarPanelProduct": totalSolarPanelProduct,
        "totalAutoBatteryProduct": totalAutoBatteryProduct,
        "totalPCUProduct": totalPCUProduct,
        "totalHKVAProduct": totalHkvaProduct,
        "totalHUPSProduct": totalHupsProduct,
        "totalNXGProduct": totalNxgProduct,
        "totalSolarBatteryProduct": totalSolarBatteryProduct,
        "totalProducts": totalProducts,
    };
}
