import 'package:equatable/equatable.dart';

class Language extends Equatable {
  final int id;
  final String language;
  final String languagecode;

  const Language({
    required this.id,
    required this.language,
    required this.languagecode,
  });

  @override
  List<Object> get props => [
        id,
        language,
        languagecode,
      ];

  factory Language.fromJson(Map<String, dynamic> json) => Language(
        id: json["id"],
        language: json["language"],
        languagecode: json["languagecode"],
      );
}
