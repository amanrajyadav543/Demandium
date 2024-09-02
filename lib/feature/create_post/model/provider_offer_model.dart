import 'package:demandium/feature/provider/model/provider_model.dart';

class ProviderOfferModel {
  String? responseCode;
  String? message;
  Content? content;


  ProviderOfferModel(
      {this.responseCode, this.message, this.content,});

  ProviderOfferModel.fromJson(Map<String, dynamic> json) {
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
  int? currentPage;
  List<ProviderOfferData>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  String? path;
  String? perPage;
  int? to;
  int? total;

  Content(
      {this.currentPage,
        this.data,
        this.firstPageUrl,
        this.from,
        this.lastPage,
        this.lastPageUrl,
        this.path,
        this.perPage,
        this.to,
        this.total});

  Content.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <ProviderOfferData>[];
      json['data'].forEach((v) {
        data!.add(ProviderOfferData.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    path = json['path'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current_page'] = currentPage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = firstPageUrl;
    data['from'] = from;
    data['last_page'] = lastPage;
    data['last_page_url'] = lastPageUrl;
    data['path'] = path;
    data['per_page'] = perPage;
    data['to'] = to;
    data['total'] = total;
    return data;
  }
}

class ProviderOfferData {
  String? id;
  String? offeredPrice;
  String? providerNote;
  String? status;
  String? postId;
  String? providerId;
  String? createdAt;
  String? updatedAt;
  ProviderData ? provider;

  ProviderOfferData(
      {this.id,
        this.offeredPrice,
        this.providerNote,
        this.status,
        this.postId,
        this.providerId,
        this.createdAt,
        this.updatedAt,
        this.provider});

  ProviderOfferData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    offeredPrice = json['offered_price'];
    providerNote = json['provider_note'];
    status = json['status'];
    postId = json['post_id'];
    providerId = json['provider_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    provider = json['provider'] != null
        ? ProviderData.fromJson(json['provider'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['offered_price'] = offeredPrice;
    data['provider_note'] = providerNote;
    data['status'] = status;
    data['post_id'] = postId;
    data['provider_id'] = providerId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (provider != null) {
      data['provider'] = provider!.toJson();
    }
    return data;
  }
}

