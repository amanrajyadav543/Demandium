import 'package:demandium/components/core_export.dart';
import 'package:get/get.dart';

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
    return Container(
      width:ResponsiveHelper.isDesktop(Get.context!)? Dimensions.webMaxWidth/2:Dimensions.webMaxWidth,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(Dimensions.radiusExtraLarge),
            topRight: Radius.circular(Dimensions.radiusExtraLarge),
          ),
          color: Theme.of(Get.context!).cardColor
      ),padding: const EdgeInsets.all(15),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          (ResponsiveHelper.isDesktop(Get.context)) ?
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 40, width: 40, alignment: Alignment.center,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white70.withOpacity(0.6),
                    boxShadow:Get.isDarkMode?null:[BoxShadow(
                      color: Colors.grey[300]!, blurRadius: 2, spreadRadius: 1,
                    )]
                ),
                child: InkWell(
                    onTap: () => Get.back(),
                    child: const Icon(
                      Icons.close,
                      color: Colors.black54,

                    )
                ),
              ),
            ],
          ) : Container(
            decoration: BoxDecoration(
              color: Theme.of(Get.context!).hintColor,
              borderRadius: BorderRadius.circular(15),
            ),
            height: 4 , width: 80,
          ),
          const SizedBox(height: Dimensions.paddingSizeDefault,),
          Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeLarge),
            child: Image.asset(Images.bottomCreatePostMan,height: 120, width: 120,),
          ),

          Text("post_your_needs".tr, style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeLarge),
            maxLines: 1, overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: Dimensions.paddingSizeDefault),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.paddingSizeDefault
            ),
            child: Text("post_your_needs_bottom".tr, style: ubuntuRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                wordSpacing: 2,
                height: 1.3,
                color: Theme.of(Get.context!).textTheme.bodyLarge!.color!.withOpacity(0.6)),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: Dimensions.paddingSizeExtraLarge + 10,),
          CustomButton(
            buttonText: "create_post".tr,
            height: ResponsiveHelper.isDesktop(Get.context!)? 45: 40,
            width: 200,
            radius: Dimensions.radiusExtraMoreLarge,
            onPressed: (){
              Get.back();
              if(Get.find<AuthController>().isLoggedIn()){
                Get.toNamed(RouteHelper.getCreatePostScreen());
              }else{
                Get.toNamed(RouteHelper.getNotLoggedScreen(RouteHelper.main,"create_post"));
              }
            },
          ),
          const SizedBox(height: Dimensions.paddingSizeExtraLarge),
        ],),
    );
  }
}
