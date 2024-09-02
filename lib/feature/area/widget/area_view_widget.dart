import 'package:demandium/components/core_export.dart';
import 'package:get/get.dart';

class AreaViewWidget extends StatelessWidget {
  const AreaViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    String? zoneId = Get.find<LocationController>().getUserAddress()?.zoneId!;
    return GetBuilder<ServiceAreaController>(
        builder: (serviceAreaController) {
          return serviceAreaController.zoneList == null  ? const AvailableAreaShimmer() :

          GridView.builder(
            key: UniqueKey(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 1.7,
              mainAxisSpacing: Dimensions.paddingSizeEight,
              crossAxisSpacing: Dimensions.paddingSizeEight,
              crossAxisCount: ResponsiveHelper.isMobile(context) ? 2 : ResponsiveHelper.isTab(context) ? 3 : 3,
            ),
            physics:const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: serviceAreaController.zoneList?.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall, vertical: 0),
                child: Column(
                  children: [
                    zoneId == serviceAreaController.zoneList![index].id ? Column( mainAxisSize: MainAxisSize.min, children: [
                      Text('your_area'.tr, style:  ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).colorScheme.primary)),
                      const SizedBox(height: 3),
                    ]) : const SizedBox(height: Dimensions.paddingSizeDefault),

                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Get.toNamed(RouteHelper.getPickMapRoute( RouteHelper.initial, true, 'false', serviceAreaController.zoneList![index], Get.find<LocationController>().getUserAddress()));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                            border: Border.all(color: zoneId == serviceAreaController.zoneList![index].id  ? Theme.of(context).colorScheme.primary.withOpacity(0.45) : Theme.of(context).colorScheme.primary.withOpacity(0.10)),
                            color: zoneId == serviceAreaController.zoneList![index].id  ? Theme.of(context).colorScheme.primary.withOpacity(0.15) : Theme.of(context).colorScheme.primary.withOpacity(0.05)
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeEight),
                          child: Center(
                            child: Text(serviceAreaController.zoneList![index].name!, style: ubuntuRegular, maxLines: 3, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          );
        }
    );
  }
}




class AvailableAreaShimmer extends StatelessWidget {
  const AvailableAreaShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: GridView.builder(
        key: UniqueKey(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 1.7,
          crossAxisCount: ResponsiveHelper.isMobile(context) ? 2 : ResponsiveHelper.isTab(context) ? 3 : 3,
        ),
        physics:const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: ResponsiveHelper.isMobile(context) ? 10 : 15,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall, vertical: 0),
            child: Column(
              children: [
                const SizedBox(height: Dimensions.paddingSizeDefault),

                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      color: Theme.of(context).cardColor,
                      boxShadow: Get.isDarkMode?null:[BoxShadow(color: Colors.grey[200]!, blurRadius: 5, spreadRadius: 1)],
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
