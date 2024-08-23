import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/datasource/mpartner_remote_data_source.dart';
import '../../../data/models/language_model.dart';
import '../../../services/services_locator.dart';
import '../../../state/contoller/language_controller.dart';
import '../../../state/contoller/user_data_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/displaymethods/display_methods.dart';
import '../../../utils/localdata/language_constants.dart';
import '../../widgets/headers/back_button_header_widget.dart';
import '../../widgets/something_went_wrong_widget.dart';
import '../base_screen.dart';
import '../userprofile/user_profile_widget.dart';
import 'display_ads_template_image_screen.dart';
import 'widgets/language_dropdown.dart';

class CreateAdvertisement extends StatefulWidget {
  const CreateAdvertisement({super.key});

  @override
  State<CreateAdvertisement> createState() {
    return _CreateAdvertisement();
  }
}

class _CreateAdvertisement extends BaseScreenState<CreateAdvertisement> {
  TextEditingController languageController = TextEditingController();
  Future<List<String>>? _fetchImageUrlsFuture;
  LanguageController controller = Get.find();
  UserDataController userController = Get.find();
  bool isLoading = true;

  bool somethingWentWrong = false;

  List<String> imageUrls = [];
  Language _selectedOption =
      const Language(id: 1, language: 'English', languagecode: 'en');

  List<Language> _options = [];

  Language findDefaultLanguage(String languageCode, List<Language> languages) {
    Language defaultLanguage = languages.firstWhere(
      (language) => language.languagecode == languageCode,
      orElse: () =>
          const Language(id: 1, language: 'English', languagecode: 'en'),
    );
    return defaultLanguage;
  }

  @override
  void initState() {
    LanguageController controller = Get.find();
    BaseMPartnerRemoteDataSource mPartnerRemoteDataSource =
        sl<BaseMPartnerRemoteDataSource>();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final _languages = mPartnerRemoteDataSource.getLanguages();
      _languages.then((value) {}).catchError((error) {
        setState(() {
          isLoading = false;
          somethingWentWrong=true;
        });
      });
      final languages = await _languages;
      _selectedOption = findDefaultLanguage(controller.language, languages);
      setState(() {
        _options = languages;
      });
      _fetchImageUrlsFuture = mPartnerRemoteDataSource.fetchImageUrls(
          findDefaultLanguage(controller.language, languages).id);
      _fetchImageUrlsFuture!.then((value) {
        setState(() {
          isLoading = false;
          if (value == []) somethingWentWrong = true;
        });
      }).catchError((error) {
        setState(() {
          isLoading = false;
          somethingWentWrong=true;
        });
      });
    });
    super.initState();
  }

  @override
  Widget baseBody(BuildContext context) {
    BaseMPartnerRemoteDataSource mPartnerRemoteDataSource =
        sl<BaseMPartnerRemoteDataSource>();
    double screenWidth = MediaQuery.of(context).size.width;
    double variablePixelHeight =
        DisplayMethods(context: context).getVariablePixelHeight();
    double variablePixelWidth =
        DisplayMethods(context: context).getVariablePixelWidth();
    double pixelMultiplier =
        DisplayMethods(context: context).getPixelMultiplier();
    double topPadding = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: AppColors.white,
      body: (isLoading)
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
            child: Column(
                children: [
                  HeaderWidgetWithBackButton(heading: translation(context).createAd, onPressed: (){Navigator.of(context).pop();}),
                  UserProfileWidget(top: 8 * variablePixelHeight),
                  (somethingWentWrong)
                      ? const SomethingWentWrongWidget()
                      : Expanded(
                          child: Column(
                            children: [
                              LanguageDropDown(
                                options: _options,
                                selectedValue: _selectedOption.language,
                                onChanged: (Language newLanguage) {
                                  print("newLanguage: {$newLanguage}");
                                  setState(() {
                                    _selectedOption = newLanguage;
                                    _fetchImageUrlsFuture =
                                        mPartnerRemoteDataSource
                                            .fetchImageUrls(newLanguage.id);
                                    _fetchImageUrlsFuture!.then((value) {
                                      setState(() {
                                        isLoading = false;
                                        if (value == [])
                                          somethingWentWrong = true;
                                      });
                                    });
                                  });
                                },
                                languageController: languageController,
                              ),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: FutureBuilder<List<String>>(
                                    future: _fetchImageUrlsFuture,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      } else if (snapshot.hasError) {
                                        return Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    24 * variablePixelWidth,
                                                    10 * variablePixelHeight,
                                                    24 * variablePixelWidth,
                                                    10 * variablePixelHeight),
                                                child: Text(translation(context)
                                                    .advertisementImageLoadErrorMessage),
                                              ),
                                            ],
                                          ),
                                        );
                                      } else if (!snapshot.hasData ||
                                          snapshot.data!.isEmpty) {
                                        return Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              24 * variablePixelWidth,
                                              10 * variablePixelHeight,
                                              24 * variablePixelWidth,
                                              10 * variablePixelHeight),
                                          child: Text(translation(context)
                                              .advertisementImageLoadErrorMessage),
                                        );
                                      } else {
                                        return Padding(
                                          padding: EdgeInsets.only(bottom: 10 * variablePixelHeight),
                                          child: Wrap(
                                            spacing: 16.0 * variablePixelWidth,
                                            runSpacing: 16.0 * variablePixelHeight,
                                            children: snapshot.data!.map((url) {
                                              return Container(
                                                width: screenWidth / 2 -
                                                    36 * variablePixelWidth,
                                                height: 160 * variablePixelHeight,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          4.0 * pixelMultiplier),
                                                  color: AppColors.dividerGreyColor,
                                                ),
                                                child: CachedNetworkImage(
                                                    imageUrl: url,
                                                    imageBuilder: (context,
                                                            imageProvider) =>
                                                        GestureDetector(
                                                          onTap: () => Navigator.of(
                                                                  context).push(MaterialPageRoute(builder: (context) =>DisplayAdsImageScreen(url:url))),
                                                          child: Container(
                                                            decoration:BoxDecoration(
                                                              image:DecorationImage(
                                                                alignment: Alignment.topCenter,
                                                                image: imageProvider,
                                                                fit: BoxFit.cover,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                    placeholder: (context, url) =>
                                                        const Center(child:CircularProgressIndicator()),
                                                    errorWidget:(context, url, error) {
                                                      return const Icon(Icons.error);
                                                    }),
                                              );
                                            }).toList(),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                ],
              ),
          ),
    );
  }
}
