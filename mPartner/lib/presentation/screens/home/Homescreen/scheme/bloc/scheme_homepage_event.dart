part of 'scheme_homepage_bloc.dart';

abstract class SchemeHomepageBlocEvent extends Equatable {
  LuminuousUserType customertype;
  SchemeHomepageBlocEvent({required this.customertype});

  @override
  List<Object> get props => [customertype];
}

class SchemeHomepageFetchEvent extends SchemeHomepageBlocEvent {
  SchemeHomepageFetchEvent({required super.customertype});
}
