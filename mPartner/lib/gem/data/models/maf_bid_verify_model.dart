import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class MafBidVerifyModel extends Equatable {
  final String? message;
  final String? status;
  final String? token;
  final String? gstStatus;


  const MafBidVerifyModel(
      {this.message,
        this.token,
        this.gstStatus,
        this.status
      });

  @override
  List<Object> get props => [
    message ?? "",
    token ?? "",
    gstStatus ?? "",
    status ?? "",
  ];

  factory MafBidVerifyModel.fromJson(
      Map<String, dynamic> json) {
    return  MafBidVerifyModel(
      message: json["message"],
      token: json["token"],
      gstStatus: json["gstStatus"],
      status: json["status"],

    );
  }
}

String converDateStringToFormatDate(String dateString) {
  DateTime tempDate = new DateFormat("yyyy-MM-ddThh:mm:ss").parse(dateString);
  String date = DateFormat("MMM dd, yyyy hh:mm a").format(tempDate);
  return date;
}
