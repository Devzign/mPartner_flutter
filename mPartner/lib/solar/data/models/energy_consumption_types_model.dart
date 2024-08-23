import 'option.dart';

class EnergyConsumptionTypeResponse {
  final String message;
  final String status;
  final String token;
  final List<Option> data;

  EnergyConsumptionTypeResponse({
    required this.message,
    required this.status,
    required this.token,
    required this.data,
  });

  factory EnergyConsumptionTypeResponse.fromJson(Map<String, dynamic> json) {
    List<dynamic> dataList = json['data'];
    List<Option> energyConsumptionTypes =
        dataList.map((item) => Option.fromJson(item)).toList();

    return EnergyConsumptionTypeResponse(
      message: json['message']??"",
      status: json['status']??"",
      token: json['token']??"",
      data: energyConsumptionTypes,
    );
  }
}
