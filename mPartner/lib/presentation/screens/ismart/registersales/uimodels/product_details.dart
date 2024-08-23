class ProductDetails {
  final String serialNoCount;
  final String status;
  final String remark;
  final String productName;
  final String primaryDetail;
  final String productType;
  final String modelName;
  final int wrsPoint;
  int? coinPoint;
  final String registeredOn;

  ProductDetails({
    required this.serialNoCount,
    required this.remark,
    required this.productName,
    required this.primaryDetail,
    required this.productType,
    required this.modelName,
    required this.wrsPoint,
    this.coinPoint,
    required this.status,
    required this.registeredOn,
  });

  @override
  String toString() {
    return '$serialNoCount, $status, $productName, $wrsPoint, $coinPoint';
  }
}
