part of 'intermediary_sales_product_details_bloc.dart';

@immutable
abstract class IntermediarySalesProductDetailsEvent extends Equatable{
  final String serialNo;
  final String electricianCode;
  final String saleDate;

  const IntermediarySalesProductDetailsEvent({required this.serialNo, required this.electricianCode, required this.saleDate});

  @override
  List<Object> get props => [serialNo,electricianCode, saleDate];
}

class GetIntermediaryProductDetailsListEvent extends IntermediarySalesProductDetailsEvent{
  GetIntermediaryProductDetailsListEvent({required super.serialNo,
    required super.electricianCode,
    required super.saleDate});
}
