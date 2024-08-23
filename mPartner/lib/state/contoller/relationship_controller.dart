import 'package:get/get.dart';
import '../../data/datasource/mpartner_remote_data_source.dart';
import '../../data/models/relationship_model.dart';

class RelationshipContoller extends GetxController {
  var relationshipListWithCount = <Map<String, dynamic>>[].obs;
  var relationshipList = <String>[].obs;
  var isLoading = false.obs;
  var error = ''.obs;

  MPartnerRemoteDataSource mPartnerRemoteDataSource =
      MPartnerRemoteDataSource();

  Future<void> fetchRelationships(String tripId) async {
    try {
      isLoading(true);
      relationshipListWithCount.clear();
      relationshipList.clear();
      final result =
          await mPartnerRemoteDataSource.postRelationships(tripId);
      result.fold(
        (failure) {
          // Handle failure (Left)
          error(
              'Failed to fetch Secondary report information for distributor: $failure');
        },
        (relationship) async {
          for (Relationship option
              in relationship) {
            if (option.props.every((value) => value == 'NA')) {
              error('No relationships available.');
            } else {
              error('');
            }
            relationshipListWithCount.add(option.toJson());
            relationshipList.add(option.relationShipName);
          }
        },
      );
    } finally {
      isLoading(false);
    }
  }

  @override
  void onInit() async {
    super.onInit();
    update();
  }

  clearRelationship() {
    relationshipListWithCount.clear();
    isLoading = false.obs;
    error = ''.obs;
  }
}
