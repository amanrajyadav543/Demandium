import 'package:demandium/components/core_export.dart';
import 'package:demandium/components/extended_wrap_widget.dart';
import 'package:get/get.dart';

class RecentSearch extends StatelessWidget {
  const RecentSearch({super.key}) ;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AllSearchController>(builder: (searchController){

      return searchController.historyList!=null && searchController.historyList!.isNotEmpty ?
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('recent_search'.tr,style: ubuntuMedium.copyWith(
            fontSize: Dimensions.fontSizeLarge -1,
          ),),

          InkWell(
            onTap: () =>  searchController.removeHistory(),
            child: Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: Text('clear_all'.tr, style: ubuntuMedium.copyWith(
                color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(.5),
                fontSize: Dimensions.fontSizeSmall,
              )),
            ),
          ),
        ]),
        const SizedBox(height: Dimensions.paddingSizeExtraSmall,),

        ExtendedWrap(
          maxLines: 5,
          minLines: 1,
          runSpacing: 0,
          spacing: 0,
          children: [for (int index =0; index < searchController.historyList!.length ;index++)
            Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
              child: Container(decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  border: Border.all(color: Theme.of(context).hintColor.withOpacity(0.1)),
                  color: Get.isDarkMode?Colors.grey.withOpacity(0.2): Theme.of(context).primaryColor.withOpacity(0.05)),
                padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeSmall,),
                margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                child: InkWell(
                  onTap: () {
                    Get.back();
                    FocusScope.of(context).unfocus();
                    searchController.populatedSearchController(searchController.historyList![index]);
                    Get.toNamed(RouteHelper.getSearchResultRoute(queryText: searchController.historyList![index]));
                  },
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: Get.width * 0.85,),
                    child: Row(mainAxisSize:MainAxisSize.min,children: [
                      const SizedBox(width: Dimensions.paddingSizeExtraSmall,),
                      Flexible(
                        child: Text(searchController.historyList![index],
                          style: ubuntuRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(.7)),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeSmall,),
                      InkWell(
                        onTap: () => searchController.removeHistory(index: index),
                        child: Icon(Icons.close, size : 20, color: Theme.of(context).hintColor,),
                      )
                    ]),
                  ),
                ),
              ),
            )
          ],
        ),

      ]): const SizedBox();
      }
    );
  }
}
