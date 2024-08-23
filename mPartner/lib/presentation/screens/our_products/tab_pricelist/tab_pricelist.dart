import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../services/services_locator.dart';
import '../../../../utils/enums.dart';
import '../../../../data/models/pricelist_model.dart';
import '../../../../utils/localdata/language_constants.dart';
import 'bloc/pricelist_bloc.dart';
import '../../../../../utils/displaymethods/display_methods.dart';
import '../../../widgets/CommonCards/card_with_download_and_share.dart';

class TabPricelist extends StatelessWidget {
  const TabPricelist({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<PricelistBloc>()..add(PriceListFetchEvent()),
      child: BlocBuilder<PricelistBloc, PricelistState>(
        builder: (context, state) {
          return BlocConsumer<PricelistBloc, PricelistState>(
            listener: (context, state) {
              // TODO: implement listener
            },
            builder: (context, state) {
              // print("Pricelist: ${state}");
              // print("state: ${state.pricelistScreenData}");
              // print("RequestState: ${state.pricelistScreenMessage}");
              // print("MessageState: ${state.pricelistScreenState}");
              switch (state.pricelistScreenState) {
                case RequestState.loading:
                  return const SizedBox(
                    height: 400.0,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                case RequestState.loaded:
                  return LayoutPriceListCard(
                    URI:
                        "https://www.google.com/url?sa=i&url=https%3A%2F%2Ftenor.com%2Fview%2Floading-gif-2600855906352330523&psig=AOvVaw1LOqxEP1nV_DKJ4HWcHCWo&ust=1700850372826000&source=images&cd=vfe&opi=89978449&ved=0CBEQjRxqFwoTCOjCkcTf2oIDFQAAAAAdAAAAABAE",
                    title: translation(context).priceList,
                    subtitle: "price list",
                    catalogData: state.pricelistScreenData,
                  );

                case RequestState.error:
                  return SizedBox(
                    height: 400.0,
                    child: Center(
                      child: Text(state.pricelistScreenMessage == "no_data" ? translation(context).noPricelist : state.pricelistScreenMessage),
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

class LayoutPriceListCard extends StatelessWidget {
  const LayoutPriceListCard({
    super.key,
    required this.URI,
    required this.title,
    required this.subtitle,
    required this.catalogData,
    this.headingforCard = false,
  });
  final String URI, title, subtitle;
  final List<Pricelist> catalogData;
  final bool headingforCard;

  @override
  Widget build(BuildContext context) {
    double h = DisplayMethods(context: context).getVariablePixelHeight();
    double w = DisplayMethods(context: context).getVariablePixelWidth();

    double f = DisplayMethods(context: context).getTextFontMultiplier();
    double r = DisplayMethods(context: context).getPixelMultiplier();
    print("working");
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(24 * w, 0, 24 * w, 47 * h),
      itemCount: catalogData.length,
      itemBuilder: (context, index) {
        return ContainerWithImageCardAndPDFDownload(
          key: key,
          title: '${catalogData[index].customertype} Price List' ?? 'NA',
          subtitle: "${translation(context).lastUpdatedOn} ${catalogData[index].lastUpdatedOn}" ?? 'NA',
          Uri: catalogData[index].mainImage ?? 'NA',
          showCardHeading: headingforCard,
          pdfUri: catalogData[index].cardAction ??
              'https://mpdev.luminousindia.com/MpartnerNewApi/Pdf/Luminous_Solar_Dealer_Price_List_MH_GOA_Sep_22633699.pdf',
          height: 150 * h,
        );
      },
    );
  }
}
