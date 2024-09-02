// import 'package:carousel_slider/carousel_slider.dart' as c;
import 'package:get/get.dart';
import 'package:demandium/components/core_export.dart';
import 'package:demandium/feature/home/model/banner_model.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BannerView extends StatelessWidget {
  const BannerView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BannerController>(
      builder: (bannerController) {
        return (bannerController.banners != null && bannerController.banners!.isEmpty) ?
        const SizedBox() :
        Container(width: MediaQuery.of(context).size.width,
          height: ResponsiveHelper.isTab(context) || MediaQuery.of(context).size.width > 450 ? 350 : MediaQuery.of(context).size.width * 0.42,
          padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
          child: bannerController.banners != null ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: CarouselSlider.builder(
                  options: CarouselOptions(
                    enableInfiniteScroll: bannerController.banners!.length > 1,
                    autoPlay: true,
                    enlargeCenterPage: false,
                    viewportFraction: .94,
                    disableCenter: true,
                    autoPlayInterval: const Duration(seconds: 7),
                    onPageChanged: (index, reason) {
                      bannerController.setCurrentIndex(index, true);
                    },
                  ),
                  itemCount: bannerController.banners!.length,
                  itemBuilder: (context, index, _) {
                    BannerModel bannerModel = bannerController.banners![index];
                    return InkWell(
                      onTap: () {
                        String link = bannerModel.redirectLink != null ? bannerModel.redirectLink! : '';
                        String id = bannerModel.category != null ? bannerModel.category!.id! : '';
                        String name = bannerModel.category != null ? bannerModel.category!.name! : "";
                        bannerController.navigateFromBanner(bannerModel.resourceType!, id, link, bannerModel.resourceId != null ? bannerModel.resourceId! : '', categoryName: name);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                            child: CustomImage(
                              image: bannerController.banners?[index].bannerImageFullPath ?? "",
                              fit: BoxFit.cover,
                              placeholder: Images.placeholder,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              bannerController.banners!.length > 1 ? Align(
                alignment: Alignment.center,
                child: AnimatedSmoothIndicator(
                  activeIndex: bannerController.currentIndex!,
                  count: bannerController.banners!.length,
                  effect: ExpandingDotsEffect(
                    dotHeight: 7,
                    dotWidth: 7,
                    spacing: 5,
                    activeDotColor: Theme.of(context).colorScheme.primary,
                    dotColor: Theme.of(context).hintColor.withOpacity(0.6),
                  ),
                ),
              ): const SizedBox(),
            ],
          ) : Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
            child: Column(
              children: [
                Expanded(
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
                const SizedBox(height: Dimensions.paddingSizeSmall),
                Align(
                  alignment: Alignment.center,
                  child: AnimatedSmoothIndicator(
                    activeIndex: 0,
                    count: 3,
                    effect: ExpandingDotsEffect(
                      dotHeight: 7,
                      dotWidth: 7,
                      spacing: 5,
                      activeDotColor: Theme.of(context).hintColor.withOpacity(0.6),
                      dotColor: Theme.of(context).hintColor.withOpacity(0.6),
                    ),
                  ),
                )
              ],
            ),
          )
        );
      },
    );
  }
}
