import 'package:demandium/components/core_export.dart';
import 'package:get/get.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

class BottomCreatePostDialog extends StatelessWidget {
  const BottomCreatePostDialog({super.key}) ;

  @override
  Widget build(BuildContext context) {
    if(ResponsiveHelper.isDesktop(context)) {
      return  Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge)),
        insetPadding: const EdgeInsets.all(30),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: pointerInterceptor(),
      );
    }
    return pointerInterceptor();
  }

  pointerInterceptor(){
    return PointerInterceptor(
      child: Container(
        width:ResponsiveHelper.isDesktop(Get.context!)? Dimensions.webMaxWidth/2:Dimensions.webMaxWidth,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(Dimensions.radiusExtraLarge),
              topRight: Radius.circular(Dimensions.radiusExtraLarge),
            ),
            color: Theme.of(Get.context!).cardColor
        ),

        child: Column(mainAxisSize: MainAxisSize.min, children: [

          Container(height: 5, width: 40,
            decoration: BoxDecoration(
                color: Theme.of(Get.context!).hintColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault)
            ),
            margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault * 1.5),
          ),

          Image.asset(Images.welcomeIcon, height: 130, fit: BoxFit.fitHeight,),
          const SizedBox(height: Dimensions.paddingSizeLarge),

          Text("${"welcome_to".tr} ${AppConstants.appName}!", style: ubuntuBold.copyWith(
              fontSize: Dimensions.fontSizeLarge
          ),),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault * 2,),
            child: Text("welcome_message_for_refer".tr , maxLines: 3,
              style: ubuntuRegular.copyWith(color: Theme.of(Get.context!).textTheme.bodySmall!.color!.withOpacity(0.6), height: 1.5),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeLarge * 1.3),

          CustomButton(
            buttonText: 'okay'.tr,
            width: 100,
            onPressed: () {
              Get.find<AuthController>().toggleReferralBottomSheetShow();
              Get.back();
            }
          ),

          const SizedBox(height: Dimensions.paddingSizeLarge),

        ]),
      ),
    );
  }
}
