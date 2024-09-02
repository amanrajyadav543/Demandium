// ignore_for_file: deprecated_member_use
import 'package:demandium/feature/search/widget/already_filtered_widget.dart';
import 'package:demandium/feature/search/widget/search_filter_button_widget.dart';
import 'package:demandium/feature/search/widget/search_shimmer_widget.dart';
import 'package:get/get.dart';
import 'package:demandium/components/core_export.dart';

class SearchResultScreen extends StatefulWidget {
  final String? queryText;
  final String? fromPage;

  const SearchResultScreen({super.key, required this.queryText, this.fromPage}) ;

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    _loadDart();
    super.initState();
  }

  _loadDart() async {

    Get.find<AllSearchController>().clearAllFilterValue(shouldUpdate: false);
    Get.find<AllSearchController>().updateSortByType(widget.fromPage, shouldUpdate: false);
    Get.find<AllSearchController>().searchData(query:widget.queryText!, offset: 1, shouldUpdate: false);
    await Get.find<CategoryController>().getCategoryList(1, false);
    Get.find<AllSearchController>().resetCategoryCheckedList(shouldUpdate: false);
    Get.find<AllSearchController>().populatedSearchController(widget.queryText ?? "", shouldUpdate: false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()  => _exitApp(),
      child: Scaffold(
        endDrawer:ResponsiveHelper.isDesktop(context) ? const MenuDrawer():null,
        appBar: const SearchAppBar(backButton: true),

        body: GetBuilder<AllSearchController>(builder: (searchController){
          return FooterBaseView(
            scrollController: scrollController,
            child: searchController.searchServiceList == null ? const SearchShimmerWidget() :
            SizedBox(
              width: Dimensions.webMaxWidth,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Container(
                    color: Theme.of(context).hoverColor,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault,vertical:  Dimensions.paddingSizeDefault),
                        child: RichText(
                          text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: <TextSpan>[
                              TextSpan(
                                text: " ${searchController.serviceModel?.content?.servicesContent?.total ?? 0} ",
                                style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeDefault),
                              ),
                              TextSpan(
                                text: 'results_found'.tr,
                                style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeDefault),
                              ),
                            ],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),


                  const SearchFilterButtonWidget(),

                  searchController.sortedByList.isNotEmpty && !ResponsiveHelper.isDesktop(context) ? const AlreadyFilteredWidget() : const SizedBox(),

                  PaginatedListView(
                    scrollController: scrollController,
                    totalSize: searchController.serviceModel?.content?.servicesContent?.total,
                    offset: searchController.serviceModel?.content?.servicesContent?.currentPage,
                    onPaginate: (int offset) async => await searchController.searchData(query: searchController.searchController.text, offset: offset, shouldUpdate: false , reload: false),
                    itemView: ServiceViewVertical(
                      service: searchController.searchServiceList!,
                      noDataText: 'no_service_found'.tr,
                      noDataType: NoDataType.search,
                      fromPage:"search_page",
                    ),
                  )

                ],
              ),
            ),
          );
          },
        ),
      ),
    );
  }

  Future<bool> _exitApp() async {
    Get.find<AllSearchController>().clearSearchController();
    return true;
  }
}
