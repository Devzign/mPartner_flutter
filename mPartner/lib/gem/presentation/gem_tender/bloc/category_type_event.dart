part of 'category_type_bloc.dart';

@immutable
abstract class CategoryTypeEvent extends Equatable{
  const CategoryTypeEvent();

  @override
  List<Object> get props => [];
}

class GetCategoryTypeEvent extends CategoryTypeEvent{}