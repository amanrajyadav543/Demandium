import 'package:demandium/components/core_export.dart';
import 'package:demandium/feature/provider/model/provider_model.dart';
import 'package:get/get.dart';

class ProviderAvailabilityWidget extends StatelessWidget {
  final String subcategories;
  final String providerId;
  const ProviderAvailabilityWidget({super.key, required this.subcategories, required this.providerId});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProviderBookingController>(builder: (providerController){
      ProviderData providerDetails = providerController.providerDetailsContent!.provider!;
      return SizedBox( width: Dimensions.webMaxWidth/2,
        child: Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeExtraLarge),
          child: Column(  mainAxisSize: MainAxisSize.min, children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start,children: [
              ClipRRect(borderRadius: BorderRadius.circular(Dimensions.radiusExtraMoreLarge),
                  child: CustomImage(height: 50, width: 50, fit: BoxFit.cover,
                      image: providerDetails.logoFullPath ?? "")),

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
                          onTap: ()=>Get.toNamed(RouteHelper.getProviderReviewScreen(subcategories,providerId)),
                          child: Text('${providerDetails.ratingCount} ${'reviews'.tr}', style: ubuntuBold.copyWith(
                            fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).secondaryHeaderColor,
                            decoration: TextDecoration.underline,
                          )),
                        ),
                      ],),

                    ],
                  ),
                ],),
              )
            ],),

            const SizedBox(height: Dimensions.paddingSizeEight,),
            Divider(color: Theme.of(context).hintColor,),
            const SizedBox(height: Dimensions.paddingSizeEight,),

            Text("availability".tr, style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeLarge),),
            const SizedBox(height: Dimensions.paddingSizeEight,),
            Row(mainAxisAlignment: MainAxisAlignment.center , children: [

              Icon(Icons.schedule,size: Dimensions.fontSizeDefault, color:Theme.of(context).textTheme.bodySmall?.color ,),
              const SizedBox(width: Dimensions.paddingSizeExtraSmall,),
              Text("currently_available".tr, style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodySmall?.color),),
            ],),


            const SizedBox(height: Dimensions.paddingSizeEight,),
            Divider(color: Theme.of(context).hintColor,),
            const SizedBox(height: Dimensions.paddingSizeEight,),

            Text("Monday - Sunday".tr, style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeLarge),),
            const SizedBox(height: Dimensions.paddingSizeEight,),
            Text("09:00 - 23:59".tr, style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodySmall?.color),),

            const SizedBox(height: Dimensions.paddingSizeExtraLarge,),

            Text("Monday - Sunday".tr, style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeLarge),),
            const SizedBox(height: Dimensions.paddingSizeEight,),
            Text("Day Off".tr, style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodySmall?.color),),


          ],),
        ),
      );
    });
  }
}
