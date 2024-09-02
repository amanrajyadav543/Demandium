import 'package:demandium/feature/category/model/category_model.dart';

class SuggestedServiceModel {
  Content? content;
  SuggestedServiceModel({ this.content});
  SuggestedServiceModel.fromJson(Map<String, dynamic> json) {
    content = json['content'] != null ? Content.fromJson(json['content']) : null;

  }
  
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (content != null) {
      data['content'] = content!.toJson();
    }
    return data;
  }
}

class Content {
  int? currentPage;
  List<SuggestedService>? suggestedServiceList;
  int? lastPage;
  String? lastPageUrl;
  int? total;

  Content(
      {this.currentPage,
        this.suggestedServiceList,
        this.lastPage,
        this.lastPageUrl,
        this.total});

  Content.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      suggestedServiceList = <SuggestedService>[];
      json['data'].forEach((v) {
        suggestedServiceList!.add(SuggestedService.fromJson(v));
      });
    }
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current_page'] = currentPage;
    if (suggestedServiceList != null) {
      data['data'] = suggestedServiceList!.map((v) => v.toJson()).toList();
    }
    data['last_page'] = lastPage;
    data['last_page_url'] = lastPageUrl;
    data['total'] = total;
    return data;
  }
}

class SuggestedService {
  String? id;
  String? categoryId;
  String? serviceName;
  String? serviceDescription;
  String? status;
  String? adminFeedback;
  String? userId;
  String? createdAt;
  String? updatedAt;
  CategoryModel? category;

  SuggestedService(
      {this.id,
        this.categoryId,
        this.serviceName,
        this.serviceDescription,
        this.status,
        this.adminFeedback,
        this.userId,
        this.createdAt,
        this.updatedAt,
        this.category});

  SuggestedService.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    serviceName = json['service_name'];
    serviceDescription = json['service_description'];
    status = json['status'];
    adminFeedback = json['admin_feedback'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    category = json['category'] != null
        ? CategoryModel.fromJson(json['category'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['category_id'] = categoryId;
    data['service_name'] = serviceName;
    data['service_description'] = serviceDescription;
    data['status'] = status;
    data['admin_feedback'] = adminFeedback;
    data['user_id'] = userId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (category != null) {
      data['category'] = category!.toJson();
    }
    return data;
  }
}
