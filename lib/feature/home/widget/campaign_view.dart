// import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:demandium/components/core_export.dart';

class CampaignView extends StatelessWidget {
  const CampaignView({super.key});


  @override
  Widget build(BuildContext context) {
    return GetBuilder<CampaignController>(
        builder: (campaignController){
          if(campaignController.campaignList != null && campaignController.campaignList!.isEmpty){
            return const SizedBox();
          }else{
            return Container(
                width: MediaQuery.of(context).size.width,
                height: ResponsiveHelper.isTab(context) || MediaQuery.of(context).size.width > 450 ? 350 :MediaQuery.of(context).size.width * 0.40,
                padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
                child: campaignController.campaignList != null ?
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: CarouselSlider.builder(
                        options: CarouselOptions(
                          enableInfiniteScroll: campaignController.campaignList!.length > 1 ? true : false,
                          autoPlay: true,
                          enlargeCenterPage: false,
                          viewportFraction: .94,
                          disableCenter: true,
                          autoPlayInterval: const Duration(seconds: 7),
                          onPageChanged: (index, reason) {
                            campaignController.setCurrentIndex(index, true);
                          },
                        ),
                        itemCount: campaignController.campaignList!.isEmpty ? 1 : campaignController.campaignList!.length,
                        itemBuilder: (context, index, _) {

                          return InkWell(
                            onTap: () {
                              if(isRedundentClick(DateTime.now())){
                                return;
                              }
                              campaignController.navigateFromCampaign(campaignController.campaignList![index].id!,campaignController.campaignList![index].discount!.discountType!);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                  border: Border.all(color: Theme.of(context).hintColor.withOpacity(0.5),width: 0.5),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                  child: GetBuilder<SplashController>(builder: (splashController) {
                                    return CustomImage(
                                      image: campaignController.campaignList![index].coverImageFullPath ?? "",
                                      fit: BoxFit.cover,
                                      placeholder: Images.placeholder,
                                    );
                                  },
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                    campaignController.campaignList!.length > 1 ? Align(
                      alignment: Alignment.center,
                      child: AnimatedSmoothIndicator(
                        activeIndex: campaignController.currentIndex!,
                        count: campaignController.campaignList!.length,
                        effect: ExpandingDotsEffect(
                          dotHeight: 8, dotWidth: 8,
                          activeDotColor: Theme.of(context).colorScheme.primary,
                          dotColor: Theme.of(context).disabledColor,
                        ),
                      ),
                    ) : const SizedBox.shrink(),
                  ],) :
                Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                  child: Shimmer(
                      duration: const Duration(seconds: 2),
                      enabled: true, color: Colors.grey,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                          boxShadow: Get.isDarkMode ? null:[BoxShadow(color: Colors.grey[200]!, blurRadius: 5, spreadRadius: 1)],
                        ),
                      )
                  ),
                ),
            );
          }
        });
  }
}
