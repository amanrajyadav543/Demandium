import 'package:demandium/components/core_export.dart';
import 'package:get/get.dart';


class ServiceDetailsShimmerWidget extends StatelessWidget {
  const ServiceDetailsShimmerWidget({super.key}) ;

  @override
  Widget build(BuildContext context) {
    return FooterBaseView(
      child: SizedBox(
        width: Dimensions.webMaxWidth,
        child: Column(
          children: [
            if(!ResponsiveHelper.isMobile(context) && !ResponsiveHelper.isTab(context))
              const SizedBox(height: Dimensions.paddingSizeDefault,),
            Stack(
              children: [
                Shimmer(
                  child: Column(
                    children: [
                      Stack(
                        children: [

                          Container(
                            width: Dimensions.webMaxWidth,
                            height: ResponsiveHelper.isDesktop(context) ? 280:150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                              color: Get.isDarkMode ? Theme.of(context).cardColor :Theme.of(context).shadowColor ,
                              boxShadow: Get.find<ThemeController>().darkTheme ? null : cardShadow,
                            ),
                          ),
                          SizedBox(
                            width: Dimensions.webMaxWidth,
                            height: ResponsiveHelper.isDesktop(context) ? 260:120,
                            child: Center(child: Container(height: 20, width: 150, decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                              color: Theme.of(context).shadowColor,
                            ),)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 120,)
                    ],
                  ),
                ),
                Positioned(bottom: 20, left: Dimensions.paddingSizeSmall, right: Dimensions.paddingSizeSmall,
                  child: Shimmer(
                    color: Colors.grey,
                    child: Container(
                      height: 150, width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor, boxShadow: Get.find<ThemeController>().darkTheme ? null : cardShadow,
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        border: Border.all(color: Get.isDarkMode? Colors.grey.shade700 : Colors.grey.shade300)
                      ),
                      child: Row(crossAxisAlignment: CrossAxisAlignment.center ,children: [

                        Container(height: 130, width: 130,
                          margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                            color: Theme.of(context).shadowColor,
                          ),
                        ),
                        Padding( padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start ,mainAxisAlignment: MainAxisAlignment.start,children: [
                            Container(height: 20, width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                color: Theme.of(context).shadowColor,
                              ),
                            ),
                            const SizedBox(height: Dimensions.paddingSizeDefault,),

                            Container( height: 16, width: Get.width * 0.4,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                color: Theme.of(context).shadowColor,
                              ),
                            ),

                            const SizedBox(height: Dimensions.paddingSizeExtraSmall,),

                            Container( height: 16, width: Get.width * 0.4,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                color: Theme.of(context).shadowColor,
                              ),
                            ),
                          ],),
                        )

                      ],),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: Dimensions.paddingSizeExtraSmall,),

            Shimmer(
              child: Row(children: [

                const Expanded(child: SizedBox()),

                Expanded(
                  child: Container(
                    height: 35,
                    decoration: BoxDecoration(
                      color: Get.isDarkMode ? Theme.of(context).cardColor : Theme.of(context).shadowColor,
                      borderRadius:  BorderRadius.circular(Dimensions.radiusDefault),
                    ),
                  ),
                ),

                const SizedBox(width: Dimensions.paddingSizeLarge,),

                Expanded(
                  child: Container(
                    height: 35,
                    decoration: BoxDecoration(
                      color: Get.isDarkMode ? Theme.of(context).cardColor : Theme.of(context).shadowColor,
                      borderRadius:  BorderRadius.circular(Dimensions.radiusDefault),
                    ),
                  ),
                ),

                const SizedBox(width: Dimensions.paddingSizeLarge,),

                Expanded(
                  child: Container(
                    height: 35,
                    decoration: BoxDecoration(
                      color: Get.isDarkMode ? Theme.of(context).cardColor : Theme.of(context).shadowColor,
                      borderRadius:  BorderRadius.circular(Dimensions.radiusDefault),
                    ),
                  ),
                ),

                const Expanded(child: SizedBox()),

              ],),
            ),

            const SizedBox(height: Dimensions.paddingSizeLarge,),

            ListView.builder(itemBuilder: (context,index){
              return Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeLarge, horizontal: Dimensions.paddingSizeDefault),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [

                        Container(
                          height: 20, width: 20,
                          decoration: BoxDecoration(
                            color: Get.isDarkMode ? Theme.of(context).cardColor : Theme.of(context).shadowColor,
                            shape: BoxShape.circle
                          ),
                        ),

                        const SizedBox(width: Dimensions.paddingSizeSmall,),
                        Container(
                          height: 20, width: Get.width * 0.3,
                          decoration: BoxDecoration(
                            color: Get.isDarkMode ? Theme.of(context).cardColor : Theme.of(context).shadowColor,
                            borderRadius:  BorderRadius.circular(Dimensions.radiusDefault),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall,),

                    Container(
                      height: 15, width: Get.width * 0.5,
                      decoration: BoxDecoration(
                        color: Get.isDarkMode ? Theme.of(context).cardColor : Theme.of(context).shadowColor,
                        borderRadius:  BorderRadius.circular(Dimensions.radiusDefault),
                      ),
                    ),

                    const SizedBox(height: Dimensions.paddingSizeExtraSmall,),

                    Container(
                      height: 15, width: Get.width * 0.6,
                      decoration: BoxDecoration(
                        color: Get.isDarkMode ? Theme.of(context).cardColor : Theme.of(context).shadowColor,
                        borderRadius:  BorderRadius.circular(Dimensions.radiusDefault),
                      ),
                    ),

                    const SizedBox(height: Dimensions.paddingSizeExtraSmall,),

                    Container(
                      height: 15, width: Get.width * 0.7,
                      decoration: BoxDecoration(
                        color: Get.isDarkMode ? Theme.of(context).cardColor : Theme.of(context).shadowColor,
                        borderRadius:  BorderRadius.circular(Dimensions.radiusDefault),
                      ),
                    ),

                  ],
                ),
              );
            },shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,),

          ],
        ),
      ),
    );
  }
}
