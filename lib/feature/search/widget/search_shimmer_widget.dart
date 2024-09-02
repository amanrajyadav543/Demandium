import 'package:demandium/components/core_export.dart';

class SearchShimmerWidget extends StatelessWidget {
  const SearchShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: Dimensions.webMaxWidth,
        child: Column(children: [

          Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
            child: Shimmer(
              duration: const Duration(seconds: 2),
              enabled: true,
              child: Row(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
                Container(height: 20, width: 30, decoration: BoxDecoration(
                  color:  Theme.of(context).shadowColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                ),),
                const SizedBox(width: Dimensions.paddingSizeSmall),
                Container(height: 20, width: 90,  decoration: BoxDecoration(
                  color:  Theme.of(context).shadowColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                ),),
              ]),
            ),
          ),

          const SizedBox(height: Dimensions.paddingSizeDefault,),

          Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(
                children: [
                  Shimmer(
                    duration: const Duration(seconds: 2),
                    enabled: true,
                    child: Container(height: 25, width: 80, decoration: BoxDecoration(
                      color:  Theme.of(context).shadowColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    ),),
                  ),

                  if(ResponsiveHelper.isDesktop(context)) Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                    child: Shimmer(
                      duration: const Duration(seconds: 2),
                      enabled: true,
                      child: Container(height: 20, width: 100, decoration: BoxDecoration(
                        color:  Theme.of(context).shadowColor,
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      ),),
                    ),
                  ),
                ],
              ),

              Row(children: [
                Shimmer(
                  duration: const Duration(seconds: 2),
                  enabled: true,
                  child: Container(
                    height: 40, width: ResponsiveHelper.isDesktop(context)? 100 : 40, decoration: BoxDecoration(
                    color:  Theme.of(context).shadowColor,
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  ),),
                ),

                const SizedBox(width: Dimensions.paddingSizeDefault,),

                Shimmer(
                  duration: const Duration(seconds: 2),
                  enabled: true,
                  child: Container(
                    height: 40, width: ResponsiveHelper.isDesktop(context)? 100 : 40, decoration: BoxDecoration(
                    color:  Theme.of(context).shadowColor,
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  ),),
                ),

              ],)
            ],),
          ),

          GridView.builder(
            key: UniqueKey(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: Dimensions.paddingSizeDefault,
              mainAxisSpacing:  Dimensions.paddingSizeDefault,
              mainAxisExtent: ResponsiveHelper.isDesktop(context) ?  270 : 240 ,
              crossAxisCount: ResponsiveHelper.isDesktop(context) ? 5 : ResponsiveHelper.isTab(context) ? 3 : 2,
            ),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap:  true, itemCount: 15,
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            itemBuilder: (context, index) {
              return const ServiceShimmer(isEnabled: true, hasDivider: true,);
            },
          )
        ],),
      ),
    );
  }
}
