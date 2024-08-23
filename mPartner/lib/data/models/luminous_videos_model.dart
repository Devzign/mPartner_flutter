import 'package:equatable/equatable.dart';

class LuminousVideoModel extends Equatable{
  final String videoId;
  final String thumbnail;
  final String title;
  final String description;
  String viewCount;



    LuminousVideoModel({required this.videoId, required this.thumbnail, required this.title,required this.description,required this.viewCount});

  @override
  List<Object> get props => [
    videoId,
    thumbnail,
    title,
    description,
    viewCount,
  ];

}
class LuminousChannelIconModel extends Equatable{
  final String thumbnail;


  const LuminousChannelIconModel({required this.thumbnail});

  @override
  List<Object> get props => [
    thumbnail,
  ];

}


