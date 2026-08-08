class OilResponseModel {
   oilResponseData? response;
   String? message;

  OilResponseModel({this.response, this.message});

  factory OilResponseModel.fromJson(Map<String, dynamic> json) {
    return OilResponseModel(
      response: json['response'] != null
          ? oilResponseData.fromJson(json['response'])
          : null,
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "response": response?.toJson(),
      "message": message,
    };
  }
}
class oilResponseData {
   List<OilType>? oilTypes;

  oilResponseData({this.oilTypes});

  factory oilResponseData.fromJson(Map<String, dynamic> json) {
    return oilResponseData(
      oilTypes: json['oilTypes'] != null
          ? List.from(json['oilTypes'])
          .map((e) => OilType.fromJson(e))
          .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "oilTypes": oilTypes?.map((e) => e.toJson()).toList(),
    };
  }
}
class OilType {
   int? oilTypeId;
   String? oilTypeName;
   List<PackType>? packTypes;

  OilType({this.oilTypeId, this.oilTypeName, this.packTypes});

  factory OilType.fromJson(Map<String, dynamic> json) {
    return OilType(
      oilTypeId: json['oilTypeId'],
      oilTypeName: json['oilTypeName'],
      packTypes: json['packTypes'] != null
          ? List.from(json['packTypes'])
          .map((e) => PackType.fromJson(e))
          .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "oilTypeId": oilTypeId,
      "oilTypeName": oilTypeName,
      "packTypes": packTypes?.map((e) => e.toJson()).toList(),
    };
  }
}

class PackType {
   int? packTypeId;
   String? packTypeName;
   double? originalMT;
   double? modifiedMT;
   double? differenceMT;
   double? totalQtyCase;
   List<Sku>? skus;

  PackType({
    this.packTypeId,
    this.packTypeName,
    this.originalMT,
    this.modifiedMT,
    this.differenceMT,
    this.totalQtyCase,
    this.skus,
  });

  factory PackType.fromJson(Map<String, dynamic> json) {
    return PackType(
      packTypeId: json['packTypeId'],
      packTypeName: json['packTypeName'],
      originalMT: (json['originalMT'] as num?)?.toDouble(),
      modifiedMT: (json['modifiedMT'] as num?)?.toDouble(),
      differenceMT: (json['differenceMT'] as num?)?.toDouble(),
      totalQtyCase: (json['totalQtyCase'] as num?)?.toDouble(),
      skus: json['skus'] != null
          ? List.from(json['skus']).map((e) => Sku.fromJson(e)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "packTypeId": packTypeId,
      "packTypeName": packTypeName,
      "originalMT": originalMT,
      "modifiedMT": modifiedMT,
      "differenceMT": differenceMT,
      "totalQtyCase": 0,
      "skus": skus?.map((e) => e.toJson()).toList(),
    };
  }
}

class Sku {
   int? skuId;
   String? skuName;
   String? skuCode;
   double? basicRate=0;
   double? pendingQuantityInCase;
   double? pendingQuantityInCaseCopy;
   double? saudaQuantity;
   double? caseToMetricTonValue;
   bool? isDelete = false;
   double? price = 0;
   double? employeeSkuDiscount = 0;

  Sku({
    this.skuId,
    this.skuName,
    this.skuCode,
    this.basicRate,
    this.pendingQuantityInCase,
    this.pendingQuantityInCaseCopy,
    this.saudaQuantity,
    this.caseToMetricTonValue,
    this.isDelete,
    this.price,
    this.employeeSkuDiscount,
  });

  factory Sku.fromJson(Map<String, dynamic> json) {
    return Sku(
      skuId: json['skuId'],
      skuName: json['skuName'],
      skuCode: json['skuCode']??"",
      basicRate: json['basicRate']??0.toDouble(),
      pendingQuantityInCase:
      (json['pendingQuantityInCase'] as num?)?.toDouble(),
      pendingQuantityInCaseCopy: (json['pendingQuantityInCase'] as num?)?.toDouble(),
      saudaQuantity: (json['saudaQuantity'] as num?)?.toDouble(),
      caseToMetricTonValue:
      (json['caseToMetricTonValue'] as num?)?.toDouble(), isDelete: false,
      price:
      (json['price'] ?? json['basicRate']).toDouble(),
      employeeSkuDiscount:
      (json['employeeSkuDiscount'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "skuId": skuId,
      "skuName": skuName,
      "skuCode": skuCode,
      "basicRate": basicRate,
      "pendingQuantityInCase": pendingQuantityInCase,
      "pendingQuantityInCaseCopy": pendingQuantityInCaseCopy,
      "saudaQuantity": saudaQuantity,
      "caseToMetricTonValue": caseToMetricTonValue,
      "isDelete": isDelete,
      "price" : price,
      "employeeSkuDiscount" : employeeSkuDiscount
    };
  }
}
