import 'package:demandium/components/core_export.dart';
import 'package:demandium/feature/conversation/widgets/empty_conversation_widget.dart';
import 'package:get/get.dart';

class ConversationSearchedListView extends StatelessWidget {
  const ConversationSearchedListView({super.key}) ;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ConversationController>(builder: (conversationController){
      return conversationController.searchedChannelList!.isEmpty ?
      const Expanded(child: Center(child: EmptyConversationWidget(fromSearch: true,))): ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: conversationController.searchedChannelList!.length,
        itemBuilder: (context,index){
          return  ChannelItem(
            channelData:  conversationController.searchedChannelList![index],
          );
        },
      );
    });
  }
}