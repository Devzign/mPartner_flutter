import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../../../utils/app_colors.dart';
import '../../../../../../utils/displaymethods/display_methods.dart';
import '../../../../widgets/horizontalspace/horizontal_space.dart';
import '../secondarysales/components/serial_number_existance_model.dart';

class SerialNumberListWidget extends StatefulWidget {
  final List<SerialNumberExistanceModel> items;
  final Function(SerialNumberExistanceModel) onValueRemoved;
  final String saletype;

  const SerialNumberListWidget(
      {required this.items, required this.saletype,required this.onValueRemoved, super.key});

  @override
  State<SerialNumberListWidget> createState() => SerialNumberListWidgetState();
}

class SerialNumberListWidgetState extends State<SerialNumberListWidget> {
  void updateList(List<SerialNumberExistanceModel> newItems) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double r = DisplayMethods(context: context).getPixelMultiplier();
    return Scrollbar(
        thumbVisibility: true,
        child: ListView.builder(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemCount: widget.items.length,
      itemBuilder: (context, index) {
        return Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12 * DisplayMethods(context: context).getVariablePixelWidth()),
                height: widget.saletype=="Secondary"?104:52 * DisplayMethods(context: context).getVariablePixelHeight(),
                child: ListTile(
                  title: Row(
                    children:
                    [
                      SizedBox(
                        height: 24 * r,
                        width: 24 * r,
                        child: SvgPicture.asset('assets/mpartner/check_circle.svg'),
                      ),
                      const HorizontalSpace(width: 10),
                      Expanded(child: Container(child: new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "S.No: ${widget.items[index].barcodevalue.toString()}",
                            maxLines: 1,
                            style: GoogleFonts.poppins(
                              color: AppColors.blackText,
                              fontSize: 16 *
                                  DisplayMethods(context: context).getTextFontMultiplier(),
                              fontWeight: FontWeight.w400,
                              letterSpacing: 1,
                            ),
                          ),

                          if(widget.saletype=="Secondary")
                            Text(
                              "Model Name: ${widget.items[index].modelName.toString()}",
                              maxLines: 1,
                              style: GoogleFonts.poppins(
                                color: AppColors.grey,
                                fontSize: 14 *
                                    DisplayMethods(context: context).getTextFontMultiplier(),
                                fontWeight: FontWeight.w400,
                                letterSpacing: 1,
                              ),
                            ),
                        ],
                      ),))
                    ],
                  ),
                  trailing: InkWell(
                    child: SvgPicture.asset(
                      "assets/mpartner/ismart/ic_delete.svg",
                    ),
                    onTap: () {
                      widget.onValueRemoved(widget.items.elementAt(index));
                    },
                  ),
                ),),
              Divider(
                thickness: 1,
                color: AppColors.dividerGreyColor,
              ),
            ]
        );
      },
    ));
  }
}
