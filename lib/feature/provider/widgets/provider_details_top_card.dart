import 'package:demandium/components/core_export.dart';
import 'package:demandium/feature/provider/model/provider_model.dart';
import 'package:get/get.dart';
class ProviderDetailsTopCard extends StatelessWidget {
  final bool isAppbar;
  final String subcategories;
  final String providerId;
  const ProviderDetailsTopCard({super.key, this.isAppbar=true, required this.subcategories, required this.providerId}) ;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProviderBookingController>(
        builder: (providerController){
          ProviderData providerDetails = providerController.providerDetailsContent!.provider!;
      return Column(children: [
        Container(decoration: BoxDecoration(color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          border: Border.all(color: Theme.of(context).hintColor.withOpacity(0.3)),
        ),
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault,vertical: Dimensions.paddingSizeDefault),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start,children: [
            ClipRRect(borderRadius: BorderRadius.circular(Dimensions.radiusExtraMoreLarge),
                child: CustomImage(height: 50, width: 50, fit: BoxFit.cover,
                    image: providerDetails.logoFullPath ??"")),

            const SizedBox(width: Dimensions.paddingSizeSmall,),
            Expanded(
              child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,children: [
                Text(providerDetails.companyName??'', style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                    maxLines: 1, overflow: TextOverflow.ellipsis),

                const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                Text(subcategories,
                  style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeSmall,color: Theme.of(context).secondaryHeaderColor),
                  maxLines: 2,overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: Dimensions.paddingSizeEight),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                   Row(children: [
                     SizedBox(
                       height: 20,
                       child: Row(
                         children: [
                           Icon(Icons.star, color: Theme.of(context).colorScheme.primary, size: Dimensions.fontSizeLarge),
                           Gaps.horizontalGapOf(5),
                           Directionality(
                             textDirection: TextDirection.ltr,
                             child: Text(
                               providerDetails.avgRating!.toString(),
                               style: TextStyle(
                                   fontWeight: FontWeight.w700,
                                   fontSize: Dimensions.fontSizeSmall,
                                   color: Colors.grey),
                             ),
                           ),
                         ],
                       ),
                     ),
                     Container(
                       width: 1,height: 10,
                       margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                       decoration: BoxDecoration(
                         color: Theme.of(context).primaryColor.withOpacity(0.5),
                       ),
                     ),
                     InkWell(
                       onTap: ()=> isAppbar ? Get.toNamed(RouteHelper.getProviderReviewScreen(subcategories,providerId)) : null,
                       child: Text('${providerDetails.ratingCount} ${'reviews'.tr}', style:  isAppbar ? ubuntuBold.copyWith(
                         fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).secondaryHeaderColor,
                         decoration:  isAppbar? TextDecoration.underline : null,
                       ) : ubuntuRegular.copyWith(
                         fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).secondaryHeaderColor,
                         decoration:  isAppbar? TextDecoration.underline : null,
                       )),
                     ),
                   ],),

                    if(isAppbar && providerDetails.timeSchedule !=null)
                    InkWell(
                      onTap: ()=> isAppbar ? Get.toNamed(RouteHelper.getProviderAvailabilityScreen(subcategories,providerId)) : null,
                      child: Text("more_info".tr, style: ubuntuMedium.copyWith(color: Theme.of(context).colorScheme.primary),),
                    )

                  ],
                ),
              ],),
            )
          ],),
        ),
        if(isAppbar==true)
          const Expanded(child: SizedBox()),
      ],
      );
    });
  }
}
