
import 'package:demandium/components/core_export.dart';
import 'package:get/get.dart';

class ConversationSearchShimmer extends StatelessWidget {
  const ConversationSearchShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.only(
        left: Dimensions.paddingSizeDefault,
        top: Dimensions.paddingSizeDefault,
        right:Dimensions.paddingSizeDefault
    ),
      child: ListView.separated(
        itemBuilder: (context, index){
          int randomValue = 1;
          if (kDebugMode) {
            print(randomValue);
          }
          return Container(height: 100, width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              boxShadow: Get.isDarkMode ?null : [BoxShadow(color: Colors.grey[300]!, blurRadius: 10, spreadRadius: 1)],
            ),
            child: Padding(padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault),
              child: Row(children: [


                Container(height: 60, width: 60, decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: randomValue == 0 ? Theme.of(context).hintColor.withOpacity(0.2) :
                    Get.isDarkMode? Colors.grey.shade700 : Colors.grey.shade100
                ),),


                Expanded(child: Padding(
                  padding: const EdgeInsets.only(
                      top: Dimensions.paddingSizeDefault,
                      left: Dimensions.paddingSizeDefault,
                      right: Dimensions.paddingSizeDefault
                  ),
                  child: Column(children: [


                    Expanded(child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [


                      Container(height: 20, width: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault),
                            color: randomValue == 0 ? Theme.of(context).hintColor.withOpacity(0.2) :
                            Get.isDarkMode? Colors.grey.shade700 : Colors.grey.shade100
                        ),
                      ),


                      randomValue == 0 ?
                      Container(height: 40, width: 40,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).hintColor.withOpacity(0.2)
                        ),
                      ) : const SizedBox(),


                    ],)),
                    const SizedBox(height: Dimensions.paddingSizeSmall),


                    Expanded(child: Container(decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault),
                        color: randomValue == 0 ? Theme.of(context).hintColor.withOpacity(0.2) :
                        Get.isDarkMode? Colors.grey.shade700 : Colors.grey.shade100
                    ))),
                    const SizedBox(height: Dimensions.paddingSizeSmall),


                    Align(alignment: Alignment.bottomRight,
                      child: Container(height: 20, width: 150,
                        decoration: BoxDecoration(
                            color: randomValue == 0 ? Theme.of(context).hintColor.withOpacity(0.2) :
                            Get.isDarkMode? Colors.grey.shade700 : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault)
                        ),
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeSmall),


                  ],),
                )),


              ],),
            ),
          );
        },
        itemCount: 10,
        separatorBuilder: (context, index){
          return const SizedBox(height: Dimensions.paddingSizeSmall);
        },
      ),
    );
  }
}
