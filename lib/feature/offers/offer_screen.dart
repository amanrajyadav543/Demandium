import 'package:get/get.dart';
import 'package:demandium/components/core_export.dart';

class OfferScreen extends StatefulWidget {
  const OfferScreen({super.key}) ;
  @override
  State<OfferScreen> createState() => _OfferScreenState();
}
class _OfferScreenState extends State<OfferScreen> {

  @override
  void initState() {
    super.initState();
    Get.find<ServiceController>().getOffersList(1,true);
  }
  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    return Scaffold(
      endDrawer:ResponsiveHelper.isDesktop(context) ? const MenuDrawer():null,
      appBar: CustomAppBar(
        isBackButtonExist: false,
        title: 'offers'.tr,
      ),
      body: GetBuilder<ServiceController>(
        builder: (serviceController){
          return Stack(
            children: [

              FooterBaseView(
                scrollController: scrollController,
                bottomPadding: false,
                child: SizedBox(
                  width: Dimensions.webMaxWidth,
                  child: Column(
                    children: [
                      !ResponsiveHelper.isMobile(context) && serviceController.offerBasedServiceList !=null && serviceController.offerBasedServiceList!.isNotEmpty ? Padding(
                        padding: EdgeInsets.fromLTRB(
                          Dimensions.paddingSizeDefault,
                          Dimensions.fontSizeDefault,
                          Dimensions.paddingSizeDefault,
                          Dimensions.paddingSizeSmall,
                        ),
                        child: TitleWidget(
                          title: 'current_offers'.tr,
                        ),
                      ):const SizedBox.shrink(),
                      ResponsiveHelper.isMobile(context)?const SizedBox(height: 120,) : const SizedBox(height: Dimensions.paddingSizeDefault,),
                      PaginatedListView(
                        scrollController: scrollController,
                        totalSize: serviceController.offerBasedServiceContent?.total,
                        offset: serviceController.offerBasedServiceContent?.currentPage ,
                        onPaginate: (int offset) async => await serviceController.getOffersList(offset, false),
                        itemView: ServiceViewVertical(
                          service: serviceController.offerBasedServiceList,
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeExtraSmall : Dimensions.paddingSizeDefault,
                            vertical: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeExtraSmall : 0,
                          ),
                          type: 'others',
                          noDataType: NoDataType.offers,
                        ),
                      ),
                    ],
                  ),
                )
              ),

              ResponsiveHelper.isMobile(context) ?
              Align(alignment: Alignment.topCenter, child: Stack(
                children: [
                  Container(
                    height: 120, width: MediaQuery.of(context).size.width,
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  Image.asset(Images.offerBanner, width: Get.width, fit: BoxFit.cover, height: 100,),
                  Container(
                    color: Colors.black54, height: 100,
                    child: Center(
                      child: Text('current_offers'.tr,style: ubuntuMedium.copyWith(color: Colors.white,
                        fontSize: Dimensions.fontSizeExtraLarge,
                      )),
                    ),
                  )
                ],
              )) : const SizedBox.shrink(),
            ],
          );
        },
      ),
    );
  }
}