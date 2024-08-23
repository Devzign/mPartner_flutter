import 'package:equatable/equatable.dart';

class NotificationPayload extends Equatable {
  final String navigationModule;
  final String transactionType;
  final String transactionId;
  final String body;
  final String otherData;

  const NotificationPayload(
      {required this.navigationModule,
      required this.transactionType,
      required this.transactionId,
      required this.body,
      required this.otherData});

  @override
  List<Object> get props => [navigationModule, transactionType, transactionId, body, otherData];

  factory NotificationPayload.fromJson(Map<String, dynamic> json) =>
      NotificationPayload(
          navigationModule: json["NavigationModule"] ?? '',
          transactionType: json["transactionType"] ?? '',
          transactionId: json["transactionId"] ?? '',
          body: json['body'] ?? '',
          otherData: json['otherData'] ?? '');
}
