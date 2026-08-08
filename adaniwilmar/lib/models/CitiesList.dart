class CitiesList {
  int? zoneId;
  int? stateId;
  int? territoryId;
  int? districtId;
  int? cityId;

  CitiesList(
      {this.zoneId,
        this.stateId,
        this.territoryId,
        this.districtId,
        this.cityId});

  CitiesList.fromJson(Map<String, dynamic> json) {
    zoneId = json['zoneId'];
    stateId = json['stateId'];
    territoryId = json['territoryId'];
    districtId = json['districtId'];
    cityId = json['cityId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['zoneId'] = this.zoneId;
    data['stateId'] = this.stateId;
    data['territoryId'] = this.territoryId;
    data['districtId'] = this.districtId;
    data['cityId'] = this.cityId;
    return data;
  }
}