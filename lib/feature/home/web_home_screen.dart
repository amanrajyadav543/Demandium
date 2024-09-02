import 'package:demandium/components/custom_shaking_widget.dart';
import 'package:demandium/feature/home/widget/explore_provider_card.dart';
import 'package:demandium/feature/home/widget/highlight_provider_widget.dart';
import 'package:get/get.dart';
import 'package:demandium/components/core_export.dart';


class WebHomeScreen extends StatelessWidget {
  final GlobalKey<CustomShakingWidgetState>?  signInShakeKey;
  final ScrollController? scrollController;
  final int availableServiceCount;
  const WebHomeScreen({super.key, required this.scrollController, required this.availableServiceCount, this.signInShakeKey});

  @override
  Widget build(BuildContext context) {

    Get.find<BannerController>().setCurrentIndex(0, false);


    return CustomScrollView(
      controller: scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [

        const SliverToBoxAdapter(child: SizedBox(height: Dimensions.paddingSizeExtraLarge,)),

        SliverToBoxAdapter(child: WebBannerView()),

        (availableServiceCount > 0) ? SliverToBoxAdapter(child: Center(
          child: GetBuilder<ProviderBookingController>(builder: (providerController){
            return GetBuilder<ServiceController>(builder: (serviceController){

              ConfigModel configModel = Get.find<SplashController>().configModel;
              int ? providerBooking = configModel.content?.directProviderBooking;
              int ? biddingStatus = configModel.content?.biddingStatus;
              bool isAvailableProvider = providerController.providerList != null && providerController.providerList!.isNotEmpty;
              bool isAvailableRecommendService = serviceController.recommendedServiceList != null && serviceController.recommendedServiceList!.isNotEmpty;
              double createPostCardHeight =  Get.find<LocalizationController>().isLtr? 235 : 255;
              double recommendedServiceHeight =  Get.find<LocalizationController>().isLtr? 210 : 225;

              return SizedBox( width: Dimensions.webMaxWidth,
                child: Column(children: [

                  const SizedBox(height: Dimensions.paddingSizeLarge),
                  const CategoryView(),

                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const WebHighlightProviderWidget(),
                    Expanded(child: WebPopularServiceView(signInShakeKey : signInShakeKey,)),
                  ],),

                  const SizedBox(height: Dimensions.paddingSizeLarge),
                  const WebCampaignView(),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  Row(children: [
                    Expanded(child: ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      child: RecommendedServiceView(height: recommendedServiceHeight, signInShakeKey: signInShakeKey,),
                    ),),

                    (providerBooking == 1 && (isAvailableProvider || providerController.providerList == null)) && ( isAvailableRecommendService  || ( serviceController.recommendedServiceList == null)) ?
                    const SizedBox(width: Dimensions.paddingSizeLarge+5) : const SizedBox(),

                    (providerBooking == 1 && (isAvailableProvider || providerController.providerList == null)) ? SizedBox(
                      width: isAvailableRecommendService || (serviceController.recommendedServiceList == null) ?
                      Dimensions.webMaxWidth /3.2 : Dimensions.webMaxWidth ,
                      height: recommendedServiceHeight,
                      child: ExploreProviderCard(showShimmer: (serviceController.recommendedServiceList == null)),
                    ) : const SizedBox(),

                  ],),

                  Padding(
                    padding: EdgeInsets.only(top: biddingStatus == 1 || providerBooking == 1 ? Dimensions.paddingSizeTextFieldGap : 0 ),
                    child: Row(children:  [

                      biddingStatus == 1 ? SizedBox(
                        width: (isAvailableProvider || providerController.providerList == null ) && providerBooking == 1 ? Dimensions.webMaxWidth /3.2 : Dimensions.webMaxWidth,
                        height: createPostCardHeight,
                        child: HomeCreatePostView(showShimmer: providerController.providerList == null,),
                      ) : const SizedBox(),

                      providerBooking == 1 && biddingStatus == 1 && (isAvailableProvider || providerController.providerList == null) ?
                      const SizedBox(width: Dimensions.paddingSizeLarge+5) : const SizedBox(),

                       providerBooking == 1 ? Expanded(child: ClipRRect(
                         borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                         child: HomeRecommendProvider(height: createPostCardHeight, signInShakeKey: signInShakeKey,),
                       )) : const SizedBox(),

                    ]),
                  ),

                  WebTrendingServiceView(signInShakeKey: signInShakeKey,),

                  WebRecentlyServiceView(signInShakeKey: signInShakeKey,),

                  WebFeatheredCategoryView(signInShakeKey: signInShakeKey,),


                  const SizedBox(height: Dimensions.paddingSizeTextFieldGap,),
                  (serviceController.allService != null && serviceController.allService!.isNotEmpty) ?   TitleWidget(
                    textDecoration: TextDecoration.underline,
                    title: 'all_service'.tr,
                   // onTap: () => Get.toNamed(RouteHelper.getSearchResultRoute()),
                  ) : const SizedBox.shrink(),
                  const SizedBox(height: Dimensions.paddingSizeDefault,),

                  GetBuilder<ServiceController>(builder: (serviceController) {
                    return PaginatedListView(
                      showBottomSheet: true,
                      scrollController: scrollController!,
                      totalSize: serviceController.serviceContent?.total,
                      offset: serviceController.serviceContent?.currentPage,
                      onPaginate: (int offset) async => await serviceController.getAllServiceList(offset,false),
                      itemView: ServiceViewVertical(
                        signInShakeKey: signInShakeKey,
                        service: serviceController.serviceContent != null ? serviceController.allService : null,
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeExtraSmall : Dimensions.paddingSizeSmall,
                          vertical: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeExtraSmall : 0,
                        ),
                        type: 'others',
                        noDataType: NoDataType.home,
                      ),
                    );
                  }),

                ],),
              );
            });
          }),

        ),) : SliverToBoxAdapter(child: SizedBox( height: MediaQuery.of(context).size.height*.8, child: const ServiceNotAvailableScreen())),

        const SliverToBoxAdapter(child: FooterView(),),

      ],
    );
  }
}
