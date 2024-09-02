import 'package:country_code_picker/country_code_picker.dart';
import 'package:demandium/feature/auth/widgets/social_login_widget.dart';
import 'package:get/get.dart';
import 'package:demandium/components/core_export.dart';

class SignUpScreen extends StatefulWidget {
   const SignUpScreen({super.key}) ;

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final FocusNode _referCodeFocus = FocusNode();
  late final GlobalKey<FormState> customerSignUpKey = GlobalKey<FormState>();

  @override
  void initState() {
    Get.find<AuthController>().firstNameController.clear();
    Get.find<AuthController>().lastNameController.clear();
    Get.find<AuthController>().emailController.clear();
    Get.find<AuthController>().phoneController.clear();
    Get.find<AuthController>().passwordController.clear();
    Get.find<AuthController>().confirmPasswordController.clear();
    Get.find<AuthController>().referCodeController.clear();
    Get.find<AuthController>().initCountryCode();
    Get.find<AuthController>().toggleTerms(value: false, shouldUpdate: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop){
        if(didPop){
          AuthController authController = Get.find();
          authController.acceptTerms == true ? authController.toggleTerms() :
              authController.acceptTerms ;
          return;
        }
      },
      child: Scaffold(
        endDrawer:ResponsiveHelper.isDesktop(context) ? const MenuDrawer() :null,
        appBar: const CustomAppBar(title: "", isBackgroundTransparent: true,),
        body: SafeArea(
          child: GetBuilder<AuthController>(
            builder: (authController){
              return FooterBaseView(
                child: WebShadowWrap(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge),
                    child: Column(
                      children: [
                        Form(
                          key: customerSignUpKey,
                          child: Column(
                            children: [
                              const SizedBox(height: Dimensions.paddingSizeExtraMoreLarge),
                              Image.asset(
                                Images.logo,
                                width: Dimensions.logoSize,
                              ),
                              const SizedBox(height: Dimensions.paddingSizeExtraMoreLarge),
                              if(ResponsiveHelper.isMobile(context))
                                _firstList(authController),
                              if(ResponsiveHelper.isMobile(context))
                                _secondList(authController),
                             if(!ResponsiveHelper.isMobile(context))
                             Row(crossAxisAlignment: CrossAxisAlignment.start,children: [
                                Expanded(child: _firstList(authController),),
                                const SizedBox(width: Dimensions.paddingSizeLarge,),
                                Expanded(
                                  child: _secondList(authController),
                                ),
                              ]),
                            ]),
                          ),
                        ConditionCheckBox(
                          checkBoxValue: authController.acceptTerms,
                          onTap: (bool? value){
                            authController.toggleTerms();
                          },
                        ),
                        const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                         CustomButton(
                          buttonText: 'sign_up'.tr,
                          isLoading: authController.isLoading,
                          onPressed: authController.acceptTerms
                              && customerSignUpKey.currentState?.validate() == true
                              ?  () => _register(authController)
                              : null,
                        ),
                        const SizedBox(height: Dimensions.paddingSizeDefault),
                        Get.find<SplashController>().configModel.content?.googleSocialLogin.toString() == '1' ||
                            Get.find<SplashController>().configModel.content?.facebookSocialLogin.toString() == '1' ?
                        const SocialLoginWidget(fromPage: RouteHelper.main,):const SizedBox(),
                        const SizedBox(height: Dimensions.paddingSizeDefault,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('${'already_have_an_account'.tr} ',
                              style: ubuntuRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault,
                                color: Theme.of(context).textTheme.bodyLarge!.color,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Get.toNamed(RouteHelper.getSignInRoute(RouteHelper.main));
                              },
                              child: Text('sign_in_here'.tr, style: ubuntuRegular.copyWith(
                                decoration: TextDecoration.underline,
                                color: Theme.of(context).colorScheme.tertiary,
                                fontSize: Dimensions.fontSizeDefault,
                              )),
                            ),
                          ],
                        ),
                        const SizedBox(height: Dimensions.paddingSizeSmall,),

                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   crossAxisAlignment: CrossAxisAlignment.center,
                        //   children: [
                        //     Text('continue_as'.tr, style: ubuntuMedium.copyWith(
                        //         fontSize: Dimensions.fontSizeDefault,
                        //         color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(.6)),),
                        //     InkWell(
                        //       onTap: () {
                        //         Get.offNamed(RouteHelper.getMainRoute('home'));
                        //       },
                        //       child: Text('guest'.tr, style: ubuntuMedium.copyWith(
                        //           fontSize: Dimensions.fontSizeDefault,
                        //           color: Theme.of(context).colorScheme.primary),),
                        //     ),
                        //   ],
                        // ),
                         const SizedBox(height: Dimensions.paddingSizeExtraMoreLarge,),


                      ],
                    ),
                  ),
                  ),
              );
            },
          ),
        ),
      ),
    );
  }



  Widget _firstList(AuthController authController) {
    return Column(children: [
      CustomTextField(
        title: 'first_name'.tr,
        hintText: 'enter_your_first_name'.tr,
        controller: authController.firstNameController,
        isAutoFocus: false,
        focusNode: _firstNameFocus,
        nextFocus: _lastNameFocus,
        inputType: TextInputType.name,
        capitalization: TextCapitalization.words,
        onValidate: (String? value){
          return FormValidation().isValidFirstName(value!);
        },

      ),
      const SizedBox(height: Dimensions.paddingSizeTextFieldGap),

      CustomTextField(
        title: 'last_name'.tr,
        hintText: 'enter_your_last_name'.tr,
        controller: authController.lastNameController,
        focusNode: _lastNameFocus,
        nextFocus: _emailFocus,
        inputType: TextInputType.name,
        capitalization: TextCapitalization.words,
        onValidate: (String? value){
          return FormValidation().isValidLastName(value!);
        },
      ),
      const SizedBox(height: Dimensions.paddingSizeTextFieldGap),

      CustomTextField(
        title: 'email_address'.tr,
        hintText: 'enter_email_address'.tr,
        controller: authController.emailController,
        focusNode: _emailFocus,
        nextFocus: _phoneFocus,
        inputType: TextInputType.emailAddress,
        onValidate: (String? value){
          return FormValidation().isValidEmail(value);
        },
      ),
      const SizedBox(height: Dimensions.paddingSizeTextFieldGap),

      CustomTextField(
        onCountryChanged: (CountryCode countryCode){
          authController.countryDialCode = countryCode.dialCode!;
        },
        countryDialCode: authController.countryDialCode,
        hintText: 'enter_phone_number'.tr,
        controller: authController.phoneController,
        focusNode: _phoneFocus,
        nextFocus: _passwordFocus,
        inputType: TextInputType.phone,
        isRequired: false,
        onValidate: (String? value) {
          if(value == null || value.isEmpty){
            return 'enter_phone_number'.tr;
          }else{
            return FormValidation().isValidPhone(
                authController.countryDialCode+(value),
                fromAuthPage: true
            );
          }
        },
      ),
      const SizedBox(height: Dimensions.paddingSizeTextFieldGap),
    ],);
  }

  Widget _secondList(AuthController authController) {
    return Column(children: [

      CustomTextField(
        title: 'password'.tr,
        hintText: '****************'.tr,
        controller: authController.passwordController,
        focusNode: _passwordFocus,
        nextFocus: _confirmPasswordFocus,
        inputType: TextInputType.visiblePassword,
        onValidate: (String? value) {
          return FormValidation().isValidPassword(value!);
        },
        isPassword: true,
      ),
      const SizedBox(height: Dimensions.paddingSizeTextFieldGap),

      CustomTextField(
        title: 'confirm_password'.tr,
        hintText: '****************'.tr,
        controller: authController.confirmPasswordController,
        focusNode: _confirmPasswordFocus,
        nextFocus: _referCodeFocus,
        inputType: TextInputType.visiblePassword,
        isPassword: true,
        onValidate: (String? value) {
          if(value == null || value.isEmpty){
            return 'this_field_can_not_empty'.tr;
          }else{
            return FormValidation().isValidConfirmPassword(
              authController.passwordController.text,
              authController.confirmPasswordController.text,);
          }
        },
      ),
      const SizedBox(height: Dimensions.paddingSizeTextFieldGap),
      CustomTextField(
        title: 'referral_code'.tr,
        hintText: 'optional'.tr,
        controller: authController.referCodeController,
        focusNode: _referCodeFocus,
        inputType: TextInputType.text,
        inputAction: TextInputAction.done,
        isRequired: false,
      ),
      const SizedBox(height: Dimensions.paddingSizeTextFieldGap),
    ],);
  }

  void _register(AuthController authController) async {
    if(customerSignUpKey.currentState!.validate()) {
      authController.registration();

      }
    }
}


