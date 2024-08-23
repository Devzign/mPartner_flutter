import 'package:flutter/material.dart';
import '../../../../../utils/displaymethods/display_methods.dart';

class OffersWidget extends StatefulWidget {
  final List<String> offerImageURLs;

  const OffersWidget({Key? key, required this.offerImageURLs}) : super(key: key);

  @override
  State<OffersWidget> createState() => _OffersWidgetState();
}

class _OffersWidgetState extends State<OffersWidget> {
  @override
  Widget build(BuildContext context) {
    double w = DisplayMethods(context: context).getVariablePixelWidth();
    double r = DisplayMethods(context: context).getPixelMultiplier();

    return Container(
      height: 156 * w,
      padding: EdgeInsets.only(left: 24 * w),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.offerImageURLs.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Container(
              width: 156 * w,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.offerImageURLs[index]),
                  fit: BoxFit.fill,
                ),
                borderRadius: BorderRadius.circular(8 * r),
              ),
            ),
          );
        },
      ),
    );
  }
}
