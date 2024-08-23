import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../services/services_locator.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/enums.dart';
import '../../../../../utils/localdata/language_constants.dart';
import '../bloc/category_type_bloc.dart';
//import '../../../../../bloc/register_sales_bloc.dart';

class TendersTypeWidget extends StatefulWidget {
  final Function(String) onTenderTypeSelected;

  const TendersTypeWidget({required this.onTenderTypeSelected, super.key});

  @override
  State<TendersTypeWidget> createState() => _TendersTypeWidgetState();
}

class _TendersTypeWidgetState extends State<TendersTypeWidget> {
  static const List<Map<String, String>> staticData = [
    {
      "saleType": "State Tenders",
      "description": "View All Tenders"
    },
    {
      "saleType": "Central PSU's",
      "description": "View All PSU's"
    },
  ];

  void _handleOnSaleTypeSelected(saleType) {
    widget.onTenderTypeSelected(saleType);
  }

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double variablePixelMultiplier =
        DisplayMethods(context: context).getPixelMultiplier();
    double variableTextMultiplier =
        DisplayMethods(context: context).getTextFontMultiplier();

    return BlocProvider(
      create: (context) => sl<CategoryTypeBloc>()..add(GetCategoryTypeEvent()),
      child: BlocBuilder<CategoryTypeBloc, CategoryTypeState>(
        builder: (context, state) {
          return  Container(
            padding: EdgeInsets.symmetric(
              horizontal: 28 * variablePixelWidth,
            ),
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemCount: staticData.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(
                      bottom: variablePixelHeight * 18),
                  child: TextButton(
                    onPressed: () => _handleOnSaleTypeSelected(
                        staticData[index]["saleType"]),
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            12 * variablePixelMultiplier),
                        side:
                        const BorderSide(color: AppColors.lightGrey2),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(
                          3 * variablePixelMultiplier),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 8,
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  staticData[index]["saleType"]!,
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontStyle: FontStyle.normal,
                                    fontSize:
                                    16 * variableTextMultiplier,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(
                                    height:
                                    variablePixelHeight * 5),
                                Text(
                                  staticData[index]["description"]!,
                                  style: GoogleFonts.poppins(
                                    color: AppColors.grayText,
                                    fontStyle: FontStyle.normal,
                                    fontSize:
                                    14 * variableTextMultiplier,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
