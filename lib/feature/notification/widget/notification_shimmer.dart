import 'package:get/get.dart';
import 'package:demandium/components/core_export.dart';

class NotificationShimmer extends StatelessWidget {
  const NotificationShimmer({super.key}) ;

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      duration: const Duration(seconds: 3),
      direction: const ShimmerDirection.fromLTRB(),
      child: SizedBox(
        height: context.height,
        width: context.width,
        child: ListView.builder(
          itemCount: 10,
          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeLarge),
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                  boxShadow: lightShadow,
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(5)
              ),
              margin: const EdgeInsets.symmetric( vertical: Dimensions.paddingSizeExtraSmall+2, horizontal: 10),
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeDefault),

              child: Row(
                crossAxisAlignment : CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).shadowColor,
                    ),
                  ),

                  const SizedBox(width: 10,),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Container(width: 180, height: 15,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).shadowColor,
                          ),
                        ),

                        const SizedBox(height: Dimensions.paddingSizeExtraSmall,),

                        Container(width: 160, height: 12,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).shadowColor,
                          ),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeExtraSmall,),
                        Container(width: 120, height: 10,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).shadowColor,
                          ),
                        ),


                      ],
                    ),
                  ),

                  Container(width: 50, height: 16,
                    margin: const EdgeInsets.only(top: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).shadowColor,
                    ),
                  ),

                ],
              ),
            );
          },
        ),
      ),
    );
  }
}