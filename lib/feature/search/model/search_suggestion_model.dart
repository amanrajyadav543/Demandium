class SearchSuggestionModel {
  String? responseCode;
  String? message;
  List<SearchSuggestion>? searchSuggestionContent;

  SearchSuggestionModel({this.responseCode, this.message, this.searchSuggestionContent});

  SearchSuggestionModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    message = json['message'];
    if (json['content'] != null) {
      searchSuggestionContent = <SearchSuggestion>[];
      json['content'].forEach((v) {
        searchSuggestionContent!.add(SearchSuggestion.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['response_code'] = responseCode;
    data['message'] = message;
    if (searchSuggestionContent != null) {
      data['content'] = searchSuggestionContent!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SearchSuggestion {
  String? name;
  int? isSearched;

  SearchSuggestion({this.name, this.isSearched});

  SearchSuggestion.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    isSearched = json['is_searched'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['is_searched'] = isSearched;
    return data;
  }
}
