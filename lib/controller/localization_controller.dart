import 'dart:convert';
import 'package:get/get.dart';
import 'package:demandium/components/core_export.dart';

class LocalizationController extends GetxController implements GetxService {
  late SharedPreferences sharedPreferences;
  late ApiClient apiClient;

  LocalizationController({required this.sharedPreferences, required this.apiClient}) {
    loadCurrentLanguage();
  }

  Locale _locale = Locale(AppConstants.languages[0].languageCode!, AppConstants.languages[0].countryCode);
  bool _isLtr = true;
  List<LanguageModel>  _localLanguages = [];

  Locale get locale => _locale;
  bool get isLtr => _isLtr;
  List<LanguageModel> get languages =>  _localLanguages;

  void setLanguage(Locale locale, {bool isInitial = false}) {
    Get.updateLocale(locale);
    _locale = locale;
    if(_locale.languageCode == 'ar') {
      _isLtr = false;
    }else {
      _isLtr = true;
    }
    AddressModel? addressModel;
    try {
      addressModel = AddressModel.fromJson(jsonDecode(sharedPreferences.getString(AppConstants.userAddress)!));
    }catch(e) {
      if (kDebugMode) {
        print(e);
      }
    }
    ///pick zone id to update header
    apiClient.updateHeader(
      sharedPreferences.getString(AppConstants.token), addressModel?.zoneId,
      locale.languageCode, Get.find<SplashController>().getGuestId(),
    );
    saveLanguage(_locale);
    if(Get.find<LocationController>().getUserAddress() != null) {
      Get.find<ServiceAreaController>().getZoneList();
    }
    Get.find<SplashController>().updateLanguage(isInitial);
    update();
  }

  void loadCurrentLanguage() async {
    _localLanguages = [];
    _localLanguages.addAll(AppConstants.languages);
    filterLanguage(isInitial: true);
    update();
  }

  void saveLanguage(Locale locale) async {
    sharedPreferences.setString(AppConstants.languageCode, locale.languageCode);
    sharedPreferences.setString(AppConstants.countryCode, locale.countryCode!);
    update();
  }

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;
  void setSelectIndex(int index, {bool shouldUpdate = true}) {
    _selectedIndex = index;
    if(shouldUpdate){
      update();
    }
  }

  void filterLanguage({bool shouldUpdate = true, bool isChooseLanguage = false, bool isInitial = false, String fromPage = ""}) {

    List<Language>  adminLanguageList = isInitial ? [] : Get.find<SplashController>().configModel.content?.languageList ?? [];

    bool showAllLocalLanguage = (AppConstants.languageCode.length == 1 || adminLanguageList.isEmpty) ? true : false;

    String? defaultLanguageCode;

    List<String> localLanguageCode = [];
    for (var element in AppConstants.languages) {
      localLanguageCode.add(element.languageCode!);
    }

    if( ((isChooseLanguage || isInitial) && fromPage != "menuDrawer" ) && adminLanguageList.length == 1 && localLanguageCode.contains(adminLanguageList[0].languageCode)){

      int index = AppConstants.languages.indexWhere((element) => element.languageCode == adminLanguageList[0].languageCode);

      if(index != -1){
        _locale = Locale( AppConstants.languages[index].languageCode!,AppConstants.languages[index].countryCode);
        _isLtr = _locale.languageCode != 'ar';
        Future.delayed(const Duration(milliseconds: 10), (){
          setLanguage(_locale, isInitial: true);
          if(Get.find<SplashController>().isShowOnboardingScreen()){
            Get.offAllNamed(RouteHelper.onBoardScreen);
          }else{
            Get.offAllNamed(RouteHelper.getInitialRoute());
          }
        });
      }

    } else{
      for (var defaultLanguage in adminLanguageList) {
        if(!localLanguageCode.contains(defaultLanguage.languageCode)){
          showAllLocalLanguage = true;
          break;
        }
        if(defaultLanguage.isDefault == true){
          defaultLanguageCode = defaultLanguage.languageCode;
        }
      }

      if(!showAllLocalLanguage){
        _localLanguages = [];
        _selectedIndex = 0;
        for (var element in adminLanguageList) {
          int index = AppConstants.languages.indexWhere((language) => language.languageCode == element.languageCode);
          if(index > -1){
            _localLanguages.add(AppConstants.languages[index]);
          }
        }


        if(isChooseLanguage && fromPage != "menuDrawer"){
          if(_localLanguages.indexWhere((e) => e.languageCode == defaultLanguageCode) != -1){
            _selectedIndex = _localLanguages.indexWhere((e) => e.languageCode == defaultLanguageCode);
          }else{
            _selectedIndex = 0;
          }
        }else{
          for(int index = 0; index< _localLanguages.length; index++) {
            if(_localLanguages[index].languageCode == sharedPreferences.getString(AppConstants.languageCode)) {
              _selectedIndex = index;
              break;
            }
          }
        }

      } else{


        if(defaultLanguageCode !=null && isChooseLanguage && fromPage != "menuDrawer"){
          for(int index = 0; index< _localLanguages.length; index++) {
            if(_localLanguages[index].languageCode == defaultLanguageCode) {
              _selectedIndex = index;
              break;
            }
          }

        }else{
          for(int index = 0; index< _localLanguages.length; index++) {
            if(_localLanguages[index].languageCode == sharedPreferences.getString(AppConstants.languageCode)) {
              _selectedIndex = index;
              break;
            }
          }
        }
      }
      _locale = Locale( _localLanguages[_selectedIndex].languageCode!, _localLanguages[_selectedIndex].countryCode);
      _isLtr = _locale.languageCode != 'ar';


      if(fromPage != "menuDrawer"){
        Future.delayed(const Duration(milliseconds: 1000), (){
          setLanguage(_locale, isInitial: true);
        });
      }
    }
  }

}