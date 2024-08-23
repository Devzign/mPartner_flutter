class UPIClientHandshakeModel{
  final String status;
  final String message;

  UPIClientHandshakeModel({
    required this.status,
    required this.message,
  });

  factory UPIClientHandshakeModel.fromJson(Map<String, dynamic> json){
    return UPIClientHandshakeModel(
      status: json['status']??'',
      message: json['message']??'',
    );
  }
}