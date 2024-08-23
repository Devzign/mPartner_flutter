part of 'pricelist_bloc.dart';

sealed class PricelistEvent extends Equatable {
  const PricelistEvent();

  @override
  List<Object> get props => [];
}

class PriceListFetchEvent extends PricelistEvent {}
