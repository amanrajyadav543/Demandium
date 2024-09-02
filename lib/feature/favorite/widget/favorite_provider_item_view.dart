import 'package:demandium/components/core_export.dart';
import 'package:demandium/components/favorite_icon_widget.dart';
import 'package:demandium/components/on_hover.dart';
import 'package:demandium/components/ripple_button.dart';
import 'package:demandium/feature/favorite/widget/favorite_item_remove_dialog.dart';
import 'package:demandium/feature/provider/model/provider_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

class FavoriteProviderItemView extends StatelessWidget {
  final bool enableSlideDelete;
  final ProviderData providerData;
  final int index;
  const FavoriteProviderItemView({super.key,  required this.providerData, required this.index, this.enableSlideDelete = true}) ;

  @override
  Widget build(BuildContext context) {

    List<String> subcategory=[];
    providerData.subscribedServices?.forEach((element) {
      if(element.subCategory!=null){
        subcategory.add(element.subCategory?.name??"");
      }
    });

    String subcategories = subcategory.toString().replaceAll('[', '');
    subcategories = subcategories.replaceAll(']', '');
    subcategories = subcategories.replaceAll('&', ' and ');

    return Padding(padding: const EdgeInsets.fromLTRB( 15, 0, 15, 15),
      child: Slidable(
        key: const ValueKey(1),
        closeOnScroll: false,
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
                    providerData: providerData,
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
                decoration: BoxDecoration(color: Theme.of(context).cardColor , borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  border: Border.all(color: Theme.of(context).hintColor.withOpacity(0.3)),
                ),
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row( crossAxisAlignment: CrossAxisAlignment.start ,children: [

                    ClipRRect(borderRadius: BorderRadius.circular(Dimensions.radiusExtraMoreLarge),
                      child: CustomImage(height: 60, width: 60, fit: BoxFit.cover,
                        image: "${providerData.logoFullPath}",
                      ),
                    ),

                    const SizedBox(width: Dimensions.paddingSizeSmall),

                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.start,children: [
                        Padding(padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: Text(providerData.companyName??"", style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                              maxLines: 1, overflow: TextOverflow.ellipsis),
                        ),

                        Padding(padding: const EdgeInsets.symmetric(vertical: 3),
                          child: Row(children: [
                            RatingBar(rating: providerData.avgRating),
                            Gaps.horizontalGapOf(5),
                            Directionality(
                              textDirection: TextDirection.ltr,
                              child:  Text('${providerData.ratingCount} ${'reviews'.tr}', style: ubuntuRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).secondaryHeaderColor,
                              )),
                            ),
                          ],
                          ),
                        ),

                        Padding(padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: Row(children: [
                            Image.asset(Images.iconLocation, height:12),
                            const SizedBox(width: Dimensions.paddingSizeExtraSmall,),
                            Flexible(
                              child: Text(providerData.companyAddress??"",
                                style: ubuntuMedium.copyWith(color:Get.isDarkMode? Theme.of(context).secondaryHeaderColor:Theme.of(context).primaryColorDark,fontSize: Dimensions.fontSizeSmall),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),

                          ],),
                        )
                      ],),
                    ),

                  ],),

                  const SizedBox(height: Dimensions.paddingSizeSmall,),

                  Row(children: [
                    Expanded(child: ProviderInfoButton(title: "${providerData.subscribedServicesCount}", subtitle: "services".tr,)),
                    const SizedBox(width: Dimensions.paddingSizeSmall,),
                    Expanded(child: ProviderInfoButton(title: "${providerData.totalServiceServed}", subtitle: "services_provided".tr,)),

                  ],)

                ]),
              ),
              Positioned.fill(child: RippleButton(onTap: (){
                Get.toNamed(RouteHelper.getProviderDetails(providerData.id!,subcategories));
              })),
              Align(
                alignment: favButtonAlignment(),
                child: FavoriteIconWidget(value: 1, onTap: () async {
                  showModalBottomSheet(
                    context: context,
                    useRootNavigator: true,
                    isScrollControlled: true,
                    builder: (context) => FavoriteItemRemoveDialog(
                      providerData: providerData,
                    ),
                    backgroundColor: Colors.transparent,
                  );
                },),
              )
            ],
          ),
        ),
      ),
    );
  }
}


class ProviderInfoButton extends StatelessWidget {
  final String? title;
  final String subtitle;
  const ProviderInfoButton({super.key, this.title, required this.subtitle}) ;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        color: Theme.of(context).hintColor.withOpacity(0.2),
      ),
      padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall -1 ),

      child: Column(children: [
        Text("$title", style: ubuntuMedium.copyWith(color: Theme.of(context).colorScheme.primary),),
        Text(subtitle, style: ubuntuMedium.copyWith(color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.5), fontSize: Dimensions.fontSizeSmall)),
        const SizedBox(height: 3,)
      ],),
    );
  }
}

