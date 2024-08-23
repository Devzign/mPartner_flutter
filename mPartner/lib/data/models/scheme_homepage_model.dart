import 'package:equatable/equatable.dart';

class SchemeHomepage extends Equatable {
  String? customerType;
  String? name;
  String? className;
  String? cardAction;
  String? backgroundImage;
  String? imageHeight;
  String? imageWidth;
  String? mainImage;
  String? title;
  String? titleColor;
  String? subTitle;
  String? subtitleColor;
  String? cardData;
  String? bannercardData;
  String? action1Color;
  String? action1Text;
  String? subcategory;
  String? currentPage;
  String? productFooter;
  String? productUpper;
  String? productMain;
  String? bMHRData;
  String? dlrCode;
  String? dlrName;

  SchemeHomepage({
    this.customerType,
    this.name,
    this.className,
    this.cardAction,
    this.backgroundImage,
    this.imageHeight,
    this.imageWidth,
    this.mainImage,
    this.title,
    this.titleColor,
    this.subTitle,
    this.subtitleColor,
    this.cardData,
    this.bannercardData,
    this.action1Color,
    this.action1Text,
    this.subcategory,
    this.currentPage,
    this.productFooter,
    this.productUpper,
    this.productMain,
    this.bMHRData,
    this.dlrCode,
    this.dlrName,
  });

  @override
  List<Object?> get props => [
        customerType,
        name,
        className,
        cardAction,
        backgroundImage,
        imageHeight,
        imageWidth,
        mainImage,
        title,
        titleColor,
        subTitle,
        subtitleColor,
        cardData,
        bannercardData,
        action1Color,
        action1Text,
        subcategory,
        currentPage,
        productFooter,
        productUpper,
        productMain,
        bMHRData,
        dlrCode,
        dlrName,
      ];

  factory SchemeHomepage.fromJson(Map<String, dynamic> json) {
    return SchemeHomepage(
      customerType: json['customertype'] ?? "",
      name: json['name'] ?? "",
      className: json['class_name'] ?? "",
      cardAction: json['card_action'] ?? "",
      backgroundImage: json['background_image'] ?? "",
      imageHeight: json['image_height'] ?? "",
      imageWidth: json['image_width'] ?? "",
      mainImage: json['main_image'] ?? "",
      title: json['title'] ?? "",
      titleColor: json['title_color'] ?? "",
      subTitle: json['sub_title'] ?? "",
      subtitleColor: json['subtitle_color'] ?? "",
      cardData: json['card_data'] ?? "",
      bannercardData: json['Bannercard_data'] ?? "",
      action1Color: json['action1_color'] ?? "",
      action1Text: json['action1_text'] ?? "",
      subcategory: json['subcategory'] ?? "",
      currentPage: json['current_page'] ?? "",
      productFooter: json['ProductFooter'] ?? "",
      productUpper: json['ProductUpper'] ?? "",
      productMain: json['ProductMain'] ?? "",
      bMHRData: json['BMHR_Data'] ?? "",
      dlrCode: json['dlr_code'] ?? "",
      dlrName: json['dlr_name'] ?? "",
    );
  }
}
