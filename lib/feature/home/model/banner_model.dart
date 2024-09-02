import 'package:demandium/components/core_export.dart';

class BannerContentModel {

  List<BannerModel>? _data;

  BannerContentModel( {List<BannerModel>? data}) {
    if (data != null) {
      _data = data;
    }
  }

  List<BannerModel>? get data => _data;

  BannerContentModel.fromJson(Map<String, dynamic> json) {

    if (json['data'] != null) {
      _data = <BannerModel>[];
      json['data'].forEach((v) {
        _data!.add(BannerModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (_data != null) {
      data['data'] = _data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BannerModel {
  String? _id;
  String? _bannerTitle;
  String? _resourceType;
  String? _resourceId;
  String? _redirectLink;
  String? _bannerImage;
  String? _bannerImageFullPath;
  String? _createdAt;
  String? _updatedAt;
  Service? _service;
  CategoryModel? _category;

  BannerModel(
      {String? id,
        String? bannerTitle,
        String? resourceType,
        String? resourceId,
        String? redirectLink,
        String? bannerImage,
        String? bannerImageFullPath,
        String? createdAt,
        String? updatedAt,
        Service? service,
        CategoryModel? category}) {
    if (id != null) {
      _id = id;
    }
    if (bannerTitle != null) {
      _bannerTitle = bannerTitle;
    }
    if (resourceType != null) {
      _resourceType = resourceType;
    }
    if (resourceId != null) {
      _resourceId = resourceId;
    }
    if (redirectLink != null) {
      _redirectLink = redirectLink;
    }
    if (bannerImage != null) {
      _bannerImage = bannerImage;
    }
    if (bannerImageFullPath != null) {
      _bannerImageFullPath = bannerImageFullPath;
    }
    if (createdAt != null) {
      _createdAt = createdAt;
    }
    if (updatedAt != null) {
      _updatedAt = updatedAt;
    }
    if (service != null) {
      _service = service;
    }
    if (category != null) {
      _category = category;
    }
  }

  String? get id => _id;
  String? get bannerTitle => _bannerTitle;
  String? get resourceType => _resourceType;
  String? get resourceId => _resourceId;
  String? get redirectLink => _redirectLink;
  String? get bannerImage => _bannerImage;
  String? get bannerImageFullPath => _bannerImageFullPath;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  Service? get service => _service;
  CategoryModel? get category => _category;


  BannerModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _bannerTitle = json['banner_title'];
    _resourceType = json['resource_type'];
    _resourceId = json['resource_id'];
    _redirectLink = json['redirect_link'];
    _bannerImage = json['banner_image'];
    _bannerImageFullPath = json['banner_image_full_path'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _service = json['service'] != null ? Service.fromJson(json['service']) : null;
    _category = json['category'] != null
        ? CategoryModel.fromJson(json['category'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['banner_title'] = _bannerTitle;
    data['resource_type'] = _resourceType;
    data['resource_id'] = _resourceId;
    data['redirect_link'] = _redirectLink;
    data['banner_image'] = _bannerImage;
    data['banner_image_full_path'] = _bannerImageFullPath;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;
    if (_service != null) {
      data['service'] = _service!.toJson();
    }
    if (_category != null) {
      data['category'] = _category!.toJson();
    }
    return data;
  }
}
