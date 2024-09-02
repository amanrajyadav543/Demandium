import 'package:demandium/components/core_export.dart';
import 'package:demandium/components/ripple_button.dart';
import 'package:get/get.dart';

class ExploreProviderCard extends StatelessWidget {
  final bool showShimmer;
  const ExploreProviderCard({super.key, required this.showShimmer});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProviderBookingController>(builder: (providerBookingController){
      return (showShimmer || providerBookingController.providerList == null ) ? const ExploreProviderCardShimmer() :

      providerBookingController.providerList != null && providerBookingController.providerList!.isNotEmpty ?  Stack(
        children: [

          Stack(
            children:[
              ClipRRect(
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                child: Image.asset(Images.mapBackground, width: double.infinity, height: double.infinity, fit: BoxFit.cover,),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  color: Get.isDarkMode ? Theme.of(context).cardColor.withOpacity(0.7) : Theme.of(context).colorScheme.primary.withOpacity(0.1),
                ),
              ),

              Align(
                alignment: Get.find<LocalizationController>().isLtr?  Alignment.bottomRight : Alignment.bottomLeft,
                child: Image.asset(Images.exploreProvider,height: 120, width: 110,),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                  child: Column(
                      crossAxisAlignment :  CrossAxisAlignment.start ,
                      mainAxisAlignment: MainAxisAlignment.center,children: [
                    Padding(
                      padding:  EdgeInsets.only(
                        right: Get.find<LocalizationController>().isLtr ? Dimensions.paddingSizeExtraMoreLarge : 0,
                        left : Get.find<LocalizationController>().isLtr ? 0 : Dimensions.paddingSizeExtraMoreLarge,
                      ),
                      child: Text("explore_nearby_providers".tr, style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeSmall,),
                    Text("find_services_just_near_you".tr,
                      style: ubuntuRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.6)),maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: Dimensions.paddingSizeSmall,),

                    Row(
                      children: [
                        Text("see_providers".tr, style: ubuntuRegular.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            decoration: TextDecoration.underline
                        ),),
                        const SizedBox(width: Dimensions.paddingSizeSmall,),
                        Icon(Icons.arrow_forward, color: Theme.of(context).colorScheme.primary, size: 20,)
                      ],
                    ),

                    const SizedBox(height: Dimensions.paddingSizeLarge,),

                  ]),
                ),
              ),
            ],),
          Positioned.fill(child: RippleButton(onTap: (){
            Get.toNamed(RouteHelper.getNearByProviderScreen());
          })),
        ],
      ) : const SizedBox();
    });
  }
}

class ExploreProviderCardShimmer extends StatelessWidget {
  const ExploreProviderCardShimmer({super.key});

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
                child: Image.asset(Images.mapBackground, width: double.infinity, height: double.infinity, fit: BoxFit.cover,),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                color: Get.isDarkMode ?  Theme.of(context).shadowColor : Theme.of(context).shadowColor.withOpacity(0.5),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(height: 15, width: 150, color: Theme.of(context).cardColor),
                const SizedBox(height: 10),
                Container(height: 15, width: 100, color: Theme.of(context).cardColor),
                const SizedBox(height: 10),
                Container(height: 10, width: 120, color: Theme.of(context).cardColor),
              ]),
            ),

            Align(
              alignment: Get.find<LocalizationController>().isLtr?  Alignment.bottomRight : Alignment.bottomLeft,
              child: Image.asset(Images.exploreProvider,height: 120, width: 110, color: Theme.of(context).shadowColor,),
            ),
          ],),
      ),
    );
  }
}

