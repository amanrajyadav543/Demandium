import 'package:demandium/components/core_export.dart';
import 'package:demandium/components/favorite_icon_widget.dart';
import 'package:demandium/components/on_hover.dart';
import 'package:demandium/components/service_center_dialog.dart';
import 'package:demandium/feature/favorite/widget/favorite_item_remove_dialog.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

class FavoriteServiceItemView extends StatelessWidget {
  final Service? service;
  final int index;
  final num? discountAmount;
  final String? discountAmountType;

  const FavoriteServiceItemView({super.key, this.service, required this.index, this.discountAmount, this.discountAmountType}) ;

  @override
  Widget build(BuildContext context) {

    double lowestPrice = 0.0;
    if(service?.variationsAppFormat!.zoneWiseVariations != null){
      lowestPrice = service!.variationsAppFormat!.zoneWiseVariations![0].price!.toDouble();
      for (var i = 0; i < service!.variationsAppFormat!.zoneWiseVariations!.length; i++) {
        if (service!.variationsAppFormat!.zoneWiseVariations![i].price! < lowestPrice) {
          lowestPrice = service!.variationsAppFormat!.zoneWiseVariations![i].price!.toDouble();
        }
      }
    }

    return Padding(padding: const  EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeEight),
      child: Slidable(
        key: ValueKey(index),
        closeOnScroll: true,
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          dismissible: null,
          extentRatio: 0.2,
          children: [
            CustomSlidableAction(
              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
              flex: 1,
              onPressed: (context) async {
                showModalBottomSheet(
                  context: context,
                  useRootNavigator: true,
                  isScrollControlled: true,
                  builder: (context) => FavoriteItemRemoveDialog(
                    service: service,
                  ),
                  backgroundColor: Colors.transparent,
                );
              },
              backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.07),
              foregroundColor: Colors.white,
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(Dimensions.radiusSmall),
                  bottomRight:  Radius.circular(Dimensions.radiusSmall)),
              child: Container(
                padding: const EdgeInsets.all(Dimensions.paddingSizeEight),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.error,
                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                ),
                child: const Icon(Icons.delete_forever_outlined, color: Colors.white,),
              ),
            ),
          ],
        ),
        child: OnHover(
          isItem: true,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor ,
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  boxShadow: Get.isDarkMode ? null: searchBoxShadow,
                  //border: Border.all(color: Theme.of(context).hintColor.withOpacity(0.2)),
                ),
                padding: const EdgeInsets.symmetric(horizontal : Dimensions.paddingSizeDefault, vertical: 10),
                child: Row(children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                        child: CustomImage(
                          image: '${service?.thumbnailFullPath}',
                          height: 90, width: 100, fit: BoxFit.cover,
                        ),
                      ),

                      if( discountAmount != null && discountAmountType!=null && discountAmount! > 0) Positioned.fill(
                        child: Align(alignment: Alignment.topRight,
                          child: Container(
                            padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.error.withOpacity(0.8),
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(Dimensions.radiusDefault),
                                topRight: Radius.circular(Dimensions.radiusSmall),
                              ),
                            ),
                            child: Directionality(
                              textDirection: TextDirection.ltr,
                              child: Text(
                                PriceConverter.percentageOrAmount('$discountAmount', discountAmountType!),
                                style: ubuntuMedium.copyWith(color: Theme.of(context).primaryColorLight),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(width: Dimensions.paddingSizeSmall,),

                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(
                        service?.name ?? "",
                        style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.8)),
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: Dimensions.paddingSizeSmall),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("starts_from".tr,style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeSmall,
                            color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.5),),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeExtraSmall,),

                          Row(crossAxisAlignment: CrossAxisAlignment.center, children: [

                            if(discountAmount! > 0) Directionality(
                              textDirection: TextDirection.ltr,
                              child: Text("${PriceConverter.convertPrice(lowestPrice)} ",
                                style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeSmall,
                                  decoration: TextDecoration.lineThrough,
                                  color: Theme.of(context).colorScheme.error.withOpacity(.8),
                                ),
                              ),
                            ),

                            discountAmount! > 0 ? Directionality(
                              textDirection: TextDirection.ltr,
                              child: Text(PriceConverter.convertPrice(lowestPrice,
                                discount: discountAmount!.toDouble(), discountType: discountAmountType,
                              ), style: ubuntuBold.copyWith(fontSize: Dimensions.paddingSizeDefault,
                                  color: Get.isDarkMode? Theme.of(context).primaryColorLight: Theme.of(context).primaryColor),
                              ),
                            ): Directionality(
                              textDirection: TextDirection.ltr,
                              child: Text(PriceConverter.convertPrice(lowestPrice),
                                style: ubuntuBold.copyWith(
                                  fontSize: Dimensions.fontSizeLarge,
                                  color: Get.isDarkMode? Theme.of(context).primaryColorLight: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),

                          ]),
                        ],
                      ),
                    ]),
                  ),

                  const SizedBox(width: Dimensions.paddingSizeExtraMoreLarge,),


                ]),
              ),

              Align(
                alignment: favButtonAlignment(),
                child: FavoriteIconWidget(value: 1, onTap: (){
                  showModalBottomSheet(
                    context: context,
                    useRootNavigator: true,
                    isScrollControlled: true,
                    builder: (context) => FavoriteItemRemoveDialog(
                      service: service,
                    ),
                    backgroundColor: Colors.transparent,
                  );
                },),
              ),

              Align(
                alignment: Get.find<LocalizationController>().isLtr ? Alignment.bottomRight : Alignment.bottomLeft,
                child: Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  child: InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        useRootNavigator: true,
                        isScrollControlled: true,
                        builder: (context) => ServiceCenterDialog(service: service,),
                        backgroundColor: Colors.transparent,
                      );
                    },
                    child: Icon(
                      Icons.add,size: Dimensions.paddingSizeExtraLarge,
                      color: Get.isDarkMode? Theme.of(context).primaryColorLight: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
