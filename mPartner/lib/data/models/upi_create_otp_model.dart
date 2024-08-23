class UPIOTPModel{
  final String message;
  final String status;
  final dynamic resendTime;

  UPIOTPModel({
    required this.message,
    required this.status,
    required this.resendTime,
  });

  factory UPIOTPModel.fromJson(Map<String,dynamic> json){
    return UPIOTPModel(message: json['message'], status: json['status'], resendTime: json['data']);
  }
}