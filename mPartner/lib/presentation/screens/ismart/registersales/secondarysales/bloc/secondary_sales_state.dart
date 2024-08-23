part of 'secondary_sales_bloc.dart';

class SecondarySalesState extends Equatable {

  final List<Dealer> dealerListData;
  final RequestState dealerListState;
  final String dealerListMessage;

  const SecondarySalesState({
    this.dealerListData = const [],
    this.dealerListState = RequestState.loading,
    this.dealerListMessage = '',
  });
  SecondarySalesState copyWith({

    List<Dealer>? dealerListData,
    RequestState? dealerListState,
    String? dealerListMessage,

  }){
    return SecondarySalesState(
      dealerListData: dealerListData ?? this.dealerListData,
      dealerListState: dealerListState ?? this.dealerListState,
      dealerListMessage: dealerListMessage ?? this.dealerListMessage,
    );
  }
  @override
  List<Object?> get props => [
    dealerListData,
    dealerListState,
    dealerListMessage,
  ];
}

