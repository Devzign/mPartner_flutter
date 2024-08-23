class CustomerwiseListItem {
  String customerName = "";
  String customerPhone = "";
  String customerAddress = "";
  int totalProducts = 0;
  Map<String, int> products = {};

  CustomerwiseListItem ({
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
    required this.totalProducts,
    required this.products,
  });
}