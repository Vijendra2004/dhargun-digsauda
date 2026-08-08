class SaudaDetailModel {
   ModResponseData? response;
   String? message;

  SaudaDetailModel({
    this.response,
    this.message,
  });

  factory SaudaDetailModel.fromJson(Map<String, dynamic> json) {
    return SaudaDetailModel(
      response: json['response'] != null
          ? ModResponseData.fromJson(json['response'])
          : null,
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'response': response?.toJson(),
      'message': message,
    };
  }
}
class ModResponseData {
   int? id;
   String? saudaNumber;
   int? statusId;
   String? status;
   String? createdDate;
   String? createdByName;
   List<SaudaLine>? lines;

  ModResponseData({
    this.id,
    this.saudaNumber,
    this.statusId,
    this.status,
    this.createdDate,
    this.createdByName,
    this.lines,
  });

  factory ModResponseData.fromJson(Map<String, dynamic> json) {
    return ModResponseData(
      id: json['id'],
      saudaNumber: json['saudaNumber'],
      statusId: json['statusId'],
      status: json['status'],
      createdDate: json['createdDate'],
      createdByName: json['createdByName'],
      lines: (json['lines'] as List?)
          ?.map((e) => SaudaLine.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'saudaNumber': saudaNumber,
      'statusId': statusId,
      'status': status,
      'createdDate': createdDate,
      'createdByName': createdByName,
      'lines': lines?.map((e) => e.toJson()).toList(),
    };
  }
}
class SaudaLine {
   int? id;
   int? oilTypeId;
   String? oilTypeName;
   int? oilPackGroupTypeId;
   String? oilPackGroupTypeName;
   double? totalOriginalPendingQty;
   double? totalModifiedQty;
   List<SkuItem>? newItems;
   List<SkuItem>? oldItems;

  SaudaLine({
    this.id,
    this.oilTypeId,
    this.oilTypeName,
    this.oilPackGroupTypeId,
    this.oilPackGroupTypeName,
    this.totalOriginalPendingQty,
    this.totalModifiedQty,
    this.newItems,
    this.oldItems,
  });

  factory SaudaLine.fromJson(Map<String, dynamic> json) {
    return SaudaLine(
      id: json['id'],
      oilTypeId: json['oilTypeId'],
      oilTypeName: json['oilTypeName'],
      oilPackGroupTypeId: json['oilPackGroupTypeId'],
      oilPackGroupTypeName: json['oilPackGroupTypeName'],
      totalOriginalPendingQty:
      (json['totalOriginalPendingQty'] as num?)?.toDouble(),
      totalModifiedQty:
      (json['totalModifiedQty'] as num?)?.toDouble(),
      newItems: (json['newItems'] as List?)
          ?.map((e) => SkuItem.fromJson(e))
          .toList(),
      oldItems: (json['oldItems'] as List?)
          ?.map((e) => SkuItem.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'oilTypeId': oilTypeId,
      'oilTypeName': oilTypeName,
      'oilPackGroupTypeId': oilPackGroupTypeId,
      'oilPackGroupTypeName': oilPackGroupTypeName,
      'totalOriginalPendingQty': totalOriginalPendingQty,
      'totalModifiedQty': totalModifiedQty,
      'newItems': newItems?.map((e) => e.toJson()).toList(),
      'oldItems': oldItems?.map((e) => e.toJson()).toList(),
    };
  }
}
class SkuItem {
   int? skuId;
   String? skuName;
   double? quantityInCase;
   double? saudaQuantity;

  SkuItem({
    this.skuId,
    this.skuName,
    this.quantityInCase,
    this.saudaQuantity,
  });

  factory SkuItem.fromJson(Map<String, dynamic> json) {
    return SkuItem(
      skuId: json['skuId'],
      skuName: json['skuName'],
      quantityInCase:
      (json['quantityInCase'] as num?)?.toDouble(),
      saudaQuantity:
      (json['saudaQuantity'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'skuId': skuId,
      'skuName': skuName,
      'quantityInCase': quantityInCase,
      'saudaQuantity': saudaQuantity,
    };
  }
}
