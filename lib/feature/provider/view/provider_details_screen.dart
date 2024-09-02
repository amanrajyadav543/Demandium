import 'package:demandium/components/core_export.dart';
import 'package:demandium/feature/provider/model/category_model_item.dart';
import 'package:demandium/feature/provider/widgets/category_item_view.dart';
import 'package:demandium/feature/provider/widgets/provider_details_top_card.dart';
import 'package:demandium/feature/provider/widgets/vertical_scrollable_tabview.dart';
import 'package:get/get.dart';


class ProviderDetailsScreen extends StatefulWidget {
  final String providerId;
  final String subCategories;
  const ProviderDetailsScreen({super.key,required this.providerId, required this.subCategories}) ;


  @override
  ProviderDetailsScreenState createState() => ProviderDetailsScreenState();
}

class ProviderDetailsScreenState extends State<ProviderDetailsScreen> with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    Get.find<ProviderBookingController>().getProviderDetailsData(widget.providerId, true).then((value){
      tabController = TabController(length: Get.find<ProviderBookingController>().categoryItemList.length, vsync: this);
      Get.find<CartController>().updatePreselectedProvider(
          null
      );
    });
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer:ResponsiveHelper.isDesktop(context) ? const MenuDrawer():null,
      appBar: CustomAppBar(title: "provider_details".tr,showCart: true,),
      body: Center(
        child: GetBuilder<ProviderBookingController>(
          builder: (providerBookingController){
            if(providerBookingController.providerDetailsContent!=null){

              if(providerBookingController.categoryItemList.isEmpty){
                return Column(
                  children: [

                    if(providerBookingController.providerDetailsContent?.provider?.serviceAvailability ==0)
                    Container(
                      width: Dimensions.webMaxWidth,
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.error.withOpacity(0.1),
                          border: Border(bottom: BorderSide(color: Theme.of(context).colorScheme.error))
                      ),
                      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault, horizontal: Dimensions.paddingSizeLarge),
                      child: Center(child: Text('provider_is_currently_unavailable'.tr, style: ubuntuMedium,)),
                    ),

                    SizedBox( width: Dimensions.webMaxWidth, child: ProviderDetailsTopCard(isAppbar: false,subcategories: widget.subCategories,providerId: widget.providerId,)),
                    SizedBox(
                      height: Get.height*0.6, width: Dimensions.webMaxWidth,
                      child: Center(child: Text('no_subscribed_subcategories_available'.tr),),
                    ),
                  ],
                );
              }else{
                return SingleChildScrollView(
                  child: Column(
                    children: [

                      if(providerBookingController.providerDetailsContent?.provider?.serviceAvailability ==0)
                      SizedBox(
                        width: Dimensions.webMaxWidth,
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.error.withOpacity(0.1),
                            border: Border(bottom: BorderSide(color: Theme.of(context).colorScheme.error))
                          ),
                          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault, horizontal: Dimensions.paddingSizeLarge),
                          child: Center(child: Text('provider_is_currently_unavailable'.tr, style: ubuntuMedium,)),
                        ),
                      ),

                      SizedBox( height: Get.height * 0.9, width: Dimensions.webMaxWidth,
                        child: VerticalScrollableTabView(
                          tabController: tabController,
                          listItemData: providerBookingController.categoryItemList,
                          verticalScrollPosition: VerticalScrollPosition.begin,
                          eachItemChild: (object, index) => CategorySection(
                            category: object as CategoryModelItem,
                            providerData: providerBookingController.providerDetailsContent?.provider,
                          ),
                          slivers: [
                            SliverAppBar(
                              automaticallyImplyLeading: false,
                              backgroundColor: Get.isDarkMode? null:Theme.of(context).cardColor,
                              pinned: true,
                              leading: const SizedBox(),
                              actions: const [ SizedBox()],
                              flexibleSpace: ProviderDetailsTopCard(subcategories: widget.subCategories,providerId: widget.providerId,),
                              toolbarHeight: 140,
                              elevation: 0,
                              bottom: TabBar(
                                isScrollable: true,
                                controller: tabController,
                                indicatorPadding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 5),
                                indicatorColor: Get.isDarkMode?Colors.white70:Theme.of(context).primaryColor,
                                labelColor: Get.isDarkMode?Colors.white:Theme.of(context).primaryColor,
                                unselectedLabelColor: Colors.grey,
                                padding: const EdgeInsets.only(bottom: 10),
                                indicatorWeight: 3.0,
                                tabs: providerBookingController.categoryItemList.map((e) {
                                  return Tab(text: e.title);
                                }).toList(),
                                onTap: (index) {
                                  VerticalScrollableTabBarStatus.setIndex(index);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      ResponsiveHelper.isDesktop(context)?
                      const FooterView() : const SizedBox()
                    ],
                  ),
                );
              }

            }else{
              return const FooterBaseView(child: WebShadowWrap(child: Center(child: CircularProgressIndicator(),)));
            }
          },
        ),
      ),
    );
  }
}