class CoinBalancePanCheck{
  final String status;
  final String message;

  CoinBalancePanCheck({
    required this.status,
    required this.message,
  });

  factory CoinBalancePanCheck.fromJson(Map<String, dynamic> json) => CoinBalancePanCheck(
        status: json['status']??'',
        message: json['message']??'',
  );
}