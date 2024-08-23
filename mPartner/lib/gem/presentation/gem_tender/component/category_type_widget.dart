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

class CategoryTypeWidget extends StatefulWidget {
  final Function(String) onCategoryTypeSelected;

  const CategoryTypeWidget({required this.onCategoryTypeSelected, super.key});

  @override
  State<CategoryTypeWidget> createState() => _CategoryTypeWidgetState();
}

class _CategoryTypeWidgetState extends State<CategoryTypeWidget> {

  void _handleOnSaleTypeSelected(saleType) {
    widget.onCategoryTypeSelected(saleType);
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
          return BlocConsumer<CategoryTypeBloc, CategoryTypeState>(
            listener: (context, state) {},
            builder: (context, state) {
              switch (state.getCategoryTypeState) {
                case RequestState.loading:
                  return SizedBox(
                    height: 174 * variablePixelHeight,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                case RequestState.loaded:
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(
                          28 * variablePixelWidth,
                          6 * variablePixelHeight,
                          24 * variablePixelWidth,
                          16 * variablePixelHeight,
                        ),
                        width: variablePixelWidth * 393,
                        child: Text(
                          translation(context).gemSupport,
                          style: GoogleFonts.poppins(
                            color: AppColors.darkGreyText,
                            fontStyle: FontStyle.normal,
                            fontSize: 16 * variableTextMultiplier,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 28 * variablePixelWidth,
                        ),
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          //itemCount: staticData.length,
                          itemCount: state.categoryTypeData.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.only(
                                  bottom: variablePixelHeight * 18),
                              child: TextButton(
                                onPressed: () => _handleOnSaleTypeSelected(state.categoryTypeData[index].sGEMMODULE),
                                style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        12 * variablePixelMultiplier),
                                    side:
                                        BorderSide(color: AppColors.lightGrey2),
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
                                               state.categoryTypeData[index].sGEMMODULE,
                                              //staticData[index]["saleType"]!,
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
                                              //staticData[index]["description"]!,
                                              state.categoryTypeData[index].sGEMMODULE_Desc,
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
                      ),
                    ],
                  );
                case RequestState.error:
                  return SizedBox(
                    height: 174 * variablePixelHeight,
                    child: Center(
                      child: Text(
                          style: GoogleFonts.poppins(
                            color: AppColors.blackText,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          state.getCategoryTypeMessage),
                    ),
                  );
              }
            },
          );
        },
      ),
    );
  }
}
