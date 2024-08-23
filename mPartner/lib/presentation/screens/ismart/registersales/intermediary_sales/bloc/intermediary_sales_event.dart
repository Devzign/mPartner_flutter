part of 'intermediary_sales_bloc.dart';

@immutable
abstract class IntermediarySalesEvent extends Equatable{
  const IntermediarySalesEvent();

  @override
  List<Object> get props => [];
}

class GetElectricianListEvent extends IntermediarySalesEvent{}
