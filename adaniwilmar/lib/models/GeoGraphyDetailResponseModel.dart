import 'CitiesList.dart';

class GeoGraphyDetailResponseModel {
  List<int>? skuIds;
  List<int>? stateIds;
  List<int>? zoneIds;
  List<CitiesList>? cities;

  GeoGraphyDetailResponseModel({this.skuIds, this.stateIds, this.zoneIds, this.cities});

  GeoGraphyDetailResponseModel.fromJson(Map<String, dynamic> json) {
    skuIds = json['skuIds'].cast<int>();
    stateIds = json['stateIds'].cast<int>();
    zoneIds = json['zoneIds'].cast<int>();
    if (json['cities'] != null) {
      cities = <CitiesList>[];
      json['cities'].forEach((v) {
        cities!.add(new CitiesList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['skuIds'] = this.skuIds;
    data['stateIds'] = this.stateIds;
    data['zoneIds'] = this.zoneIds;
    if (this.cities != null) {
      data['cities'] = this.cities!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

