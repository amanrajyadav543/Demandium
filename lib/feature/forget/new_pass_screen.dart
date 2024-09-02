import 'package:demandium/feature/forget/model/forget_password_body.dart';
import 'package:get/get.dart';
import 'package:demandium/components/core_export.dart';


class NewPassScreen extends StatefulWidget {
  final ForgetPasswordBody? forgetPasswordBody;
  const NewPassScreen({super.key, this.forgetPasswordBody});

  @override
  State<NewPassScreen> createState() => _NewPassScreenState();
}

class _NewPassScreenState extends State<NewPassScreen> {
  final GlobalKey<FormState> newPassKey = GlobalKey<FormState>();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  String _identity='';

  @override
  void initState() {

    AuthController authController = Get.find();

    authController.newPasswordController.clear();
    authController.confirmNewPasswordController.clear();

    super.initState();
    _identity = widget.forgetPasswordBody?.identity ?? "";

    if(widget.forgetPasswordBody?.fromUrl == 1){
      authController.verifyOtpForForgetPasswordScreen(widget.forgetPasswordBody?.identity ?? "", widget.forgetPasswordBody?.identityType ?? "" , widget.forgetPasswordBody?.otp ??"", fromOutsideUrl: true, shouldUpdate: false).then((status) async {
        if (status.isSuccess!) {
         if (kDebugMode) {
           print("Session Available");
         }
        }else {
          if (kDebugMode) {
            print("Session Expired");
          }
        }
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer:ResponsiveHelper.isDesktop(context) ? const MenuDrawer():null,
      appBar: CustomAppBar(title:'change_password'.tr, onBackPressed: (){
        Get.find<AuthController>().updateVerificationCode('');
        Get.back();
      },),
      body: GetBuilder<AuthController>(builder: (controller){
        return SafeArea(child: FooterBaseView(
          isCenter: true,
          child: WebShadowWrap(
            child: Center(
              child: controller.forgetPasswordUrlSessionExpired && controller.isLoading ?
              const CircularProgressIndicator() :
              controller.forgetPasswordUrlSessionExpired && !controller.isLoading ?
              Column(children: [
                Text("url_session_expired".tr),
                const SizedBox(height: Dimensions.paddingSizeLarge,),
                CustomButton( width: 200 , buttonText: "go_back".tr,
                  onPressed: (){Get.offAllNamed(RouteHelper.getSignInRoute(RouteHelper.main));
                  },
                )
              ],) : Form(key: newPassKey, child: Column(children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveHelper.isDesktop(context)?Dimensions.webMaxWidth/6:
                      ResponsiveHelper.isTab(context)? Dimensions.webMaxWidth/8:Dimensions.paddingSizeLarge
                  ),
                  child: Column(children: [
                    CustomTextField(
                      title: 'new_password'.tr,
                      hintText: '**************',
                      controller: controller.newPasswordController,
                      focusNode: _passwordFocus,
                      nextFocus: _confirmPasswordFocus,
                      inputType: TextInputType.visiblePassword,
                      isPassword: true,
                      onValidate: (String? value) {
                        return FormValidation().isValidPassword(value!);
                      },
                    ),
                    const SizedBox(height: Dimensions.paddingSizeTextFieldGap),

                    CustomTextField(
                      title: 'confirm_new_password'.tr,
                      hintText: '**************',
                      controller: controller.confirmNewPasswordController,
                      inputAction: TextInputAction.done,
                      focusNode: _confirmPasswordFocus,
                      inputType: TextInputType.visiblePassword,
                      isPassword: true,
                      onValidate: (String? value) {
                        if(value == null || value.isEmpty){
                          return 'this_field_can_not_empty'.tr;
                        }else{
                          return FormValidation().isValidConfirmPassword(
                            controller.newPasswordController.text,
                            value,
                          );
                        }
                      },
                      onSubmit: (text) => GetPlatform.isWeb ? _resetPassword(controller.confirmNewPasswordController.text,controller.confirmNewPasswordController.text) : null,
                    ),
                    const SizedBox(height: Dimensions.paddingSizeTextFieldGap),

                    GetBuilder<UserController>(builder: (userController) {
                      return GetBuilder<AuthController>(builder: (authBuilder) {
                        return CustomButton(
                          buttonText: 'change_password'.tr,
                          isLoading: authBuilder.isLoading,
                          onPressed: () {
                            if(isRedundentClick(DateTime.now())){
                              return;
                            }
                            else{
                              _resetPassword(controller.newPasswordController.value.text, controller.confirmNewPasswordController.value.text);
                            }
                          },
                        );

                      });
                    }),

                  ]),
                ),

              ],),
            ),),
          ),
        ));
      }),
    );
  }

  void _resetPassword(newPassword, confirmNewPassword) {
    if(newPassKey.currentState!.validate()){
      if(newPassword != confirmNewPassword){
        customSnackBar('confirm_password_not_matched'.tr);
      }else{
        Get.find<AuthController>().resetPassword(_identity,widget.forgetPasswordBody?.identityType ?? "",widget.forgetPasswordBody?.otp ?? "",newPassword,confirmNewPassword);
      }
    }
  }
}




