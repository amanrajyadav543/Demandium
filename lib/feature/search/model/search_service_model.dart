import 'package:demandium/components/core_export.dart';

class SearchServiceModel {
  String? responseCode;
  String? message;
  Content? content;


  SearchServiceModel({this.responseCode, this.message, this.content});

  SearchServiceModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    message = json['message'];
    content =
    json['content'] != null ? Content.fromJson(json['content']) : null;

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['response_code'] = responseCode;
    data['message'] = message;
    if (content != null) {
      data['content'] = content!.toJson();
    }

    return data;
  }
}

class Content {
  double? initialMinPrice;
  double? initialMaxPrice;
  double? filteredMinPrice;
  double? filteredMaxPrice;
  ServiceContent? servicesContent;

  Content({this.initialMinPrice, this.initialMaxPrice, this.servicesContent});

  Content.fromJson(Map<String, dynamic> json) {
    initialMinPrice = double.tryParse(json['initial_min_price'].toString());
    initialMaxPrice = double.tryParse(json['initial_max_price'].toString());
    filteredMinPrice = double.tryParse(json['filter_min_price'].toString());
    filteredMaxPrice = double.tryParse(json['filter_max_price'].toString());
    servicesContent = json['services'] != null
        ? ServiceContent.fromJson(json['services'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['min_price'] = initialMinPrice;
    data['max_price'] = initialMaxPrice;
    if (servicesContent != null) {
      data['services'] = servicesContent!.toJson();
    }
    return data;
  }
}

