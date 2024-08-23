class CustomerInfo {
  final String customerName;
  final String mobileNo;
  final String? custAddress;
  final String? refCode;
  final String saleDate;
  final String saleTime;
  final String tertiarySaleType;

  CustomerInfo({
    required this.customerName,
    required this.mobileNo,
    required this.saleDate,
    required this.saleTime,
    required this.tertiarySaleType,
    this.custAddress,
    this.refCode});

  @override
  String toString() {
    return '$customerName, $mobileNo, $custAddress, $saleDate, $saleTime, $refCode, $tertiarySaleType';
  }

}
