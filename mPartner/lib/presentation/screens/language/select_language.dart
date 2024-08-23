import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpartner/presentation/screens/base_screen.dart';
import 'package:mpartner/presentation/screens/language/bloc/language_bloc.dart';

import '../../../../services/services_locator.dart';
import '../../../../utils/app_colors.dart';
import 'components/select_language_components.dart';

class SelectLanguage extends StatefulWidget {
  const SelectLanguage({Key? key}) : super(key: key);

  @override
  State<SelectLanguage> createState() => _SelectLanguageState();
}

class _SelectLanguageState extends BaseScreenState<SelectLanguage> {
  String selectedLanguage = 'English';

  @override
  Widget baseBody(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
      sl<LanguageBloc>()..add(LanguageInitialFetchEvent()),
      child: BlocBuilder<LanguageBloc, LanguageState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.lightGrey,
            body: Center(
              child: Container(
                child: const SelectLanguageComponent(),
              ),
            ),
          );
        },
      ),
    );
  }
}
