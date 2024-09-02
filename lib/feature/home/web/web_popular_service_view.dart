import 'package:demandium/components/custom_shaking_widget.dart';
import 'package:demandium/components/service_widget_vertical.dart';
import 'package:demandium/feature/home/controller/advertisement_controller.dart';
import 'package:get/get.dart';
import 'package:demandium/components/core_export.dart';

class WebPopularServiceView extends StatelessWidget {
  final GlobalKey<CustomShakingWidgetState>?  signInShakeKey;
  const WebPopularServiceView({super.key, this.signInShakeKey});


  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdvertisementController>(builder: (advertisementController){
      return GetBuilder<ServiceController>(

        builder: (serviceController){
          if(serviceController.popularServiceList != null && serviceController.popularServiceList!.isEmpty){
            return const SizedBox();
          }else{
            if(serviceController.popularServiceList != null){

              int length = 0;
              int itemCount = 3;

              if((advertisementController.advertisementList !=null && advertisementController.advertisementList!.isNotEmpty) || advertisementController.advertisementList == null ){
                length = serviceController.popularServiceList!.length> 6 ? 6 : serviceController.popularServiceList!.length;
                itemCount = 3;

              }else{
                itemCount = 5;
                length = serviceController.popularServiceList!.length > 10 ? 10 : serviceController.popularServiceList!.length ;
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: Dimensions.paddingSizeLarge),
                  TitleWidget(
                    textDecoration: TextDecoration.underline,
                    title: 'popular_services'.tr,
                    onTap: () => Get.toNamed(RouteHelper.getSearchResultRoute(fromPage: "popular")),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: itemCount,
                      childAspectRatio:ResponsiveHelper.isMobile(context) ? 0.78 : 0.72,
                      crossAxisSpacing: Dimensions.paddingSizeDefault,
                      mainAxisSpacing: Dimensions.paddingSizeDefault,
                    ),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                    itemCount: length,
                    itemBuilder: (context, index){
                      return ServiceWidgetVertical(service: serviceController.popularServiceList![index], fromType: '', signInShakeKey : signInShakeKey,);
                    },
                  )
                ],
              );
            }
            else{
              int length = 6;
              int itemCount = 3;

              if(advertisementController.advertisementList == null ){
                length = 6;
                itemCount = 3;
              }else if(advertisementController.advertisementList != null && advertisementController.advertisementList!.isEmpty){
                length = 10;
                itemCount = 5;

              }
              return  Padding(padding: const EdgeInsets.only(top: 65),
                child: GridView.builder(
                  key: UniqueKey(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: Dimensions.paddingSizeDefault,
                    mainAxisSpacing:  Dimensions.paddingSizeDefault,
                    childAspectRatio:ResponsiveHelper.isMobile(context) ? 0.78 : 0.79,
                    crossAxisCount: itemCount,
                  ),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap:  true,
                  itemCount: length,
                  padding: const EdgeInsets.all(0),
                  itemBuilder: (context, index) {
                    return const ServiceShimmer(isEnabled: true, hasDivider: true);
                  },
                ),
              );
            }
          }
        },
      );
    });
  }
}
