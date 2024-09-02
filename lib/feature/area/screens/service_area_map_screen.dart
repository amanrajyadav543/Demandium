import 'package:demandium/feature/area/widget/area_map_view.dart';
import 'package:get/get.dart';
import 'package:demandium/components/core_export.dart';

class ServiceAreaMapScreen extends StatefulWidget {
  const ServiceAreaMapScreen({super.key}) ;

  @override
  State<ServiceAreaMapScreen> createState() => _ServiceAreaMapScreenState();
}

class _ServiceAreaMapScreenState extends State<ServiceAreaMapScreen> {
  @override
  void initState() {
    Get.find<ServiceAreaController>().getZoneList(reload: false);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer:ResponsiveHelper.isDesktop(context) ? const MenuDrawer():null,
      appBar: CustomAppBar(centerTitle: false, title: 'our_services_areas'.tr, showCart: false),
      body: GetBuilder<ServiceAreaController>(builder: (serviceAreaController){
        return  serviceAreaController.zoneList != null ? Column(
          children: [
            Expanded(child: AreaMapViewScreen(zoneList: serviceAreaController.zoneList?? [])),
          ],
        ): Center(child: WebShadowWrap(child: SizedBox(height : Get.height * 0.9)));

      }),
    );
  }
}
