part of 'term_and_conditions_bloc.dart';

@immutable
abstract class TermsAndCondtionsEvent extends Equatable{
  final String dynamicPage;
  const TermsAndCondtionsEvent({required this.dynamicPage});

  @override
  List<Object> get props => [dynamicPage];
}

class TermsAndCondtionsEvents extends TermsAndCondtionsEvent{
  TermsAndCondtionsEvents({required super.dynamicPage});
}