class ModOilMaterialResponse {
  final List<ModOilMaterial> response;
  final String? message;

  ModOilMaterialResponse({
    required this.response,
    this.message,
  });

  factory ModOilMaterialResponse.fromJson(Map<String, dynamic> json) {
    return ModOilMaterialResponse(
      response: (json['response'] as List)
          .map((e) => ModOilMaterial.fromJson(e))
          .toList(),
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'response': response.map((e) => e.toJson()).toList(),
      'message': message,
    };
  }
}
class ModOilMaterial {
   int? oilTypeId;
   String? oilTypeName;
   List<ModOilMaterialItem>? materials;

  ModOilMaterial({
    this.oilTypeId,
    this.oilTypeName,
    this.materials,
  });

  factory ModOilMaterial.fromJson(Map<String, dynamic> json) {
    return ModOilMaterial(
      oilTypeId: json['oilTypeId'],
      oilTypeName: json['oilTypeName'],
      materials: (json['materials'] as List)
          .map((e) => ModOilMaterialItem.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'oilTypeId': oilTypeId,
      'oilTypeName': oilTypeName,
      'materials': materials?.map((e) => e.toJson()).toList(),
    };
  }
}
class ModOilMaterialItem {
   int? id;
   String? skuCode;
   String? skuName;
   double? pendingQuantityInCase;
   double? saudaQuantity;
   double? caseToMetricTonValue;

  ModOilMaterialItem({
    this.id,
     this.skuCode,
     this.skuName,
     this.pendingQuantityInCase,
     this.saudaQuantity,
     this.caseToMetricTonValue,
  });

  factory ModOilMaterialItem.fromJson(Map<String, dynamic> json) {
    return ModOilMaterialItem(
      id: json['id'],
      skuCode: json['skuCode'],
      skuName: json['skuName'],
      pendingQuantityInCase:
      (json['pendingQuantityInCase'] as num).toDouble(),
      saudaQuantity: (json['saudaQuantity'] as num).toDouble(),
      caseToMetricTonValue:
      (json['caseToMetricTonValue'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'skuCode': skuCode,
      'skuName': skuName,
      'pendingQuantityInCase': pendingQuantityInCase,
      'saudaQuantity': saudaQuantity,
      'caseToMetricTonValue': caseToMetricTonValue,
    };
  }
}

