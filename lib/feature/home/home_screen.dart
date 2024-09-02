
import 'package:demandium/components/custom_shaking_widget.dart';
import 'package:demandium/feature/home/controller/advertisement_controller.dart';
import 'package:demandium/feature/home/widget/explore_provider_card.dart';
import 'package:demandium/feature/home/widget/highlight_provider_widget.dart';
import 'package:get/get.dart';
import 'package:demandium/components/core_export.dart';


class HomeScreen extends StatefulWidget {
  static Future<void> loadData(bool reload, {int availableServiceCount = 1}) async {

    if(availableServiceCount==0){
      Get.find<BannerController>().getBannerList(reload);
    }else{
      Get.find<ServiceController>().getRecommendedSearchList();
      Get.find<ServiceController>().getAllServiceList(1,reload);
      Get.find<BannerController>().getBannerList(reload);
      Get.find<AdvertisementController>().getAdvertisementList(reload);
      Get.find<CategoryController>().getCategoryList(1,reload);
      Get.find<ServiceController>().getPopularServiceList(1,reload);
      Get.find<ServiceController>().getTrendingServiceList(1,reload);
      Get.find<ProviderBookingController>().getProviderList(1,reload);
      Get.find<CampaignController>().getCampaignList(reload);
      Get.find<ServiceController>().getRecommendedServiceList(1, reload);
      Get.find<CheckOutController>().getOfflinePaymentMethod(false);
      if(Get.find<AuthController>().isLoggedIn()){
        Get.find<ServiceController>().getRecentlyViewedServiceList(1,reload);
      }
      Get.find<ServiceController>().getFeatherCategoryList(reload);
      Get.find<ServiceAreaController>().getZoneList(reload: reload);
      Get.find<WebLandingController>().getWebLandingContent();
      Get.find<ServiceController>().getRecommendedSearchList();
    }
  }
  final AddressModel? addressModel;
  final bool showServiceNotAvailableDialog;
  const HomeScreen({super.key, this.addressModel, required this.showServiceNotAvailableDialog}) ;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AddressModel? _previousAddress;
  int availableServiceCount = 0;

  @override
  void initState() {
    super.initState();

    Get.find<LocalizationController>().filterLanguage(shouldUpdate: false);
    if(Get.find<AuthController>().isLoggedIn()) {
      Get.find<UserController>().getUserInfo();
      Get.find<LocationController>().getAddressList();
    }
    if(Get.find<LocationController>().getUserAddress() !=null){
      availableServiceCount = Get.find<LocationController>().getUserAddress()!.availableServiceCountInZone!;
    }
    HomeScreen.loadData(false, availableServiceCount: availableServiceCount);

    _previousAddress = widget.addressModel;

    if (_previousAddress != null && availableServiceCount == 0 && widget.showServiceNotAvailableDialog) {
      Future.delayed(const Duration(microseconds: 1000), () {
        Get.dialog(
          ServiceNotAvailableDialog(
            address: _previousAddress,
            forCard: false,
            showButton: true,
            onBackPressed: () {
              Get.back();
              Get.find<LocationController>().setZoneContinue('false');
            },
          )
        );
      });
    }
  }

  homeAppBar({GlobalKey<CustomShakingWidgetState>? signInShakeKey}){
    if(ResponsiveHelper.isDesktop(context)){
      return WebMenuBar(signInShakeKey: signInShakeKey,);
    }else{
      return const AddressAppBar(backButton: false);
    }
  }
  final ScrollController scrollController = ScrollController();
  final signInShakeKey = GlobalKey<CustomShakingWidgetState>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: homeAppBar(signInShakeKey: signInShakeKey),
      endDrawer:ResponsiveHelper.isDesktop(context) ? const MenuDrawer() : null,
      body: ResponsiveHelper.isDesktop(context) ? WebHomeScreen(scrollController: scrollController, availableServiceCount: availableServiceCount, signInShakeKey : signInShakeKey,) : SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {

            if(availableServiceCount > 0){
              await Get.find<ServiceController>().getAllServiceList(1,true);
              await Get.find<BannerController>().getBannerList(true);
              await  Get.find<AdvertisementController>().getAdvertisementList(true);
              await Get.find<CategoryController>().getCategoryList(1,true);
              await Get.find<ServiceController>().getRecommendedServiceList(1,true);
              await Get.find<ProviderBookingController>().getProviderList(1, true);
              await Get.find<ServiceController>().getPopularServiceList(1,true,);
              await Get.find<ServiceController>().getRecentlyViewedServiceList(1,true,);
              await Get.find<ServiceController>().getTrendingServiceList(1,true,);
              await Get.find<CampaignController>().getCampaignList(true);
              await Get.find<ServiceController>().getFeatherCategoryList(true);
              await Get.find<CartController>().getCartListFromServer();
            }else{
              await Get.find<BannerController>().getBannerList(true);
            }

            Get.find<ProviderBookingController>().resetProviderFilterData();

          },
          child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: GetBuilder<SplashController>(builder: (splashController){
              return GetBuilder<ProviderBookingController>(builder: (providerController){
                return GetBuilder<ServiceController>(builder: (serviceController){

                  bool isAvailableProvider = providerController.providerList != null && providerController.providerList!.isNotEmpty;
                  int ? providerBooking = splashController.configModel.content?.directProviderBooking;

                  return  CustomScrollView(
                    controller: scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [

                      const SliverToBoxAdapter(child: SizedBox(height: Dimensions.paddingSizeSmall)),

                      const HomeSearchWidget(),

                      SliverToBoxAdapter(
                        child: Center(child: SizedBox(width: Dimensions.webMaxWidth, child: Column(children: [

                          const BannerView(),
                          availableServiceCount > 0 ? Column(children: [
                            const Padding(padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                              child: CategoryView(),
                            ),

                            const Padding(padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                              child: HighlightProviderWidget(),
                            ),

                            const SizedBox(height: Dimensions.paddingSizeLarge),
                            HorizontalScrollServiceView(fromPage: 'popular_services',serviceList: serviceController.popularServiceList),

                            const RandomCampaignView(),

                            const SizedBox(height: Dimensions.paddingSizeLarge),
                            const RecommendedServiceView(height: 215,),


                            (providerBooking == 1 && (isAvailableProvider || providerController.providerList == null)) ?
                            Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeLarge),
                              child: SizedBox(
                                height: 180,
                                child: ExploreProviderCard(showShimmer: providerController.providerList == null,),
                              ),
                            ) : const SizedBox(),

                            if(Get.find<SplashController>().configModel.content?.directProviderBooking==1)
                              const HomeRecommendProvider(height: 235,),

                            if(Get.find<SplashController>().configModel.content?.biddingStatus == 1)
                              (serviceController.allService != null && serviceController.allService!.isNotEmpty) ?
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeLarge),
                                child: HomeCreatePostView(showShimmer: false,),
                              ) : const SizedBox(),


                            if(Get.find<AuthController>().isLoggedIn())
                              HorizontalScrollServiceView(fromPage: 'recently_view_services',serviceList: serviceController.recentlyViewServiceList),
                            const CampaignView(),
                            HorizontalScrollServiceView(fromPage: 'trending_services',serviceList: serviceController.trendingServiceList),

                            const FeatheredCategoryView(),

                            (serviceController.allService != null && serviceController.allService!.isNotEmpty) ? (ResponsiveHelper.isMobile(context) || ResponsiveHelper.isTab(context))?  Padding(
                              padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, 15, Dimensions.paddingSizeDefault,  Dimensions.paddingSizeSmall,),
                              child: TitleWidget(
                                textDecoration: TextDecoration.underline,
                                title: 'all_service'.tr,
                                onTap: () => Get.toNamed(RouteHelper.getSearchResultRoute()),
                              ),
                            ) : const SizedBox.shrink() : const SizedBox.shrink(),

                            PaginatedListView(
                              scrollController: scrollController,
                              totalSize: serviceController.serviceContent?.total ,
                              offset:  serviceController.serviceContent?.currentPage ,
                              onPaginate: (int offset) async => await serviceController.getAllServiceList(offset, false),
                              showBottomSheet: true,
                              itemView: ServiceViewVertical(
                                service: serviceController.serviceContent != null ? serviceController.allService : null,
                                padding: EdgeInsets.symmetric(
                                  horizontal: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeExtraSmall : Dimensions.paddingSizeDefault,
                                  vertical: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeExtraSmall : 0,
                                ),
                                type: 'others',
                                noDataType: NoDataType.home,
                              ),
                            ),
                          ],) : SizedBox( height: MediaQuery.of(context).size.height *.6, child: const ServiceNotAvailableScreen())

                        ]))),
                      ),
                    ],
                  );
                });
              });
            })
          ),
        ),
      ),
    );
  }
}

