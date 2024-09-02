import 'package:demandium/feature/notification/repository/notification_repo.dart';
import 'dart:convert';
import 'package:demandium/components/core_export.dart';

class SearchRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  SearchRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> getSearchData({required String query,required offset,String? sortBy, String? sortByType, double? minPrice, double ? maxPrice, String? rating, List<String>? categoryIdes }) async {
    // Codec<String, String> stringToBase64 = utf8.fuse(base64);
    // String encoded = stringToBase64.encode(query);

    Map<String, dynamic> data = {
      "string": query,
      "sort_by" : sortBy,
      "sort_by_type": sortByType,
      "min_price": minPrice,
      "max_price": maxPrice,
      "rating" : rating,
    };
    if(categoryIdes !=null && categoryIdes.isNotEmpty){
      data.addAll({
        "category_ids" : categoryIdes
      });
    }
    return await apiClient.postData("${AppConstants.searchUri}?limit=10&offset=$offset", data);
  }

  Future<Response> getSearchSuggestion({String? query}) async {
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = stringToBase64.encode(query??"");
    return apiClient.getData("${AppConstants.searchSuggestion}?string=$encoded");
  }

  Future<bool> saveSearchHistory(List<String> searchHistories) async {
    return await sharedPreferences.setStringList(AppConstants.searchHistory, searchHistories);
  }

  List<String> getSearchAddress() {
    return sharedPreferences.getStringList(AppConstants.searchHistory) ?? [];
  }

}
