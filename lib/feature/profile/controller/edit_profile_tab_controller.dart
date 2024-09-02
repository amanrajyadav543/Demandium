import 'package:demandium/core/helper/image_size_checker.dart';
import 'package:demandium/core/helper/phone_verification_helper.dart';
import 'package:get/get.dart';
import 'package:demandium/components/core_export.dart';

enum EditProfileTabControllerState {generalInfo,accountIno}

class EditProfileTabController extends GetxController implements GetxService{

  final UserRepo userRepo;
  EditProfileTabController({required this.userRepo});

  bool _isLoading = false;
  get isLoading => _isLoading;

  XFile? _pickedProfileImageFile ;
  XFile? get pickedProfileImageFile => _pickedProfileImageFile;


  List<Widget> editProfileDetailsTabs = [
    Tab(text: 'general_info'.tr),
    Tab(text: 'account_information'.tr),
  ];


  var editProfilePageCurrentState = EditProfileTabControllerState.generalInfo;

  void updateEditProfilePage(EditProfileTabControllerState editProfileTabControllerState,index){
    editProfilePageCurrentState = editProfileTabControllerState;
    update();
  }

  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  var countryDialCode = "+880";
  UserInfoModel? _userInfoModel;
  UserInfoModel? get userInfoModel => _userInfoModel;


  void setValue(){
    _userInfoModel = Get.find<UserController>().userInfoModel;
    firstNameController.text = Get.find<UserController>().userInfoModel?.fName??'';
    lastNameController.text = Get.find<UserController>().userInfoModel?.lName??'';
    emailController.text = Get.find<UserController>().userInfoModel?.email??'';
     phoneController.text = PhoneVerificationHelper.updateCountryAndNumberInEditProfilePage(
         _userInfoModel?.phone != null ? Get.find<UserController>().userInfoModel!.phone! :'');
    passwordController.text = '';
    confirmPasswordController.text = '';
  }

  Future<void> updateUserProfile() async {

    if(_userInfoModel?.fName!=firstNameController.text ||
        _userInfoModel?.lName!=lastNameController.text ||
        _pickedProfileImageFile!=null ||
        _userInfoModel?.phone!= phoneController.value.text
    ){
      UserInfoModel userInfoModel = UserInfoModel(
        fName: firstNameController.value.text,
        lName: lastNameController.value.text,
        email: emailController.value.text,
        phone: countryDialCode + phoneController.value.text,
      );

      if (kDebugMode) {
        print("Updated User Information: ${userInfoModel.toJson().toString()}");
      }

      _isLoading = true;
      update();
      Response response = await userRepo.updateProfile(userInfoModel, pickedProfileImageFile);

      if (response.body['response_code'] == 'default_update_200') {
        Get.back();
        customSnackBar('${response.body['response_code']}'.tr, isError: false);
        _isLoading = false;
      }else{
        customSnackBar('${response.body['errors'][0]['message']}'.tr, isError: true);
        _isLoading = false;
      }
      update();
      Get.find<UserController>().getUserInfo();
    }else{
      customSnackBar('change_something_to_update'.tr,isError: false);
    }
  }

  Future<void> updateAccountInfo() async {

    UserInfoModel userInfoModel = UserInfoModel(
        fName: firstNameController.value.text,
        lName: lastNameController.value.text,
        email: emailController.value.text,
        phone: countryDialCode + phoneController.value.text,
        password: passwordController.value.text,
        confirmPassword: confirmPasswordController.value.text
    );

    _isLoading = true;
    update();
    Response response = await userRepo.updateAccountInfo(userInfoModel);
    if (response.body['response_code'] == 'default_update_200') {
      Get.back();
      customSnackBar('password_updated_successfully'.tr,isError: false);

    }else{
      customSnackBar(response.body['message']);
    }
    _isLoading = false;
    update();
  }


  void pickProfileImage() async {
    _pickedProfileImageFile = await ImagePicker().pickImage(source: ImageSource.gallery,imageQuality: 100);
    double imageSize = await ImageSize.getImageSizeFromXFile(_pickedProfileImageFile!);
    if(imageSize >AppConstants.limitOfPickedImageSizeInMB){
      customSnackBar("image_size_greater_than".tr);
      _pickedProfileImageFile =null;
    }
    update();
  }

  Future<void> removeProfileImage() async {
    _pickedProfileImageFile = null;
  }



  validatePassword(String value){
    if(value.length < 8){
      return 'password_should_be'.tr;
    }else if(passwordController.text != confirmPasswordController.text && passwordController.text.isNotEmpty && confirmPasswordController.text.isNotEmpty){
      return 'confirm_password_does_not_matched'.tr;
    }
  }

  void resetPasswordText(){
    passwordController.text = '';
    confirmPasswordController.text = '';
    update();
  }
}