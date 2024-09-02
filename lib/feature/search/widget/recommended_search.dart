import 'dart:math';
import 'package:demandium/components/core_export.dart';
import 'package:get/get.dart';

class RecommendedSearch extends StatefulWidget {
  const RecommendedSearch({super.key}) ;

  @override
  State<RecommendedSearch> createState() => _RecommendedSearchState();
}

class _RecommendedSearchState extends State<RecommendedSearch> {
  @override
  void initState() {
    super.initState();
    Get.find<ServiceController>().getRecommendedSearchList();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ServiceController>(
      builder: (serviceController){
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(child: Text(
              'recommended_for_you'.tr,style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeLarge -1),
              overflow: TextOverflow.ellipsis,
            )),

            const SizedBox(width: Dimensions.paddingSizeSmall,),

            serviceController.recommendedSearchList != null && serviceController.recommendedSearchList!.isEmpty ? const SizedBox() :InkWell(
              onTap: ()=> serviceController.recommendedSearchList == null? null : serviceController.getRecommendedSearchList(reload: true),
              child: Row(children: [
                Text('shuffle'.tr,style: ubuntuMedium.copyWith(
                  color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(.5),

                ),),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall,),
                Icon(Icons.cached,size: 16, color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(.5),)
              ],),
            )
          ]),
          const SizedBox(height: Dimensions.paddingSizeDefault,),

          (serviceController.recommendedSearchList!=null && serviceController.recommendedSearchList!.isNotEmpty) ? Padding(
            padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault, top: Dimensions.paddingSizeSmall),
            child: SizedBox( height: 40,
              child: ListView.builder(
                shrinkWrap: true, scrollDirection: Axis.horizontal,
                itemBuilder: (context,index){
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: Theme.of(context).hintColor.withOpacity(0.5)),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                  margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                  child: Center(
                    child: Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                      child: InkWell(
                        hoverColor: Colors.transparent,
                        onTap: (){
                          Get.back();
                          FocusScope.of(context).unfocus();
                          Get.toNamed(RouteHelper.getSearchResultRoute(queryText: serviceController.recommendedSearchList?[index].name??''));
                          Get.find<AllSearchController>().populatedSearchController(serviceController.recommendedSearchList?[index].name??'');
                         },
                        child: Text(
                          serviceController.recommendedSearchList?[index].name??"",
                          style: ubuntuRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(.8)),
                        ),
                      ),
                    ),
                  ),
                );
               },
                itemCount: serviceController.recommendedSearchList!.length,
               ),
            ),
          ) : serviceController.recommendedSearchList != null && serviceController.recommendedSearchList!.isEmpty ?
          Padding(
            padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault, top: Dimensions.paddingSizeSmall),
            child: Text("no_services_available".tr, style: ubuntuRegular.copyWith(color: Theme.of(context).hintColor),),
          ) : const RecommendedSearchShimmer(),

        ]);
    });
  }
}

class RecommendedSearchShimmer extends StatelessWidget {
  const RecommendedSearchShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault, top: Dimensions.paddingSizeSmall),
      child: SizedBox( height: 40,
        child: ListView.builder(
          shrinkWrap: true, scrollDirection: Axis.horizontal,
          itemCount: 5,
          itemBuilder: (context, index) {
            return Shimmer(
              duration: const Duration(seconds: 3),
              interval: const Duration(seconds: 5),
              color: Theme.of(context).colorScheme.surface,
              colorOpacity: 0,
              enabled: true,
              child: Container(width: (Random().nextInt(150) + 100),
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Theme.of(context).shadowColor,
                ),

                child: Row(children: [
                  const SizedBox(width: Dimensions.paddingSizeExtraSmall,),
                  Expanded(
                    child: Container(
                      height: 16,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeEight,),
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 16,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                    ),
                  ),
                ],),
              ),
            );
          },
        ),
      ),
    );
  }
}


