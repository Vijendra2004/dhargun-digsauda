class PlanDepotList {
  int? id;
  int? userId;
  String? code;
  String? name;
  String? location;
  String? email;
  String? pinCode;
  String? zoneName;
  int? zoneId;
  int? areaId;
  String? area;
  int? cityId;
  String? city;
  int? districtId;
  String? district;
  int? stateId;
  String? state;
  int? territoryId;
  String? territoryName;
  int? associatedPlantId;
  String? associatedPlantName;
  bool? isActive;
  bool? isToReturnActiveData;
  bool? postStatus;
  String? postMessage;
  bool? isChecked;
  List<int>? mappedPlantIds;
  List<Areas>? areas;
  List<Depotlist>? depotlist;
  List<Depotlist>? rakelist;
  bool? isPlant;
  String? usage;
  String? plantCode;

  PlanDepotList(
      {this.id,
      this.userId,
      this.code,
      this.name,
      this.location,
      this.email,
      this.pinCode,
      this.zoneName,
      this.zoneId,
      this.areaId,
      this.area,
      this.cityId,
      this.city,
      this.districtId,
      this.district,
      this.stateId,
      this.state,
      this.territoryId,
      this.territoryName,
      this.associatedPlantId,
      this.associatedPlantName,
      this.isActive,
      this.isToReturnActiveData,
      this.postStatus,
      this.postMessage,
      this.isChecked,
      this.mappedPlantIds,
      this.areas,
      this.depotlist,
      this.rakelist,
      this.isPlant,
      this.usage,
      this.plantCode});

  PlanDepotList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    code = json['code'];
    name = json['name'];
    location = json['location'];
    email = json['email'];
    pinCode = json['pinCode'];
    zoneName = json['zoneName'];
    zoneId = json['zoneId'];
    areaId = json['areaId'];
    area = json['area'];
    cityId = json['cityId'];
    city = json['city'];
    districtId = json['districtId'];
    district = json['district'];
    stateId = json['stateId'];
    state = json['state'];
    territoryId = json['territoryId'];
    territoryName = json['territoryName'];
    associatedPlantId = json['associatedPlantId'];
    associatedPlantName = json['associatedPlantName'];
    isActive = json['isActive'];
    isToReturnActiveData = json['isToReturnActiveData'];
    postStatus = json['postStatus'];
    postMessage = json['postMessage'];
    isChecked = json['isChecked'];
    if (json['mappedPlantIds'] != null) {
      mappedPlantIds = json['mappedPlantIds'].cast<int>();
    }
    if (json['areas'] != null) {
      areas = <Areas>[];
      json['areas'].forEach((v) {
        areas!.add(Areas.fromJson(v));
      });
    }
    if (json['depotlist'] != null) {
      depotlist = <Depotlist>[];
      json['depotlist'].forEach((v) {
        depotlist!.add(Depotlist.fromJson(v));
      });
    }
    if (json['rakelist'] != null) {
      rakelist = <Depotlist>[];
      json['rakelist'].forEach((v) {
        rakelist!.add(Depotlist.fromJson(v));
      });
    }
    isPlant = json['isPlant'];
    usage = json['usage'];
    plantCode = json['plantCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['code'] = code;
    data['name'] = name;
    data['location'] = location;
    data['email'] = email;
    data['pinCode'] = pinCode;
    data['zoneName'] = zoneName;
    data['zoneId'] = zoneId;
    data['areaId'] = areaId;
    data['area'] = area;
    data['cityId'] = cityId;
    data['city'] = city;
    data['districtId'] = districtId;
    data['district'] = district;
    data['stateId'] = stateId;
    data['state'] = state;
    data['territoryId'] = territoryId;
    data['territoryName'] = territoryName;
    data['associatedPlantId'] = associatedPlantId;
    data['associatedPlantName'] = associatedPlantName;
    data['isActive'] = isActive;
    data['isToReturnActiveData'] = isToReturnActiveData;
    data['postStatus'] = postStatus;
    data['postMessage'] = postMessage;
    data['isChecked'] = isChecked;
    data['mappedPlantIds'] = mappedPlantIds;
    if (areas != null) {
      data['areas'] = areas!.map((v) => v.toJson()).toList();
    }
    if (depotlist != null) {
      data['depotlist'] = depotlist!.map((v) => v.toJson()).toList();
    }
    if (rakelist != null) {
      data['rakelist'] = rakelist!.map((v) => v.toJson()).toList();
    }
    data['isPlant'] = isPlant;
    data['usage'] = usage;
    data['plantCode'] = plantCode;
    return data;
  }
}

class Areas {
  int? areaId;
  String? areaName;

  Areas({this.areaId, this.areaName});

  Areas.fromJson(Map<String, dynamic> json) {
    areaId = json['areaId'];
    areaName = json['areaName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['areaId'] = areaId;
    data['areaName'] = areaName;
    return data;
  }
}

class Depotlist {
  int? id;
  String? code;
  String? name;
  String? location;
  String? email;
  String? pinCode;
  String? zoneName;
  String? zoneId;
  int? areaId;
  String? area;
  int? cityId;
  String? city;
  int? districtId;
  String? district;
  int? stateId;
  String? state;
  int? territoryId;
  String? territoryName;
  int? associatedPlantId;
  String? associatedPlantName;
  bool? isActive;
  bool? isToReturnActiveData;
  bool? postStatus;
  String? postMessage;
  bool? isChecked;

  Depotlist(
      {this.id,
      this.code,
      this.name,
      this.location,
      this.email,
      this.pinCode,
      this.zoneName,
      this.zoneId,
      this.areaId,
      this.area,
      this.cityId,
      this.city,
      this.districtId,
      this.district,
      this.stateId,
      this.state,
      this.territoryId,
      this.territoryName,
      this.associatedPlantId,
      this.associatedPlantName,
      this.isActive,
      this.isToReturnActiveData,
      this.postStatus,
      this.postMessage,
      this.isChecked});

  Depotlist.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    name = json['name'];
    location = json['location'];
    email = json['email'];
    pinCode = json['pinCode'];
    zoneName = json['zoneName'];
    zoneId = json['zoneId'];
    areaId = json['areaId'];
    area = json['area'];
    cityId = json['cityId'];
    city = json['city'];
    districtId = json['districtId'];
    district = json['district'];
    stateId = json['stateId'];
    state = json['state'];
    territoryId = json['territoryId'];
    territoryName = json['territoryName'];
    associatedPlantId = json['associatedPlantId'];
    associatedPlantName = json['associatedPlantName'];
    isActive = json['isActive'];
    isToReturnActiveData = json['isToReturnActiveData'];
    postStatus = json['postStatus'];
    postMessage = json['postMessage'];
    isChecked = json['isChecked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['code'] = code;
    data['name'] = name;
    data['location'] = location;
    data['email'] = email;
    data['pinCode'] = pinCode;
    data['zoneName'] = zoneName;
    data['zoneId'] = zoneId;
    data['areaId'] = areaId;
    data['area'] = area;
    data['cityId'] = cityId;
    data['city'] = city;
    data['districtId'] = districtId;
    data['district'] = district;
    data['stateId'] = stateId;
    data['state'] = state;
    data['territoryId'] = territoryId;
    data['territoryName'] = territoryName;
    data['associatedPlantId'] = associatedPlantId;
    data['associatedPlantName'] = associatedPlantName;
    data['isActive'] = isActive;
    data['isToReturnActiveData'] = isToReturnActiveData;
    data['postStatus'] = postStatus;
    data['postMessage'] = postMessage;
    data['isChecked'] = isChecked;
    return data;
  }
}
