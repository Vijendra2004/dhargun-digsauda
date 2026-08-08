class DailyRate {
  String? skuName;
  int? skuId;
  int? plantDepotId;
  String? plantDepotName;
  double? finalPrice;

  DailyRate(
      {this.skuName,
      this.skuId,
      this.plantDepotId,
      this.plantDepotName,
      this.finalPrice});

  DailyRate.fromJson(Map<String, dynamic> json) {
    skuName = json['skuName'];
    skuId = json['skuId'];
    plantDepotId = json['plantDepotId'];
    plantDepotName = json['plantDepotName'];
    finalPrice = json['finalPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['skuName'] = skuName;
    data['skuId'] = skuId;
    data['plantDepotId'] = plantDepotId;
    data['plantDepotName'] = plantDepotName;
    data['finalPrice'] = finalPrice;
    return data;
  }
}

class SalesOrganization {
  int? id;
  String? salesOrganizationName;

  SalesOrganization({
    this.id,
    this.salesOrganizationName,
  });

  SalesOrganization.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    salesOrganizationName = json['salesOrganizationName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['salesOrganizationName'] = salesOrganizationName;
    return data;
  }
}

class DistributionChannel {
  int? id;
  String? distributionChannelName;
  DistributionChannel({
    this.id,
    this.distributionChannelName,
  });
  DistributionChannel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    distributionChannelName = json['distributionChannelName'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['distributionChannelName'] = distributionChannelName;
    return data;
  }
}

class Vertical {
  int? id;
  String? name;
  String? code;

  Vertical({this.id, this.name, this.code});
  Vertical.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['code'] = code;
    return data;
  }
}

class IncoTerms {
  int? id;
  String? name;
  String? code;
  int? type;
  bool? isActive;

  IncoTerms({this.id, this.name, this.code, this.type, this.isActive});

  IncoTerms.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    type = json['type'];
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['code'] = code;
    data['type'] = type;
    data['isActive'] = isActive;
    return data;
  }
}
