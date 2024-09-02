import 'package:demandium/components/custom_shaking_widget.dart';
import 'package:demandium/components/service_widget_vertical.dart';
import 'package:demandium/components/core_export.dart';
import 'package:get/get.dart';

class WebFeatheredCategoryView extends StatefulWidget {
  final GlobalKey<CustomShakingWidgetState>?  signInShakeKey;
  const WebFeatheredCategoryView({super.key, this.signInShakeKey}) ;

  @override
  State<WebFeatheredCategoryView> createState() => _WebFeatheredCategoryViewState();
}

class _WebFeatheredCategoryViewState extends State<WebFeatheredCategoryView> {

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ServiceController>(builder: (serviceController){
      return serviceController.categoryList !=null ? SizedBox(
        child: ListView.builder(itemBuilder: (context,categoryIndex){

          int serviceItemCount;
            serviceItemCount = serviceController.categoryList![categoryIndex].servicesByCategory!.length> 10 ? 10
                : serviceController.categoryList![categoryIndex].servicesByCategory!.length;

          return Container(
            height: Get.find<LocalizationController>().isLtr ? 320 : 330,
            width: Get.width,
            decoration: BoxDecoration(
              color: Get.isDarkMode ? Theme.of(context).colorScheme.primary.withOpacity(0.1) : Theme.of(context).colorScheme.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            ),
            margin: const EdgeInsets.only(top: Dimensions.paddingSizeTextFieldGap),
            child: Row(
              children: [
                Container(
                  width: 220,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: Get.isDarkMode ? Theme.of(context).colorScheme.primary.withOpacity(0.2) : Theme.of(context).colorScheme.primary.withOpacity(0.03),
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.03),
                        offset: const Offset(1, 0),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          child: CustomImage(
                            image: serviceController.categoryList?[categoryIndex].imageFullPath ?? "",
                            height: 70, width: 70,
                          ),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeDefault,),
                        Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                          child: Text(serviceController.categoryList![categoryIndex].name??"",
                            style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                            maxLines: 2, overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        const SizedBox(),

                        InkWell(
                          onTap: () {
                            Get.toNamed(RouteHelper.getFeatheredCategoryService(
                              serviceController.categoryList?[categoryIndex].name??"", serviceController.categoryList?[categoryIndex].id??""));
                            },
                          child: Padding(
                            padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall, right: Dimensions.paddingSizeDefault, left: Dimensions.paddingSizeDefault ),
                            child: Text('see_all'.tr, style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeDefault,
                              decoration: TextDecoration.underline,
                              color:Get.isDarkMode ?Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(.6) : Theme.of(context).colorScheme.primary,
                            )),
                          ),
                        ),
                      ],),

                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeLarge),
                          itemCount: serviceItemCount,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(
                                right: Get.find<LocalizationController>().isLtr? Dimensions.paddingSizeLarge :0,
                                left: Get.find<LocalizationController>().isLtr? 0 :  Dimensions.paddingSizeLarge,
                              ),
                              child: SizedBox(
                                width: Dimensions.webMaxWidth/5.7 ,
                                child: ServiceWidgetVertical(
                                  service: serviceController.categoryList![categoryIndex].servicesByCategory![index],
                                  fromType: '', signInShakeKey: widget.signInShakeKey,
                              )),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeSmall,),

                    ],
                  ),
                ),
              ],
            ),
          );
        },itemCount: serviceController.categoryList?.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
        ),
      ) : const SizedBox();
    });
  }
}
