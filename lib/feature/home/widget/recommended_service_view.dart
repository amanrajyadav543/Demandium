import 'package:demandium/components/custom_shaking_widget.dart';
import 'package:get/get.dart';
import 'package:demandium/components/core_export.dart';

class RecommendedServiceView extends StatelessWidget {
  final double height;
  final GlobalKey<CustomShakingWidgetState>?  signInShakeKey;
  const RecommendedServiceView({super.key, required this.height, this.signInShakeKey});

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();
    return GetBuilder<ServiceController>(
      builder: (serviceController){

        if(serviceController.recommendedServiceList != null && serviceController.recommendedServiceList!.isEmpty){
          return const SizedBox();
        }
        else{
          if(serviceController.recommendedServiceList != null){
            return Container(
              color: Get.isDarkMode ? Colors.grey.shade900 : Theme.of(context).hintColor.withOpacity(0.1),
              height: height,
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: Get.width * 0.07),
                    child: Align(
                      alignment: favButtonAlignment(),
                      child: Opacity(
                        opacity: 0.5,
                        child: Image.asset(Images.recommendedServiceBg, fit: BoxFit.fitHeight,),
                      ),
                    ),
                  ),
                  Column(
                    children: [

                      Padding(
                        padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, 15, Dimensions.paddingSizeDefault,  Dimensions.paddingSizeSmall,),
                        child: TitleWidget(
                          textDecoration: TextDecoration.underline,
                          title: 'recommended_for_you'.tr,
                          onTap: () => Get.toNamed(RouteHelper.getSearchResultRoute(fromPage: "recommended")),
                        ),
                      ),

                      SizedBox( height: 140,
                        child: ListView.builder(
                          controller: scrollController,
                          physics: const ClampingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                          scrollDirection: Axis.horizontal,
                          itemCount: serviceController.recommendedServiceList!.length > 10 ? 10 : serviceController.recommendedServiceList!.length,
                          itemBuilder: (context, index){
                            Discount discountValue =  PriceConverter.discountCalculation(serviceController.recommendedServiceList![index]);
                            return SizedBox(
                              width: ResponsiveHelper.isDesktop(context) ? Dimensions.webMaxWidth / 3.2 : ResponsiveHelper.isTab(context)? Get.width/ 2.5 :  Get.width/1.16,
                              child: ServiceWidgetHorizontal(
                                serviceList: serviceController.recommendedServiceList!,
                                discountAmountType: discountValue.discountAmountType,
                                discountAmount: discountValue.discountAmount,
                                index: index,
                                signInShakeKey: signInShakeKey,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeDefault,)
                    ],
                  ),
                ],
              ),
            );
          }else{
            return RecommendedServiceShimmer(enabled: true, height: height,);
          }
        }
      },
    );
  }
}

class RecommendedServiceShimmer extends StatelessWidget {
  final bool enabled;
  final double height;
  const RecommendedServiceShimmer({super.key, required this.enabled, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        boxShadow: Get.isDarkMode ? null : [BoxShadow(color: Colors.grey[300]!, blurRadius: 10, spreadRadius: 1)],
      ),
      margin: const EdgeInsets.all(2),
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
      child: Column(
        children: [

          const SizedBox(height: Dimensions.paddingSizeDefault,),

          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
            Container(height: 15, width: 130, color: Theme.of(context).shadowColor),
            Container(height: 15, width: 80, color: Theme.of(context).shadowColor),
          ],),

          const SizedBox(height: Dimensions.paddingSizeDefault,),

          SizedBox(
            height: 140,
            child: ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: 10,
              itemBuilder: (context, index){
                return Container(
                  width: Dimensions.webMaxWidth /3.2,
                  margin: const EdgeInsets.symmetric(horizontal:Dimensions.paddingSizeSmall),
                  padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                  decoration: BoxDecoration(
                    color: Theme.of(context).shadowColor,
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    boxShadow: Get.isDarkMode?null:[BoxShadow(color: Colors.grey[200]!, blurRadius: 5, spreadRadius: 1)],
                  ),
                  child: Shimmer(
                    duration: const Duration(seconds: 1),
                    interval: const Duration(seconds: 1),
                    enabled: enabled,
                    child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                      Container(
                        height: 90, width: 90,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                          color: Theme.of(context).cardColor,
                        ),
                      ),

                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                            Container(height: 15, width: 100, color: Theme.of(context).cardColor),
                            const SizedBox(height: 5),
                            Container(height: 10, width: 130, color: Theme.of(context).cardColor),
                            const SizedBox(height: 5),
                            Container(height: 15, width: 100, color: Theme.of(context).cardColor),
                          ]),
                        ),
                      ),

                    ]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}