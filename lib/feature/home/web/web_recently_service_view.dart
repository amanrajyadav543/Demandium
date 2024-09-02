import 'package:demandium/components/custom_shaking_widget.dart';
import 'package:demandium/components/service_widget_vertical.dart';
import 'package:demandium/components/core_export.dart';
import 'package:get/get.dart';

class WebRecentlyServiceView extends StatelessWidget {
  final GlobalKey<CustomShakingWidgetState>?  signInShakeKey;
  const WebRecentlyServiceView({super.key, this.signInShakeKey}) ;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ServiceController>(
        builder: (serviceController){
      if(serviceController.recentlyViewServiceList != null && serviceController.recentlyViewServiceList!.isEmpty){
        return const SizedBox();
      }else{
        if(serviceController.recentlyViewServiceList != null){
          return  Column(
            children: [

              const SizedBox(height: Dimensions.paddingSizeTextFieldGap),
              TitleWidget(
                textDecoration: TextDecoration.underline,
                title: 'recently_view_services'.tr,
                onTap: () => Get.toNamed(RouteHelper.allServiceScreenRoute("recently_view_services")),
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault,),

              GridView.builder(
                key: UniqueKey(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: Dimensions.paddingSizeLarge,
                  mainAxisSpacing:  Dimensions.paddingSizeLarge,
                  mainAxisExtent: ResponsiveHelper.isMobile(context) ?  240 : 270 ,
                  crossAxisCount: ResponsiveHelper.isMobile(context) ? 2 : ResponsiveHelper.isTab(context) ? 3 : 5,
                ),
                physics:const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: serviceController.recentlyViewServiceList!.length>5?5:serviceController.recentlyViewServiceList!.length,
                itemBuilder: (context, index) {
                  return ServiceWidgetVertical(service: serviceController.recentlyViewServiceList![index],fromType: '', signInShakeKey: signInShakeKey,);
                },
              ),

            ],
          );
        }
        else{
          return const SizedBox();
        }
      }
    });
  }
}
