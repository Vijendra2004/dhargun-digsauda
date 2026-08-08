class SalesReport {
  SalesReport(
      {this.oilTypeId,
      this.packGroupId,
      this.oilType,
      this.quantityInMT,
      this.materialType,
      this.skuReport});

  int? oilTypeId;
  int? packGroupId;
  String? oilType;
  double? quantityInMT;
  double? quantityCase;
  double? premiumquantityInMT;
  double? bakeryquantityInMT;
  double? lauricquantityInMT;
  double? popularquantityInMT;
  String? materialType;
  List<SKUListReport>? skuReport;

  SalesReport.fromJson(Map<String, dynamic> json) {
    oilTypeId = json['oilTypeId'];
    packGroupId = json['packGroupId'];
    oilType = json['oilType'];
    quantityCase = json['quantityCase'];
    quantityInMT = json['quantityInMT'];
    premiumquantityInMT = json['premiumquantityInMT'];
    bakeryquantityInMT = json['bakeryquantityInMT'];
    lauricquantityInMT = json['lauricquantityInMT'];
    popularquantityInMT = json['popularquantityInMT'];
    materialType = json['materialType'];
    if (json['skuListReportDto'] != null) {
      skuReport = <SKUListReport>[];
      json['skuListReportDto'].forEach((v) {
        skuReport!.add(SKUListReport.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['oilTypeId'] = oilTypeId;
    _data['packGroupId'] = packGroupId;
    _data['oilType'] = oilType;
    _data['quantityInMT'] = quantityInMT;
    _data['quantityCase'] = quantityCase;
    _data['premiumquantityInMT'] = premiumquantityInMT;
    _data['bakeryquantityInMT'] = bakeryquantityInMT;
    _data['lauricquantityInMT'] = lauricquantityInMT;
    _data['popularquantityInMT'] = popularquantityInMT;
    _data['materialType'] = materialType;
    if (skuReport != null) {
      _data['rakelist'] = skuReport!.map((v) => v.toJson()).toList();
    }
    return _data;
  }
}

class SKUListReport {
  String? skuName;
  double? bidQuantity;
  double? bidQuantityCase;

  SKUListReport.fromJson(Map<String, dynamic> json) {
    skuName = json['skuName'];
    bidQuantityCase = json['bidQuantityCase'];
    bidQuantity = json['bidQuantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['skuName'] = skuName;
    data['bidQuantityCase'] = bidQuantityCase;
    data['bidQuantity'] = bidQuantity;
    return data;
  }
}

class SaudaNHReport {

  SaudaNHReport ({this.totalQuantity,this.quantityCase,required this.saudaNHReportStateList});

  double? totalQuantity;
  double? quantityCase;
  List<SaudaNHReportStateList> saudaNHReportStateList = <SaudaNHReportStateList>[];

  SaudaNHReport.fromJson(Map<String, dynamic> json) {
    totalQuantity = json['quantityInMT'];
    quantityCase = json['quantityCase'];
    if (json['stateList'] != null) {
      saudaNHReportStateList = <SaudaNHReportStateList>[];
      json['stateList'].forEach((v) {
        saudaNHReportStateList!.add(SaudaNHReportStateList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['quantityInMT'] = totalQuantity;
    data['quantityCase'] = quantityCase;
    if (saudaNHReportStateList != null) {
      data['stateList'] =
          saudaNHReportStateList!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class SaudaNHReportStateList {
  int? stateId;
  String? stateName;
  double? totalStateQuantity;
  double? totalQuantityCase;
  List<SaudaNHReportOilTypeList> saudaNHReportOilTypeList = <SaudaNHReportOilTypeList>[];

  SaudaNHReportStateList.fromJson(Map<String, dynamic> json) {
    stateId = json['stateId'];
    stateName = json['stateName'];
    totalStateQuantity = json['quantityInMT'];
    totalQuantityCase = json['quantityCase'];

    if (json['oilTypes'] != null) {
      saudaNHReportOilTypeList = <SaudaNHReportOilTypeList>[];
      json['oilTypes'].forEach((v) {
        saudaNHReportOilTypeList!.add(SaudaNHReportOilTypeList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['stateId'] = stateId;
    data['stateName'] = stateName;
    data['quantityCase'] = totalQuantityCase;
    data['quantityInMT'] = totalStateQuantity;
    if (saudaNHReportOilTypeList != null) {
      data['oilTypes'] =
          saudaNHReportOilTypeList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SaudaNHReportOilTypeList {
  int? oilTypeId;
  String? oilType;
  double? totalOilTypeQuantity;
  double? quantityCase;
  List<SKUListReport>? saudaListReport = <SKUListReport>[];

  SaudaNHReportOilTypeList.fromJson(Map<String, dynamic> json) {
    oilType = json['oilType'];
    oilTypeId = json['oilTypeId'];
    totalOilTypeQuantity = json['quantityInMT'];
    quantityCase = json['quantityCase'];
    if (json['skuListReportDto'] != null) {
      saudaListReport = <SKUListReport>[];
      json['skuListReportDto'].forEach((v) {
        saudaListReport!.add(SKUListReport.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['oilType'] = oilType;
    data['oilTypeId'] = oilTypeId;
    data['quantityInMT'] = totalOilTypeQuantity;
    data['quantityCase'] = quantityCase;
    if (saudaListReport != null) {
      data['skuListReportDto'] =
          saudaListReport!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
