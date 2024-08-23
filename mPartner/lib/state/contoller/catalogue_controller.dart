import 'package:get/get.dart';

import '../../data/datasource/mpartner_remote_data_source.dart';
import '../../data/models/catalogue_model.dart';
import '../../utils/app_constants.dart';

class CatalogueController extends GetxController {
  List<String?> catalogueImageUrls = [];
  List<String?> catalogName = [];
  var isLoading = false.obs;
  var error = ''.obs;
  var isCatalogEmpty = true.obs;

  var catalogue = const Catalog(
          id: 0,
          categoryname: "",
          pdfName: "",
          pdfURL: "",
          imageURL: "",
          lastUpdatedOn: "")
      .obs;

  MPartnerRemoteDataSource mPartnerRemoteDataSource =
      MPartnerRemoteDataSource();

  Future<void> fetchCatalogList(String userType) async {
    try {
      isLoading(true);

      final result = await mPartnerRemoteDataSource.postCatalog(userType);
      result.fold(
        (failure) {
          // Handle failure (Left)
          print("RA: failure block Failed to fetch Catalog: ${failure}");
          error('Failed to fetch Catalog: $failure');
          isLoading(false);
        },
        (catalogData) async {
          for (var option in catalogData) {
            print("RA: Success block Catalog : ${option}");
            if (option.props.every((value) => value == 'NA')) {
              error('No banners available');
            } else {
              error('');
            }
            catalogueImageUrls =
                catalogData.map((option) => option.imageURL).toList();
            catalogName = catalogData.map((option) => option.pdfName).toList();
            catalogue(option);
          }
          if(catalogueImageUrls.isNotEmpty){
            isCatalogEmpty.value = false;
          }
          updateCatalogList(catalogueImageUrls, catalogName);
        },
      );
    } catch(e){
      logger.e("RA: Exception : ${e}");
      isLoading(false);
      error('Failed to fetch Catalog');
    }finally {
      isLoading(false);
    }
  }

  @override
  void onInit() async {
    super.onInit();
    update();
  }

  updateCatalogList(List<String?> urls, List<String?> type) async {
    catalogueImageUrls = urls;
    catalogName = type;
    update();
  }

  @override 
  clearCatalogue(){
    catalogueImageUrls.clear();
    catalogName.clear();
    isLoading = false.obs;
    error = ''.obs;
    update();
  }
}
