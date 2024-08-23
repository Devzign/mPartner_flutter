import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../services/services_locator.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../utils/enums.dart';
import '../../../../../utils/localdata/language_constants.dart';
import '../bloc/register_sales_bloc.dart';

class SaleTypeListWidget extends StatefulWidget {
  final Function(String) onSaleTypeSelected;

  const SaleTypeListWidget({required this.onSaleTypeSelected, super.key});

  @override
  State<SaleTypeListWidget> createState() => _SaleTypeListWidgetState();
}

class _SaleTypeListWidgetState extends State<SaleTypeListWidget> {
  void _handleOnSaleTypeSelected(saleType) {
    widget.onSaleTypeSelected(saleType);
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
      create: (context) => sl<RegisterSalesBloc>()..add(GetSaleTypeEvent()),
      child: BlocBuilder<RegisterSalesBloc, RegisterSalesState>(
        builder: (context, state) {
          return BlocConsumer<RegisterSalesBloc, RegisterSalesState>(
            listener: (context, state) {},
            builder: (context, state) {
              switch (state.getSaleTypeState) {
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
                          translation(context).selectSaleType,
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
                          itemCount: state.saleTypeData.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.only(
                                  bottom: variablePixelHeight * 18),
                              child: TextButton(
                                onPressed: () => _handleOnSaleTypeSelected(
                                    state.saleTypeData[index].saleType),
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
                                              state
                                                  .saleTypeData[index].saleType,
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
                                              state.saleTypeData[index]
                                                  .description,
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
                      child: Text(state.getSaleTypeMessage),
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
