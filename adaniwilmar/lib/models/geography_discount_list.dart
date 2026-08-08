class GeographyDiscountList {
  int? id;
  String? encryptedId;
  int? salesOrganizationId;
  String? salesOrganization;
  int? distributionChannelId;
  String? distributionChannel;
  int? divisionId;
  String? division;
  String? discountReason;
  int? oilTypeId;
  String? packGroupId;
  int? packGroupTypeId;
  String? oilTypeName;
  String? oilTypeCode;
  int? skuId;
  String? skuName;
  String? skuCode;
  double? actualDiscount;
  bool? isActive;
  String? validFrom;
  String? validTo;
  int? loginUserId;
  bool? postStatus;
  String? postMessage;
  int? parentId;
  List<int>? skuIds;
  List<int>? stateIds;
  List<int>? zoneIds;
  List<Cities>? cities;

  GeographyDiscountList({
    this.id,
    this.encryptedId,
    this.salesOrganizationId,
    this.salesOrganization,
    this.distributionChannelId,
    this.distributionChannel,
    this.divisionId,
    this.division,
    this.discountReason,
    this.oilTypeId,
    this.packGroupId,
    this.packGroupTypeId,
    this.oilTypeName,
    this.oilTypeCode,
    this.skuId,
    this.skuName,
    this.skuCode,
    this.actualDiscount,
    this.isActive,
    this.validFrom,
    this.validTo,
    this.loginUserId,
    this.postStatus,
    this.postMessage,
    this.parentId,
    this.skuIds,
    this.stateIds,
    this.zoneIds,
    this.cities,
  });

  factory GeographyDiscountList.fromJson(Map<String, dynamic> json) {
    return GeographyDiscountList(
      id: json['id'],
      encryptedId: json['encryptedId'],
      salesOrganizationId: json['salesOrganizationId'],
      salesOrganization: json['salesOrganization'],
      distributionChannelId: json['distributionChannelId'],
      distributionChannel: json['distributionChannel'],
      divisionId: json['divisionId'],
      division: json['division'],
      discountReason: json['discountReason'],
      oilTypeId: json['oilTypeId'],
      packGroupId: json['packGroupId'],
      packGroupTypeId: json['packTypeId'],
      oilTypeName: json['oilTypeName'],
      oilTypeCode: json['oilTypeCode'],
      skuId: json['skuId'],
      skuName: json['skuName'],
      skuCode: json['skuCode'],
      actualDiscount: json['actualDiscount']?.toDouble(),
      isActive: json['isActive'],
      validFrom: json['validFrom'],
      validTo: json['validTo'],
      loginUserId: json['loginUserId'],
      postStatus: json['postStatus'],
      postMessage: json['postMessage'],
      parentId: json['parentId'],
      skuIds: List<int>.from(json['skuIds'] ?? []),
      stateIds: List<int>.from(json['stateIds'] ?? []),
      zoneIds: List<int>.from(json['zoneIds'] ?? []),
      cities: json['cities'] != null
          ? List<Cities>.from(json['cities'].map((x) => Cities.fromJson(x)))
          : null,
    );
  }
}

class Cities {
  int? zoneId;
  int? stateId;
  int? territoryId;
  int? districtId;
  int? cityId;

  Cities({
    this.zoneId,
    this.stateId,
    this.territoryId,
    this.districtId,
    this.cityId,
  });

  factory Cities.fromJson(Map<String, dynamic> json) {
    return Cities(
      zoneId: json['zoneId'],
      stateId: json['stateId'],
      territoryId: json['territoryId'],
      districtId: json['districtId'],
      cityId: json['cityId'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ZoneId'] = this.zoneId;
    data['StateId'] = this.stateId;
    data['TerritoryId'] = this.territoryId;
    data['DistrictId'] = this.districtId;
    data['CityId'] = this.cityId;
    return data;
  }
}