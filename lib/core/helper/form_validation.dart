import 'package:demandium/core/helper/phone_verification_helper.dart';
import 'package:get/get.dart';


class FormValidation {
  String? isValidLength(String value) {
    if (value.isEmpty) {
      return 'enter_contact_person_name'.tr;
    }
    return null;
  }
  String? isValidFirstName(String value) {
    if (value.isEmpty) {
      return 'enter_your_first_name'.tr;
    }
    return null;
  }
  String? isValidLastName(String value) {
    if (value.isEmpty) {
      return 'enter_your_last_name'.tr;
    }
    return null;
  }


  String? isValidPassword(String value) {
    if(value.isEmpty){
      return 'this_field_can_not_empty'.tr;
    }
    if (value.length<=7) {
      return 'password_should_be'.tr;
    }
    return null;
  }

  String? isValidConfirmPassword(String password, String confirmPassword){
    if(password != confirmPassword){
      return 'confirm_password_not_matched'.tr;
    }
    return null;
  }

  String? isValidPhone(String number, {required bool fromAuthPage }) =>

      PhoneVerificationHelper.isPhoneValid(number, fromAuthPage: fromAuthPage) != "" ? null
      : "enter_valid_phone_number".tr;

  String? isValidEmail(String? value) {
    if(value == null || value.isEmpty){
      return 'enter_email_address'.tr;
    }
    if (!GetUtils.isEmail(value)) {
      return 'enter_a_valid_email_address'.tr;
    }
    return null;
  }

  String? validateDynamicTextFiled(String inputValue , String validateText ) {
    if (inputValue.isEmpty) {
      return "${validateText.tr} ${"is_required".tr}";
    }
    return null;
  }


}