/*
class ConsumerEmiSmRoDetails{
  String message;
  String status;
  String token;
  List<SmRoDetails>? data;
  final String data1;

  ConsumerEmiSmRoDetails({
    required this.message,
    required this.status,
    required this.token,
    this.data,
    required this.data1,
  });

  factory ConsumerEmiSmRoDetails.fromJson(Map<String, dynamic> json) {
    return ConsumerEmiSmRoDetails(
      message: json['message'],
      status: json['status'],
      token: json['token'],
      data: json['data'] != null ? List<SmRoDetails>.from(json['data'].map((x) => SmRoDetails.fromJson(x))) : null,
      data1: json['data1'] as String? ?? '',
    );
  }
}
*/

class SmRoDetails {
  String smName;
  String smPhoneNo;
  String roName;
  String roPhoneNo;
  String bankMiddleInfo;
  String bankBottomInfo;
  String designation;
  String designation2;

  SmRoDetails({
    required this.smName,
    required this.smPhoneNo,
    required this.roName,
    required this.roPhoneNo,
    required this.bankMiddleInfo,
    required this.bankBottomInfo,
    required this.designation,
    required this.designation2,
  });
  @override
  String toString() {
    return 'SmRoDetails{smName: $smName, smPhoneNo: $smPhoneNo, roName: $roName, roPhoneNo: $roPhoneNo, '
        'bankMiddleInfo: $bankMiddleInfo, bankBottomInfo: $bankBottomInfo, designation: $designation, designation2: $designation2}';
  }

  factory SmRoDetails.fromJson(Map<String, dynamic> json) => SmRoDetails(
      smName: json['sm_name'],
      smPhoneNo: json['sm_phoneno'],
      roName: json['ro_name'],
      roPhoneNo: json['ro_phoneno'],
      bankMiddleInfo: json['bank_middle_info'],
      bankBottomInfo: json['bank_bottom_info'],
      designation: json['designation'],
      designation2: json['designation2'],
    );
}
