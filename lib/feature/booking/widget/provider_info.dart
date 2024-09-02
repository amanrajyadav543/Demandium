import 'package:demandium/feature/provider/model/provider_model.dart';
import 'package:get/get.dart';
import 'package:demandium/components/core_export.dart';

class ProviderInfo extends StatelessWidget {
  final ProviderData provider;
  const ProviderInfo({super.key, required this.provider}) ;

  @override
  Widget build(BuildContext context) {

    return Container(
      width:double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
        color: Theme.of(context).hoverColor,
      ),
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
      child: Column(
        children: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
              child: Text("provider_info".tr, style: ubuntuMedium.copyWith(
                  fontSize: Dimensions.fontSizeDefault,
                  color:Get.isDarkMode? Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(.6): Theme.of(context).primaryColor))),
          Gaps.verticalGapOf(Dimensions.paddingSizeSmall),

          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeExtraLarge)),
            child: SizedBox(
              width: Dimensions.imageSize,
              height: Dimensions.imageSize,
              child:  CustomImage(image: provider.logoFullPath ?? ""),

            ),
          ),
          Gaps.verticalGapOf(Dimensions.paddingSizeExtraSmall),
          Text("${provider.companyName}",style:ubuntuBold.copyWith(fontSize: Dimensions.fontSizeDefault,)),
          Gaps.verticalGapOf(Dimensions.paddingSizeExtraSmall),
          Text("${provider.companyPhone}",style:ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeDefault,)),
        ],
      ),
    );
  }
}
