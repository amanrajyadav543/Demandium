import 'package:demandium/components/core_export.dart';
import 'package:demandium/feature/favorite/controller/my_favorite_controller.dart';
import 'package:demandium/feature/favorite/widget/favorite_provider_item_view.dart';
import 'package:get/get.dart';

class FavoriteProviderListView extends StatelessWidget {

  const FavoriteProviderListView({super.key}) ;

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    return GetBuilder<MyFavoriteController>(builder: (myFavoriteController){
      return RefreshIndicator(
        onRefresh: () async{
          Get.find<MyFavoriteController>().getProviderList(1, true);
        },
        child: myFavoriteController.providerList !=null && myFavoriteController.providerList!.isNotEmpty ?  PaginatedListView(
          scrollController: scrollController,
          totalSize: myFavoriteController.providerModel?.content?.total ,
          offset:  myFavoriteController.providerModel?.content?.currentPage,
          onPaginate: (int offset) async => await  myFavoriteController.getProviderList(offset, false),
          showBottomSheet: false,
          bottomPadding: 0,
          itemView: Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 0,
                mainAxisSpacing: Dimensions.paddingSizeExtraSmall,
                crossAxisCount: ResponsiveHelper.isMobile(context) ? 1 : ResponsiveHelper.isTab(context) ? 2 : 3,
                mainAxisExtent: Get.find<LocalizationController>().isLtr ? 165 : 195,
              ),
              controller: scrollController,
              itemCount: myFavoriteController.providerList?.length,
              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
              itemBuilder: (context,index){
                return FavoriteProviderItemView(providerData: myFavoriteController.providerList![index], index: index,);
              },
              shrinkWrap: true,
            ),
          ),
        ) : myFavoriteController.providerList != null && myFavoriteController.providerList!.isEmpty ?
        Padding(
          padding:  EdgeInsets.only(bottom: Get.height*0.15),
          child: const NoDataScreen(text: "you_have_not_any_favorite_provider" ,type: NoDataType.provider,),
        ) : const Center(child: CircularProgressIndicator()),
      );
    });
  }
}


