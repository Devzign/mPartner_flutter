import 'dart:convert';

class Relationship {
    String relationShipName;
    int count;

    Relationship({
        required this.relationShipName,
        required this.count,
    });

    @override
    List<Object> get props => [
      relationShipName,
      count
    ];

    factory Relationship.fromJson(Map<String, dynamic> json) => Relationship(
        relationShipName: json["relationShipName"] ?? "",
        count: json["count"] ?? 0,
    );

    Map<String, dynamic> toJson() => {
        "relationShipName": relationShipName,
        "count": count,
    };
}
