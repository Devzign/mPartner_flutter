part of 'secondary_sales_bloc.dart';

@immutable
abstract class SecondarySalesEvent extends Equatable{
  const SecondarySalesEvent();

  @override
  List<Object> get props => [];
}

class GetDealerListEvent extends SecondarySalesEvent{}
