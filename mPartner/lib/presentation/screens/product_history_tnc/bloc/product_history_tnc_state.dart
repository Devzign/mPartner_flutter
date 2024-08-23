import 'package:equatable/equatable.dart';

import '../../../../data/models/terms_condition_model.dart';
import '../model/purchase_product_history_response_model.dart';


abstract class ProductHistoryTncState extends Equatable {
  const ProductHistoryTncState();

  @override
  List<Object?> get props => [];
}

class InitialState extends ProductHistoryTncState {}

class LoadingState extends ProductHistoryTncState {}
class NewDataState extends ProductHistoryTncState {}

class ProductHistoryTncResponseState extends ProductHistoryTncState {
  final PurchaseProductHistoryResponseModel responseModel;
  final TermsConditionsResponse termsConditionsResponse;

  const ProductHistoryTncResponseState(this.responseModel,this.termsConditionsResponse);

  @override
  List<Object> get props => [responseModel,termsConditionsResponse];
}

class TncResponseState extends ProductHistoryTncState {

  const TncResponseState();

  @override
  List<Object> get props => [];
}

class NoInternetConnection extends ProductHistoryTncState {}

class ErrorDataState extends ProductHistoryTncState {
  final String errorMsg;
  const ErrorDataState(this.errorMsg);
}

class ErrorState extends ProductHistoryTncState {
  final String errorMsg;
  const ErrorState(this.errorMsg);

  @override
  List<Object?> get props => [errorMsg];

  @override
  String toString() => 'STATIC_LINK_API_ERROR { error: $errorMsg }';
}
