import 'package:demandium/feature/area/widget/area_map_view.dart';
import 'package:demandium/feature/area/widget/area_top_widget.dart';
import 'package:demandium/feature/area/widget/area_view_widget.dart';
import 'package:get/get.dart';
import 'package:demandium/components/core_export.dart';

class ServiceAreaScreen extends StatefulWidget {
  const ServiceAreaScreen({super.key}) ;

  @override
  State<ServiceAreaScreen> createState() => _ServiceAreaScreenState();
}

class _ServiceAreaScreenState extends State<ServiceAreaScreen> {

  @override
  void initState() {
    super.initState();
    Get.find<ServiceAreaController>().getZoneList(reload: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      endDrawer:ResponsiveHelper.isDesktop(context) ? const MenuDrawer():null,
      appBar: CustomAppBar(centerTitle: false, title: 'our_services_areas'.tr,showCart: false),

      body: GetBuilder<ServiceAreaController>(builder: (serviceAreaController){
        return FooterBaseView(
          child: SizedBox( width: Dimensions.webMaxWidth,
            child: Padding( padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
              child: Column( children: [

                const AreaTopWidget(),

                Row( crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Expanded(child: AreaViewWidget()),

                  ResponsiveHelper.isDesktop(context) && serviceAreaController.zoneList != null  ?
                  Expanded( child: Padding(
                    padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeLarge,Dimensions.paddingSizeLarge,0,0),
                    child: SizedBox(
                      height: Get.height * 0.6,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                        child: AreaMapViewScreen(zoneList: serviceAreaController.zoneList ?? [],),
                      ),
                    ),
                  )) : ResponsiveHelper.isDesktop(context) && serviceAreaController.zoneList == null ?
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeLarge,Dimensions.paddingSizeLarge,0,0),
                      child: SizedBox(
                        height: Get.height * 0.63,
                        width: Dimensions.webMaxWidth/2,
                        child: Shimmer(child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                            color: Theme.of(context).cardColor,
                            boxShadow: Get.isDarkMode?null:[BoxShadow(color: Colors.grey[200]!, blurRadius: 5, spreadRadius: 1)],
                          ),
                        )),
                      ),
                    ),
                  ) :const SizedBox()
                ]),
              ]),
            ),
          ),
        );
      }),


      bottomSheet: !ResponsiveHelper.isDesktop(context) ? SizedBox( height: 80,
        child: Center(
          child: Padding( padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
            child: CustomButton(
              radius: Dimensions.radiusLarge,
              buttonText: 'view_on_map'.tr,
              onPressed: () {
                Get.toNamed(RouteHelper.getServiceAreaMap());
              },
            ),
          ),
        ),
      ) : null,


    );
  }
}
