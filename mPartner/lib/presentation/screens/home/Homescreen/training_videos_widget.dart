// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:mpartner/core/utils/app_colors.dart';
// import 'package:mpartner/core/utils/displaymethods/display_methods.dart';
// import 'package:mpartner/mpartner/presentation/screens/home/widgets/section_headings.dart';
// import 'package:mpartner/mpartner/presentation/screens/home/widgets/video_card.dart';
// import 'package:mpartner/mpartner/presentation/widgets/verticalspace/vertical_space.dart';

// class TrainingVideosWidget extends StatefulWidget {
//   const TrainingVideosWidget({super.key});

//   @override
//   State<TrainingVideosWidget> createState() =>
//       _TrainingVideosWidgetState();
// }

// class _TrainingVideosWidgetState extends State<TrainingVideosWidget> {
//   @override
//   Widget build(BuildContext context) {
//     double variablePixelHeight = DisplayMethods(context: context).getVariablePixelHeight();
//     double variablePixelWidth = DisplayMethods(context: context).getVariablePixelWidth();
//     return Container(
//       padding: EdgeInsets.only(
//           left: variablePixelWidth * 24,
//           bottom: variablePixelHeight * 16),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             padding: EdgeInsets.only(right: 24*variablePixelWidth),
//             child: SectionHeading(text: "Training Videos", fontWeight: FontWeight.w500,)),
//           VerticalSpace(height: 16),
//           Text(
//             'Learn more to help you grow your business',
//             style: GoogleFonts.poppins(
//               color: AppColors.grayText,
//               fontSize: 12,
//               fontWeight: FontWeight.w400,
//               height: 0.09,
//             ),
//           ),
//           VerticalSpace(height: 16),
//           Container(
//             height: variablePixelHeight * 150,
//             child: ListView(
//               scrollDirection: Axis.horizontal,
//               children: <Widget>[
//                 VideoCard(
//                     imagePath:
//                         "assets/mpartner/Homepage_Assets/training_video_1.jpg",
//                     text: "Complete solar guide"),
//                 VideoCard(
//                     imagePath:
//                         "assets/mpartner/Homepage_Assets/training_video_2.jpg",
//                     text: "Luminous Inverter"),
//                 VideoCard(
//                     imagePath:
//                         "assets/mpartner/Homepage_Assets/training_video_3.jpg",
//                     text: "Luminous Inverter")
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
