import 'package:demandium/components/service_widget_vertical.dart';
import 'package:demandium/components/core_export.dart';
import 'package:get/get.dart';

class FeatheredCategoryView extends StatefulWidget {
  const FeatheredCategoryView({super.key}) ;

  @override
  State<FeatheredCategoryView> createState() => _FeatheredCategoryViewState();
}

class _FeatheredCategoryViewState extends State<FeatheredCategoryView> {

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ServiceController>(builder: (serviceController){

      return serviceController.categoryList == null ? const SizedBox() :

       SizedBox(
        height: serviceController.categoryList!.length * 330,
        child: ListView.builder(itemBuilder: (context,categoryIndex){

          int serviceItemCount;
          serviceItemCount = serviceController.categoryList![categoryIndex].servicesByCategory!.length>5?5
                : serviceController.categoryList![categoryIndex].servicesByCategory!.length;

          return  Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            ),
            margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall,horizontal: Dimensions.paddingSizeDefault),
            child: Column(
              children: [

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall, vertical: Dimensions.paddingSizeExtraSmall),
                  child: TitleWidget(
                    textDecoration: TextDecoration.underline,
                    title: serviceController.categoryList?[categoryIndex].name??"",
                    onTap: () =>  Get.toNamed(RouteHelper.getFeatheredCategoryService(
                        serviceController.categoryList?[categoryIndex].name??"", serviceController.categoryList?[categoryIndex].id ?? ""),
                    ),
                  ),
                ),


                SizedBox(
                  height: 255,
                  width: Get.width,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: serviceItemCount,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                        child: SizedBox(
                           width: ResponsiveHelper.isTab(context) ? 250 : Get.width / 2.3,
                            child: ServiceWidgetVertical(service: serviceController.categoryList![categoryIndex].servicesByCategory![index],
                          fromType: '',
                        )
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeDefault)
              ],
            ),
          );
        },itemCount: serviceController.categoryList?.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
        ),
      );
    });
  }
}
