part of 'product_bloc.dart';

sealed class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class CatalogFetchEvent extends ProductEvent {}

class UserTypeInitial extends ProductEvent {}

class ChangeUserType extends ProductEvent {
  ChangeUserType({required this.state});
  int state;
}

class ChangeMonthType extends ProductEvent {
  ChangeMonthType({required this.currMonth});
  String currMonth;
}
