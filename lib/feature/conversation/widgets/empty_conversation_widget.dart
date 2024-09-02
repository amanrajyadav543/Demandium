import 'package:demandium/components/core_export.dart';
import 'package:get/get.dart';

class EmptyConversationWidget extends StatelessWidget {
  final bool fromSearch;
  const EmptyConversationWidget({super.key,  this.fromSearch = false}) ;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center ,children: [

      Image.asset(Images.emptyConversation, width: 50,),
      
      const SizedBox(height: Dimensions.paddingSizeDefault * 2,),
      
      Padding(padding: EdgeInsets.symmetric(horizontal: Get.width * 0.15),
        child: Text( fromSearch ? "no_conversation_found_to_your_related_search".tr : "you_don't_have_any_conversation_yet".tr,
          style: ubuntuRegular.copyWith(color: Theme.of(context).hintColor),
          textAlign: TextAlign.center,
        ),
      ),

      SizedBox(height: MediaQuery.of(context).size.height * 0.1,)
    ]);
  }
}
