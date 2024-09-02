import 'package:demandium/feature/home/widget/referal_welcome_dialog.dart';
import 'package:demandium/feature/service/model/recommendation_search_model.dart';
import 'package:get/get.dart';
import 'package:demandium/components/core_export.dart';
import 'package:demandium/feature/campaign/model/service_types.dart';

class ServiceController extends GetxController implements GetxService {
  final ServiceRepo serviceRepo;
  ServiceController({required this.serviceRepo});


  bool _isLoading = false;
  List<int>? _variationIndex;

  final int _cartIndex = -1;


  ServiceContent? _serviceContent;
  ServiceContent? _offerBasedServiceContent;
  ServiceContent? _popularBasedServiceContent;
  ServiceContent? _recommendedServiceContent;
  ServiceContent? _trendingServiceContent;
  ServiceContent? _recentlyViewServiceContent;
  FeatheredCategoryContent? _featheredCategoryContent;



  ServiceContent? get serviceContent => _serviceContent;
  ServiceContent? get offerBasedServiceContent => _offerBasedServiceContent;
  ServiceContent? get popularBasedServiceContent => _popularBasedServiceContent;
  ServiceContent? get recommendedBasedServiceContent => _recommendedServiceContent;
  ServiceContent? get trendingServiceContent => _trendingServiceContent;
  ServiceContent? get recentlyViewServiceContent => _recentlyViewServiceContent;
  FeatheredCategoryContent? get featheredCategoryContent => _featheredCategoryContent;

  List<Service>? _popularServiceList;
  List<Service>? _trendingServiceList;
  List<Service>? _recentlyViewServiceList;
  List<Service>? _recommendedServiceList;
  List<RecommendedSearch>? _recommendedSearchList;
  List<Service>? _subCategoryBasedServiceList;
  List<Service>? _campaignBasedServiceList;
  List<Service>? _offerBasedServiceList;
  List<Service>? _allService;
  List<CategoryData>? _categoryList;


  List<Service>? get allService => _allService ;
  List<Service>? get popularServiceList => _popularServiceList;
  List<Service>? get trendingServiceList => _trendingServiceList;
  List<Service>? get recentlyViewServiceList => _recentlyViewServiceList;
  List<Service>? get recommendedServiceList => _recommendedServiceList;
  List<Service>? get subCategoryBasedServiceList => _subCategoryBasedServiceList;
  List<Service>? get campaignBasedServiceList => _campaignBasedServiceList;
  List<Service>? get offerBasedServiceList => _offerBasedServiceList;
  List<RecommendedSearch>? get recommendedSearchList => _recommendedSearchList;
  List<CategoryData>? get categoryList => _categoryList ;


  bool get isLoading => _isLoading;
  List<int>? get variationIndex => _variationIndex;

  int get cartIndex => _cartIndex;

  String? _fromPage;
  String? get fromPage => _fromPage!;

  final List<double> _lowestPriceList = [];
  List<double> get lowestPriceList => _lowestPriceList;

  @override
  Future<void> onInit() async {
    super.onInit();
    if(Get.find<AuthController>().isLoggedIn()) {
     await Get.find<UserController>().getUserInfo();

     await Get.find<CartController>().getCartListFromServer();
    }
  }



  Future<void> getAllServiceList(int offset, bool reload) async {
    if(offset != 1 || _allService == null || reload){
      if(reload){
        _allService = null;
      }
      Response response = await serviceRepo.getAllServiceList(offset);
      if (response.statusCode == 200) {
        if(reload){
          _allService = [];
        }
        _serviceContent = ServiceModel.fromJson(response.body).content;
        if(_allService != null && offset != 1){
          _allService!.addAll(ServiceModel.fromJson(response.body).content!.serviceList!);
        }else{
          _allService = [];
          _allService!.addAll(ServiceModel.fromJson(response.body).content!.serviceList!);
        }
        update();
      } else {
        ApiChecker.checkApi(response);
      }

      if(_allService !=null && _allService!.isNotEmpty && offset == 1 && (Get.currentRoute.contains(RouteHelper.main) || Get.currentRoute.contains("/?page=home"))){

        if(Get.find<UserController>().showReferWelcomeDialog() && Get.find<AuthController>().getIsShowReferralBottomSheet() == true){
          Future.delayed(const Duration(microseconds: 500), () {
            showModalBottomSheet(
              isDismissible: false,
              context: Get.context!,
              useRootNavigator: true,
              isScrollControlled: true,
              builder: (context) => const BottomCreatePostDialog(),
              backgroundColor: Colors.transparent,
            );
          });
        }
      }
    }
  }


  Future<void> getPopularServiceList(int offset, bool reload) async {
    if(offset != 1 || _popularServiceList == null || reload ){
      Response response = await serviceRepo.getPopularServiceList(offset);
      if (response.statusCode == 200) {
        if(reload){
          _popularServiceList = [];
        }
        _popularBasedServiceContent = ServiceModel.fromJson(response.body).content;

        if(_popularServiceList != null && offset != 1){
          _popularServiceList!.addAll(_popularBasedServiceContent!.serviceList!);
        }else{
          _popularServiceList = [];
          _popularServiceList!.addAll(_popularBasedServiceContent!.serviceList!);
        }
      } else {
        ApiChecker.checkApi(response);
      }
      update();
    }
  }


  Future<void> getTrendingServiceList(int offset, bool reload) async {
    if(offset != 1 || _trendingServiceList == null || reload ){
      Response response = await serviceRepo.getTrendingServiceList(offset);
      if (response.statusCode == 200) {
        if(reload){
          _trendingServiceList = [];
        }
        _trendingServiceContent = ServiceModel.fromJson(response.body).content;

        if(_trendingServiceList != null && offset != 1){
          _trendingServiceList!.addAll(_trendingServiceContent!.serviceList!);
        }else{
          _trendingServiceList = [];
          _trendingServiceList!.addAll(_trendingServiceContent!.serviceList!);
        }
      } else {
        ApiChecker.checkApi(response);
      }
      update();
    }
  }


  Future<void> getRecentlyViewedServiceList(int offset, bool reload) async {
    if(offset != 1 || _recentlyViewServiceList == null || reload ){
      Response response = await serviceRepo.getRecentlyViewedServiceList(offset);
      if (response.statusCode == 200) {
        if(reload){
          _recentlyViewServiceList = [];
        }
        _recentlyViewServiceContent = ServiceModel.fromJson(response.body).content;

        if(_recentlyViewServiceList != null && offset != 1){
          _recentlyViewServiceList!.addAll(_recentlyViewServiceContent!.serviceList!);
        }else{
          _recentlyViewServiceList = [];
          _recentlyViewServiceList!.addAll(_recentlyViewServiceContent!.serviceList!);
        }
      } else {
        //ApiChecker.checkApi(response);
      }
      update();
    }
  }



  Future<void> getFeatherCategoryList( bool reload) async {

    if(_featheredCategoryContent == null || reload){
      if(reload){
        _categoryList =[];
        _featheredCategoryContent = null;
      }
      Response response = await serviceRepo.getFeatheredCategoryServiceList();
      if (response.statusCode == 200) {
        _featheredCategoryContent = FeatheredCategoryModel.fromJson(response.body).content;

        if(_featheredCategoryContent!.categoryList!=null || _featheredCategoryContent!.categoryList!.isNotEmpty){
          _categoryList =[];
          _featheredCategoryContent?.categoryList?.forEach((element) {
            if(element.servicesByCategory!=null && element.servicesByCategory!.isNotEmpty){
              _categoryList!.add(element);
            }
          });
        }
      } else {
        ApiChecker.checkApi(response);
      }
      update();
    }
  }

  Future<void> getRecommendedServiceList(int offset, bool reload ) async {
   if(offset != 1 || _recommendedServiceList == null || reload){
     Response response = await serviceRepo.getRecommendedServiceList(offset);
     if (response.statusCode == 200) {
       if(reload){
         _recommendedServiceList = [];
       }
       _recommendedServiceContent = ServiceModel.fromJson(response.body).content;
       if(_recommendedServiceList != null && offset != 1){
         _recommendedServiceList!.addAll(ServiceModel.fromJson(response.body).content!.serviceList!);
       }else{
         _recommendedServiceList = [];
         _recommendedServiceList!.addAll(_recommendedServiceContent!.serviceList!);
       }
     } else {
       ApiChecker.checkApi(response);
     }
     update();
   }
  }

  Future<void> getRecommendedSearchList({bool reload = false}) async {

    if(_recommendedSearchList == null || reload){
      if(reload){
        _recommendedSearchList = null;
        update();
      }
      Response response = await serviceRepo.getRecommendedSearchList();
      if (response.statusCode == 200) {
        if(response.body['content']!=null){
          List<dynamic> list = response.body['content'];
          _recommendedSearchList = [];
          for (var element in list) {
            _recommendedSearchList?.add(RecommendedSearch.fromJson(element));
          }
        }
      } else {
        ApiChecker.checkApi(response);
      }
      update();
    }

  }

  int _apiHitCount = 0;

  Future<void> updateIsFavoriteStatus({required String serviceId, required int currentStatus}) async {
    _apiHitCount++;
    updateIsFavoriteValue( currentStatus == 1 ? 0 : 1, serviceId);
    update();

    Response response = await serviceRepo.updateIsFavoriteStatus(serviceId: serviceId);
    _apiHitCount--;
    int status;
    if(response.statusCode == 200 && (response.body['response_code'] == "service_favorite_store_200" || response.body['response_code'] == "service_remove_favorite_200")){
      if(response.body['content']['status'] !=null){
        status  = response.body['content']['status'];

        customSnackBar(response.body['message'], isError: status==1? false : true);
        updateIsFavoriteValue(status, serviceId);
      }
    }
    if(_apiHitCount == 0){
      update();
    }

  }

  updateIsFavoriteValue(int status, String serviceId, {bool shouldUpdate = false}){
    if(_allService !=null){
      int? index = _allService?.indexWhere((element) => element.id == serviceId);
      if(index !=null && index>-1){
        _allService![index].isFavorite = status;
      }
    }

    if(_popularServiceList !=null){
      int? index = _popularServiceList?.indexWhere((element) => element.id == serviceId);
      if(index !=null && index>-1){
        _popularServiceList![index].isFavorite = status;
      }
    }

    if(_trendingServiceList !=null) {
      int? index = _trendingServiceList?.indexWhere((element) => element.id == serviceId);
      if(index !=null && index>-1){
        _trendingServiceList![index].isFavorite = status;
      }
    }

    if(_recentlyViewServiceList !=null){
      int? index = _recentlyViewServiceList?.indexWhere((element) => element.id == serviceId);
      if(index !=null && index>-1){
        _recentlyViewServiceList![index].isFavorite = status;
      }
    }

    if(_recommendedServiceList !=null){
      int? index = _recommendedServiceList?.indexWhere((element) => element.id == serviceId);
      if(index !=null && index>-1){
        _recommendedServiceList![index].isFavorite = status ;
      }
    }

    if(_offerBasedServiceList !=null){
      int? index = _offerBasedServiceList?.indexWhere((element) => element.id == serviceId);
      if(index !=null && index>-1){
        _offerBasedServiceList![index].isFavorite = status ;
      }
    }

    if(_subCategoryBasedServiceList !=null){
      int? index = _subCategoryBasedServiceList?.indexWhere((element) => element.id == serviceId);
      if(index !=null && index>-1){
        _subCategoryBasedServiceList![index].isFavorite = status ;
      }
    }

    if(_campaignBasedServiceList !=null){
      int? index = _subCategoryBasedServiceList?.indexWhere((element) => element.id == serviceId);
      if(index !=null && index>-1){
        _subCategoryBasedServiceList![index].isFavorite = status ;
      }
    }

    for(int categoryIndex = 0; categoryIndex < (_categoryList?.length ?? 0) ; categoryIndex ++){
      int? serviceIndex = _categoryList![categoryIndex].servicesByCategory?.indexWhere((element) => element.id ==serviceId);

      if(serviceIndex !=null && serviceIndex>-1){
        _categoryList![categoryIndex].servicesByCategory?[serviceIndex].isFavorite = status;
      }
    }

    Get.find<AllSearchController>().updateIsFavoriteValue(status, serviceId, shouldUpdate: shouldUpdate);

    if(shouldUpdate){
      update();
    }
  }


   cleanSubCategory(){
    _subCategoryBasedServiceList = null;
    update();
  }

  Future<void> getSubCategoryBasedServiceList(String subCategoryID, bool isWithPagination, {bool isShouldUpdate = true, bool showShimmerAlways = false}) async {
    if(showShimmerAlways){
      _subCategoryBasedServiceList = null;
      update();
    }
    if(subCategoryID !=""){
      Response response = await serviceRepo.getServiceListBasedOnSubCategory(subCategoryID: subCategoryID,offset: 1);
      if (response.statusCode == 200) {
        if(!isWithPagination){
          _subCategoryBasedServiceList = [];
        }
        _subCategoryBasedServiceList!.addAll(ServiceModel.fromJson(response.body).content?.serviceList??[]);
      } else {
        ApiChecker.checkApi(response);
      }
    }else{
      _subCategoryBasedServiceList = [];
    }

    if(isShouldUpdate){
      update();
    }
  }

  Future<void> getCampaignBasedServiceList(String campaignID, bool reload) async {
    Response response = await serviceRepo.getItemsBasedOnCampaignId(campaignID: campaignID);
    if (response.body['response_code'] == 'default_200') {
      if(reload){
        _campaignBasedServiceList = [];
      }
      response.body['content']['data'].forEach((serviceTypesModel) {
        if(ServiceTypesModel.fromJson(serviceTypesModel).service != null){
          _campaignBasedServiceList!.add(ServiceTypesModel.fromJson(serviceTypesModel).service!);
        }
      });
      Get.toNamed(RouteHelper.allServiceScreenRoute("fromCampaign",campaignID: campaignID));
    } else {
      customSnackBar('campaign_is_not_available_for_this_service'.tr);
      if(response.statusCode != 200){
        ApiChecker.checkApi(response);
      }
    }
    update();
  }

  Future<void> getEmptyCampaignService()async {
    _campaignBasedServiceList = null;
  }

  Future<void> getMixedCampaignList(String campaignID, bool isWithPagination) async {
    if(!isWithPagination){
      _campaignBasedServiceList = [];
    }
    Response response = await serviceRepo.getItemsBasedOnCampaignId(campaignID: campaignID);
    if (response.body['response_code'] == 'default_200') {
      response.body['content']['data'].forEach((serviceTypesModel) {
        if(ServiceTypesModel.fromJson(serviceTypesModel).service != null){
          _campaignBasedServiceList!.add(ServiceTypesModel.fromJson(serviceTypesModel).service!);
        }
      });
      _isLoading = false;
      if(_campaignBasedServiceList!.isEmpty){
        Get.find<CategoryController>().getCampaignBasedCategoryList(campaignID,false);
      }else{
        Get.toNamed(RouteHelper.allServiceScreenRoute("fromCampaign",campaignID: campaignID));
      }
    } else {
      if(response.statusCode != 200){
        ApiChecker.checkApi(response);
      }else{
        customSnackBar('campaign_is_not_available_for_this_service'.tr);
      }
    }
    update();
  }

  Future<void> getOffersList(int offset, bool reload) async {
    Response response = await serviceRepo.getOffersList(offset);
    if (response.statusCode == 200) {
      if( reload){
        _offerBasedServiceList = [];
      }
      _offerBasedServiceContent = ServiceModel.fromJson(response.body).content;
      if(_offerBasedServiceList != null && offset != 1){
        _offerBasedServiceList!.addAll(_offerBasedServiceContent!.serviceList!);
      }else{
        _offerBasedServiceList = [];
        _offerBasedServiceList!.addAll(_offerBasedServiceContent!.serviceList!);
      }
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }



}
