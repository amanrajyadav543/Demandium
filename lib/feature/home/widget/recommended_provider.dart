import 'package:demandium/components/core_export.dart';
import 'package:demandium/components/custom_shaking_widget.dart';
import 'package:demandium/feature/provider/widgets/provider_item_view.dart';
import 'package:get/get.dart';

class HomeRecommendProvider extends StatelessWidget {
  final double height;
  final GlobalKey<CustomShakingWidgetState>?  signInShakeKey;
  const HomeRecommendProvider({super.key, required this.height, this.signInShakeKey}) ;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProviderBookingController>(
      builder: (providerBookingController){
        return providerBookingController.providerList != null && providerBookingController.providerList!.isNotEmpty ? Container(
          color: Get.isDarkMode ? Colors.grey.shade900 : Theme.of(context).primaryColor.withOpacity(0.12),
          height: height,
          child: Stack(children: [
            Image.asset(Images.homeProviderBackground,width: Get.width,fit: BoxFit.cover,),
            Column(children: [
              const SizedBox(height: Dimensions.paddingSizeDefault),

              Padding(
                padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, 15, Dimensions.paddingSizeDefault,  Dimensions.paddingSizeSmall,),
                child: TitleWidget(
                  textDecoration: TextDecoration.underline,
                  title:'recommended_experts_for_you'.tr,
                  onTap: () => Get.toNamed(RouteHelper.getAllProviderRoute()),
                ),
              ),

              SizedBox(height: ResponsiveHelper.isMobile(context) ? 160: 170,
                child: ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                  itemCount: providerBookingController.providerList?.length,
                  itemBuilder: (context, index){
                    return Padding(padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeLarge),
                      child: SizedBox(
                        width: ResponsiveHelper.isDesktop(context) ? Dimensions.webMaxWidth / 3.2 : ResponsiveHelper.isTab(context)? Get.width/ 2.5 :  Get.width/1.16,
                        child: ProviderItemView(providerData: providerBookingController.providerList![index], index: index, signInShakeKey: signInShakeKey,),
                      ),
                    );
                  },
                ),
              ),
            ])
          ],
          ),
        ) :  providerBookingController.providerList != null && providerBookingController.providerList!.isEmpty ? const SizedBox() :
         HomeRecommendedProviderShimmer(height: height,);

    });
  }
}

class HomeRecommendedProviderShimmer extends StatelessWidget {
  final double height;
  const HomeRecommendedProviderShimmer({super.key, required this.height});

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
                  padding: const EdgeInsets.symmetric(vertical:Dimensions.paddingSizeExtraSmall, horizontal: Dimensions.paddingSizeLarge),
                  decoration: BoxDecoration(
                    color: Theme.of(context).shadowColor,
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    boxShadow: Get.isDarkMode?null:[BoxShadow(color: Colors.grey[200]!, blurRadius: 5, spreadRadius: 1)],
                  ),
                  child: Shimmer(
                    duration: const Duration(seconds: 1),
                    interval: const Duration(seconds: 1),
                    enabled: true,
                    child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                      Container(
                        height: 70, width: 70,
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          shape: BoxShape.circle
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

