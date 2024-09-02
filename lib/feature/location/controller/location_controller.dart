import 'dart:convert';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:demandium/core/helper/map_bound_helper.dart';
import 'package:demandium/feature/address/model/address_format.dart';
import 'package:get/get.dart';
import 'package:demandium/components/core_export.dart';
import 'package:demandium/feature/location/model/place_details_model.dart';

enum Address {service, billing }
enum AddressLabel {home, office, others }
class LocationController extends GetxController implements GetxService {
  final LocationRepo locationRepo;
  LocationController({required this.locationRepo});

  Position _position = Position(longitude: 0, latitude: 0, timestamp: DateTime.now(), accuracy: 1, altitude: 1, heading: 1, speed: 1, speedAccuracy: 1, altitudeAccuracy: 1, headingAccuracy: 1);
  Position _pickPosition = Position(longitude: 0, latitude: 0, timestamp: DateTime.now(), accuracy: 1, altitude: 1, heading: 1, speed: 1, speedAccuracy: 1, altitudeAccuracy: 1, headingAccuracy: 1);
  bool _loading = false;
  AddressModel _address = AddressModel();
  AddressModel _pickAddress = AddressModel() ;
  final List<Marker> _markers = <Marker>[];
  List<AddressModel>? _addressList;
  final int _addressLabelIndex = 0;
  AddressModel? _selectedAddress;
  bool _isLoading = false;
  bool _inZone = false;
  String _zoneID = '';
  bool _buttonDisabled = true;
  bool _changeAddress = true;
  GoogleMapController? _mapController;
  List<PredictionModel> _predictionList = [];
  PredictionModel? _firstPredictionModel;
  bool _updateAddAddressData = true;
  Address _selectedAddressType = Address.service;
  AddressLabel _selectedAddressLabel = AddressLabel.home;
  TextEditingController searchController = TextEditingController();
  String  countryDialCode = CountryCode.fromCountryCode(Get.find<SplashController>().configModel.content?.countryCode ?? "BD").dialCode!;






  List<PredictionModel> get predictionList => _predictionList;
  PredictionModel? get firstPredictionModel => _firstPredictionModel;
  bool get isLoading => _isLoading;
  bool get loading => _loading;
  Position get position => _position;
  Position get pickPosition => _pickPosition;
  AddressModel get address => _address;
  AddressModel get pickAddress => _pickAddress;
  List<Marker> get markers => _markers;
  List<AddressModel>? get addressList => _addressList;
  int get addressLabelIndex => _addressLabelIndex;
  bool get inZone => _inZone;
  String get zoneID => _zoneID;
  bool get buttonDisabled => _buttonDisabled;
  GoogleMapController get mapController => _mapController!;

  ///address type like home , office , others
  Address get selectedAddressType => _selectedAddressType;
  AddressLabel get selectedAddressLabel => _selectedAddressLabel;
  AddressModel? get selectedAddress => _selectedAddress;

  set buttonDisabledOption(bool value) => _buttonDisabled = value;



  Future<AddressModel> getCurrentLocation(bool fromAddress, {GoogleMapController? mapController, LatLng? defaultLatLng, bool notify = true}) async {
    _loading = true;
    if(notify) {
      update();
    }
    AddressModel addressModel;
    Position myPosition;
    try {
      await Geolocator.requestPermission();
      Position newLocalData = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      if(defaultLatLng !=null){

        myPosition =  Position(
          latitude:defaultLatLng.latitude,
          longitude:defaultLatLng.longitude,
          timestamp: DateTime.now(), accuracy: 1, altitude: 1, heading: 1, speed: 1, speedAccuracy: 1,
            altitudeAccuracy: 1, headingAccuracy: 1
        );
      }else{
        myPosition = newLocalData;
      }
    }catch(e) {
      if(defaultLatLng != null){
        myPosition = Position(
          latitude:defaultLatLng.latitude,
          longitude:defaultLatLng.longitude,
          timestamp: DateTime.now(), accuracy: 1, altitude: 1, heading: 1, speed: 1, speedAccuracy: 1,  altitudeAccuracy: 1, headingAccuracy: 1
        );
      }else{
        myPosition = Position(
          latitude:  Get.find<SplashController>().configModel.content?.defaultLocation?.latitude ?? 23.0000,
          longitude: Get.find<SplashController>().configModel.content?.defaultLocation?.longitude ?? 90.0000,
          timestamp: DateTime.now(), accuracy: 1, altitude: 1, heading: 1, speed: 1, speedAccuracy: 1,  altitudeAccuracy: 1, headingAccuracy: 1
        );
      }

    }
    if(fromAddress) {
      _position = myPosition;
    }else {
      _pickPosition = myPosition;
    }
    if (mapController != null) {

      mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(myPosition.latitude, myPosition.longitude), zoom: 16),
      ));
    }
    AddressModel address = await getAddressFromGeocode(LatLng(myPosition.latitude, myPosition.longitude));


    ZoneResponseModel responseModel = await getZone(myPosition.latitude.toString(), myPosition.longitude.toString(), true, isLoading: fromAddress);

    if(fromAddress){
      if(responseModel.zoneIds == getUserAddress()?.zoneId){
        _buttonDisabled = false;
      }else{
        _buttonDisabled = true;
      }
    }else{
      _buttonDisabled = !responseModel.isSuccess;
    }

    String? firstName;

    if( Get.find<AuthController>().isLoggedIn() && Get.find<UserController>().userInfoModel?.phone!=null && Get.find<UserController>().userInfoModel?.fName !=null){
      firstName = "${Get.find<UserController>().userInfoModel?.fName} ";
    }
    addressModel = AddressModel(
      latitude: myPosition.latitude.toString(), longitude: myPosition.longitude.toString(), addressType: 'others',
      zoneId: responseModel.isSuccess ? responseModel.zoneIds : '',
      address: address.address ?? "",
      country: address.country ?? "",
      house: address.house ?? "",
      street: address.street ?? "",
      city: address.city ?? "",
      zipCode: address.zipCode ?? "",
      addressLabel: AddressLabel.home.name,
      availableServiceCountInZone: responseModel.totalServiceCount,
        contactPersonNumber: firstName !=null? Get.find<UserController>().userInfoModel?.phone ?? "" : "",
        contactPersonName: firstName!=null ? "$firstName${Get.find<UserController>().userInfoModel?.lName ?? "" }" : ""
    );

    fromAddress ? _address = addressModel : _pickAddress = addressModel;
    _loading = false;
    update();
    return addressModel;
  }

  Future<ZoneResponseModel> getZone(String lat, String long, bool markerLoad, {bool isLoading = false}) async {
    
    if(!isLoading){
      _isLoading = true;
    }
    update();
    ZoneResponseModel responseModel;
    Response response = await locationRepo.getZone(lat, long);

    int totalServiceCountInZone = 0;
    if(response.statusCode == 200 && response.body['content'] != null) {
      _inZone = true;
      _zoneID = response.body['content']['zone']['id'];

      if(response.body['content']['available_services_count'] !=null){
        totalServiceCountInZone = int.tryParse(response.body['content']['available_services_count'].toString()) ?? 0;
      }
      responseModel = ZoneResponseModel(true, '',_zoneID, totalServiceCountInZone);
    }else {
      _inZone = false;
      responseModel = ZoneResponseModel(false, response.body['message'], '',totalServiceCountInZone);
    }
    if(!isLoading){
      _isLoading = false;
      
    }
    update();
    return responseModel;
  }

  void updatePosition(CameraPosition position, bool fromAddress, {bool formCheckout = false}) async {
    if(_updateAddAddressData) {
      _loading = true;
      update();
      try {
        if (fromAddress) {
          _position = Position(
            latitude: position.target.latitude, longitude: position.target.longitude, timestamp: DateTime.now(),
            heading: 1, accuracy: 1, altitude: 1, speedAccuracy: 1, speed: 1,
              altitudeAccuracy: 1, headingAccuracy: 1
          );
        } else {
          _pickPosition = Position(
            latitude: position.target.latitude, longitude: position.target.longitude, timestamp: DateTime.now(),
            heading: 1, accuracy: 1, altitude: 1, speedAccuracy: 1, speed: 1,
              altitudeAccuracy: 1, headingAccuracy: 1
          );
        }
        ZoneResponseModel responseModel = await getZone(position.target.latitude.toString(), position.target.longitude.toString(), true, isLoading: formCheckout);
        if( formCheckout && !responseModel.zoneIds.contains(getUserAddress()?.zoneId??'')){
          Get.dialog(
            ConfirmationDialog(
                description: null, icon: null, onYesPressed: null,
                widget: Column(mainAxisSize: MainAxisSize.min, children: [
                  Text('this_service_not_available'.tr),
                  const SizedBox(height: Dimensions.paddingSizeDefault),
                  CustomButton(buttonText: 'ok'.tr, onPressed: ()=> Get.back()),
                ],)),
          );

        }else{
          if(responseModel.isSuccess) {
            _buttonDisabled = false;
          }
        }
        if (_changeAddress) {
          AddressModel address = await getAddressFromGeocode(LatLng(position.target.latitude, position.target.longitude));

          fromAddress ? _address= address : _pickAddress = address;

        } else {
          _changeAddress = true;
        }
      } catch (e) {
        if (kDebugMode) {
          print('');
        }
      }
    }else {
      _updateAddAddressData = true;
    }
    _loading = false;
    update();
  }

  Future<ResponseModel> deleteUserAddressByID(AddressModel address) async {
    ResponseModel responseModel ;
    Response response = await locationRepo.removeAddressByID(address.id!);
    if (response.statusCode == 200 && response.body['response_code']=="default_delete_200") {
      await getAddressList();

      if(address.id == _selectedAddress?.id) {
        _selectedAddress = null;
      }
      responseModel = ResponseModel(true, response.body['message']);
    } else {
      responseModel = ResponseModel(false, response.body['message']??response.statusText);
    }
    update();
    return responseModel;
  }

  Future<void> getAddressList({bool fromCheckout = false}) async {
    Response response = await locationRepo.getAllAddress();
    if (response.statusCode == 200) {
      _addressList = <AddressModel>[];
      response.body['content']['data'].forEach((address) {
        _addressList!.add(AddressModel.fromJson(address));
      });
    } else {
      ApiChecker.checkApi(response);
    }
    if(_addressList != null && _addressList!.isNotEmpty){
      for(var element in _addressList!){
        if(element.id == getUserAddress()?.id){
          _addressList?.remove(element);
          _addressList?.insert(0, element);
        }
      }
    }
   // _isLoading = false;

    update();
  }

  Future<void> addAddress(AddressModel addressModel, bool fromAddAddressScreen) async {
    _isLoading = true;
    update();
    Response response = await locationRepo.addAddress(addressModel);
    if (response.body["response_code"] == "default_store_200") {
      await getAddressList();
      if(fromAddAddressScreen){
        Get.back();
        if(addressModel.zoneId == getUserAddress()?.zoneId){
          _selectedAddress = addressModel;
          customSnackBar('new_address_added_successfully'.tr, isError: false);
        }else{
          customSnackBar('you_added_address_from_different_zone'.tr, isError: false);
        }
      }else{
        await saveUserAddress(AddressModel.fromJson(response.body["content"]));
      }
    } else {
      customSnackBar(response.statusText == 'out_of_coverage'.tr ? 'service_not_available_in_this_area'.tr : response.statusText.toString().tr, isError: false);
    }
    _isLoading = false;
    update();
  }

  Future<ResponseModel> updateAddress(AddressModel addressModel, String addressId) async {
    _isLoading = true;
    update();
    Response response = await locationRepo.updateAddress(addressModel, addressId);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      await getAddressList();
      responseModel = ResponseModel(true, response.body["response_code"]);
    } else {
      responseModel = ResponseModel(false, response.statusText.toString().tr);

    }
    _isLoading = false;
    update();
    return responseModel;
  }


  Future<bool> saveUserAddress(AddressModel address) async {
    String userAddress = jsonEncode(address.toJson());
    return await locationRepo.saveUserAddress(userAddress, address.zoneId);
  }


  AddressModel? getUserAddress() {
    AddressModel? addressModelUser;
    try {
      addressModelUser = AddressModel.fromJson(jsonDecode(locationRepo.getUserAddress()!));
      //_selectedAddress = addressModelUser;
    }catch(e){
      return addressModelUser;
    }
    return addressModelUser;
  }

  ///
  Future<void> saveAddressAndNavigate(AddressModel address, bool fromSignUp, String? route, bool canRoute, bool isServiceAvailable, {bool fromAddressDialog = false, String? showDialog}) async {
    ZoneResponseModel responseModel = await getZone(address.latitude.toString(), address.longitude.toString(), true);
    AddressModel? previousAddress = getUserAddress();
    if(previousAddress != null) {
      setZoneContinue('true');
    }


    address.availableServiceCountInZone = responseModel.totalServiceCount;

    if(!fromAddressDialog && (getUserAddress() != null && getUserAddress()!.zoneId != null)? !responseModel.zoneIds.contains(getUserAddress()!.zoneId.toString()) : true && Get.find<CartController>().cartList.isNotEmpty) {
      Get.dialog(ConfirmationDialog(
        icon: Images.warning, title: 'are_you_sure_to_reset'.tr, description: 'if_you_change_location'.tr,
        onYesPressed: () {
          Get.back();
          _setZoneData(address, fromSignUp, route, canRoute,true, responseModel.zoneIds, previousAddress, isServiceAvailable, showDialog: showDialog);
        },
        onNoPressed: () {
          Get.back();
          Get.back();
        },
      ));
    }else {
      _setZoneData(address, fromSignUp, route, canRoute,false, responseModel.zoneIds, previousAddress, isServiceAvailable, showDialog: showDialog);
    }
  }

  void _setZoneData(AddressModel address, bool fromSignUp, String? route, bool canRoute,bool shouldCartDelete, String? zoneIds, AddressModel? previousAddress, bool? isServiceAvailable, {String? showDialog}) {
    if(zoneIds != null){
      address.zoneId = zoneIds;
      autoNavigate(address, fromSignUp, route, canRoute, previousAddress,isServiceAvailable, shouldCartDelete: shouldCartDelete, showDialog: showDialog);
    }

  }

  void autoNavigate(AddressModel address, bool fromSignUp, String? route, bool canRoute, AddressModel? previousAddress, bool? isServiceAvailable, {bool shouldCartDelete = false,  String? showDialog}) async {
    if(GetPlatform.isAndroid && !GetPlatform.isWeb){
      if(getUserAddress() != null){
        if (getUserAddress()!.zoneId != address.zoneId) {
          FirebaseMessaging.instance.unsubscribeFromTopic('zone_${getUserAddress()!.zoneId}_customer');
          FirebaseMessaging.instance.subscribeToTopic('zone_${address.zoneId}_customer');
        }
      }
      else {
        FirebaseMessaging.instance.subscribeToTopic('zone_${address.zoneId}_customer');
      }
    }
    await saveUserAddress(address);
    Get.offAllNamed(RouteHelper.getMainRoute('home', previousAddress: previousAddress, showServiceNotAvailableDialog: showDialog));
    if(shouldCartDelete){
      await Get.find<CartController>().removeAllCartItem();
    }
  }

  Future<AddressModel> setLocation(String placeID, String address, GoogleMapController? mapController) async {
    _loading = true;
    update();

    LatLng latLng = const LatLng(0, 0);

    AddressModel addressModel = AddressModel();
    addressModel.address = address;

    Response response = await locationRepo.getPlaceDetails(placeID);

    if(response.statusCode == 200) {
      PlaceDetailsModel placeDetails = PlaceDetailsModel.fromJson(response.body);
      if(placeDetails.content!.status == 'OK') {
        latLng = LatLng(placeDetails.content?.result?.geometry?.location?.lat ?? 0, placeDetails.content?.result?.geometry?.location?.lng ?? 0);

        addressModel.latitude = latLng.latitude.toString();
        addressModel.longitude = latLng.longitude.toString();

        placeDetails.content?.result?.addressComponents?.forEach((element) {
          if(element.types !=null){
            if(element.types!.contains("country")){
              addressModel.country = element.longName ?? "";
            }
            if(element.types!.contains("locality") && element.types!.contains("political")){
              addressModel.city = element.longName ?? "";
            }
            if(element.types!.contains("street_number")) {
              addressModel.house = element.longName ?? "";
            }
            if(element.types!.contains("route")){
              addressModel.street = element.longName ?? "";
            }
            if(element.types!.contains("postal_code")){
              addressModel.zipCode = element.longName ?? "";
            }
          }

        });
      }
    }

    _pickPosition = Position(
      latitude: latLng.latitude, longitude: latLng.longitude,
      timestamp: DateTime.now(), accuracy: 1, altitude: 1, heading: 1, speed: 1, speedAccuracy: 1,
        altitudeAccuracy: 1, headingAccuracy: 1
    );

    _pickAddress = addressModel;
    _changeAddress = false;
    if(mapController != null){
      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: latLng, zoom: 17)));
    }
    _loading = false;
    update();

    return addressModel;
  }

  void disableButton() {
    _buttonDisabled = true;
    _inZone = true;
    update();
  }

  void setAddAddressData() {
    _position = _pickPosition;
    _address = _pickAddress;
    _updateAddAddressData = false;
    update();
  }

  void setUpdateAddress(AddressModel address){
    _position = Position(
      latitude: double.parse(address.latitude!), longitude: double.parse(address.longitude!), timestamp: DateTime.now(),
      altitude: 1, heading: 1, speed: 1, speedAccuracy: 1, floor: 1, accuracy: 1,
        altitudeAccuracy: 1, headingAccuracy: 1
    );
    _address.address = address.address!;
  }

  void updateAddressType(Address address){
    _selectedAddressType = address;
    update();
  }

  void updateAddressLabel({AddressLabel? addressLabel,String addressLabelString = ''}){
    if(addressLabel == null) {
      _selectedAddressLabel = _getAddressLabel(addressLabelString);
    }else{
      _selectedAddressLabel = addressLabel;
      update();
    }
  }

  AddressLabel _getAddressLabel(String addressLabel) {
    late AddressLabel label;
    if(AddressLabel.home.name.contains(addressLabel)) {
      label = AddressLabel.home;
    }else if(AddressLabel.office.name.contains(addressLabel)){
      label = AddressLabel.office;
    }else{
      label = AddressLabel.others;
    }

    return label;
  }


  ///set address index to select address from address list
  Future<bool> setAddressIndex(AddressModel address,{bool fromAddressScreen = true}) async {
    bool isSuccess = false;
    if(fromAddressScreen){
      ZoneResponseModel selectedZone = await  getZone('${address.latitude}', '${address.longitude}', false);
      if(selectedZone.zoneIds.contains(getUserAddress()?.zoneId??"")) {
        _selectedAddress = address;

        update();
        isSuccess = true;
      }else{
        isSuccess = false;
      }
    }else{
      _selectedAddress = address;
      update();
      isSuccess = true;
    }
    return isSuccess;
  }

  void resetAddress(){
    _address.address = '';
  }

  void setPickData() {
    _pickPosition = _position;
    _pickAddress = _address;
  }

  void setMapController(GoogleMapController mapController) {
    _mapController = mapController;
  }

  Future<AddressModel> getAddressFromGeocode(LatLng latLng) async {
    Response response = await locationRepo.getAddressFromGeocode(latLng);
    AddressFormat addressFormat;
    AddressModel address = AddressModel(
      address: 'Unknown Location Found'
    );
    if(response.statusCode == 200 && response.body['content']['status'] == 'OK') {

      addressFormat = AddressFormat.fromJson( response.body['content']['results'][0]);

      addressFormat.addressComponents?.forEach((element) {

        if(element.types !=null){
          if(element.types!.contains("country")){
            address.country = element.longName ?? "";
          }
          if(element.types!.contains("locality") && element.types!.contains("political")){
            address.city = element.longName ?? "";
          }
          if(element.types!.contains("street_number")) {
            address.house = element.longName ?? "";
          }
          if(element.types!.contains("route")){
            address.street = element.longName ?? "";
          }

          if(element.types!.contains("postal_code")){
            address.zipCode = element.longName ?? "";
          }
        }
      });
      address.address = addressFormat.formattedAddress ?? "";
    }
    return address;
  }

  Future<List<PredictionModel>> searchLocation(BuildContext context, String text) async {

    _firstPredictionModel = null;

    if(text.isNotEmpty) {
      Response response = await locationRepo.searchLocation(text);
      if (response.body['response_code'] == "default_200" && response.body['content']['status'] == 'OK') {
        _predictionList = [];
        response.body['content']['predictions'].forEach((prediction) => _predictionList.add(PredictionModel.fromJson(prediction)));

        if(_predictionList.isNotEmpty){
          _firstPredictionModel = _predictionList.first;
        }
      } else {

      }
    }
    return _predictionList;
  }

  void setPlaceMark({AddressModel? addressModel,String? address, String? house, String? floor,String? city,String? country,String? zipCode,String? street,}) {

    if(addressModel !=null){
      _address = addressModel;
    }

    if(address != null){
      _address.address = address;
    }else if(house != null){
      _address.house = house;
    }else if(floor != null){
      _address.floor = floor;
    }else if(city != null){
      _address.city = city;
    } else if(country != null){
      _address.country = country;
    } else if(zipCode != null){
      _address.zipCode = zipCode;
    }else if(street != null){
      _address.street = street;
    }
  }

  void updateSelectedAddress(AddressModel? addressModel, {bool shouldUpdate = true} ) {
    _selectedAddress =  addressModel;

    if(shouldUpdate){
      update();
    }
  }

  Future<void> updatePostInformation(String postId,String addressId) async {
    Response response = await locationRepo.changePostServiceAddress(postId,addressId);

    if(response.statusCode==200 && response.body['response_code']=="default_update_200"){
      customSnackBar("service_schedule_updated_successfully".tr,isError: false);
    }
  }

  Future<void>  setZoneContinue(String isContinue) async {
    await  locationRepo.setZoneContinue(isContinue);
  }

  String getZoneContinue() {
    return locationRepo.getZoneContinue();
  }

  void mapBound(GoogleMapController controller, List<Coordinates>? coordinates) async {
    List<LatLng> latLongList = [];

    if (coordinates != null) {
      for (int subIndex = 0; subIndex < coordinates.length; subIndex++) {
        latLongList.add(LatLng(coordinates[subIndex].latitude!, coordinates[subIndex].longitude!));
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