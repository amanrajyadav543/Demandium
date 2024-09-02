import 'package:demandium/components/custom_shaking_widget.dart';
import 'package:demandium/components/discount_tag_widget.dart';
import 'package:demandium/components/favorite_icon_widget.dart';
import 'package:demandium/components/on_hover.dart';
import 'package:demandium/feature/provider/model/provider_model.dart';
import 'package:get/get.dart';
import 'package:demandium/components/ripple_button.dart';
import 'package:demandium/components/service_center_dialog.dart';
import 'package:demandium/components/core_export.dart';

class ServiceWidgetVertical extends StatelessWidget {
  final Service service;
  final String fromType;
  final String fromPage;
  final ProviderData? providerData;
  final GlobalKey<CustomShakingWidgetState>?  signInShakeKey;

  const ServiceWidgetVertical({
    super.key, required this.service, required this.fromType,
    this.fromPage ="", this.providerData, this.signInShakeKey}) ;

  @override
  Widget build(BuildContext context) {
    num lowestPrice = 0.0;

    if(fromType == 'fromCampaign'){
      if(service.variations != null){
        lowestPrice = service.variations![0].price!;
        for (var i = 0; i < service.variations!.length; i++) {
          if (service.variations![i].price! < lowestPrice) {
            lowestPrice = service.variations![i].price!;
          }
        }
      }
    }else{
      if(service.variationsAppFormat != null){
        if(service.variationsAppFormat!.zoneWiseVariations != null){
          lowestPrice = service.variationsAppFormat!.zoneWiseVariations![0].price!;
          for (var i = 0; i < service.variationsAppFormat!.zoneWiseVariations!.length; i++) {
            if (service.variationsAppFormat!.zoneWiseVariations![i].price! < lowestPrice) {
              lowestPrice = service.variationsAppFormat!.zoneWiseVariations![i].price!;
            }
          }
        }
      }
    }


    Discount discountModel =  PriceConverter.discountCalculation(service);
    return OnHover(
      isItem: true,
      child: GetBuilder<ServiceController>(builder: (serviceController){
        return Stack(alignment: Alignment.bottomRight, children: [
          Stack(children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                boxShadow: Get.find<ThemeController>().darkTheme ? null : cardShadow,
              ),

              child: Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
                  Expanded(
                    flex: 5,
                    child: Stack(children: [

                      ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusSmall)),
                        child: CustomImage(
                          image: '${service.thumbnailFullPath}',
                          fit: BoxFit.cover,width: double.maxFinite,
                          height: double.infinity,
                        ),
                      ),

                      discountModel.discountAmount! > 0 ? Align(alignment: Alignment.topLeft,
                        child: DiscountTagWidget(
                          discountAmount: discountModel.discountAmount,
                          discountAmountType: discountModel.discountAmountType,
                        ),
                      ) : const SizedBox(),

                    ],),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                    child: Text(
                      service.name ?? "",
                      style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                      maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,
                    ),
                  ),

                  Expanded(
                    flex: 3,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'starts_from'.tr,
                            style: ubuntuRegular.copyWith(
                                fontSize: Dimensions.fontSizeSmall,
                                color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(.6)),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if(discountModel.discountAmount! > 0)
                                Directionality(
                                  textDirection: TextDirection.ltr,
                                  child: Text(
                                    PriceConverter.convertPrice(lowestPrice.toDouble()),
                                    maxLines: 2,
                                    style: ubuntuRegular.copyWith(
                                        fontSize: Dimensions.fontSizeSmall,
                                        decoration: TextDecoration.lineThrough,
                                        color: Theme.of(context).colorScheme.error.withOpacity(.8)),),
                                ),
                              discountModel.discountAmount! > 0?
                              Directionality(
                                textDirection: TextDirection.ltr,
                                child: Text(
                                  PriceConverter.convertPrice(
                                      lowestPrice.toDouble(),
                                      discount: discountModel.discountAmount!.toDouble(),
                                      discountType: discountModel.discountAmountType),
                                  style: ubuntuMedium.copyWith(
                                      fontSize: Dimensions.fontSizeDefault-2 ,
                                      color:  Get.isDarkMode? Theme.of(context).primaryColorLight: Theme.of(context).primaryColor),
                                ),
                              ):
                              Directionality(
                                textDirection: TextDirection.ltr,
                                child: Text(
                                  PriceConverter.convertPrice(lowestPrice.toDouble()),
                                  style: ubuntuMedium.copyWith(
                                      fontSize:Dimensions.fontSizeDefault -2,
                                      color: Get.isDarkMode? Theme.of(context).primaryColorLight: Theme.of(context).primaryColor),
                                ),
                              ),
                            ],
                          ),
                        ]),
                  ),
                ],),
              ),
            ),
            Positioned.fill(child: RippleButton(onTap: () {

              if(fromPage=="search_page"){
                Get.toNamed(RouteHelper.getServiceRoute(service.id!,fromPage:"search_page"),);
              }else{
                Get.toNamed(RouteHelper.getServiceRoute(service.id!),);
              }
            }))
          ],),

          if(fromType != 'fromCampaign')
            Align(
              alignment:Get.find<LocalizationController>().isLtr ? Alignment.bottomRight : Alignment.bottomLeft,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    child: Icon(Icons.add,
                      color: Get.isDarkMode? Theme.of(context).primaryColorLight : Theme.of(context).primaryColor,
                      size: Dimensions.paddingSizeExtraLarge,
                    ),
                  ),
                  Positioned.fill(child: RippleButton(onTap: () {
                    showModalBottomSheet(
                        useRootNavigator: true,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        context: context, builder: (context) => ServiceCenterDialog(service: service, providerData: providerData,));
                  }))
                ],
              ),
            ),

          if(fromType != "provider_details")
          Align(
            alignment: Alignment.topRight,
            child: FavoriteIconWidget(
              value: service.isFavorite,
              onTap: (){

                if(Get.find<AuthController>().isLoggedIn()){
                  serviceController.updateIsFavoriteStatus(
                    serviceId: service.id!,
                    currentStatus: service.isFavorite ?? 0,
                  );
                }else{
                  signInShakeKey?.currentState?.shake();
                  customSnackBar(
                    "message",
                    customWidget: Row(mainAxisAlignment:  MainAxisAlignment.spaceBetween, children: [
                      Flexible(
                        child: Text("please_login_to_add_favorite_list".tr,
                          style: ubuntuRegular.copyWith(color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      InkWell(
                        onTap : () => Get.toNamed(RouteHelper.getSignInRoute(RouteHelper.main)),
                        child: Text('sign_in'.tr, style: ubuntuRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall, color: Colors.white,
                          decoration: TextDecoration.underline,
                        )),
                      ),

                    ],),
                  );
                }
              },
            ),
          )

        ],);
      }),
    );
  }
}
