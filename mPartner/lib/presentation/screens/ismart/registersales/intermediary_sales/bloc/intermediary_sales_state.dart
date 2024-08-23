part of 'intermediary_sales_bloc.dart';

class IntermediarySalesState extends Equatable {
  final List<Electrician> electricianListData;
  final RequestState electricianListState;
  final String electricianListMessage;

  const IntermediarySalesState({
    this.electricianListData = const [],
    this.electricianListState = RequestState.loading,
    this.electricianListMessage = '',
  });
  IntermediarySalesState copyWith({

    List<Electrician>? electricianListData,
    RequestState? electricianListState,
    String? electricianListMessage,

  }){
    return IntermediarySalesState(
      electricianListData: electricianListData ?? this.electricianListData,
      electricianListState: electricianListState ?? this.electricianListState,
      electricianListMessage: electricianListMessage ?? this.electricianListMessage,
    );
  }
  @override
  List<Object?> get props => [
    electricianListData,
    electricianListState,
    electricianListMessage,
  ];
}

