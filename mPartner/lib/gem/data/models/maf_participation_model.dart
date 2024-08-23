import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import '../../../presentation/screens/network_management/dealer_electrician/components/common_network_utils.dart';
import '../../../solar/data/models/option.dart';
import 'gem_option.dart';

// class MafParticipationModel extends Equatable {
//   final int? nLookUPID;
//   final String? sLookUpValue;
//
//   const MafParticipationModel({
//     this.sLookUpValue,
//     this.nLookUPID,
//   });
//   @override
//   List<Object> get props => [
//         sLookUpValue ?? "Gem Tender",
//         nLookUPID ?? 0,
//       ];
//   factory MafParticipationModel.fromJson(Map<String, dynamic> json) {
//     return MafParticipationModel(
//       sLookUpValue: json["sLookUpValue"],
//       nLookUPID: json["nLookUPID"],
//     );
//   }
// }

class MafParticipationModel {
  final String message;
  final String status;
  final String token;
  final List<GemOption> data;

  MafParticipationModel({
    required this.message,
    required this.status,
    required this.token,
    required this.data,
  });

  factory MafParticipationModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> dataList = json['data'];
    List<GemOption> solutionTypes =
    dataList.map((item) => GemOption.fromJson(item)).toList();

    return MafParticipationModel(
      message: json['message']??"",
      status: json['status']??"",
      token: json['token']??"",
      data: solutionTypes,
    );
  }
}


String converDateStringToFormatDate(String dateString) {
  DateTime tempDate = new DateFormat("yyyy-MM-ddThh:mm:ss").parse(dateString);
  String date = DateFormat("MMM dd, yyyy hh:mm a").format(tempDate);
  return date;
}
