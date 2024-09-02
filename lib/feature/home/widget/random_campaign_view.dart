import 'dart:math';
import 'package:demandium/core/helper/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demandium/components/custom_image.dart';
import 'package:demandium/core/helper/help_me.dart';
import 'package:demandium/feature/home/controller/campaign_controller.dart';
import 'package:demandium/utils/dimensions.dart';
import 'package:demandium/utils/images.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class RandomCampaignView extends StatelessWidget {
   const RandomCampaignView({super.key}) ;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CampaignController>(
        builder: (campaignController) {
          int randomIndex = 1;
          if(campaignController.campaignList != null && campaignController.campaignList!.isEmpty){
            return const SizedBox();
          }else{

            if(campaignController.campaignList != null) {
              var rng = Random();
              randomIndex =  rng.nextInt(campaignController.campaignList!.isNotEmpty ? campaignController.campaignList!.length :1 );
              return InkWell(
                onTap: (){
                  if(isRedundentClick(DateTime.now())){
                    return;
                  }
                  campaignController.navigateFromCampaign(
                      campaignController.campaignList![randomIndex].id!,
                      campaignController.campaignList![randomIndex].discount!.discountType!);
                },
                child: Padding(
                  padding:  const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                  child: Column(
                    children: [
                      const SizedBox(height: Dimensions.paddingSizeLarge),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          border: Border.all(color: Theme.of(context).hintColor.withOpacity(0.5),width: 0.5)
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault),
                          child: CustomImage(
                            height: ResponsiveHelper.isTab(context) || MediaQuery.of(context).size.width > 450 ? 350 :MediaQuery.of(context).size.width * 0.40,
                            width: Get.width, fit: BoxFit.cover, placeholder: Images.placeholder,
                            image:campaignController.campaignList![randomIndex].coverImageFullPath ?? "",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            else{
              return Column(
                children: [
                  const SizedBox(height: Dimensions.paddingSizeLarge),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: ResponsiveHelper.isTab(context) ? 300 : GetPlatform.isDesktop ? 500 : MediaQuery.of(context).size.width * 0.40,
                    child:  Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                      child: Shimmer(
                          duration: const Duration(seconds: 2),
                          enabled: true,
                          color: Colors.grey,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                              boxShadow: Get.isDarkMode?null:[BoxShadow(color: Colors.grey[200]!, blurRadius: 5, spreadRadius: 1)],
                            ),
                          )
                      ),
                    ),
                  ),
                ],
              );
            }
          }
        });
  }
}
