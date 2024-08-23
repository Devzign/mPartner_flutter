


import 'package:equatable/equatable.dart';

class StateInfo extends Equatable {

  final String? id;
  final String? name;

  const StateInfo({
    required this.id,
    required this.name,
  });

  @override
  List<Object> get props => [
    id??"",
    name??"",

  ];

  factory StateInfo.fromJson(Map<String, dynamic> json) => StateInfo(
    id: json["stateId"],
    name: json["stateName"],

  );
}

class DistrictInfo extends Equatable {

  final String? id;
  final String? name;

  const DistrictInfo({
    required this.id,
    required this.name,
  });

  @override
  List<Object> get props => [
    id??"",
    name??"",

  ];

  factory DistrictInfo.fromJson(Map<String, dynamic> json) => DistrictInfo(
    id: json["districtId"].toString(),
    name: json["districtName"],

  );
}


class CityInfo extends Equatable {

  final String? id;
  final String? name;

  const CityInfo({
    required this.id,
    required this.name,
  });

  @override
  List<Object> get props => [
    id??"",
    name??"",

  ];

  factory CityInfo.fromJson(Map<String, dynamic> json) => CityInfo(
    id: json["districtId"].toString(),
    name: json["cityName"],

  );
}

class GovtIdTypeInfo extends Equatable {

  final String? id;
  final String? name;

  const GovtIdTypeInfo({
    required this.id,
    required this.name,
  });

  @override
  List<Object> get props => [
    id??"",
    name??"",

  ];

  factory GovtIdTypeInfo.fromJson(Map<String, dynamic> json) => GovtIdTypeInfo(
    id: json["id"].toString(),
    name: json["docname"],

  );
}
