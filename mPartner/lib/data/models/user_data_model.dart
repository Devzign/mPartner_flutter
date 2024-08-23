import 'package:equatable/equatable.dart';

class UserData extends Equatable {
  final String id;
  final String type;
  final String name;
  final String city;
  final String message;
  final String type_Child_Parent;
  final String profileImage;

  const UserData({
    required this.id,
    required this.type,
    required this.name,
    required this.city,
    required this.message,
    required this.type_Child_Parent,
    required this.profileImage,
  });

  @override
  List<Object> get props => [id, type, name, city, message, type_Child_Parent];

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        id: json["id"],
        type: json["type"],
        name: json["name"],
        city: json["city"],
        message: json["message"],
        type_Child_Parent: json["type_Child_Parent"],
        profileImage: json["profileImage"]
      );
}

class GetUserDataParameters extends Equatable {
  final String phoneNumber;
  final String userId;
  final String token;

  const GetUserDataParameters(
      {required this.phoneNumber, required this.userId, required this.token});
  @override
  List<Object> get props => [phoneNumber, userId, token];
}
