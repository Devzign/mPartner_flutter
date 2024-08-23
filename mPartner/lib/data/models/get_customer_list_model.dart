import 'package:equatable/equatable.dart';

class Customer extends Equatable {
  final String customer_Name;
  final String customer_Phone;
  final String customer_Address;

  const Customer(
      {required this.customer_Name,
        required this.customer_Phone,
        required this.customer_Address});

  @override
  List<Object?> get props => [
    customer_Name,
    customer_Phone,
    customer_Address
  ];

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      customer_Name: json['customer_Name'] ?? '',
      customer_Phone: json['customer_Phone'] ?? '',
      customer_Address: json['customer_Address'] ?? '',
    );
  }
}
