// import 'package:carousel_slider/carousel_slider.dart';
import 'package:chewie/chewie.dart';
import 'package:demandium/components/core_export.dart';
import 'package:demandium/components/favorite_icon_widget.dart';
import 'package:demandium/feature/home/controller/advertisement_controller.dart';
import 'package:demandium/feature/home/model/advertisement_model.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:video_player/video_player.dart';

class HighlightProviderWidget extends StatelessWidget {
  const HighlightProviderWidget({super.key});

  @override
  Widget build(BuildContext context) {

    return GetBuilder<AdvertisementController>(builder: (advertisementController){
      return advertisementController.advertisementList != null &&  advertisementController.advertisementList!.isNotEmpty ? Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          color: Theme.of(context).colorScheme.primary.withOpacity(Get.isDarkMode ? 0.2 : 0.1),
        ),
        child: Stack( alignment: Get.find<LocalizationController>().isLtr ? Alignment.topRight : Alignment.topLeft,children: [
          Padding(padding: const EdgeInsets.symmetric(vertical : Dimensions.paddingSizeDefault),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [

              const SizedBox(height: Dimensions.paddingSizeDefault,),
              Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                child: Text('highlight_for_you'.tr, style: ubuntuBold.copyWith(
                  fontSize: Dimensions.fontSizeLarge,
                ),),
              ),

              const SizedBox(height: Dimensions.paddingSizeSmall,),
              Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                child: Text('see_our_most_popular_providers_and_service'.tr, style: ubuntuRegular.copyWith(
                    fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor
                ),),
              ),

             const SizedBox(height: Dimensions.paddingSizeDefault ,),

              CarouselSlider.builder(
                options: CarouselOptions(
                  enableInfiniteScroll:advertisementController.advertisementList!.length > 1,
                  autoPlay: advertisementController.autoPlay,
                  enlargeCenterPage: false,
                  aspectRatio: MediaQuery.of(context).size.width < 400 ? 10.5 / 9 : ResponsiveHelper.isTab(context) ? 13/9 : 11 / 9,
                  viewportFraction: 1,
                  disableCenter: true,
                  onPageChanged: (index, reason) {

                    advertisementController.setCurrentIndex(index, true);

                    if(advertisementController.advertisementList?[index].type == "video_promotion"){
                      advertisementController.updateAutoPlayStatus(status: false);
                    }else{
                      advertisementController.updateAutoPlayStatus(status: true);
                    }
                  },
                ),
                itemCount: advertisementController.advertisementList?.length,
                itemBuilder: (context, index, _) {
                  return  advertisementController.advertisementList?[index].type == "video_promotion" ? AdvertisementVideoPromotionWidget(
                    advertisement :advertisementController.advertisementList![index],
                  ) : AdvertisementProfilePromotionWidget(advertisement : advertisementController.advertisementList![index],index: index,);
                },
              ),

              const AdvertisementIndicator(),

              const SizedBox(height: Dimensions.paddingSizeExtraSmall,),

            ],),
          ),

          Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
            child: Image.asset(Images.highlightProvider, width: 50,),
          ),
        ],),
      ): advertisementController.advertisementList == null ?
      const AdvertisementShimmer() : const SizedBox();
    });
  }
}

class WebHighlightProviderWidget extends StatelessWidget {
  const WebHighlightProviderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdvertisementController>(builder: (advertisementController){
      return advertisementController.advertisementList != null &&  advertisementController.advertisementList!.isNotEmpty ? Expanded(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            color: Theme.of(context).colorScheme.primary.withOpacity(Get.isDarkMode ? 0.2 : 0.1),
          ),
          margin:  EdgeInsets.only(top:  Dimensions.paddingSizeLarge * 1.5,
            right: Get.find<LocalizationController>().isLtr? Dimensions.paddingSizeLarge : 0,
            left: Get.find<LocalizationController>().isLtr? 0: Dimensions.paddingSizeLarge,
          ),
          child: Stack(alignment: Get.find<LocalizationController>().isLtr ? Alignment.topRight : Alignment.topLeft, children: [
            Padding(padding: const EdgeInsets.symmetric(vertical : Dimensions.paddingSizeDefault),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [

                const SizedBox(height: Dimensions.paddingSizeEight,),
                Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                  child: Text('highlight_for_you'.tr, style: ubuntuBold.copyWith(
                    fontSize: Dimensions.fontSizeLarge,
                  ),),
                ),

                const SizedBox(height: Dimensions.paddingSizeSmall,),
                Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                  child: Text('see_our_most_popular_providers_and_service'.tr, style: ubuntuRegular.copyWith(
                      fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor
                  ),),
                ),

                const SizedBox(height: Dimensions.paddingSizeDefault * 1.5  ,),

                CarouselSlider.builder(
                  options: CarouselOptions(
                    enableInfiniteScroll:advertisementController.advertisementList!.length > 1,
                    autoPlay: advertisementController.autoPlay,
                    enlargeCenterPage: false,
                    aspectRatio: 12/9,
                    viewportFraction: 1,
                    disableCenter: true,
                    onPageChanged: (index, reason) {

                      if(advertisementController.advertisementList?[index].type == "video_promotion"){
                        advertisementController.updateAutoPlayStatus(status: false);
                      }else{
                        advertisementController.updateAutoPlayStatus(status: true);
                      }
                      advertisementController.setCurrentIndex(index, true);
                    },
                  ),
                  itemCount: advertisementController.advertisementList?.length,
                  itemBuilder: (context, index, _) {
                    return  advertisementController.advertisementList?[index].type == "video_promotion" ? AdvertisementVideoPromotionWidget(
                      advertisement :advertisementController.advertisementList![index],
                    ) : AdvertisementProfilePromotionWidget(advertisement : advertisementController.advertisementList![index], index: index,);
                  },
                ),

                const AdvertisementIndicator(),


              ],),
            ),

            Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
              child: Image.asset(Images.highlightProvider, width: 50,),
            ),
          ],),
        ),
      ): advertisementController.advertisementList == null ?
      const Expanded(child: Center(child: AdvertisementShimmer(),)) : const SizedBox();
    });
  }
}


class AdvertisementVideoPromotionWidget extends StatefulWidget {
  final Advertisement advertisement;
  const AdvertisementVideoPromotionWidget({super.key, required this.advertisement});

  @override
  State<AdvertisementVideoPromotionWidget> createState() => _AdvertisementVideoPromotionWidgetState();
}

class _AdvertisementVideoPromotionWidgetState extends State<AdvertisementVideoPromotionWidget> {


  late VideoPlayerController videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    initializePlayer();
    videoPlayerController.addListener(() {

      if(videoPlayerController.value.duration == videoPlayerController.value.position ){
        Get.find<AdvertisementController>().updateAutoPlayStatus(status:  true, shouldUpdate: true);
      }
    });
  }

  Future<void> initializePlayer() async {
    videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(
        widget.advertisement.promotionalVideoFullPath ?? ""
    ));

    await Future.wait([
      videoPlayerController.initialize(),

    ]);
    _createChewieController();
    setState(() {});
  }

  void _createChewieController() {

    _chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: true,
      aspectRatio: videoPlayerController.value.aspectRatio,
    );
    _chewieController?.setVolume(0);
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {

    List<String> subcategory=[];
    widget.advertisement.providerData?.subscribedServices?.forEach((element) {
      if(element.subCategory!=null){
        subcategory.add(element.subCategory?.name??"");
      }
    });

    String subcategories = subcategory.toString().replaceAll('[', '');
    subcategories = subcategories.replaceAll(']', '');
    subcategories = subcategories.replaceAll('&', ' and ');

    return Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
      child: Column(
        children: [
          Center(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(Dimensions.radiusLarge),
                topRight : Radius.circular(Dimensions.radiusLarge),
              ),
              child: AspectRatio(
                aspectRatio:  16/9,
                child: Stack(
                  alignment: Alignment.center,
                  children: [

                    Positioned.fill(child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Get.isDarkMode ? Colors.grey.shade700 : Colors.white, // Color at the beginning
                          Get.isDarkMode ? Theme.of(context).cardColor : Colors.cyan.shade50, // Color in the middle
                          Get.isDarkMode ? Colors.grey.shade800 : Colors.white,
                        ]),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(Dimensions.radiusLarge),
                          topRight : Radius.circular(Dimensions.radiusLarge),
                        ),
                      ),

                    )),
                    _chewieController !=null &&  _chewieController!.videoPlayerController.value.isInitialized ?
                    Stack(
                      children: [
                        Chewie(controller: _chewieController!),
                      ],
                    ) : const CircularProgressIndicator(),

                  ],
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(Dimensions.radiusLarge),
                bottomRight: Radius.circular(Dimensions.radiusLarge),
              ),
              color: Theme.of(context).cardColor,
              boxShadow: Get.find<ThemeController>().darkTheme ? null : cardShadow,
            ),
            height: ResponsiveHelper.isDesktop(context) ? 110 : 100,
            padding: const EdgeInsets.symmetric( horizontal : Dimensions.paddingSizeLarge),
            child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [
              Row( children: [

                Expanded(
                  child: Column( crossAxisAlignment: CrossAxisAlignment.start, children: [

                    Text(widget.advertisement.title ?? "",
                      style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeLarge),
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: Dimensions.paddingSizeSmall,),
                    Text(
                      widget.advertisement.description ?? "",
                      style: ubuntuRegular.copyWith(
                          color: Theme.of(context).hintColor
                      ),
                      maxLines: 2, overflow: TextOverflow.ellipsis,
                    ),
                  ]),
                ),

                const SizedBox(width: Dimensions.paddingSizeLarge,),

                InkWell(
                  onTap: () => Get.toNamed(RouteHelper.getProviderDetails( widget.advertisement.providerId! , subcategories)),
                  child: Container(
                    margin: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall),
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall + 5, vertical: Dimensions.paddingSizeSmall),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    child:  Icon(Icons.arrow_forward_rounded, size: 20, color: Colors.white.withOpacity(0.8),),
                  ),
                )
              ],)
            ],),
          )
        ],
      ),
    );
  }
}

class AdvertisementProfilePromotionWidget extends StatelessWidget {
  final Advertisement advertisement;
  final int index;
  const AdvertisementProfilePromotionWidget({super.key, required this.advertisement, required this.index});

  @override
  Widget build(BuildContext context) {

    List<String> subcategory=[];
    advertisement.providerData?.subscribedServices?.forEach((element) {
      if(element.subCategory!=null){
        subcategory.add(element.subCategory?.name??"");
      }
    });

    String subcategories = subcategory.toString().replaceAll('[', '');
    subcategories = subcategories.replaceAll(']', '');
    subcategories = subcategories.replaceAll('&', ' and ');


    return Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
      child: GetBuilder<AdvertisementController>(builder: (advertisementController){

        return InkWell(
          onTap: () => Get.toNamed(RouteHelper.getProviderDetails(advertisement.providerId!, subcategories)),
          child: Stack(children: [
            Column(
              children: [
                AspectRatio(
                  aspectRatio: 16/9,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(Dimensions.radiusLarge),
                      topRight: Radius.circular(Dimensions.radiusLarge),
                    ),
                    child: CustomImage(
                      height: double.infinity, width: double.infinity,
                      image:  advertisement.providerCoverImageFullPath ?? "",
                    ),
                  ),
                ),
                Container(
                  height: ResponsiveHelper.isDesktop(context) ? 110 : 100,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(Dimensions.radiusLarge),
                      bottomRight: Radius.circular(Dimensions.radiusLarge),
                    ),
                    color: Theme.of(context).cardColor,
                    boxShadow: Get.find<ThemeController>().darkTheme ? null : cardShadow,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                  child: Row( children: [

                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: CustomImage(
                        image:  advertisement.providerProfileImageFullPath ??"",
                        height: 60, width: 60,
                      ),
                    ),

                    const SizedBox(width: Dimensions.paddingSizeDefault,),

                    Expanded(
                      child: Column( crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.center, children: [

                        Text(advertisement.title ?? "",
                          style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeLarge),
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: 2,),
                        Text(advertisement.description ?? "",
                          style: ubuntuRegular.copyWith(
                            color: Theme.of(context).hintColor,fontSize: Dimensions.fontSizeSmall,
                          ),
                          maxLines: 2, overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: 2,),
                        Row(children: [
                          Row(
                            children: [
                              Icon(Icons.star, color: Theme.of(context).colorScheme.primary, size: Dimensions.fontSizeDefault),
                              Gaps.horizontalGapOf(5),
                              Directionality(
                                textDirection: TextDirection.ltr,
                                child: Text(
                                  "${advertisement.providerData?.avgRating?.toStringAsFixed(1)}",
                                  style: ubuntuRegular.copyWith(color: Theme.of(context).hintColor,fontSize: Dimensions.fontSizeSmall),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 1,height: 10,
                            margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor.withOpacity(0.5),
                            ),
                          ),
                          Text('${advertisement.providerData?.ratingCount} ${'reviews'.tr}', style: ubuntuRegular.copyWith(
                              color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall
                          ),),
                        ],)
                      ]),
                    ),

                    const SizedBox(width: Dimensions.paddingSizeLarge,),

                    Align(
                      alignment: favButtonAlignment(),
                      child: FavoriteIconWidget(
                        value: advertisement.providerData?.isFavorite,
                        onTap: null
                      ),
                    ),
                  ],),
                )
              ],
            ),
          ],
          ),
        );
      }),
    );
  }
}


class AdvertisementShimmer extends StatelessWidget {
  const AdvertisementShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          color: Theme.of(context).cardColor ,
          boxShadow: Get.isDarkMode ? null : [BoxShadow(color: Colors.grey[300]!, blurRadius: 10, spreadRadius: 1)],
        ),
        margin:  EdgeInsets.only(
          top: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeLarge * 3.5 : 0 ,
          right: Get.find<LocalizationController>().isLtr && ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeLarge : 0,
          left: !Get.find<LocalizationController>().isLtr && ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeLarge : 0,
        ),
        child: Padding( padding : const EdgeInsets.symmetric(vertical : Dimensions.paddingSizeDefault),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: Dimensions.paddingSizeLarge,),

              Container(height: 20, width: 200,
                margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).shadowColor
              ),),

              const SizedBox(height: Dimensions.paddingSizeSmall,),

              Container(height: 15, width: 250,
                margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).shadowColor,
              ),),

              const SizedBox(height: Dimensions.paddingSizeDefault * 2,),

              Stack(
                clipBehavior: Clip.none,
                children: [
                  Padding(padding: const EdgeInsets.only(bottom: 0, left: 10, right: 10),
                    child: AspectRatio(
                      aspectRatio: 16/9,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                          color: Theme.of(context).shadowColor,
                          border: Border.all(color: Theme.of(context).hintColor.withOpacity(0.2),),
                        ),
                        padding: const EdgeInsets.only(bottom: 25),
                        child: const Center(child: Icon(Icons.play_circle, color: Colors.white,size: 45,),),
                      ),
                    ),
                  ),

                  Positioned( bottom: -20,left: 0,right: 0, child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                      color: Theme.of(context).cardColor,
                      boxShadow: Get.find<ThemeController>().darkTheme ? null : cardShadow,
                      border: Border.all(color: Theme.of(context).shadowColor)
                    ),
                    padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                    margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                    child: Column(children: [
                      Row( children: [

                        Expanded(
                          child: Column( crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Container(
                              height: 17, width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                color: Theme.of(context).shadowColor,
                              ),
                            ),

                            const SizedBox(height: Dimensions.paddingSizeSmall,),
                            Container(
                              height: 17, width: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                color: Theme.of(context).shadowColor,
                              ),
                            ),

                            const SizedBox(height: Dimensions.paddingSizeExtraSmall,),

                            Container(
                              height: 17, width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                color: Theme.of(context).shadowColor,
                              ),
                            )
                          ]),
                        ),

                        const SizedBox(width: Dimensions.paddingSizeLarge,),

                        InkWell(
                          onTap: () => Get.back(),
                          child: Container(
                            margin: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall),
                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall + 5, vertical: Dimensions.paddingSizeSmall),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                              color: Theme.of(context).shadowColor,
                            ),
                            child:  Icon(Icons.arrow_forward_rounded, size: 20, color: Colors.white.withOpacity(0.8),),
                          ),
                        )
                      ],)
                    ],),
                  ))
                ],
              ),

              const SizedBox(height: Dimensions.paddingSizeLarge * 2,),

              Align(
                alignment: Alignment.center,
                child: AnimatedSmoothIndicator(
                  activeIndex: 0,
                  count: 3,
                  effect: ExpandingDotsEffect(
                    dotHeight: 7,
                    dotWidth: 7,
                    spacing: 5,
                    activeDotColor: Theme.of(context).disabledColor,
                    dotColor: Theme.of(context).hintColor.withOpacity(0.6),
                  ),
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall,),
            ],
          ),
        ),
      ),
    );
  }
}

class AdvertisementIndicator extends StatelessWidget {
  const AdvertisementIndicator({super.key});

  @override
  Widget build(BuildContext context) {

    return GetBuilder<AdvertisementController>(
      builder: (advertisementController) {
        return advertisementController.advertisementList != null && advertisementController.advertisementList!.length > 2?
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(height: 7, width: 7,
            decoration:  BoxDecoration(color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center,
            children: advertisementController.advertisementList!.map((advertisement) {
              int index = advertisementController.advertisementList!.indexOf(advertisement);
              return index == advertisementController.currentIndex ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 3),
                margin: const EdgeInsets.symmetric(horizontal: 6.0),
                decoration: BoxDecoration(
                    color:  Theme.of(context).primaryColor ,
                    borderRadius: BorderRadius.circular(50)),
                child:  Text("${index+1}/ ${advertisementController.advertisementList!.length}",
                  style: const TextStyle(color: Colors.white,fontSize: 12),),
              ):const SizedBox();
            }).toList(),
          ),
          Container(height: 7, width: 7,

            decoration:  BoxDecoration(color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
          )
        ],
        ): advertisementController.advertisementList != null && advertisementController.advertisementList!.length == 2 ?
        Align(
          alignment: Alignment.center,
          child: AnimatedSmoothIndicator(
            activeIndex: advertisementController.currentIndex,
            count: advertisementController.advertisementList!.length,
            effect: ExpandingDotsEffect(
              dotHeight: 7,
              dotWidth: 7,
              spacing: 5,
              activeDotColor: Theme.of(context).colorScheme.primary,
              dotColor: Theme.of(context).hintColor.withOpacity(0.6),
            ),
          ),
        ): const SizedBox();
      }
    );
  }
}


