// To parse this JSON data, do
//
//     final ismartOffers = ismartOffersFromJson(jsonString);

import 'dart:convert';

IsmartOffers ismartOffersFromJson(String str) => IsmartOffers.fromJson(json.decode(str));

String ismartOffersToJson(IsmartOffers data) => json.encode(data.toJson());

class IsmartOffers {
    String title;
    String backgroundImage;
    String mainImage;
    String cardAction;
    String imageHeight;
    String imageWidth;
    int productCategoryId;
    dynamic productCategoryName;
    int catalogMenuUpperId;
    dynamic catalogMenuUpperName;
    int productCatalogId;
    dynamic productCatalogName;

    IsmartOffers({
        required this.title,
        required this.backgroundImage,
        required this.mainImage,
        required this.cardAction,
        required this.imageHeight,
        required this.imageWidth,
        required this.productCategoryId,
        required this.productCategoryName,
        required this.catalogMenuUpperId,
        required this.catalogMenuUpperName,
        required this.productCatalogId,
        required this.productCatalogName,
    });
    List<Object?> get props => [
      title,
      backgroundImage,
      mainImage,
      cardAction,
      imageHeight,
      imageWidth,
      productCategoryId,
      productCategoryName,
      catalogMenuUpperId,
      catalogMenuUpperName,
      productCatalogId,
      productCatalogName
    ];

    factory IsmartOffers.fromJson(Map<String, dynamic> json) => IsmartOffers(
        title: json["title"],
        backgroundImage: json["background_image"],
        mainImage: json["main_image"],
        cardAction: json["card_action"],
        imageHeight: json["image_height"],
        imageWidth: json["image_width"],
        productCategoryId: json["product_category_id"],
        productCategoryName: json["product_category_name"],
        catalogMenuUpperId: json["catalog_menu_upper_id"],
        catalogMenuUpperName: json["catalog_menu_upper_name"],
        productCatalogId: json["product_catalog_id"],
        productCatalogName: json["product_catalog_name"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "background_image": backgroundImage,
        "main_image": mainImage,
        "card_action": cardAction,
        "image_height": imageHeight,
        "image_width": imageWidth,
        "product_category_id": productCategoryId,
        "product_category_name": productCategoryName,
        "catalog_menu_upper_id": catalogMenuUpperId,
        "catalog_menu_upper_name": catalogMenuUpperName,
        "product_catalog_id": productCatalogId,
        "product_catalog_name": productCatalogName,
    };
}
