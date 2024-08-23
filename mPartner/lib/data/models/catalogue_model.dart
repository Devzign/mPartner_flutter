import 'package:equatable/equatable.dart';

class Catalog extends Equatable {
  final int? id;
  final String? categoryname;
  final String? pdfName;
  final String? pdfURL;
  final String? imageURL;
  final String? lastUpdatedOn;

  const Catalog({
    required this.id,
    required this.categoryname,
    required this.pdfName,
    required this.pdfURL,
    required this.imageURL,
    required this.lastUpdatedOn,
  });

  @override
  List<Object?> get props =>
      [id, categoryname, pdfName, pdfURL, imageURL, lastUpdatedOn];

  factory Catalog.fromJson(Map<String, dynamic> json) => Catalog(
        id: json['id'] ?? 0,
        categoryname: json['categoryname'] ?? '',
        pdfName: json['pdfName'] ?? '',
        pdfURL: json['pdfURL'] ?? '',
        imageURL: json['imageURL'] ?? '',
        lastUpdatedOn: json['lastUpdatedOn'] ?? '',
      );
}


// class SplashModel extends Splash {

//   const SplashModel({required super.imageUrl});

//   // factory SplashModel.fromJson(Map<String, dynamic> json) {
//   //   return SplashModel(imageUrl: json['dynamic_screen'][0]['image_url']);
//   // }
//   factory SplashModel.fromJson(Map<String, dynamic> json) => SplashModel(
//         imageUrl: json["image_url"],
//       );
// }

// class LanguageModel extends Language {

//   const LanguageModel({required super.id, required super.language, required super.languagecode});

//   factory LanguageModel.fromJson(Map<String, dynamic> json) => LanguageModel(
//     id: json["id"],
//     language: json["language"],
//     languagecode: json["languagecode"],
//   );
