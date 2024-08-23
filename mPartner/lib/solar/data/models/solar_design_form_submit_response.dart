class SolarDesignFormSubmitResponse{
  final String message;
  final String status;
  final dynamic data;  

  SolarDesignFormSubmitResponse({
    required this.message,
    required this.status,
    required this.data,
  });

  factory SolarDesignFormSubmitResponse.fromJson(Map<String, dynamic> json) {
    return SolarDesignFormSubmitResponse(
      message: json['message'] ?? '',
      status: json['status'] ?? '',
      data: json['data'] ?? '',
    );
  }

  static SolarDesignFormSubmitResponse empty(){
    return SolarDesignFormSubmitResponse(message: "", status: "", data: "");
  }
}