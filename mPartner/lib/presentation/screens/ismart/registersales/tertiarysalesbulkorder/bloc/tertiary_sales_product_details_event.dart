part of 'tertiary_sales_product_details_bloc.dart';

@immutable
abstract class TertiarySalesProductDetailsEvent extends Equatable{
  final String serialNo;
  final CustomerInfo customerInfo;

  const TertiarySalesProductDetailsEvent({
    required this.serialNo,
    required this.customerInfo});

  @override
  List<Object> get props => [serialNo,customerInfo];
}

class GetTertiaryBulkProductDetailsListEvent extends TertiarySalesProductDetailsEvent{
  GetTertiaryBulkProductDetailsListEvent({
    required super.serialNo,
    required super.customerInfo});
}

