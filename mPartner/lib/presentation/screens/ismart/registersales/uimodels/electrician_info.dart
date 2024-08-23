class ElectricianInfo {
  final String electricianName;
  final String disCode;
  final String electricianCity;
  final String electricianCountry;

  ElectricianInfo({
    required this.electricianName,
    required this.disCode,
    required this.electricianCity,
    required this.electricianCountry});

  @override
  String toString() {
    return '$electricianName, $disCode, $electricianCity, $electricianCountry';
  }

}
