part of 'register_sales_bloc.dart';

class RegisterSalesState extends Equatable {

  final List<SaleType> saleTypeData;
  final RequestState getSaleTypeState;
  final String getSaleTypeMessage;

  const RegisterSalesState({
    this.saleTypeData = const [],
    this.getSaleTypeState = RequestState.loading,
    this.getSaleTypeMessage = '',
  });
  RegisterSalesState copyWith({

    List<SaleType>? saleTypeData,
    RequestState? getSaleTypeState,
    String? getSaleTypeMessage,

  }){
    return RegisterSalesState(
      saleTypeData: saleTypeData ?? this.saleTypeData,
      getSaleTypeState: getSaleTypeState ?? this.getSaleTypeState,
      getSaleTypeMessage: getSaleTypeMessage ?? this.getSaleTypeMessage,
    );
  }
  @override
  List<Object?> get props => [
    saleTypeData,
    getSaleTypeState,
    getSaleTypeMessage,
  ];
}

