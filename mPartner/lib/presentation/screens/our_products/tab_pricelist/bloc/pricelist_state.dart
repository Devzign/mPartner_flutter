part of 'pricelist_bloc.dart';

class PricelistState extends Equatable {
  final List<Pricelist> pricelistScreenData;
  final RequestState pricelistScreenState;
  final String pricelistScreenMessage;

  const PricelistState({
    this.pricelistScreenData = const [],
    this.pricelistScreenState = RequestState.loading,
    this.pricelistScreenMessage = '',
  });
  PricelistState copyWith({
    List<Pricelist>? pricelistScreenData,
    RequestState? pricelistScreenState,
    String? pricelistScreenMessage,
  }) {
    return PricelistState(
      pricelistScreenData: pricelistScreenData ?? this.pricelistScreenData,
      pricelistScreenState: pricelistScreenState ?? this.pricelistScreenState,
      pricelistScreenMessage:
          pricelistScreenMessage ?? this.pricelistScreenMessage,
    );
  }

  @override
  List<Object?> get props => [
        pricelistScreenData,
        pricelistScreenState,
        pricelistScreenMessage,
      ];
}

final class PricelistInitial extends PricelistState {}
