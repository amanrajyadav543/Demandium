import 'dart:convert';
import 'package:get/get.dart';
import 'package:demandium/components/core_export.dart';

class AuthRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  AuthRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response?> registration(SignUpBody signUpBody) async {
    return await apiClient.postData(AppConstants.registerUri, signUpBody.toJson());
  }

  Future<Response?> login({required String phone, required String password}) async {
    return await apiClient.postData(AppConstants.loginUri, {"email_or_phone": phone, "password": password , "guest_id": Get.find<SplashController>().getGuestId()});
  }


  Future<Response?> logOut() async {
    return await apiClient.postData(AppConstants.loginOut, {});
  }

  Future<Response> loginWithSocialMedia(SocialLogInBody socialLogInBody) async {
    return await apiClient.postData(AppConstants.socialLoginUri, socialLogInBody.toJson(),headers: AppConstants.configHeader);
  }

  Future<Response?> registerWithSocialMedia(SocialLogInBody socialLogInBody) async {
    return await apiClient.postData(AppConstants.socialRegisterUri, socialLogInBody.toJson());
  }

  Future<Response?> updateToken() async {
    String? deviceToken;
    if (GetPlatform.isIOS && !GetPlatform.isWeb) {
      FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
      NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
        alert: true, announcement: false, badge: true, carPlay: false,
        criticalAlert: false, provisional: false, sound: true,
      );
      if(settings.authorizationStatus == AuthorizationStatus.authorized) {
        deviceToken = await _saveDeviceToken();
      }
    }else {
      deviceToken = await _saveDeviceToken();
    }

    if(GetPlatform.isIOS && !GetPlatform.isWeb){
      if(Get.find<LocationController>().getUserAddress() != null){
        FirebaseMessaging.instance.subscribeToTopic(AppConstants.topic);
        FirebaseMessaging.instance.subscribeToTopic('${AppConstants.topic}-${Get.find<LocationController>().getUserAddress()!.zoneId!}');
      }
    }
    if (kDebugMode) {
      print("_deviceToken");
      print(deviceToken);
    }
    return await apiClient.postData(AppConstants.tokenUri, {"_method": "put", "fcm_token": deviceToken});
  }

  Future<String?> _saveDeviceToken() async {
    String? deviceToken = '@';
    try {
      deviceToken = await FirebaseMessaging.instance.getToken();
    }catch(e) {
      if (kDebugMode) {
        print('');
      }
    }
    if (deviceToken != null) {
      if (kDebugMode) {
        print('--------Device Token---------- $deviceToken');
      }
    }
    return deviceToken;
  }


  Future<Response> sendOtpForVerificationScreen(String identity, String type) async {
    return await apiClient.postData(AppConstants.sendOtpForVerification, {
      "identity": identity,
      "identity_type": type
    });
  }

  Future<Response> sendOtpForForgetPassword(String identity, String identityType) async {
    return await apiClient.postData(AppConstants.sendOtpForForgetPassword,
      {
        "identity": identity,
        "identity_type": identityType
      },

    );
  }

  Future<Response?> verifyOtpForVerificationScreen(String? identity,String identityType, String otp) async {
    return await apiClient.postData(AppConstants.verifyOtpForVerificationScreen,
      {
        "identity": identity,
        'otp':otp,
        "identity_type": identityType
      },
    );
  }

  Future<Response> verifyOtpForForgetPassword(String identity, String identityType, String otp) async {
    return await apiClient.postData(AppConstants.verifyOtpForForgetPasswordScreen,
      {
        "identity": identity,
        'otp':otp,
        "identity_type": identityType
      },
    );
  }

  Future<Response?> resetPassword(String identity, String identityType, String otp, String password, String confirmPassword) async {
    return await apiClient.putData(
      AppConstants.resetPasswordUri,
      {
        "_method": "put",
        "identity": identity,
        "identity_type": identityType,
        "otp": otp,
        "password": password,
        "confirm_password": confirmPassword},
    );
  }



  Future<Response?> updateZone() async {
    return await apiClient.getData(AppConstants.updateZoneUri);
  }

  Future<bool?> saveUserToken(String token) async {
    apiClient.token = token;
    apiClient.updateHeader(token, sharedPreferences.getString(AppConstants.userAddress) != null ?
    AddressModel.fromJson(jsonDecode(sharedPreferences.getString(AppConstants.userAddress)!)).zoneId :
    null, sharedPreferences.getString(AppConstants.languageCode), sharedPreferences.getString(AppConstants.guestId));
    return await sharedPreferences.setString(AppConstants.token, token);
  }

  String getUserToken() {
    return sharedPreferences.getString(AppConstants.token) ?? "";
  }

  bool isLoggedIn() {
    return sharedPreferences.containsKey(AppConstants.token);
  }

  bool clearSharedData({Response? response}) {
    if(GetPlatform.isAndroid && !GetPlatform.isWeb){
      if(Get.find<LocationController>().getUserAddress() != null){
        if(Get.find<LocationController>().getUserAddress()!.zoneId != null){
          FirebaseMessaging.instance.unsubscribeFromTopic(AppConstants.topic);
          FirebaseMessaging.instance.unsubscribeFromTopic('${AppConstants.topic}-${Get.find<LocationController>().getUserAddress()!.zoneId!}');
        }
      }
    }
    apiClient.postData(AppConstants.tokenUri, {"_method": "put", "fcm_token": '@'});
    sharedPreferences.remove(AppConstants.token);
    sharedPreferences.remove(AppConstants.referredBottomSheet);
    Get.find<AuthController>().updateSavedLocalAddress(saveContactPersonInfo: false);
    Get.find<AllSearchController>().removeHistory();
    Get.find<UserController>().setUserInfoModelData(null);
    sharedPreferences.setStringList(AppConstants.searchHistory, []);
    apiClient.token = null;
    if(response !=null && response.body['response_code'] != null && response.statusCode == 401 && response.body['response_code'] == "zone_404"){
      AddressModel? address = Get.find<LocationController>().getUserAddress();
      address?.zoneId = "";
      Get.find<LocationController>().saveUserAddress( address ?? AddressModel());
    }
    return true;
  }

  Future<void> saveUserNumberAndPassword(String number, String password) async {
    try {
      await sharedPreferences.setString(AppConstants.userPassword, password);
      await sharedPreferences.setString(AppConstants.userNumber, number);

    } catch (e) {
      rethrow;
    }
  }

  String getUserNumber() {
    return sharedPreferences.getString(AppConstants.userNumber) ?? "";
  }

  String getUserCountryCode() {
    return sharedPreferences.getString(AppConstants.userCountryCode) ?? "";
  }

  String getUserPassword() {
    return sharedPreferences.getString(AppConstants.userPassword) ?? "";
  }

  bool isNotificationActive() {
    return sharedPreferences.getBool(AppConstants.notification) ?? true;
  }

  toggleNotificationSound(bool isNotification){
    sharedPreferences.setBool(AppConstants.notification, isNotification);
  }

  toggleReferralBottomSheetShow (bool isShowBottomSheet){
    sharedPreferences.setBool(AppConstants.referredBottomSheet, isShowBottomSheet);
  }

  bool getIsShowReferralBottomSheet (){
    return sharedPreferences.getBool(AppConstants.referredBottomSheet) ?? true;
  }


  Future<bool> clearUserNumberAndPassword() async {
    await sharedPreferences.remove(AppConstants.userPassword);
    await sharedPreferences.remove(AppConstants.userCountryCode);
    return await sharedPreferences.remove(AppConstants.userNumber);
  }

  bool clearSharedAddress(){
    sharedPreferences.remove(AppConstants.userAddress);
    return true;
  }
}
