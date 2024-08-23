class GemOption {
  final int id;
  final String name;

  GemOption({
    required this.id,
    required this.name,
  });

  factory GemOption.fromJson(Map<String, dynamic> json) {
    return GemOption(
      id: json['nLookUPID'] ?? 0,
      name: json['sLookUpValue'] ?? '',
    );
  }
}
