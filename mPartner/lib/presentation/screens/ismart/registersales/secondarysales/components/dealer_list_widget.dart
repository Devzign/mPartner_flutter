import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../services/services_locator.dart';
import '../../../../../../utils/app_colors.dart';
import '../../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../../utils/enums.dart';
import '../../../../../../utils/localdata/language_constants.dart';
import '../../uimodels/dealer_info.dart';
import '../bloc/secondary_sales_bloc.dart';

class DealerListWidget extends StatefulWidget {
  final String searchQuery;
  final Function(DealerInfo) onDealerSelected;
  const DealerListWidget({required this.searchQuery,
    required this.onDealerSelected,super.key});

  @override
  State<DealerListWidget> createState() => _DealerListWidgetState();
}

class _DealerListWidgetState extends State<DealerListWidget> {

  void _handleOnDealerSelected(dealer){
    widget.onDealerSelected(dealer);
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
      create: (context) => sl<SecondarySalesBloc>()..add(GetDealerListEvent()),
      child: BlocBuilder<SecondarySalesBloc, SecondarySalesState>(
        builder: (context, state) {
          return BlocConsumer<SecondarySalesBloc, SecondarySalesState>(
            listener: (context, state) {},
            builder: (context, state) {
              final filteredDealerList = state.dealerListData.where((dealer) {
                String query = widget.searchQuery.toLowerCase();
                String dealerName = dealer.dealerName.toLowerCase();
                String disCode = dealer.dlr_Sap_Code.toLowerCase();
                return dealerName.contains(query) || disCode.contains(query);
              }).toList();

              switch (state.dealerListState) {
                case RequestState.loading:
                  return SizedBox(
                    height: 174 * variablePixelHeight,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                case RequestState.loaded:
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 8*variablePixelWidth),
                        child: Text(
                          "${filteredDealerList.length.toString()} ${translation(context).dealersListed}",
                          style: GoogleFonts.poppins(
                            color: AppColors.grayText,
                            fontSize: 14 * variableTextMultiplier,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8 * variablePixelWidth),
                        height: variablePixelHeight * 400,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemCount: filteredDealerList.length,
                          itemBuilder: (context, index) {
                            final dealerList = filteredDealerList[index];
                            return InkWell(
                              onTap: () => _handleOnDealerSelected(DealerInfo(
                                  dealerName: dealerList.dealerName,
                                  disCode: dealerList.dlr_Sap_Code,
                                  dealerCity: dealerList.city,
                                  dealerCountry: "")),
                              child: Container(
                                width: variablePixelHeight * 392,
                                padding: EdgeInsets.symmetric(vertical: 10 * variablePixelMultiplier),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${dealerList.dealerName}, ${dealerList.dlr_Sap_Code}",
                                      style: GoogleFonts.poppins(
                                        color: AppColors.darkText2,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 14 * variableTextMultiplier,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 1,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),

                                    Text(
                                      "${dealerList.contactName}",
                                      style: GoogleFonts.poppins(
                                        color: AppColors.darkGreyText,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 14 * variableTextMultiplier,
                                        fontWeight: FontWeight.w400,
                                        letterSpacing: 1,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),


                                    // Text(
                                    //   "${dealerList.city}",
                                    //   style: GoogleFonts.poppins(
                                    //     color: AppColors.darkGreyText,
                                    //     fontStyle: FontStyle.normal,
                                    //     fontSize: 14 * variableTextMultiplier,
                                    //     fontWeight: FontWeight.w400,
                                    //     letterSpacing: 1,
                                    //   ),
                                    //   textAlign: TextAlign.start,
                                    // ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  );
                case RequestState.error:
                  return SizedBox(
                    height: 174 * variablePixelHeight,
                    child: Center(
                      child: Text(state.dealerListMessage),
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
