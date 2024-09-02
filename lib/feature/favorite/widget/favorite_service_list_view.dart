import 'package:demandium/components/core_export.dart';
import 'package:demandium/feature/favorite/controller/my_favorite_controller.dart';
import 'package:demandium/feature/favorite/widget/favorite_service_item_view.dart';
import 'package:get/get.dart';

class FavoriteServiceListView extends StatelessWidget {

  const FavoriteServiceListView({super.key,}) ;

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    return GetBuilder<MyFavoriteController>(builder: (myFavoriteController){
      return RefreshIndicator(
        onRefresh: () async{
          Get.find<MyFavoriteController>().getFavoriteServiceList(1, true);
        },
        child: myFavoriteController.favoriteServiceList!=null && myFavoriteController.favoriteServiceList!.isNotEmpty ? PaginatedListView(
          scrollController: scrollController,
          totalSize: myFavoriteController.serviceContent?.total ,
          offset:  myFavoriteController.serviceContent?.currentPage ,
          onPaginate: (int offset) async => await  myFavoriteController.getFavoriteServiceList(offset, false),
          bottomPadding: 0,
          itemView: Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 0,
                mainAxisSpacing: Dimensions.paddingSizeExtraSmall,
                crossAxisCount: ResponsiveHelper.isMobile(context) ? 1 : ResponsiveHelper.isTab(context) ? 2 : 3,
                mainAxisExtent: ResponsiveHelper.isMobile(context) ? 140 : 150,
              ),
              controller: scrollController,
              itemCount: myFavoriteController.favoriteServiceList?.length,
              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
              itemBuilder: (context,index){
               Discount? discount =  PriceConverter.discountCalculation( myFavoriteController.favoriteServiceList![index]);
                return FavoriteServiceItemView(service: myFavoriteController.favoriteServiceList?[index],
                  index: index,
                  discountAmountType: discount.discountAmountType,
                  discountAmount: discount.discountAmount,
                );
              },
              shrinkWrap: true,
            ),
          ),
        ) :  myFavoriteController.favoriteServiceList != null && myFavoriteController.favoriteServiceList!.isEmpty ?
            Padding(
              padding:  EdgeInsets.only(bottom: Get.height*0.15),
              child: const NoDataScreen(text: "you_have_not_any_favorite_services",type: NoDataType.service,),
            ) : const Center(child: CircularProgressIndicator()),

      );
    });
  }
}
