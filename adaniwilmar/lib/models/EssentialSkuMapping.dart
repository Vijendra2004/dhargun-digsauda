class MandatorySkuMapping {
  final Response? response;
  final dynamic message;

  MandatorySkuMapping({
    this.response,
    this.message,
  });

  MandatorySkuMapping.fromJson(Map<String, dynamic> json)
      : response = (json['response'] as Map<String,dynamic>?) != null ? Response.fromJson(json['response'] as Map<String,dynamic>) : null,
        message = json['message'];

  Map<String, dynamic> toJson() => {
    'response' : response?.toJson(),
    'message' : message
  };
}

class Response {
  final int? id;
  final List<int>? essentialSkuId;
  final List<String>? essentialSkuName;
  final List<String>? essentialSkuCode;
  final bool? isActive;
  final List<MandatorySkuMappingList>? mandatorySkuMappingList;

  Response({
    this.id,
    this.essentialSkuId,
    this.essentialSkuName,
    this.essentialSkuCode,
    this.isActive,
    this.mandatorySkuMappingList,
  });

  Response.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        essentialSkuId = (json['essentialSkuId'] as List?)?.map((e) => e as int).toList(),
        essentialSkuName = (json['essentialSkuName'] as List?)?.map((e) => e as String).toList(),
        essentialSkuCode = (json['essentialSkuCode'] as List?)?.map((e) => e as String).toList(),
        isActive = json['isActive'] as bool?,
        mandatorySkuMappingList = (json['mandatorySkuMappingList'] as List?)
            ?.map((e) => MandatorySkuMappingList.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() => {
    'id': id,
    'essentialSkuId': essentialSkuId,
    'essentialSkuName': essentialSkuName,
    'essentialSkuCode': essentialSkuCode,
    'isActive': isActive,
    'mandatorySkuMappingList': mandatorySkuMappingList?.map((e) => e.toJson()).toList(),
  };
}


class MandatorySkuMappingList {
  final int? parentId;
  final int? mandatorySkuId;
  final String? mandatorySkuName;
  final String? mandatorySkuCode;
  final double? mandatoryBookingQuantityPercentage;
  double? mandatorySkuQuantity;
  bool? isFromMandatoryField;
  final int? pricingId;
  final int? oilTypeId;
  final double? mandatorySkuPrice;
  final double? employeeSkuPremium;
  final double? employeeSkuDiscount;
  final double? employeeSkuDiscountId;
  final double? employeeSkuPremiumId;
  final int? plantId;
  final double? caseToMetricTonValue;
  final int? uomId;
  final String? uom;
  final int? divisionId;
  final int? salesOrganizationId;
  final int? distributionChannelId;

  MandatorySkuMappingList({
    this.parentId,
    this.mandatorySkuId,
    this.mandatorySkuName,
    this.mandatorySkuCode,
    this.mandatoryBookingQuantityPercentage,
    this.mandatorySkuQuantity,
    this.pricingId,
    this.oilTypeId,
    this.isFromMandatoryField,
    this.mandatorySkuPrice,
    this.employeeSkuPremium,
    this.employeeSkuDiscount,
    this.employeeSkuDiscountId,
    this.employeeSkuPremiumId,
    this.plantId,
    this.caseToMetricTonValue,
    this.uomId,
    this.uom,
    this.divisionId,
    this.salesOrganizationId,
    this.distributionChannelId,
  });

  MandatorySkuMappingList.fromJson(Map<String, dynamic> json)
      : parentId = json['parentId'] as int?,
        mandatorySkuId = json['mandatorySkuId'] as int?,
        mandatorySkuName = json['mandatorySkuName'] as String?,
        mandatorySkuCode = json['mandatorySkuCode'] as String?,
        mandatoryBookingQuantityPercentage = (json['mandatoryBookingQuantityPercentage'] as num?)?.toDouble(),
        mandatorySkuQuantity = (json['mandatorySkuQuantity'] as num?)?.toDouble(),
        pricingId = json['pricingId'] as int?,
        oilTypeId = json['oilTypeId'] as int?,
        mandatorySkuPrice = (json['mandatorySkuPrice'] as num?)?.toDouble(),
        employeeSkuPremium = (json['employeeSkuPremium'] as num?)?.toDouble(),
        employeeSkuDiscount = (json['employeeSkuDiscount'] as num?)?.toDouble(),
        employeeSkuDiscountId = (json['employeeSkuDiscountId'] as num?)?.toDouble(),
        employeeSkuPremiumId = (json['employeeSkuPremiumId'] as num?)?.toDouble(),
        plantId = json['plantId'] as int?,
        caseToMetricTonValue = (json['caseToMetricTonValue'] as num?)?.toDouble(),
        uomId = json['uomId'] as int?,
        uom = json['uom'] as String?,
        divisionId = json['divisionId'] as int?,
        salesOrganizationId = json['salesOrganizationId'] as int?,
        distributionChannelId = json['distributionChannelId'] as int?;

  Map<String, dynamic> toJson() => {
    'parentId': parentId,
    'mandatorySkuId': mandatorySkuId,
    'mandatorySkuName': mandatorySkuName,
    'mandatorySkuCode': mandatorySkuCode,
    'mandatoryBookingQuantityPercentage': mandatoryBookingQuantityPercentage,
    'mandatorySkuQuantity': mandatorySkuQuantity,
    'pricingId': pricingId,
    'oilTypeId': oilTypeId,
    'mandatorySkuPrice': mandatorySkuPrice,
    'employeeSkuPremium': employeeSkuPremium,
    'employeeSkuDiscount': employeeSkuDiscount,
    'employeeSkuDiscountId': employeeSkuDiscountId,
    'employeeSkuPremiumId': employeeSkuPremiumId,
    'plantId': plantId,
    'caseToMetricTonValue': caseToMetricTonValue,
    'uomId': uomId,
    'uom': uom,
    'divisionId': divisionId,
    'salesOrganizationId': salesOrganizationId,
    'distributionChannelId': distributionChannelId,
  };
}



class Sku {
  final int? skuId;
  final double? quantity;
  final int? oilTypeId;

  Sku({
    this.skuId,
    this.quantity,
    this.oilTypeId,
  });

  Sku.fromJson(Map<String, dynamic> json)
      : skuId = json['SkuId'] as int?,
        quantity = (json['Quantity'] as num?)?.toDouble(),
        oilTypeId = json['OilTypeId'] as int?;

  Map<String, dynamic> toJson() => {
    'SkuId': skuId,
    'Quantity': quantity,
    'OilTypeId': oilTypeId,
  };
}
