import 'dart:ui';

import 'package:demandium/components/core_export.dart';
import 'package:demandium/core/helper/map_bound_helper.dart';
import 'package:demandium/feature/home/controller/advertisement_controller.dart';
import 'package:demandium/feature/provider/controller/explore_provider_controller.dart';
import 'package:demandium/feature/provider/model/category_model_item.dart';
import 'package:demandium/feature/provider/model/provider_details_model.dart';
import 'package:demandium/feature/provider/model/provider_model.dart';
import 'package:get/get.dart';
import 'package:scroll_to_index/scroll_to_index.dart';


class ProviderBookingController extends GetxController implements GetxService {
  final ProviderBookingRepo providerBookingRepo;
  ProviderBookingController({required this.providerBookingRepo});


  @override
  void onInit() async {
    super.onInit();
    getCategoryList();
  }

  final bool _isLoading = false;
  get isLoading => _isLoading;

  ProviderModel? _providerModel;
  ProviderModel? get providerModel => _providerModel;

  ProviderDetailsContent? _providerDetailsContent;
  ProviderDetailsContent? get providerDetailsContent => _providerDetailsContent;

  List<CategoryModelItem> categoryItemList =[];

  List<ProviderData>? _providerList;
  List<ProviderData>? get  providerList=> _providerList;

  Set<Marker> markers = HashSet<Marker>();
  int selectedProviderIndex = 0;
  AutoScrollController? scrollController;


  String formatDays(List<String> dayList) {
    if (dayList.isEmpty) {
      return "";
    }
    List<String> formattedList = dayList.map((day) => day[0].toLowerCase() + day.substring(1)).toList();
    if (formattedList.length == 1) {
      return formattedList[0].tr;
    }
    formattedList.sort((a, b) {
      const daysOfWeek = [ "saturday", "sunday", "monday", "tuesday", "wednesday", "thursday", "friday"];
      return daysOfWeek.indexOf(a) - daysOfWeek.indexOf(b);
    });
    bool isConsecutive = true;
    for (int i = 1; i < formattedList.length; i++) {
      if (_nextDay(formattedList[i - 1]) != formattedList[i]) {
        isConsecutive = false;
        break;
      }
    }
    if (isConsecutive) {
      return "${formattedList.first.toLowerCase().tr} - ${formattedList.last.toLowerCase().tr}";
    } else {

      List<String> translatedList =[];
      for (var element in formattedList) {
        translatedList.add(element.tr);
      }
      return translatedList.join(', ');
    }
  }
  String _nextDay(String day) {
    const daysOfWeek = [ "saturday", "sunday", "monday", "tuesday", "wednesday", "thursday","friday"];
    final index = daysOfWeek.indexOf(day);
    return daysOfWeek[(index + 1) % daysOfWeek.length];
  }


  Future<void> getProviderList(int offset, bool reload) async {

    if(offset != 1 || _providerList == null || reload){

      if(reload){
        _providerList = null;
      }
      
      Map<String,dynamic> body={
        'sort_by': sortBy[selectedSortByIndex],
        'rating': selectedRatingIndex,
      }; 
      
      if(selectedCategoryId.isNotEmpty){
        body.addAll({'category_ids': selectedCategoryId});
      }

      Response response = await providerBookingRepo.getProviderList(offset,body);
      if (response.statusCode == 200) {
        if(reload){
          _providerList = [];
        }
        _providerModel = ProviderModel.fromJson(response.body);
        if(_providerList != null && offset != 1){
          _providerList!.addAll(_providerModel?.content?.data??[]);
        }else{
          _providerList = [];
          _providerList!.addAll(_providerModel?.content?.data??[]);
        }

      } else {
        ApiChecker.checkApi(response);
      }
      update();

    }
  }



  Future<void> getProviderDetailsData(String providerId, bool reload) async {

    if(_providerDetailsContent == null || reload){
      if(reload){
        categoryItemList =[];
        _providerDetailsContent = null;
      }
      Response response = await providerBookingRepo.getProviderDetails(providerId);
      if (response.statusCode == 200) {
        _providerDetailsContent = ProviderDetails.fromJson(response.body).content;

        if(_providerDetailsContent!.subCategories!=null || _providerDetailsContent!.subCategories!.isNotEmpty){
          for (var subcategory in _providerDetailsContent!.subCategories!) {
            List<Service> serviceList = [];
            if(subcategory.services!.isNotEmpty){
              subcategory.services?.forEach((service) {
                  serviceList.add(service);
              });

              if(serviceList.isNotEmpty){
                categoryItemList.add(CategoryModelItem(
                  title: subcategory.name!, serviceList: serviceList,
                ));
              }
            }
          }
        }
      } else {
        ApiChecker.checkApi(response);
      }
      update();
    }
  }

  int _apiHitCount = 0;

  Future<void> updateIsFavoriteStatus({ required String providerId, required int index}) async {

    _apiHitCount ++;
    updateIsFavoriteValue(providerList?[index].isFavorite ==1 ? 0 : 1,providerId);
    update();
    Response response = await providerBookingRepo.updateIsFavoriteStatus(serviceId: providerId);

    _apiHitCount --;
    int status;
    if(response.statusCode == 200 && (response.body['response_code'] == "provider_favorite_store_200" || response.body['response_code'] == "provider_remove_favorite_200")){
      if(response.body['content']['status'] !=null){
        status  = response.body['content']['status'];
        updateIsFavoriteValue(status,providerId);
        customSnackBar(response.body['message'], isError: status == 1 ? false : true);
      }
    }

    if(_apiHitCount ==0){
      update();
    }
  }

  updateIsFavoriteValue(int status, String providerId, {bool shouldUpdate = false, bool fromProviderBooking = true}){

    int? index = _providerList?.indexWhere((element) => element.id == providerId);
    if(index !=null && index > -1){
      _providerList?[index].isFavorite = status;
    }
    Get.find<AdvertisementController>().updateIsFavoriteValue(status, providerId, shouldUpdate: true);
    if(fromProviderBooking){
      Get.find<ExploreProviderController>().updateIsFavoriteValue(status, providerId, shouldUpdate: true, fromExploreProviderScreen: false);

    }
    if(shouldUpdate){
      update();
    }
  }



  /// filter Section
  int selectedRatingIndex = 0;
  int selectedSortByIndex = 0;

  List<CategoryModel> categoryList =[];

  List<String> sortBy = ['asc',"desc"];

  List<bool> categoryCheckList =[];
  List<String> selectedCategoryId =[];

  Future<void> getCategoryList() async {
    Response response = await providerBookingRepo.getCategoryList();
    if(response.statusCode == 200){

      categoryList = [];
      categoryCheckList = [];

      List<dynamic> serviceCategoryList = response.body['content']['data'];
      for (var category in serviceCategoryList) {
        categoryList.add(CategoryModel.fromJson(category));
        categoryCheckList.add(false);
      }
    }
    else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  updateSortByIndex(int rating){
    selectedSortByIndex= rating;
    update();
  }

  updateRatingIndex(int rating){
    selectedRatingIndex= rating;
    update();
  }

  void toggleFromCampaignChecked(int index) {

    categoryCheckList[index] = !categoryCheckList[index];

    if(categoryCheckList[index]==true){
      if(!selectedCategoryId.contains(categoryList[index].id)){
        selectedCategoryId.add(categoryList[index].id!);
      }
    }else{
      if(selectedCategoryId.contains(categoryList[index].id)){
        selectedCategoryId.remove(categoryList[index].id);
      }
    }
    update();

  }

  resetProviderFilterData({bool shouldUpdate= false}){
    selectedCategoryId=[];
    categoryCheckList = [];
    selectedRatingIndex=0;
    selectedSortByIndex = 0;

    for (var element in categoryList) {
      categoryCheckList.add(false);
      if (kDebugMode) {
        print(element.name);
      }
    }
    if(shouldUpdate){
      update();
    }
  }

  Future<void> setMarker(GoogleMapController mapController, LatLng initialPosition) async {

    final Uint8List selectedProvider = await convertAssetToUnit8List(Images.selectedProvider,width:  70);
    final Uint8List unselectedProvider = await  convertAssetToUnit8List(Images.unselectedProvider, width:  60);
    final Uint8List currentLocationIcon = await  convertAssetToUnit8List(Images.currentLocation, width:  50);

    // Marker
    markers = HashSet<Marker>();
    for(int index = 0; index < _providerList!.length; index++) {

      if(_providerList![index].coordinates !=null){
        markers.add(Marker(
            onTap: () async {
              _resetMarker(index, mapController, initialPosition, selectedProvider, unselectedProvider, currentLocationIcon);
              await scrollController!.scrollToIndex(index, preferPosition: AutoScrollPosition.middle);
              await scrollController!.highlight(index);
            },
            markerId: MarkerId('branch_$index'),
            position: LatLng(_providerList![index].coordinates!.latitude!, _providerList![index].coordinates!.longitude!),
            infoWindow: InfoWindow(title: _providerList![index].companyName),
            icon:  BitmapDescriptor.bytes(
              selectedProviderIndex == index ?  selectedProvider : unselectedProvider,
            )
        ));
      }
    }

    markers.add(Marker(
      onTap: (){
        mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target:  initialPosition,
          zoom: 16,
        )));
      },
      markerId: const MarkerId('current_location'),
      position: initialPosition,
      infoWindow: InfoWindow(title: "my_location".tr, snippet: ''),
      icon: BitmapDescriptor.bytes(currentLocationIcon),
    ));

    mapBound(mapController);

  }

  void _resetMarker(int index, GoogleMapController mapController, LatLng initialPosition, Uint8List selectedProvider,Uint8List unselectedProvider, Uint8List currentLocationIcon){
    selectedProviderIndex = index;

    markers = HashSet<Marker>();
    for(int index = 0; index < _providerList!.length; index++) {

      if(_providerList![index].coordinates !=null){
        markers.add(Marker(
          onTap: () async {
            _resetMarker(index, mapController, initialPosition, selectedProvider, unselectedProvider, currentLocationIcon);
            await scrollController!.scrollToIndex(index, preferPosition: AutoScrollPosition.middle);
            await scrollController!.highlight(index);
            },
          markerId: MarkerId('branch_$index'),
          position: LatLng(_providerList![index].coordinates!.latitude!, _providerList![index].coordinates!.longitude!),
          infoWindow: InfoWindow(title: _providerList![index].companyName),
          icon:  BitmapDescriptor.bytes(
            selectedProviderIndex == index ?  selectedProvider : unselectedProvider,
          ),
        ));
      }
    }

    markers.add(Marker(
      onTap: (){
        mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target:  initialPosition,
          zoom: 16,
        )));
      },
      markerId: const MarkerId('current_location'),
      position: initialPosition,
      infoWindow: InfoWindow(title: "my_location".tr, snippet: ''),
      icon: BitmapDescriptor.bytes(currentLocationIcon),
    ));

    update();
  }



  Future<Uint8List> convertAssetToUnit8List(String imagePath, {int width = 50}) async {
    ByteData data = await rootBundle.load(imagePath);
    Codec codec = await instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ImageByteFormat.png))!.buffer.asUint8List();
  }


  void mapBound(GoogleMapController controller) async {
    List<LatLng> latLongList = [];
    for (int index = 0; index < _providerList!.length; index++) {
      if(_providerList![index].coordinates !=null){
        latLongList.add(LatLng(_providerList![index].coordinates!.latitude!, _providerList![index].coordinates!.longitude!));
      }
    }
    await controller.getVisibleRegion();
    Future.delayed(const Duration(milliseconds: 100), () {
      controller.animateCamera(CameraUpdate.newLatLngBounds(
        MapHelper.boundsFromLatLngList(latLongList),
        100.5,
      ));
    });

    update();
  }


}