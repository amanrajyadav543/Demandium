import 'package:demandium/components/core_export.dart';
import 'package:demandium/feature/search/model/search_suggestion_model.dart';
import 'package:get/get.dart';

class RealTimeSearchSuggestion extends StatelessWidget {
  final List<SearchSuggestion>  suggestionList;
  const RealTimeSearchSuggestion({super.key, required this.suggestionList});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AllSearchController>(builder: (searchController){
      return ConstrainedBox(
        constraints: const BoxConstraints(
          maxHeight: 300
        ),
        child: ListView.separated(itemBuilder: (context, index){
          final item = suggestionList[index].name!;
          final searchQuery = searchController.searchController.text;

          if(searchQuery.isNotEmpty && item.toLowerCase().contains(searchQuery.toLowerCase())){
            final startIndex = item.toLowerCase().indexOf(searchQuery.toLowerCase());
            final prefix = item.substring(0, startIndex);
            final suffix = item.substring(startIndex + searchQuery.length);
            return ListTile(
              visualDensity: VisualDensity.compact,
              horizontalTitleGap: 0,
              title: RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: <TextSpan>[
                    TextSpan(
                      text: prefix,
                      style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeDefault),
                    ),
                    TextSpan(
                      text: prefix.isEmpty ? searchQuery.capitalizeFirst : searchQuery,
                      style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeDefault),
                    ),
                    TextSpan(
                      text: suffix,
                      style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeDefault),
                    ),
                  ],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: const Icon(Icons.north_west_rounded, size: 18,),
              contentPadding: EdgeInsets.zero,
              leading: suggestionList[index].isSearched == 1 ?
              Icon(Icons.refresh,color: Theme.of(context).hintColor, size: 18) :Image.asset( Images.searchIcon, color: Theme.of(context).hintColor, width: 18,),
              onTap: (){
                Get.back();
                FocusScope.of(context).unfocus();
                searchController.populatedSearchController(suggestionList[index].name!);
                Get.toNamed(RouteHelper.getSearchResultRoute(queryText: suggestionList[index].name!));
              },
            );

          }else{
            return ListTile(
              visualDensity: VisualDensity.compact,
              horizontalTitleGap: 0,
              title: Text("${suggestionList[index].name}", style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeDefault),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: const Icon(Icons.north_west_rounded, size: 18,),
              contentPadding: EdgeInsets.zero,
              leading: suggestionList[index].isSearched == 1 ?
              Icon(Icons.refresh,color: Theme.of(context).hintColor, size: 18) :Image.asset( Images.searchIcon, color: Theme.of(context).hintColor, width: 18,),
              onTap: (){
                Get.back();
                FocusScope.of(context).unfocus();
                searchController.populatedSearchController(suggestionList[index].name!);
                Get.toNamed(RouteHelper.getSearchResultRoute(queryText: suggestionList[index].name!));
              },
            );
          }

          },
          itemCount: suggestionList.length,
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          separatorBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
              child: Divider(height: 0.5, color: Theme.of(context).hintColor.withOpacity(0.5),),
            );
          },
        ),
      );
    });
  }
}
