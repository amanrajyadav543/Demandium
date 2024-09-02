import 'package:demandium/feature/search/model/filter_model.dart';
import 'package:demandium/feature/search/model/search_service_model.dart';
import 'package:demandium/feature/search/model/search_suggestion_model.dart';
import 'package:get/get.dart';
import 'package:demandium/components/core_export.dart';


enum AllFilterType {sortBy, sortByType, price, rating, category, query}

class AllSearchController extends GetxController implements GetxService {
  final SearchRepo searchRepo;
  AllSearchController({required this.searchRepo});

  bool _isSearchComplete = false;
  bool get isSearchComplete => _isSearchComplete;

  bool _isActiveSuffixIcon = false;
  bool get isActiveSuffixIcon => _isActiveSuffixIcon;

  bool _isSortedApplied = false;
  bool get isSortedApplied => _isSortedApplied;

  SearchServiceModel? _serviceModel;
  SearchServiceModel? get serviceModel => _serviceModel;

  List<Service>? _searchServiceList;
  List<Service>? get searchServiceList => _searchServiceList;

  SearchSuggestionModel? _searchSuggestionModel;
  SearchSuggestionModel? get searchSuggestionModel => _searchSuggestionModel;

  List<SearchSuggestion> _searchSuggestionList = [];
  List<SearchSuggestion> get searchSuggestionList => _searchSuggestionList;

  List<String>? _historyList;
  List<String>? get historyList => _historyList;

  final List<String> _sortBy = ['a_to_z','z_to_a', 'high_to_low', 'low_to_high'];
  List<String>  get sortBy => _sortBy;

  final List<String> _ratingFilter = ['5','4', '3', '2','1'];
  List<String>  get ratingFilter => _ratingFilter;

  final List<String> _sortByType = [ 'default','top_rated','most_loved', "trending" ,'popular', 'newest', "recommended"];
  List<String>  get sortByType => _sortByType;

  String? _selectedSortBy;
  String? get selectedSortBy => _selectedSortBy;

  String _selectedSortByType = 'default';
  String get selectedSortByType => _selectedSortByType;

  String? _selectedRating;
  String? get selectedRating => _selectedRating;

  double _initialMinPrice = 0;
  double get initialMinPrice=> _initialMinPrice;

  double _initialMaxPrice = 100;
  double get initialMaxPrice=> _initialMaxPrice;

  double? _filteredMinPrice ;
  double? get filteredMinPrice => _filteredMinPrice;

  double? _filteredMaxPrice;
  double ? get filteredMaxPrice => _filteredMaxPrice;

  List<bool> _categoryCheckList =[];
  List<bool> get categoryCheckList => _categoryCheckList;

  List<String> _selectedCategoryId =[];
  List<String> get selectedCategoryId => _selectedCategoryId;

  List<FilterModel> sortedByList = [];
  List<FilterModel> filteredByList = [];


  var searchController = TextEditingController(text: "");
  final FocusNode searchFocus = FocusNode();


  @override
  void onInit() {
    super.onInit();
    getHistoryList();
    searchController.text = '';
  }



  Future<void> navigateToSearchResultScreen()async{

    if(Get.isDialogOpen! && Navigator.canPop(Get.context!)){
      Get.back();
    }
    if(searchController.value.text.trim().isNotEmpty){
      if(Get.currentRoute.contains('/search?query=')){
        Get.offNamed(RouteHelper.getSearchResultRoute(queryText: searchController.value.text.trim()));
      }else{
        Get.toNamed(RouteHelper.getSearchResultRoute(queryText: searchController.value.text.trim()));
      }
    }
  }

  Future<void> clearSearchController({bool shouldUpdate = true})async{
    if(searchController.value.text.trim().isNotEmpty){
      searchController.clear();
      _isSearchComplete = false;
      _isActiveSuffixIcon = false;
      if(shouldUpdate){
        update();
      }
    }
  }

  Future<void> populatedSearchController(String queryText, {bool shouldUpdate = true})async{

    if(queryText.isNotEmpty){
      Future.delayed(const Duration(milliseconds: 100), (){

        searchController = TextEditingController(text: queryText);
        _isActiveSuffixIcon = true;
      });
      if(shouldUpdate){
        update();
      }
    }
  }


  Future<void> searchData({required String query, required offset, bool shouldUpdate = true, bool reload = true}) async {

   if(query.isNotEmpty){
     if (!_historyList!.contains(query)) {
       _historyList!.insert(0, query);
     }
     searchRepo.saveSearchHistory(_historyList!);
   }


   if(reload){
     _searchServiceList = null;
   }

   if(shouldUpdate) {
     update();
   }

    Response response = await searchRepo.getSearchData(
      query: query, offset: offset, sortBy: _selectedSortBy, sortByType: _selectedSortByType,
      minPrice: _filteredMinPrice ?? 0, maxPrice: _filteredMaxPrice ?? _serviceModel?.content?.initialMaxPrice ?? 0, rating: _selectedRating, categoryIdes: _selectedCategoryId,
    );
    if (response.statusCode == 200) {

      _serviceModel = SearchServiceModel.fromJson(response.body);

      if(_searchServiceList!= null && offset != 1){
        _searchServiceList!.addAll(_serviceModel?.content?.servicesContent?.serviceList ??[]);
      }else{
        _searchServiceList = [];
        _searchServiceList!.addAll(_serviceModel?.content?.servicesContent?.serviceList ??[]);
      }

      _initialMinPrice = _serviceModel?.content?.initialMinPrice ?? 0;
      _initialMaxPrice =  _serviceModel?.content?.initialMaxPrice ?? 100;

    } else {
    }

   updatedIsSortedAppliedStatus(shouldUpdate: false);
   updatedIsFilteredAppliedStatus(shouldUpdate: false);

    _isSearchComplete = true;
    update();
  }

  Future<void> getSearchSuggestion(String query, {bool shouldUpdate = true,}) async {

    Response response = await searchRepo.getSearchSuggestion(query: searchController.text);
    if (response.statusCode == 200) {
      _searchSuggestionModel = SearchSuggestionModel.fromJson(response.body);
      if(_searchSuggestionModel!=null && _searchSuggestionModel!.searchSuggestionContent != null && _searchSuggestionModel!.searchSuggestionContent!.isNotEmpty){
        _searchSuggestionList = [];
        _searchSuggestionList = _searchSuggestionModel!.searchSuggestionContent! ;
      }
    } else {
      ApiChecker.checkApi(response);
    }

    update();
  }



  updateIsFavoriteValue(int status, String serviceId, {bool shouldUpdate = false}){
    if(_searchServiceList !=null){
      int? index = _searchServiceList?.indexWhere((element) => element.id == serviceId);
      if(index !=null && index>-1){
        _searchServiceList![index].isFavorite = status;
      }
    }
    if(shouldUpdate){
      update();
    }
  }


  void showSuffixIcon(context,String text){
    if(text.isNotEmpty){
      _isActiveSuffixIcon = true;
    }else if(text.isEmpty){
      _isActiveSuffixIcon = false;
      _searchSuggestionList = [];
      _searchSuggestionModel = null;
    }
    update();
  }


  void getHistoryList() {
    _historyList = [];
    if(searchRepo.getSearchAddress().isNotEmpty){
      _historyList!.addAll(searchRepo.getSearchAddress());
    }
  }

  void removeHistory({int? index}) {
    if(index!=null){
      _historyList!.removeAt(index);
    }else{
      _historyList!.clear();
    }
    searchRepo.saveSearchHistory(_historyList!);
    update();
  }


  void removeService(String queryText) async {
    if(queryText.isEmpty){
      _searchServiceList = [];
      _isSearchComplete = false;
    }
  }

  void updateSortBy(String value){
    _selectedSortBy = value;
    update();
  }

  void updateSortByType(String? value, {bool shouldUpdate = true}){
    if(value != null && value !=""){
      _selectedSortByType = value;

      if(shouldUpdate){
        update();
      }
    }else{
      _selectedSortByType = "default";
    }

  }

  void updateFilterPriceRange(double minPrice, double maxPrice){
    _filteredMinPrice = minPrice;
    _filteredMaxPrice = maxPrice;
    update();
  }

  void updateFilterByRating(String value){
    _selectedRating= value;
    update();
  }

  insertCategoryCheckedList(){
   Get.find<CategoryController>().categoryList?.forEach((element) {
     categoryCheckList.add(false);
   });
  }

  clearSortByValues({bool shouldUpdate = true}){
    _selectedSortBy = null;
    _selectedSortByType = "default";
    _isSortedApplied = false;

    if(shouldUpdate){
      update();
    }
  }

  clearFilterDataValues ({bool shouldUpdate = true}){
    _selectedCategoryId=[];
    _categoryCheckList = [];

    _filteredMinPrice = null;
    _filteredMaxPrice = null;
    _selectedRating = null;

    resetCategoryCheckedList(shouldUpdate: false);

    if(shouldUpdate){
      update();
    }

    }

  void resetCategoryCheckedList({bool shouldUpdate = true}){
    Get.find<CategoryController>().categoryList?.forEach((element) {
      _categoryCheckList.add(false);
    });

    if(shouldUpdate){
      update();
    }
  }

  void toggleFromCampaignChecked(int index) {

    List<CategoryModel> categoryList = Get.find<CategoryController>().categoryList ?? [];
    _categoryCheckList[index] = !categoryCheckList[index];

    if(_categoryCheckList[index]==true){
      if(!_selectedCategoryId.contains(categoryList[index].id)){
        _selectedCategoryId.add(categoryList[index].id!);
      }
    }else{
      if(_selectedCategoryId.contains(categoryList[index].id)){
        _selectedCategoryId.remove(categoryList[index].id);
      }
    }
    update();

  }

  removeSortedItem({ AllFilterType? removeItem, bool shouldUpdate = true}){

    if(removeItem == AllFilterType.sortBy){
      _selectedSortBy = null;
    } else if (removeItem == AllFilterType.sortByType){
      _selectedSortByType = "default";
    }
    else if (removeItem == AllFilterType.query){
      searchController.text = "";
      _isActiveSuffixIcon = false;
    }
    updatedIsSortedAppliedStatus(shouldUpdate: false);

    if(shouldUpdate){
      update();
    }

  }

  updatedIsSortedAppliedStatus({bool shouldUpdate = true}){
    sortedByList = [];

    if(_selectedSortBy !=null){
      sortedByList.add(FilterModel(title: _selectedSortBy, type: AllFilterType.sortBy));
    }
    if(_selectedSortByType != "default"){
      sortedByList.add(FilterModel(title: _selectedSortByType, type: AllFilterType.sortByType));
    }
    if(searchController.text.isNotEmpty){
      sortedByList.add(FilterModel(title: searchController.text, type: AllFilterType.query));
    }

   if(shouldUpdate){
     update();
   }
  }

  updatedIsFilteredAppliedStatus({bool shouldUpdate = true}){

    filteredByList = [];

    if((_filteredMinPrice !=null && _serviceModel?.content?.filteredMinPrice != _filteredMinPrice) || (_filteredMaxPrice !=null && _serviceModel?.content?.filteredMaxPrice != _filteredMaxPrice)){

      filteredByList.add(FilterModel(title: "price", type: AllFilterType.price));
    }
    if(_selectedRating != null){
      filteredByList.add(FilterModel(title: "rating", type: AllFilterType.rating));
    }

    if(_selectedCategoryId.isNotEmpty){
      for (var element in _selectedCategoryId) {
        filteredByList.add(FilterModel(title: "category", type: AllFilterType.category));

        if (kDebugMode) {
          print(element);
        }
      }
    }


    if(shouldUpdate){
      update();
    }
  }

  void clearAllFilterValue({bool shouldUpdate = false}){
    _searchServiceList = null;
    clearSortByValues(shouldUpdate: shouldUpdate);
    clearFilterDataValues(shouldUpdate: shouldUpdate);
  }

}
