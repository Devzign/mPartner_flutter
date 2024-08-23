import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../../services/services_locator.dart';
import '../../../../../../utils/app_colors.dart';
import '../../../../../../utils/displaymethods/display_methods.dart';
import '../../../../../../utils/enums.dart';
import '../../../../../../utils/localdata/language_constants.dart';
import '../../uimodels/electrician_info.dart';
import '../bloc/intermediary_sales_bloc.dart';


class ElectricianListWidget extends StatefulWidget {
  final String searchQuery;
  final Function(ElectricianInfo) onElectricianSelected;
  
  const ElectricianListWidget({
    required this.searchQuery,
    required this.onElectricianSelected,
    super.key});

  @override
  State<ElectricianListWidget> createState() => _ElectricianListWidgetState();
}

class _ElectricianListWidgetState extends State<ElectricianListWidget> {

  void _handleOnElectricianSelected(electrician){
    widget.onElectricianSelected(electrician);
  }

  @override
  Widget build(BuildContext context) {
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
    DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelMultiplier =
    DisplayMethods(context: context).getPixelMultiplier();
    double variableTextMultiplier =
    DisplayMethods(context: context).getTextFontMultiplier();

    return BlocProvider(
      create: (context) => sl<IntermediarySalesBloc>()..add(GetElectricianListEvent()),
      child: BlocBuilder<IntermediarySalesBloc, IntermediarySalesState>(
        builder: (context, state) {
          return BlocConsumer<IntermediarySalesBloc, IntermediarySalesState>(
            listener: (context, state) {},
            builder: (context, state) {
              final filteredElectricianList = state.electricianListData.where((electrician) {
                String query = widget.searchQuery.toLowerCase();
                String electricianName = electrician.electricianName.toLowerCase();
                String disCode = electrician.disCode.toLowerCase();
                return electricianName.contains(query) || disCode.contains(query);
              }).toList();

              switch (state.electricianListState) {
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
                      Text(
                        "${state.electricianListData.length.toString()} ${translation(context).electricianListed}",
                        style: GoogleFonts.poppins(
                          color: AppColors.grayText,
                          fontSize: 14 * variableTextMultiplier,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8 * variablePixelWidth),
                        height: variablePixelHeight * 400,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemCount: filteredElectricianList.length,
                          itemBuilder: (context, index) {
                            final electricianList = filteredElectricianList[index];
                            return InkWell(
                              onTap: () => _handleOnElectricianSelected(ElectricianInfo(
                                  electricianName: electricianList.electricianName,
                                  disCode: electricianList.disCode,
                                  electricianCity: electricianList.city,
                                  electricianCountry: electricianList.country)),
                              child: Container(
                                width: variablePixelHeight * 392,
                                padding: EdgeInsets.symmetric(vertical: 10 * variablePixelMultiplier),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${electricianList.electricianName}, ${electricianList.disCode}",
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
                                      "${electricianList.city}, ${electricianList.country}",
                                      style: GoogleFonts.poppins(
                                        color: AppColors.darkGreyText,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 14 * variableTextMultiplier,
                                        fontWeight: FontWeight.w400,
                                        letterSpacing: 1,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
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
                      child: Text(state.electricianListMessage),
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
