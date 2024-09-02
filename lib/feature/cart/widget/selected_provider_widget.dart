import 'package:demandium/components/core_export.dart';
import 'package:demandium/feature/provider/model/provider_model.dart';
import 'package:get/get.dart';

class SelectedProductWidget extends StatelessWidget {
  final ProviderData? providerData;
  const SelectedProductWidget({super.key, this.providerData}) ;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(builder: (cartController){
      return Container(
        height:  ResponsiveHelper.isDesktop(context)? 50 : 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.5),width: 0.7),
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        ),
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
        child: Center(child: Row(
          children:  [

            ClipRRect( borderRadius: BorderRadius.circular(Dimensions.radiusExtraMoreLarge),
              child: CustomImage(
                image: "${providerData?.logoFullPath}",
                height: 25,width: 25,),),
            const SizedBox(width: Dimensions.paddingSizeSmall,),
            Icon(Icons.star,color: Theme.of(context).colorScheme.primary,size: 15,),
            Directionality(textDirection: TextDirection.ltr,
              child: Text( "${providerData?.avgRating ?? ""}",style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeDefault),),
            )

          ],
        )),
      );
    });
  }
}
