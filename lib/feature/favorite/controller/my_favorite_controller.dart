import 'package:demandium/components/core_export.dart';
import 'package:demandium/feature/favorite/repository/my_favorite_repo.dart';
import 'package:demandium/feature/provider/model/provider_model.dart';
import 'package:get/get.dart';



class MyFavoriteController extends GetxController implements GetxService{
  final MyFavoriteRepo myFavoriteRepo;
  MyFavoriteController({required this.myFavoriteRepo});

  ServiceContent? _serviceContent;
  ServiceContent? get serviceContent => _serviceContent;

  ProviderModel? _providerModel;
  ProviderModel? get providerModel => _providerModel;

  List<Service>? _favoriteServiceList;
  List<Service>? get favoriteServiceList => _favoriteServiceList ;

  List<ProviderData>? _providerList;
  List<ProviderData>? get  providerList=> _providerList;

  Future<void> getFavoriteServiceList(int offset, bool reload ) async {
    if(offset != 1 || _favoriteServiceList == null || reload){
      if(reload){
        _favoriteServiceList = null;
      }
      Response response = await myFavoriteRepo.getFavoriteServiceList(offset);
      if (response.statusCode == 200) {
        if(reload){
          _favoriteServiceList = [];
        }
        _serviceContent = ServiceModel.fromJson(response.body).content;
        if(_favoriteServiceList != null && offset != 1){
          _favoriteServiceList!.addAll(ServiceModel.fromJson(response.body).content!.serviceList!);
        }else{
          _favoriteServiceList = [];
          _favoriteServiceList!.addAll(ServiceModel.fromJson(response.body).content!.serviceList!);
        }
        update();
      } else {
        ApiChecker.checkApi(response);
      }
    }
  }

  Future<void> getProviderList(int offset, bool reload) async {

    if(offset != 1 || _providerModel == null || reload){
      if(reload){
        _providerModel = null;
      }

      Response response = await myFavoriteRepo.getFavoriteProviderList(offset);
      if (response.statusCode == 200) {
        if(reload){
          _providerList = [];
        }
        _providerModel = ProviderModel.fromJson(response.body);
        if(_providerModel != null && offset != 1){
          _providerList!.addAll(ProviderModel.fromJson(response.body).content?.data??[]);
        }else{
          _providerList = [];
          _providerList!.addAll(ProviderModel.fromJson(response.body).content?.data??[]);
        }
        update();
      } else {
         ApiChecker.checkApi(response);
      }
    }
  }


  Future<void> removeFavoriteService(String serviceId) async {
    Response response = await myFavoriteRepo.removeFavoriteService(serviceId);
    if(response.statusCode == 200){
      _favoriteServiceList?.removeWhere((element) => element.id == serviceId);
      Get.find<ServiceController>().updateIsFavoriteValue(0, serviceId, shouldUpdate: true);
    }
    update();
  }

  Future<void> removeFavoriteProvider(String providerId) async {
    Response response = await myFavoriteRepo.removeFavoriteProvider(providerId);

    if(response.statusCode == 200 && response.body['response_code'] == "default_delete_200"){
      _providerList?.removeWhere((element) => element.id == providerId);
      Get.find<ProviderBookingController>().updateIsFavoriteValue(0, providerId, shouldUpdate: true);
    }
    update();
  }


}

