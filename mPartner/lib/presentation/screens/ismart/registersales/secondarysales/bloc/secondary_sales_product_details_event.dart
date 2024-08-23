part of 'secondary_sales_product_details_bloc.dart';

@immutable
abstract class SecondarySalesProductDetailsEvent extends Equatable{
  final String serialNo;
  final String dealerCode;
  final String saleDate;

  const SecondarySalesProductDetailsEvent({required this.serialNo, required this.dealerCode, required this.saleDate});

  @override
  List<Object> get props => [serialNo,dealerCode, saleDate];
}

class GetProductDetailsListEvent extends SecondarySalesProductDetailsEvent{
  GetProductDetailsListEvent({required super.serialNo,
    required super.dealerCode,
    required super.saleDate});
}
