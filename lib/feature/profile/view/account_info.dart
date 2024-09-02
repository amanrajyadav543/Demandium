import 'package:get/get.dart';
import 'package:demandium/feature/profile/controller/edit_profile_tab_controller.dart';
import 'package:demandium/components/core_export.dart';

class EditProfileAccountInfo extends StatefulWidget {
  const EditProfileAccountInfo({super.key}) ;

  @override
  State<EditProfileAccountInfo> createState() => _EditProfileAccountInfoState();
}

class _EditProfileAccountInfoState extends State<EditProfileAccountInfo> {
  final FocusNode _passwordFocus = FocusNode();

  final FocusNode _confirmPasswordFocus = FocusNode();

  final GlobalKey<FormState> accountInfoKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    if(accountInfoKey.currentState != null){
      accountInfoKey.currentState!.validate();
    }

    return Form(
      key: accountInfoKey,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: GetBuilder<EditProfileTabController>(builder: (editProfileTabController){
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const SizedBox(height: Dimensions.paddingSizeSmall),
                      CustomTextField(
                        title: 'new_password'.tr,
                        hintText: '**************',
                        controller: editProfileTabController.passwordController,
                        focusNode: _passwordFocus,
                        nextFocus: _confirmPasswordFocus,
                        inputType: TextInputType.visiblePassword,
                        isPassword: true,
                        onValidate: (String? value){
                          return  FormValidation().isValidPassword(value!);
                        },
                      ),

                      const SizedBox(height: Dimensions.paddingSizeTextFieldGap),
                      CustomTextField(
                        title: 'confirm_new_password'.tr,
                        hintText: '**************',
                        controller: editProfileTabController.confirmPasswordController,
                        focusNode: _confirmPasswordFocus,
                        inputType: TextInputType.visiblePassword,
                        isPassword: true,
                        onValidate: (String? value) {
                          if(value == null || value.isEmpty){
                            return 'this_field_can_not_empty'.tr;
                          }else{
                            return FormValidation().isValidConfirmPassword(
                              editProfileTabController.passwordController.text,
                              editProfileTabController.confirmPasswordController.text,
                            );
                          }
                        },
                      ),
                      const SizedBox(height: Dimensions.paddingSizeDefault),
                    ],
                  ),
                ),
              ),

              CustomButton(
                isLoading: editProfileTabController.isLoading,
                buttonText: 'change_password'.tr,
                onPressed: (){
                  if(accountInfoKey.currentState!.validate()){
                    Get.find<EditProfileTabController>().updateAccountInfo();
                  }},
              )
            ],
          );
        }),
      ),
    );
  }

  Widget customRichText(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: RichText(
          text: TextSpan(children: <TextSpan>[
        TextSpan(text: title, style: ubuntuRegular.copyWith(color: const Color(0xff2C3439))),
        TextSpan(text: ' *', style: ubuntuRegular.copyWith(color: Colors.red)),
      ])),
    );
  }
}
