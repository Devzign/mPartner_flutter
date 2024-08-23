import 'option.dart';

class SolutionTypeResponse {
  final String message;
  final String status;
  final String token;
  final List<Option> data;

  SolutionTypeResponse({
    required this.message,
    required this.status,
    required this.token,
    required this.data,
  });

  factory SolutionTypeResponse.fromJson(Map<String, dynamic> json) {
    List<dynamic> dataList = json['data'];
    List<Option> solutionTypes =
        dataList.map((item) => Option.fromJson(item)).toList();

    return SolutionTypeResponse(
      message: json['message']??"",
      status: json['status']??"",
      token: json['token']??"",
      data: solutionTypes,
    );
  }
}
