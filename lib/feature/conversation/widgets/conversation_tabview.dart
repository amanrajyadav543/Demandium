import 'package:demandium/components/core_export.dart';
import 'package:get/get.dart';

class ConversationListTabview extends StatelessWidget {
  final TabController? tabController;
  const ConversationListTabview({super.key, this.tabController}) ;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ConversationController>(
      builder: (conversationController) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
          child: Row(
            children: [
              TabBar(
                controller: tabController,
                unselectedLabelColor: Colors.grey,
                isScrollable: true,
                indicatorColor: Theme.of(context).colorScheme.primary,
                labelColor:  Theme.of(context).colorScheme.primary,
                labelStyle: ubuntuMedium,
                indicatorWeight: 1.5,
                tabAlignment: TabAlignment.start,
                indicatorPadding: const EdgeInsets.only(right: 50),
                labelPadding: EdgeInsets.only(
                  right: conversationController.isActiveSuffixIcon && conversationController.isSearchComplete
                      && conversationController.searchedProviderChannelList!.isNotEmpty ? 10 : 25,
                ),
                tabs:  [
                  SizedBox(
                    height: 35,
                    child:Center(
                      child: Row(
                        children: [
                          Text("provider".tr),
                          conversationController.isActiveSuffixIcon && conversationController.isSearchComplete  && conversationController.searchedProviderChannelList!.isNotEmpty?
                          Container(height: 15 , width: 15,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Theme.of(context).primaryColor,
                            ),
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            padding: const EdgeInsets.all(2),
                            child: FittedBox(child: Text(
                              conversationController.searchedProviderChannelList!.length.toString(),
                              style: ubuntuRegular.copyWith(color: Colors.white),
                            ),
                            ),
                          ) : const SizedBox(),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 35,
                    child:  Center(
                      child: Row(
                        children: [
                          Text("serviceman".tr),
                          conversationController.isActiveSuffixIcon && conversationController.isSearchComplete  && conversationController.searchedServicemanChannelList!.isNotEmpty?
                          Container(height: 15 , width: 15,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Theme.of(context).primaryColor,
                            ),
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            padding: const EdgeInsets.all(2),
                            child: FittedBox(child: Text(
                              conversationController.searchedServicemanChannelList!.length.toString(),
                              style: ubuntuRegular.copyWith(color: Colors.white),
                            ),
                            ),
                          ) : const SizedBox(),
                        ],
                      ),
                    ),
                  ),
                ],
                onTap: (index){
                  if( conversationController.isActiveSuffixIcon && conversationController.isSearchComplete){

                  }else{
                    Get.find<ConversationController>().getChannelList(1,type: index == 0 ? "provider": "serviceman");
                  }

                },
              ),
              const Expanded(child: SizedBox()),
            ],
          ),
        );
      }
    );
  }
}
