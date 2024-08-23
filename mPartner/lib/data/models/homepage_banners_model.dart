

import 'package:equatable/equatable.dart';

class HomepageBanners extends Equatable {
  final String title;
  final String background_image;
  final String main_image;
  final String card_action;
  final String image_height;
  final String image_width;
  final String product_id;
  final String product_name;

  const HomepageBanners({
    required this.title,
    required this.background_image,
    required this.main_image,
    required this.card_action,
    required this.image_height,
    required this.image_width,
    required this.product_id,
    required this.product_name,
  });

  @override
  List<Object> get props => [
   title,
   background_image,
   main_image,
   card_action,
   image_height,
   image_width,
   product_id,
   product_name,
  ];

  factory HomepageBanners.fromJson(Map<String, dynamic> json) => HomepageBanners(
    title: json["title"] ?? "",
    background_image: json["background_image"] ?? "",
    main_image: json["main_image"] ?? "",
    card_action: json["card_action"] ?? "",
    image_height: json["image_height"] ?? "",
    image_width: json['image_width'] ?? "",
    product_id: json["product_id"] ?? "",
    product_name: json['product_name'] ?? "",
  );
}