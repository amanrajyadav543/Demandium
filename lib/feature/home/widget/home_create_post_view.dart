import 'package:demandium/components/core_export.dart';
import 'package:get/get.dart';

class HomeCreatePostView extends StatelessWidget {
  final bool showShimmer;
  const HomeCreatePostView({super.key, required this.showShimmer}) ;

  @override
  Widget build(BuildContext context) {
    return showShimmer ? const HomeCreatePostViewShimmer() : Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Images.createPostBackgroundImage),
          fit: BoxFit.cover
        ),
        color: Theme.of(context).cardColor ,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.3)),
      ),
      padding: const EdgeInsets.only(top: Dimensions.paddingSizeLarge),

      child: Stack(
        alignment:Get.find<LocalizationController>().isLtr? Alignment.bottomLeft: Alignment.bottomRight,
        children:[
          Image.asset(Images.homeCreatePostMan,height: 120, width: 110,),
          Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
            child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [

              const SizedBox(width: 100,),
              Expanded(
                child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [
                  Text("post_for_customized_service".tr, style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall,),
                  Text("create_post_text".tr,
                    textAlign: TextAlign.center,
                    style: ubuntuRegular.copyWith(
                      fontSize: Dimensions.fontSizeSmall,
                      color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.6)),maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault,),
                  CustomButton(
                    buttonText: "create_post".tr,
                    height: 45,
                    width: 150,
                    radius: Dimensions.radiusExtraMoreLarge,
                    onPressed: (){
                      if(Get.find<AuthController>().isLoggedIn()){
                        Get.toNamed(RouteHelper.getCreatePostScreen());
                      }else{
                        Get.toNamed(RouteHelper.getNotLoggedScreen(RouteHelper.main.tr,"create_post"));
                      }
                    },
                  ),
                  const SizedBox(height: Dimensions.paddingSizeLarge,),

                ]),
              )
            ]),
          ),
      ],),
    );
  }
}

class HomeCreatePostViewShimmer extends StatelessWidget {
  const HomeCreatePostViewShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return  Shimmer(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        ),

        child: Stack(
          children:[
            Opacity(opacity: Get.isDarkMode ? 0.1 : 0.9,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                child: Image.asset(Images.createPostBackgroundImage, width: double.infinity, height: double.infinity, fit: BoxFit.cover,),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                color: Get.isDarkMode ?  Theme.of(context).shadowColor : Theme.of(context).shadowColor.withOpacity(0.5),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(height: 20, width: 150, color: Theme.of(context).cardColor),
                  const SizedBox(height: 10),
                  Container(height: 10, width: 100, color: Theme.of(context).cardColor),
                  const SizedBox(height: 5),
                  Container(height: 10, width: 150, color: Theme.of(context).cardColor),
                  const SizedBox(height: 5),
                  Container(height: 10, width: 100, color: Theme.of(context).cardColor),
                  const SizedBox(height: 20),
                  Container(height: 30, width: 120, decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusExtraMoreLarge),
                    color: Theme.of(context).cardColor,
                  ),),
                ]),
              ),
            ),

            Align(
              alignment: Get.find<LocalizationController>().isLtr ?  Alignment.bottomLeft : Alignment.bottomRight,
              child: Image.asset(Images.homeCreatePostMan,height: 120, width: 110, color: Theme.of(context).shadowColor,),
            ),
          ],),
      ),
    );
  }
}

