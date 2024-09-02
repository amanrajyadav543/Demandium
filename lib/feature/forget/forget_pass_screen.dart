import 'package:country_code_picker/country_code_picker.dart';
import 'package:demandium/core/helper/phone_verification_helper.dart';
import 'package:get/get.dart';
import 'package:demandium/components/core_export.dart';

class ForgetPassScreen extends StatefulWidget {
  final bool fromVerification;
  const ForgetPassScreen({super.key,this.fromVerification = false});

  @override
  State<ForgetPassScreen> createState() => _ForgetPassScreenState();
}

class _ForgetPassScreenState extends State<ForgetPassScreen> {

  final TextEditingController _identityController = TextEditingController();


  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  ConfigModel? configModel ;
  final FocusNode focusNode = FocusNode();

  String identityType ="";
  String countryDialCode  = "";
  @override
  void initState() {
    super.initState();

    configModel = Get.find<SplashController>().configModel;
    countryDialCode = CountryCode.fromCountryCode(configModel?.content?.countryCode ??"").dialCode ?? "+880" ;

    if(widget.fromVerification){
      if(configModel?.content?.emailVerification == 1){
        identityType = "email";
      }else{
        identityType = "phone";
      }

    } else{
      identityType = configModel?.content?.forgetPasswordVerificationMethod ?? "" ;
    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      endDrawer:ResponsiveHelper.isDesktop(context) ? const MenuDrawer():null,
      appBar: CustomAppBar(title: widget.fromVerification && configModel?.content?.phoneVerification == 1 ?
      'phone_verification'.tr : widget.fromVerification && configModel?.content?.emailVerification == 1 ?
      "email_verification".tr : 'forgot_password'.tr.replaceAll("?", " "),
        onBackPressed: (){
        if(Navigator.canPop(context)){
          Get.back();
        }else{
          Get.toNamed(RouteHelper.getSignInRoute(RouteHelper.main));
        }
        },
      ),

      body: SafeArea(
        child: GetBuilder<AuthController>(
          builder: (authController){
            return FooterBaseView(
              isCenter: true,
              child: WebShadowWrap(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveHelper.isDesktop(context)?Dimensions.webMaxWidth/6:
                      ResponsiveHelper.isTab(context)? Dimensions.webMaxWidth/8:0
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                    child: Form(
                      key: formKey,
                      child: Column(

                        mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                        Image.asset(Images.forgotPass, width: 100, height: 100,),

                        if(widget.fromVerification)
                        Padding(padding: const EdgeInsets.only(top: Dimensions.paddingSizeLarge),
                          child: Center(child: Text('${"verify_your".tr} ${identityType=="email"?"email_address".tr.toLowerCase():"phone_number".tr.toLowerCase()}',
                            style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeLarge,color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.9)),textAlign: TextAlign.center,
                          )),
                        ),

                         Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeLarge*1.5),
                           child: Center(child: Text('${"please_enter_your".tr} ${identityType=="email"?"email_address".tr.toLowerCase():"phone_number".tr.toLowerCase()} ${"to_receive_a_verification_code".tr}',
                             style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeDefault,color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7)),textAlign: TextAlign.center,
                           )),
                         ),

                        (identityType=="phone") ?
                         CustomTextField(
                           hintText: 'enter_phone_number'.tr,
                           controller: _identityController,
                           inputType: TextInputType.phone,
                           inputAction: TextInputAction.done,
                           countryDialCode: countryDialCode,
                           focusNode: focusNode,
                           onCountryChanged: (CountryCode countryCode) => countryDialCode = countryCode.dialCode ?? "+880",
                           onValidate: (String? value) {
                             if(value == null || value.isEmpty){
                               return 'enter_phone_number'.tr;
                             }else{
                               return FormValidation().isValidPhone(countryDialCode + value, fromAuthPage: true
                               );
                             }
                           },

                         ): Padding(padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: CustomTextField(
                            title: 'email_address'.tr,
                            hintText: 'enter_email_address'.tr,
                            controller: _identityController,
                            inputType: TextInputType.emailAddress,
                            focusNode: focusNode,
                            onValidate: (String? value){
                              return FormValidation().isValidEmail(value);
                            },
                           ),
                        ),

                        const SizedBox(height: Dimensions.paddingSizeLarge * 1.5),
                        GetBuilder<AuthController>(builder: (authController) {
                          return CustomButton(
                            buttonText: 'send_verification_code'.tr,
                            isLoading: authController.isLoading,
                            fontSize: Dimensions.fontSizeDefault,
                            onPressed: ()=> formKey.currentState!.validate() ? _forgetPass(countryDialCode,authController) : null,
                          );
                        }),
                       const SizedBox(height: Dimensions.paddingSizeLarge*4),
                        ]),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _forgetPass(String countryDialCode,AuthController authController) async {
    String phone = PhoneVerificationHelper.getValidPhoneWithCountryCode(countryDialCode + _identityController.text.trim(), withCountryCode: true);
    if (kDebugMode) {
      print("Phone : $phone");
    }
    String email = _identityController.text.trim();
    String identity = identityType=="phone"? phone : email;

      if(widget.fromVerification){
        authController.sendOtpForVerificationScreen(identity,identityType).then((status) {
          if(status.isSuccess!){
            Get.toNamed(RouteHelper.getVerificationRoute(identity,identityType,"verification"));
          }else{
            customSnackBar(status.message.toString().capitalizeFirst);
          }
        });
      }else{
        authController.sendOtpForForgetPassword(identity,identityType).then((status){
          if(status.isSuccess!){
            Get.toNamed(RouteHelper.getVerificationRoute(identity,identityType,"forget-password"));
          }else{
            customSnackBar(status.message.toString().capitalizeFirst);
          }
        });

      }
    }
}

