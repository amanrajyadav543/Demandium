import 'package:demandium/components/core_export.dart';

class ZoneModel {
  String? id;
  String? name;
  List<Coordinates>? formattedCoordinates;
  int? status;
  String? createdAt;
  String? updatedAt;


  ZoneModel({this.id, this.name, this.formattedCoordinates, this.status, this.createdAt, this.updatedAt});

  ZoneModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['formatted_coordinates'] != null) {
      formattedCoordinates = <Coordinates>[];
      json['formatted_coordinates'].forEach((v) {
        formattedCoordinates!.add(Coordinates.fromJson(v));
      });
    }
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    if (formattedCoordinates != null) {
      data['formatted_coordinates'] = formattedCoordinates!.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}


