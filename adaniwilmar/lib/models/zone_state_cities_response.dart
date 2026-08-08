class ActiveStateResponse {
  int? stateId;
  String? stateName;

  ActiveStateResponse({this.stateId, this.stateName});

  ActiveStateResponse.fromJson(Map<String, dynamic> json) {
    stateId = json['stateId'];
    stateName = json['stateName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stateId'] = stateId;
    data['stateName'] = stateName;
    return data;
  }
}

class CityTerritory {
  int? cityId;
  String? cityName;
  int? districtId;
  String? districtName;
  int? stateId;
  String? stateName;
  int? territoryId;
  String? territoryName;
  int? zoneId;
  String? zoneName;
  bool? isChecked;

  CityTerritory(
      {this.cityId,
        this.cityName,
        this.districtId,
        this.districtName,
        this.stateId,
        this.stateName,
        this.territoryId,
        this.territoryName,
        this.zoneId,
        this.zoneName,
      this.isChecked = false});

  CityTerritory.fromJson(Map<String, dynamic> json) {
    cityId = json['cityId'];
    cityName = json['cityName'];
    districtId = json['districtId'];
    districtName = json['districtName'];
    stateId = json['stateId'];
    stateName = json['stateName'];
    territoryId = json['territoryId'];
    territoryName = json['territoryName'];
    zoneId = json['zoneId'];
    zoneName = json['zoneName'];
    isChecked = json['isChecked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cityId'] = cityId;
    data['cityName'] = cityName;
    data['districtId'] = districtId;
    data['districtName'] = districtName;
    data['stateId'] = stateId;
    data['stateName'] = stateName;
    data['territoryId'] = territoryId;
    data['territoryName'] = territoryName;
    data['zoneId'] = zoneId;
    data['zoneName'] = zoneName;
    data['isChecked'] = isChecked;
    return data;
  }
}
