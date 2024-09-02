import 'package:country_code_picker/country_code_picker.dart';
import 'package:demandium/core/helper/phone_verification_helper.dart';
import 'package:get/get.dart';
import 'package:demandium/components/core_export.dart';

class AuthController extends GetxController implements GetxService {
  final AuthRepo authRepo;


  bool _isLoading = false;
  bool _acceptTerms = false;
  bool _forgetPasswordUrlSessionExpired = false;


  bool savedCookiesData = false;

  AuthController({required this.authRepo});
  bool get isLoading => _isLoading;
  bool get forgetPasswordUrlSessionExpired => _forgetPasswordUrlSessionExpired;
  bool get acceptTerms => _acceptTerms;

  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  var referCodeController = TextEditingController();
  var contactNumberController = TextEditingController();
  var countryDialCode= "+880";
  final String _mobileNumber = '';
  String get mobileNumber => _mobileNumber;

  var newPasswordController = TextEditingController();
  var confirmNewPasswordController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    firstNameController.text = '';
    lastNameController.text = '';
    emailController.text = '';
    phoneController.text = '';
    passwordController.text = '';
    confirmPasswordController.text = '';
    contactNumberController.text = '';
    newPasswordController.text = '';
    confirmNewPasswordController.text = '';
    contactNumberController.text = '';

    countryDialCode = CountryCode.fromCountryCode(Get.find<SplashController>().configModel.content != null ? Get.find<SplashController>().configModel.content!.countryCode!:"BD").dialCode!;

  }

  Future<void> registration() async {
    SignUpBody signUpBody;
    String numberWithCountryCode = PhoneVerificationHelper.getValidPhoneWithCountryCode(
        countryDialCode + phoneController.value.text, withCountryCode: true
    );

    if (kDebugMode) {
      print("number with Country code : $numberWithCountryCode");
    }

    _isLoading = true;
    update();

      if(referCodeController.text!=""){
        signUpBody = SignUpBody(
            fName: firstNameController.value.text.trim(),
            lName: lastNameController.value.text.trim(),
            email: emailController.value.text.trim(),
            phone: numberWithCountryCode.trim(),
            password: passwordController.value.text.trim(),
            confirmPassword: confirmPasswordController.value.text.trim(),
            referCode: referCodeController.text.trim()
        );
      }else{
        signUpBody = SignUpBody(
            fName: firstNameController.value.text.trim(),
            lName: lastNameController.value.text.trim(),
            email: emailController.value.text.trim(),
            phone: numberWithCountryCode.trim(),
            password: passwordController.value.text.trim(),
            confirmPassword: confirmPasswordController.value.text.trim(),
        );
      }
      Response? response = await authRepo.registration(signUpBody);
      if (response!.statusCode == 200 && response.body['response_code'] == 'registration_200') {

        if(Get.find<SplashController>().configModel.content?.phoneVerification==1 || Get.find<SplashController>().configModel.content?.emailVerification==1){
          Get.offAllNamed(RouteHelper.getSendOtpScreen("verification"));
        }else{
          Get.toNamed(RouteHelper.getSignInRoute(RouteHelper.main));
        }
        resetControllerValue();
        customSnackBar('registration_200'.tr,isError:false);
      }
      else if(response.statusCode == 404 && response.body['response_code']=="referral_code_400"){
        customSnackBar("invalid_refer_code".tr);
      } else if(response.statusCode == 400 && response.body['response_code']=="default_400"){
        customSnackBar(response.body['errors'][0]['message']);
      }
      else {
        customSnackBar(response.statusText);
      }

    _isLoading = false;
    update();
  }

  Future<void> login(String fromPage, String emailPhone, String password) async {
      _isLoading = true;
      update();
      Response? response = await authRepo.login(phone: emailPhone, password: password);
      if (response!.statusCode == 200 && response.body['response_code']=="auth_login_200") {
        authRepo.saveUserToken(response.body['content']['token']);
        await authRepo.updateToken();
        Get.find<SplashController>().updateLanguage(true);
        Get.find<LocationController>().getAddressList();
        _navigateLogin(fromPage, emailPhone: emailPhone, password: password);

      }else if(response.statusCode == 401 && (response.body["response_code"]=="unverified_phone_401") || response.body["response_code"]=="unverified_email_401"){
        customSnackBar(response.body['message']);
        Get.toNamed(RouteHelper.getSendOtpScreen("verification"));
      }
      else{
        customSnackBar(response.body["message"].toString().capitalizeFirst??response.statusText);
      }
      _isLoading = false;

      update();

  }

  Future<void> logOut() async {
    Response? response = await authRepo.logOut();
    if(response?.statusCode == 200){
      if (kDebugMode) {
        print("Logout successfully with ${response?.body}");
      }
    }else{
      if (kDebugMode) {
        print("Logout Failed");
      }
    }
  }

  _navigateLogin(String fromPage, {String? emailPhone, String? password}){

    if( fromPage.contains(RouteHelper.main) || fromPage.contains(RouteHelper.splash) || fromPage.contains("booking")){
      if (Get.find<LocationController>().getUserAddress() != null) {

        updateSavedLocalAddress();

        if(fromPage=="booking"){
          Get.offAllNamed(RouteHelper.getMainRoute('booking'));
        }else{
          Get.offAllNamed(RouteHelper.getMainRoute('home'));
        }
      } else {
        Get.offAllNamed(RouteHelper.getAccessLocationRoute('home'));
      }
    }else{
      Get.offAllNamed(fromPage);
    }
    if (_isActiveRememberMe) {
      saveUserNumberAndPassword(emailPhone ?? "", password ?? "");
    } else {
      clearUserNumberAndPassword();
    }
  }

  updateSavedLocalAddress({bool saveContactPersonInfo = true}) async {

    AddressModel addressModel = Get.find<LocationController>().getUserAddress()!;

    if(saveContactPersonInfo){
      if(Get.find<UserController>().userInfoModel == null){
        Get.find<UserController>().getUserInfo(reload: true);
      }else{
        String? firstName;
        if( Get.find<AuthController>().isLoggedIn() && Get.find<UserController>().userInfoModel?.phone!=null && Get.find<UserController>().userInfoModel?.fName !=null){
          firstName = "${Get.find<UserController>().userInfoModel?.fName} ";
        }

        addressModel.contactPersonNumber = firstName !=null? Get.find<UserController>().userInfoModel?.phone ?? "" : "";
        addressModel.contactPersonName = firstName!=null ? "$firstName${Get.find<UserController>().userInfoModel?.lName ?? "" }" : "";

      }
    }else{
      addressModel.contactPersonNumber =  "";
      addressModel.contactPersonName =  "";
    }
    Get.find<LocationController>().saveUserAddress(addressModel);
  }


  Future<void> loginWithSocialMedia(SocialLogInBody socialLogInBody,{String? fromPage}) async {
    Get.dialog(const CustomLoader(),barrierDismissible: false);
    Response response = await authRepo.loginWithSocialMedia(socialLogInBody);
    if (response.statusCode == 200  && response.body['response_code']=="auth_login_200") {
      String token = response.body['content']['token'];
      if(token.isNotEmpty) {
        if(response.body['content']['is_active'] == 1) {
          authRepo.saveUserToken(response.body['content']['token']);
          await authRepo.updateToken();
          Get.find<LocationController>().getAddressList();
          Get.back();
          _navigateLogin(fromPage??RouteHelper.getMainRoute("home"));
        }else{
          Get.back();
        }
      }else{
        Get.back();
      }
    } else {
      Get.back();
      ApiChecker.checkApi(response);
    }
  }

  Future<ResponseModel> sendOtpForVerificationScreen(String identity, String identityType) async {
    _isLoading = true;
    update();
    Response  response = await authRepo.sendOtpForVerificationScreen(identity,identityType);
    if (response.statusCode == 200 && response.body["response_code"]=="default_200") {
      _isLoading = false;
      update();
      return ResponseModel(true, "");
    } else {
      _isLoading = false;
      update();
      String responseText = "";
      if(response.statusCode == 500){
        responseText = "Internal Server Error";
      }else{
        responseText = response.body["message"] ?? response.statusText ;
      }
      return ResponseModel(false, responseText);
    }
  }


  Future<ResponseModel> sendOtpForForgetPassword(String identity, String identityType) async {
    _isLoading = true;
    update();
    Response response = await authRepo.sendOtpForForgetPassword(identity,identityType);

    if (response.statusCode == 200 && response.body["response_code"]=="default_200") {
      _isLoading = false;
      update();
      return ResponseModel(true, "");
    } else {
      _isLoading = false;
      update();
      String responseText = "";
      if(response.statusCode == 500){
        responseText = "Internal Server Error";
      }else{
        responseText = response.body["message"] ?? response.statusText ;
      }
      return ResponseModel(false, responseText);
    }
  }


  Future<ResponseModel>  verifyOtpForVerificationScreen(String identity,  String identityType, String otp,) async {
    _isLoading = true;
    update();
    Response? response = await authRepo.verifyOtpForVerificationScreen(identity,identityType,otp);
    ResponseModel responseModel;
    if (response!.statusCode == 200 && response.body['response_code']=="default_200") {
      responseModel = ResponseModel(true, response.body["message"]);
    } else {

      String responseText = "";
      if(response.statusCode == 500){
        responseText = "Internal Server Error";
      }else{
        responseText = response.body["message"] ?? response.statusText ;
      }
      responseModel = ResponseModel(false, responseText);
    }
    _isLoading = false;
    update();
    return responseModel;
  }


  Future<ResponseModel> verifyOtpForForgetPasswordScreen(String identity, String identityType, String otp, {bool fromOutsideUrl = false , bool shouldUpdate = true}) async {

    _isLoading = true;

    if(fromOutsideUrl){
      _forgetPasswordUrlSessionExpired = true;
    }

    if(shouldUpdate){
      update();
    }

    Response response = await authRepo.verifyOtpForForgetPassword(identity, identityType, otp);

    if (response.statusCode==200 &&  response.body['response_code'] == 'default_200') {
      _isLoading = false;
      _forgetPasswordUrlSessionExpired = false;
      update();
      return ResponseModel(true, "successfully_verified");
    }else{
      _isLoading = false;
      update();
      String responseText = "";
      if(response.statusCode == 500){
        responseText = "Internal Server Error";
      }else{
        responseText = response.body["message"] ?? response.statusText ;
      }
      return ResponseModel(false, responseText);
    }

  }


  Future<void> resetPassword(String identity,String identityType, String otp, String password, String confirmPassword) async {
    _isLoading = true;
    update();
    Response? response = await authRepo.resetPassword(identity,identityType, otp, password, confirmPassword);

    if (response!.statusCode == 200 && response.body['response_code']=="default_password_reset_200") {
      Get.offNamed(RouteHelper.getSignInRoute(RouteHelper.main));
      customSnackBar('password_changed_successfully'.tr,isError: false);
    } else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }



  void resetControllerValue(){
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    phoneController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    referCodeController.clear();
  }



  String _verificationCode = '';
  String _otp = '';
  String get otp => _otp;
  String get verificationCode => _verificationCode;

  void updateVerificationCode(String query) {
    _verificationCode = query;
    if(_verificationCode.isNotEmpty){
    _otp = _verificationCode;
    }
    update();
  }

  void updateForgetPasswordUrlSessionExpiredStatus({required bool status, bool shouldUpdate = false}){
    _forgetPasswordUrlSessionExpired = status;
    if(shouldUpdate){
      update();
    }
  }


  bool _isActiveRememberMe = false;
  bool get isActiveRememberMe => _isActiveRememberMe;

  void toggleTerms({bool? value , bool shouldUpdate = true}) {
    if(value != null){
      _acceptTerms = value;
    }else{
      _acceptTerms = !_acceptTerms;
    }
    if(shouldUpdate){
      update();
    }
  }


  void cancelTermsAndCondition(){
    _acceptTerms = false;
  }

  void toggleRememberMe() {
    _isActiveRememberMe = !_isActiveRememberMe;
    update();
  }

  void toggleReferralBottomSheetShow (){
    authRepo.toggleReferralBottomSheetShow(false);
    update();
  }

  bool getIsShowReferralBottomSheet (){
    return authRepo.getIsShowReferralBottomSheet();
  }

  bool isLoggedIn() {
    return authRepo.isLoggedIn();
  }

  bool clearSharedData({Response? response}) {
    return authRepo.clearSharedData(response: response);
  }

  void saveUserNumberAndPassword(String number, String password) {
    authRepo.saveUserNumberAndPassword(number, password);
  }

  String getUserNumber() {
    return authRepo.getUserNumber();
  }

  String getUserCountryCode() {
    return authRepo.getUserCountryCode();
  }

  String getUserPassword() {
    return authRepo.getUserPassword();
  }
  bool isNotificationActive() {
    return authRepo.isNotificationActive();

  }
  toggleNotificationSound(){
    authRepo.toggleNotificationSound(!isNotificationActive());
    update();
  }

  Future<bool> clearUserNumberAndPassword() async {
    return authRepo.clearUserNumberAndPassword();
  }

  String getUserToken() {
    return authRepo.getUserToken();
  }


  final GoogleSignIn _googleSignIn = GoogleSignIn();

  GoogleSignInAccount? googleAccount;
  GoogleSignInAuthentication? auth;

  Future<void> socialLogin() async {
    googleAccount = (await _googleSignIn.signIn());
    auth = await googleAccount?.authentication;
    update();
  }



  Future<void> googleLogout() async {
    try{
      googleAccount = (await _googleSignIn.disconnect())!;
      auth = await googleAccount!.authentication;
    }catch(e){
      if (kDebugMode) {
        print("");
      }
    }
  }


  Future<void> signOutWithFacebook() async {
    await FacebookAuth.instance.logOut();
  }

  Future<void> updateToken() async {
    await authRepo.updateToken();
  }

  void initCountryCode(){
    countryDialCode = CountryCode.fromCountryCode(Get.find<SplashController>().configModel.content != null ? Get.find<SplashController>().configModel.content!.countryCode!:"BD").dialCode!;
  }
}