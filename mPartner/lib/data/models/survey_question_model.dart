import 'package:equatable/equatable.dart';

enum QuestionType {
  radioButton,
  starRating,
  checkbox,
  unknown,
}

class SurveyQuestionsResponse extends Equatable {
  final String message;
  final String status;
  final String token;
  final int data;
  final List<SurveyQuestions> data1;

  SurveyQuestionsResponse({
    required this.message,
    required this.status,
    required this.token,
    required this.data,
    required this.data1,
  });

  factory SurveyQuestionsResponse.fromJson(Map<String, dynamic> json) {
    var dataList = json["data1"] as List;
    List<SurveyQuestions> parsedDataList =
    dataList.map((data) => SurveyQuestions.fromJson(data)).toList();

    return SurveyQuestionsResponse(
      message: json["message"],
      status: json["status"],
      token: json["token"],
      data: json["data"],
      data1: parsedDataList,
    );
  }

  @override
  List<Object?> get props => [message, status, token, data, data1];
}

class SurveyQuestions extends Equatable {
  final int? id;
  final QuestionType? type;
  final int? questionNo;
  final String? title;
  final String? optionA;
  final String? optionB;
  final String? optionC;
  final String? optionD;
  final String? optionE;
  final String? usertype;

  SurveyQuestions({
    required this.id,
    required this.type,
    required this.questionNo,
    required this.title,
    required this.optionA,
    required this.optionB,
    required this.optionC,
    required this.optionD,
    required this.optionE,
    required this.usertype,
  });

  factory SurveyQuestions.fromJson(Map<String, dynamic> json) {
    QuestionType? questionType;

    switch (json["type"]) {
      case "radioButton":
        questionType = QuestionType.radioButton;
        break;
      case "starRating":
        questionType = QuestionType.starRating;
        break;
      case "checkbox":
        questionType = QuestionType.checkbox;
        break;
      default:
        questionType = QuestionType.unknown;
    }

    return SurveyQuestions(
      id: json["id"],
      type: questionType,
      questionNo: json["questionNo"],
      title: json["title"],
      optionA: json["optionA"],
      optionB: json["optionB"],
      optionC: json["optionC"],
      optionD: json["optionD"],
      optionE: json["optionE"],
      usertype: json["usertype"],
    );
  }

  @override
  List<Object?> get props => [
    id,
    type,
    questionNo,
    title,
    optionA,
    optionB,
    optionC,
    optionD,
    optionE,
    usertype
  ];
}

