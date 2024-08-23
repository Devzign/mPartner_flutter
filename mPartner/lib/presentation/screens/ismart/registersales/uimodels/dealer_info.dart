class DealerInfo {
  final String dealerName;
  final String disCode;
  final String dealerCity;
  final String dealerCountry;

  DealerInfo({
    required this.dealerName,
    required this.disCode,
    required this.dealerCity,
    required this.dealerCountry});

  @override
  String toString() {
    return '$dealerName, $disCode, $dealerCity, $dealerCountry';
  }

}
