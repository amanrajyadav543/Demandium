import 'package:demandium/feature/home/model/advertisement_model.dart';
import 'package:demandium/feature/home/repository/advertisement_repo.dart';
import 'package:get/get.dart';
import 'package:demandium/components/core_export.dart';


class AdvertisementController extends GetxController implements GetxService {
  final AdvertisementRepo advertisementRepo;
  AdvertisementController({required this.advertisementRepo});

  List<Advertisement>? _advertisementList;
  List<Advertisement>? get advertisementList => _advertisementList;

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  Duration autoPlayDuration = const Duration(seconds: 7);

  bool autoPlay = true;

  Future<void> getAdvertisementList(bool reload) async {

    if(_advertisementList == null || reload){
      Response response = await advertisementRepo.getAdvertisementList();
      if (response.statusCode == 200) {
        _advertisementList = [];
        response.body['content']['data'].forEach((banner){
          _advertisementList!.add(Advertisement.fromJson(banner));
        });
      } else {
        ApiChecker.checkApi(response);
      }

      if(_advertisementList !=null && _advertisementList!.isNotEmpty && _advertisementList![0].type == "video_promotion"){
        autoPlay = false;
      }
      update();
    }

  }

  void setCurrentIndex(int index, bool notify) {
    _currentIndex = index;
    if(notify) {
      update();
    }
  }

  void updateAutoPlayStatus({bool shouldUpdate = false, bool status = false}){
    autoPlay = status;
    if(shouldUpdate){
      update();
    }
  }

  updateIsFavoriteValue(int status, String providerId, {bool shouldUpdate = false}){

    _advertisementList?.forEach((element){
      int? index;
      if(element.providerData?.id == providerId){
        index = _advertisementList?.indexOf(element);
      }
      if(index !=null && index > -1){
        _advertisementList?[index].providerData?.isFavorite = status;
      }
    });
    if(shouldUpdate){
      update();
    }
  }

}
