class LoginFlowBanner {
  String message;
  String status;
  String token;
  List<Datum> data;
  String data1;

  LoginFlowBanner({
    required this.message,
    required this.status,
    required this.token,
    required this.data,
    required this.data1,
  });

  factory LoginFlowBanner.fromJson(Map<String, dynamic> json) => LoginFlowBanner(
    message: json["message"],
    status: json["status"],
    token: json["token"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    data1: json["data1"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status": status,
    "token": token,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "data1": data1,
  };
}

class Datum {
  String name;
  String className;
  String cardAction;
  String backgroundImage;
  String imageHeight;
  String imageWidth;
  String mainImage;
  String title;
  String titleColor;
  String subTitle;
  String subtitleColor;
  List<CardDatum>? cardData;
  List<BannercardDatum>? bannercardData;
  String action1Color;
  String action1Text;
  dynamic subcategory;
  dynamic currentPage;
  dynamic productFooter;
  dynamic productUpper;
  dynamic productMain;
  dynamic bmhRData;
  dynamic dlrCode;
  dynamic dlrName;
  dynamic lastUpdatedOn;

  Datum({
    required this.name,
    required this.className,
    required this.cardAction,
    required this.backgroundImage,
    required this.imageHeight,
    required this.imageWidth,
    required this.mainImage,
    required this.title,
    required this.titleColor,
    required this.subTitle,
    required this.subtitleColor,
    required this.cardData,
    required this.bannercardData,
    required this.action1Color,
    required this.action1Text,
    required this.subcategory,
    required this.currentPage,
    required this.productFooter,
    required this.productUpper,
    required this.productMain,
    required this.bmhRData,
    required this.dlrCode,
    required this.dlrName,
    required this.lastUpdatedOn,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    name: json["name"],
    className: json["class_name"],
    cardAction: json["card_action"],
    backgroundImage: json["background_image"],
    imageHeight: json["image_height"],
    imageWidth: json["image_width"],
    mainImage: json["main_image"],
    title: json["title"],
    titleColor: json["title_color"],
    subTitle: json["sub_title"],
    subtitleColor: json["subtitle_color"],
    cardData: json["card_data"] == null ? [] : List<CardDatum>.from(json["card_data"]!.map((x) => CardDatum.fromJson(x))),
    bannercardData: json["bannercard_data"] == null ? [] : List<BannercardDatum>.from(json["bannercard_data"]!.map((x) => BannercardDatum.fromJson(x))),
    action1Color: json["action1_color"],
    action1Text: json["action1_text"],
    subcategory: json["subcategory"],
    currentPage: json["current_page"],
    productFooter: json["productFooter"],
    productUpper: json["productUpper"],
    productMain: json["productMain"],
    bmhRData: json["bmhR_Data"],
    dlrCode: json["dlr_code"],
    dlrName: json["dlr_name"],
    lastUpdatedOn: json["lastUpdatedOn"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "class_name": className,
    "card_action": cardAction,
    "background_image": backgroundImage,
    "image_height": imageHeight,
    "image_width": imageWidth,
    "main_image": mainImage,
    "title": title,
    "title_color": titleColor,
    "sub_title": subTitle,
    "subtitle_color": subtitleColor,
    "card_data": cardData == null ? [] : List<dynamic>.from(cardData!.map((x) => x.toJson())),
    "bannercard_data": bannercardData == null ? [] : List<dynamic>.from(bannercardData!.map((x) => x.toJson())),
    "action1_color": action1Color,
    "action1_text": action1Text,
    "subcategory": subcategory,
    "current_page": currentPage,
    "productFooter": productFooter,
    "productUpper": productUpper,
    "productMain": productMain,
    "bmhR_Data": bmhRData,
    "dlr_code": dlrCode,
    "dlr_name": dlrName,
    "lastUpdatedOn": lastUpdatedOn,
  };
}

class BannercardDatum {
  dynamic title;
  String backgroundImage;
  dynamic mainImage;
  dynamic cardAction;
  dynamic imageHeight;
  dynamic imageWidth;
  dynamic productId;
  dynamic productName;

  BannercardDatum({
    required this.title,
    required this.backgroundImage,
    required this.mainImage,
    required this.cardAction,
    required this.imageHeight,
    required this.imageWidth,
    required this.productId,
    required this.productName,
  });

  factory BannercardDatum.fromJson(Map<String, dynamic> json) => BannercardDatum(
    title: json["title"],
    backgroundImage: json["background_image"],
    mainImage: json["main_image"],
    cardAction: json["card_action"],
    imageHeight: json["image_height"],
    imageWidth: json["image_width"],
    productId: json["product_id"],
    productName: json["product_name"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "background_image": backgroundImage,
    "main_image": mainImage,
    "card_action": cardAction,
    "image_height": imageHeight,
    "image_width": imageWidth,
    "product_id": productId,
    "product_name": productName,
  };
}

class CardDatum {
  dynamic title;
  String backgroundImage;
  String mainImage;
  dynamic cardAction;
  dynamic imageHeight;
  dynamic imageWidth;
  int productCategoryId;
  dynamic productCategoryName;
  int catalogMenuUpperId;
  dynamic catalogMenuUpperName;
  int productCatalogId;
  dynamic productCatalogName;

  CardDatum({
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

  factory CardDatum.fromJson(Map<String, dynamic> json) => CardDatum(
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
