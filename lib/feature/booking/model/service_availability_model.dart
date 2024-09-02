
class ServiceAvailabilityModel {
  String? responseCode;
  String? message;
  Content? content;

  ServiceAvailabilityModel({this.responseCode, this.message, this.content});

  ServiceAvailabilityModel.fromJson(Map<String, dynamic> json) {
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
  int? isProviderAvailable;
  int? isServiceInfoUnchanged;
  List<Services>? services;

  Content({this.isProviderAvailable, this.isServiceInfoUnchanged, this.services});

  Content.fromJson(Map<String, dynamic> json) {
    isProviderAvailable = json['is_provider_available'];
    isServiceInfoUnchanged = json['is_service_info_unchanged'];
    if (json['services'] != null) {
      services = <Services>[];
      json['services'].forEach((v) {
        services!.add(Services.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_provider_available'] = isProviderAvailable;
    data['is_service_info_unchanged'] = isServiceInfoUnchanged;
    if (services != null) {
      data['services'] = services!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Services {
  String? serviceId;
  String? serviceName;
  String? variantKey;
  double? serviceCost;
  double? bookingServiceCost;
  int? isAvailable;
  int? isPriceChanged;

  Services(
      {this.serviceId,
        this.serviceName,
        this.variantKey,
        this.serviceCost,
        this.bookingServiceCost,
        this.isAvailable,
        this.isPriceChanged});

  Services.fromJson(Map<String, dynamic> json) {
    serviceId = json['service_id'];
    serviceName = json['service_name'];
    variantKey = json['variant_key'];
    if(json['service_unit_cost'] != null){
      serviceCost = double.parse(json['service_unit_cost'].toString());
    }
    if(json['booking_service_unit_cost'] != null) {
      bookingServiceCost = double.parse(json['booking_service_unit_cost'].toString());
    }
    isAvailable = json['is_available'];
    isPriceChanged = json['is_price_changed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['service_id'] = serviceId;
    data['service_name'] = serviceName;
    data['variant_key'] = variantKey;
    data['service_cost'] = serviceCost;
    data['booking_service_cost'] = bookingServiceCost;
    data['is_available'] = isAvailable;
    data['is_price_changed'] = isPriceChanged;
    return data;
  }
}