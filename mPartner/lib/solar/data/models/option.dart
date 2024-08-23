class Option {
  final int id;
  final String name;

  Option({
    required this.id,
    required this.name,
  });

  factory Option.fromJson(Map<String, dynamic> json) {
    // String idKey = ''; 
    // String nameKey = ''; 

    // if (json.containsKey('solutionTypeId') && json.containsKey('solutionTypeName')) {
    //   idKey = 'solutionTypeId';
    //   nameKey = 'solutionTypeName';
    // } else if (json.containsKey('avgEnergyConsumptionId') && json.containsKey('avgEnergyConsumptionName')) {
    //   idKey = 'avgEnergyConsumptionId';
    //   nameKey = 'avgEnergyConsumptionName';
    // } else {
    //   throw const FormatException('Invalid JSON structure for Option');
    // }

    return Option(
      id: json['nLookUPID'] ?? 0,
      name: json['sLookUpValue'] ?? '',
    );
  }
}
