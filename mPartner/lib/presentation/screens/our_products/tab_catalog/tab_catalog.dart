import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/enums.dart';
import '../../../../utils/localdata/language_constants.dart';
import '../bloc/product_bloc.dart';
import '../../../../../services/services_locator.dart';
import 'layout_card_catalog.dart';

class TabCatalog extends StatelessWidget {
  const TabCatalog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProductBloc>()..add(CatalogFetchEvent()),
      child: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          return BlocConsumer<ProductBloc, ProductState>(
            listener: (context, state) {
              // TODO: implement listener
            },
            builder: (context, state) {
              print("catalog: ${state}");
              print("state: ${state.catalogScreenData}");
              print("RequestState: ${state.catalogScreenMessage}");
              print("MessageState: ${state.catalogScreenState}");
              switch (state.catalogScreenState) {
                case RequestState.loading:
                  return const SizedBox(
                    height: 400.0,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                case RequestState.loaded:
                  return Column(
                    children: [
                      Expanded(
                        child: LayoutCardCatalog(
                          catalogData: state.catalogScreenData,
                          headingforCard: true,
                        ),
                      ),
                    ],
                  );

                case RequestState.error:
                  return SizedBox(
                    height: 400.0,
                    child: Center(
                      child: Text(state.catalogScreenMessage == "no_data" ? translation(context).noCatalog : state.catalogScreenMessage),
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

// BlocProvider(
//       create: (BuildContext context) => sl<SplashBloc>()
//         ..add(SplashInitialFetchEvent()),
//       child: BlocBuilder<SplashBloc, SplashState>(
//         builder: (context, state)