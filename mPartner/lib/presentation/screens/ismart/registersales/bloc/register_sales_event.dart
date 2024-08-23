part of 'register_sales_bloc.dart';

@immutable
abstract class RegisterSalesEvent extends Equatable{
  const RegisterSalesEvent();

  @override
  List<Object> get props => [];
}

class GetSaleTypeEvent extends RegisterSalesEvent{}
