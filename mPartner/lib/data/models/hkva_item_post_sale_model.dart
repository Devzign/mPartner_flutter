
class HvkaResponsePostSale{
  final String message;
  final String status;
  final String token;
  final List<HkvaItemPostSaleModel> data;
  final dynamic data1;

  HvkaResponsePostSale({
    required this.message,
    required this.status,
    required this.token,
    required this.data,
    required this.data1,
  });

  factory HvkaResponsePostSale.fromJson(Map<String, dynamic> json) {
    return HvkaResponsePostSale(
      message: json['message'] ?? '',
      status: json['status'] ?? '',
      token: json['token'] ?? '',
      data: (json['data']!=null || json['data']=='') ? List<HkvaItemPostSaleModel>.from(json['data'].map((x) => HkvaItemPostSaleModel.fromJson(x))):[],
      data1: json['data1'] ?? '',
    );
  }

}
class HkvaItemPostSaleModel {
   final String serialNo;
  final String status;
  final String msgType;
  final String modelName;
  final int capacity;
  final String wrsPoint;
  final String tripPoint;
  final String coinPoints;
  final String systemStatus;
  final int totalWRSAccepted;
  final int totalCoinsAccepted;
  final int totalWRSRejected;
  final int totalCoinsRejected;
  final int totalWRSPending;
  final int totalCoinsPending;
  final String productType;
  final String registeredOn;

  HkvaItemPostSaleModel({
    required this.serialNo,
    required this.status,
    required this.msgType,
    required this.modelName,
    required this.capacity,
    required this.wrsPoint,
    required this.tripPoint,
    required this.coinPoints,
    required this.systemStatus,
    required this.totalWRSAccepted,
    required this.totalCoinsAccepted,
    required this.totalWRSRejected,
    required this.totalCoinsRejected,
    required this.totalWRSPending,
    required this.totalCoinsPending,
    required this.productType,
    required this.registeredOn,
  });

  factory HkvaItemPostSaleModel.fromJson(Map<String, dynamic> json) {
    return HkvaItemPostSaleModel(
      serialNo: json['serialNo'] ?? '',
      status: json['status'] ?? '',
      msgType: json['msgType'] ?? '',
      modelName: json['modelName'] ?? '',
      capacity: json['capacity'] ?? 0,
      wrsPoint: json['wrsPoint'] ?? '',
      tripPoint: json['tripPoint'] ?? '',
      coinPoints: json['coin_Points'] ?? '',
      systemStatus: json['systemStatus']?? '',
      totalWRSAccepted: json['totalWRSAccepted']?? 0,
      totalCoinsAccepted: json['totalCoinsAccepted']?? 0,
      totalWRSRejected: json['totalWRSRejected']?? 0,
      totalCoinsRejected: json['totalCoinsRejected']?? 0,
      totalWRSPending: json['totalWRSPending']?? 0,
      totalCoinsPending: json['totalCoinsPending']?? 0,
      productType: json['productType']?? '',
      registeredOn: json['registeredOn']??'',
    );
  }
}