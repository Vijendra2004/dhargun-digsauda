class PendingContractFilterValue {
  List<PackGroup>? packGroup;
  List<OilTypesPendingContractReport>? oilTypesPendingContractReport;

  PendingContractFilterValue(
      {this.packGroup, this.oilTypesPendingContractReport});

  PendingContractFilterValue.fromJson(Map<String, dynamic> json) {
    if (json['packGroup'] != null) {
      packGroup = <PackGroup>[];
      json['packGroup'].forEach((v) {
        packGroup!.add(PackGroup.fromJson(v));
      });
    }
    if (json['oilTypesPendingContractReport'] != null) {
      oilTypesPendingContractReport = <OilTypesPendingContractReport>[];
      json['oilTypesPendingContractReport'].forEach((v) {
        oilTypesPendingContractReport!
            .add(OilTypesPendingContractReport.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (packGroup != null) {
      data['packGroup'] = packGroup!.map((v) => v.toJson()).toList();
    }
    if (oilTypesPendingContractReport != null) {
      data['oilTypesPendingContractReport'] =
          oilTypesPendingContractReport!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PackGroup {
  int? id;
  String? name;
  bool? isActive;

  PackGroup({this.id, this.name, this.isActive});

  PackGroup.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['isActive'] = isActive;
    return data;
  }
}

class OilTypesPendingContractReport {
  int? oilTypeId;
  String? oilTypeName;
  List<SkuandPackGroup>? skuandPackGroup;

  OilTypesPendingContractReport(
      {this.oilTypeId, this.oilTypeName, this.skuandPackGroup});

  OilTypesPendingContractReport.fromJson(Map<String, dynamic> json) {
    oilTypeId = json['oilTypeId'];
    oilTypeName = json['oilTypeName'];
    if (json['skuandPackGroup'] != null) {
      skuandPackGroup = <SkuandPackGroup>[];
      json['skuandPackGroup'].forEach((v) {
        skuandPackGroup!.add(SkuandPackGroup.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['oilTypeId'] = oilTypeId;
    data['oilTypeName'] = oilTypeName;
    if (skuandPackGroup != null) {
      data['skuandPackGroup'] =
          skuandPackGroup!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SkuandPackGroup {
  int? skuId;
  String? skuName;
  int? packGroupId;
  String? packGroupName;

  SkuandPackGroup(
      {this.skuId, this.skuName, this.packGroupId, this.packGroupName});

  SkuandPackGroup.fromJson(Map<String, dynamic> json) {
    skuId = json['skuId'];
    skuName = json['skuName'];
    packGroupId = json['packGroupId'];
    packGroupName = json['packGroupName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['skuId'] = skuId;
    data['skuName'] = skuName;
    data['packGroupId'] = packGroupId;
    data['packGroupName'] = packGroupName;
    return data;
  }
}
