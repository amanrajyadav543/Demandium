import 'package:demandium/components/core_export.dart';
import 'package:demandium/feature/search/widget/realtime_search_suggestion.dart';
import 'package:demandium/feature/search/widget/recommended_search.dart';
import 'package:get/get.dart';

class SearchSuggestionDialog extends StatelessWidget {
  const SearchSuggestionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AllSearchController>(builder: (searchController){
      return Container(
        margin: EdgeInsets.only(top: ResponsiveHelper.isDesktop(context) ? 0 : 72),
        padding: const EdgeInsets.symmetric(horizontal:Dimensions.paddingSizeDefault),
        alignment: Alignment.topCenter,
        child: Column( mainAxisSize: MainAxisSize.min, children: [

          ResponsiveHelper.isDesktop(context) ? const WebMenuBar(openSearchDialog: false,) : const SearchInputBoxApp(),

          const SizedBox(height: Dimensions.paddingSizeExtraSmall + 2,),

          SizedBox(
            width: Dimensions.webMaxWidth,
            child: Material(
              borderRadius: ResponsiveHelper.isDesktop(context)
                  ? const BorderRadius.vertical(bottom: Radius.circular(Dimensions.radiusDefault),)
                  : BorderRadius.circular(Dimensions.radiusDefault),

              color: Theme.of(context).cardColor,
              child: Padding(
                padding:  const EdgeInsets.all(Dimensions.paddingSizeDefault),
                child: searchController.searchController.text.isNotEmpty && searchController.searchSuggestionModel != null && searchController.searchSuggestionList.isNotEmpty ?
                RealTimeSearchSuggestion(suggestionList: searchController.searchSuggestionList,) : const Column( children: [
                  RecentSearch(),
                  SizedBox(height: Dimensions.paddingSizeLarge,),
                  RecommendedSearch()
                ]),
              ),
            ),
          ),

        ]),
      );
    });
  }
}
