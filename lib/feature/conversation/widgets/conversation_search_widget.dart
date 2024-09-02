import 'package:demandium/components/core_export.dart';
import 'package:get/get.dart';

class ConversationSearchWidget extends StatelessWidget {
  const ConversationSearchWidget({super.key}) ;

  @override
  Widget build(BuildContext context) {
    return Padding( padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
      child: GetBuilder<ConversationController>(
        builder: (conversationController){
          return TextField(

            controller: conversationController.searchController,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: Dimensions.fontSizeDefault,
            ),

            cursorColor: Theme.of(context).hintColor,
            autofocus: false,
            textAlignVertical: TextAlignVertical.center,
            textInputAction: TextInputAction.search,
            onChanged: (text) => conversationController.showSuffixIcon(context,text),
            onSubmitted: (text){
              if(text.isNotEmpty) {
                conversationController.getSearchedChannelList(query: text);
              }
              FocusScope.of(context).unfocus();
            },
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 22),
              fillColor: Theme.of(context).cardColor,
              border:  OutlineInputBorder(
                borderRadius: const BorderRadius.horizontal(right: Radius.circular(10,),left: Radius.circular(10)),
                borderSide: BorderSide( width: 0.5, color: Theme.of(context).primaryColor.withOpacity(0.5)),
              ),
              errorBorder:  OutlineInputBorder(
                borderRadius: const BorderRadius.horizontal(right: Radius.circular(10,),left: Radius.circular(10)),
                borderSide: BorderSide( width: 0.5, color: Theme.of(context).primaryColor.withOpacity(0.5)),
              ),

              focusedBorder:  OutlineInputBorder(
                borderRadius: const BorderRadius.horizontal(right: Radius.circular(10,),left: Radius.circular(10)),
                borderSide: BorderSide( width: 0.5, color: Theme.of(context).primaryColor.withOpacity(0.5)),
              ),
              enabledBorder :  OutlineInputBorder(
                borderRadius: const BorderRadius.horizontal(right: Radius.circular(10,),left: Radius.circular(10)),
                borderSide: BorderSide( width: 0.5, color: Theme.of(context).primaryColor.withOpacity(0.5)),
              ),

              isDense: true,
              hintText: 'search'.tr,
              hintStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).hintColor,
              ),
              filled: true,
              suffixIcon: conversationController.isActiveSuffixIcon ? IconButton(
                color: Get.isDarkMode? light.cardColor.withOpacity(0.8) :Theme.of(context).colorScheme.primary,
                onPressed: () {
                  if(conversationController.searchController.text.trim().isNotEmpty) {
                    conversationController.clearSearchController();
                  }
                  FocusScope.of(context).unfocus();
                },
                icon: Icon(
                  Icons.cancel_outlined, size: 18,color: Theme.of(context).hintColor
                ),
              ) : Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                child: Icon(Icons.search_outlined,color: Theme.of(context).hintColor, size: 22,),
              ),
            ),
          );
        },
      ),
    );
  }
}