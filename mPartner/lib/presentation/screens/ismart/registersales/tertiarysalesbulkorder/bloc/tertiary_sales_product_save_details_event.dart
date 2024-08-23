part of 'tertiary_sales_product_save_details_bloc.dart';

@immutable
abstract class TertiarySalesProductSaveDetailsEvent extends Equatable{
  final String serialNo;
  final CustomerInfo customerInfo;

  const TertiarySalesProductSaveDetailsEvent({
    required this.serialNo,
    required this.customerInfo});

  @override
  List<Object> get props => [serialNo,customerInfo];
}

class GetTertiaryBulkProductSaveEvent extends TertiarySalesProductSaveDetailsEvent{
  final String eW_ViaVerified;
  final String eW_OTP;
  final String transId;

  GetTertiaryBulkProductSaveEvent( {
    required this.eW_ViaVerified,
    required this.eW_OTP,
    required this.transId,
    required super.serialNo,
    required super.customerInfo});

  @override
  List<Object> get props => [eW_ViaVerified,eW_OTP,transId];
}
