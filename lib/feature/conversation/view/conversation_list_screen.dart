import 'package:demandium/feature/conversation/widgets/conversation_list_shimmer.dart';
import 'package:demandium/feature/conversation/widgets/conversation_listview.dart';
import 'package:demandium/feature/conversation/widgets/conversation_search_shimmer.dart';
import 'package:demandium/feature/conversation/widgets/conversation_search_widget.dart';
import 'package:demandium/feature/conversation/widgets/conversation_tabview.dart';
import 'package:get/get.dart';
import 'package:demandium/components/core_export.dart';


class ConversationListScreen extends StatefulWidget {
  final String? fromNotification;
  const ConversationListScreen({super.key, this.fromNotification}) ;

  @override
  State<ConversationListScreen> createState() => _ConversationListScreenState();
}

class _ConversationListScreenState extends State<ConversationListScreen> with SingleTickerProviderStateMixin{



  @override
  void initState() {
    super.initState();
    Get.find<ConversationController>().clearSearchController(shouldUpdate: false);
    _loadData();
  }

  _loadData() async {
    await Get.find<ConversationController>().getChannelList(1, type: "provider");
    Get.find<ConversationController>().getChannelList(1, type: "serviceman");
  }

  @override
  Widget build(BuildContext context) {
    return CustomPopScopeWidget(
      onPopInvoked: (){
        Get.offNamed(RouteHelper.getMainRoute(RouteHelper.chatInbox));
      },
      child: Scaffold(
        endDrawer:ResponsiveHelper.isDesktop(context) ? const MenuDrawer():null,
        appBar: CustomAppBar(title: 'inbox'.tr,
          isBackButtonExist: true,
          onBackPressed: (){
            if(widget.fromNotification == "fromNotification" || !Navigator.canPop(context)){
              Get.offNamed(RouteHelper.getMainRoute(RouteHelper.chatInbox));
            }else{
              ConversationController conversationController = Get.find();
              if(conversationController.isActiveSuffixIcon && conversationController.isSearchComplete){
                conversationController.clearSearchController();
              }else{
                Get.back();
              }

            }
          },
        ),
        body: GetBuilder<ConversationController>(builder: (conversationController){
          return FooterBaseView(
            isScrollView: true,
            child: conversationController.providerChannelList != null ? Center(
              child: SizedBox(
                height: ResponsiveHelper.isDesktop(context) ? Get.height * 0.8 : Get.height,
                width: Dimensions.webMaxWidth,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                  const SizedBox(height: Dimensions.paddingSizeDefault),
                  const ConversationSearchWidget(),
                  const SizedBox(height: Dimensions.paddingSizeSmall,),


                  Expanded(
                    child: Column( crossAxisAlignment: CrossAxisAlignment.start,children: [

                      conversationController.adminConversationModel != null?
                      ChannelItem(
                        channelData: conversationController.adminConversationModel!,
                        isAdmin: true,
                      ): const SizedBox(),

                      const SizedBox(height: Dimensions.paddingSizeSmall,),
                      ConversationListTabview( tabController: conversationController.tabController,),
                      const SizedBox(height: Dimensions.paddingSizeSmall,),

                      Expanded(
                        child: TabBarView( controller: conversationController.tabController, children: [

                          conversationController.searchedChannelList == null && !conversationController.isSearchComplete ?
                              const ConversationSearchShimmer() :

                          ConversationListView(
                            channelList: conversationController.isSearchComplete ? conversationController.searchedProviderChannelList!:
                                         conversationController.providerChannelList ?? [],
                            tabIndex: 0,
                          ),

                          conversationController.searchedChannelList == null && !conversationController.isSearchComplete ?
                          const ConversationSearchShimmer() :

                          ConversationListView(
                            channelList : conversationController.isSearchComplete ?
                            conversationController.searchedServicemanChannelList! : conversationController.servicemanChannelList ?? [],
                            tabIndex: 1,
                          ),
                        ]),
                      ),
                    ],),
                  ),

                ],),
              ),
            ) : const ConversationListShimmer() ,
          );
          },
        ),

      ),
    );
  }
}
