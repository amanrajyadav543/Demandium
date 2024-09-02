import 'package:get/get.dart';
import 'package:demandium/core/common_model/user_model.dart';
import 'package:demandium/components/core_export.dart';
class ServiceManInfo extends StatelessWidget {
  final User user;
  const ServiceManInfo({super.key,required this.user, }) ;

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
              child: Text("service_man_info".tr, style: ubuntuMedium.copyWith(
                  fontSize: Dimensions.fontSizeDefault,
                  color:Get.isDarkMode? Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(.6): Theme.of(context).primaryColor))),
          Gaps.verticalGapOf(Dimensions.paddingSizeSmall),

          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeExtraLarge)),
            child: SizedBox(
              width: Dimensions.imageSize,
              height: Dimensions.imageSize,
              child:  CustomImage(image: user.profileImageFullPath ?? ""),

            ),
          ),
          Gaps.verticalGapOf(Dimensions.paddingSizeExtraSmall),
          Text("${user.firstName ?? ""} ${user.lastName ?? ""}",style:ubuntuBold.copyWith(fontSize: Dimensions.fontSizeDefault,)),
          Gaps.verticalGapOf(Dimensions.paddingSizeExtraSmall),
          Text(user.phone ?? "",style:ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeDefault,)),
        ],
      ),
    );
  }
}
