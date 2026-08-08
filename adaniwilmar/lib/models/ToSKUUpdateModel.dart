class ToSKUUpdateModel {
  final List<ToSKUItem>? response;
  final String? message;

  ToSKUUpdateModel({
     this.response,
    this.message,
  });

  factory ToSKUUpdateModel.fromJson(Map<String, dynamic> json) {
    return ToSKUUpdateModel(
      response: json['response'] != null
          ? (json['response'] as List)
          .map((e) => ToSKUItem.fromJson(e))
          .toList()
          : [],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'response': response?.map((e) => e.toJson()).toList(),
      'message': message,
    };
  }
}

class ToSKUItem {
  final int? pricingId;
  final int? skuId;
  final String? skuName;
  final int? oilTypeId;
  double? price =0;
  final double? employeeSkuPremium;
  final int? employeeSkuPremiumId;
  double? employeeSkuDiscount=0;
  final int? employeeSkuDiscountId;
  final int? plantId;
  final double? caseToMetricTonValue;
  final int? uomId;
  final String? uom;
  final int? divisionId;
  final int? salesOrganizationId;
  final int? distributionChannelId;
  final int? oilPackGroupTypeId;

  ToSKUItem({
     this.pricingId,
     this.skuId,
     this.skuName,
     this.oilTypeId,
     this.price,
     this.employeeSkuPremium,
     this.employeeSkuPremiumId,
     this.employeeSkuDiscount,
     this.employeeSkuDiscountId,
     this.plantId,
     this.caseToMetricTonValue,
     this.uomId,
     this.uom,
     this.divisionId,
     this.salesOrganizationId,
     this.distributionChannelId,
     this.oilPackGroupTypeId,
  });

  factory ToSKUItem.fromJson(Map<String, dynamic> json) {
    return ToSKUItem(
      pricingId: json['pricingId'] ?? 0,
      skuId: json['skuId'] ?? 0,
      skuName: json['skuName'] ?? '',
      oilTypeId: json['oilTypeId'] ?? 0,
      price: (json['price'] ?? 0).toDouble(),
      employeeSkuPremium: (json['employeeSkuPremium'] ?? 0).toDouble(),
      employeeSkuPremiumId: json['employeeSkuPremiumId'] ?? 0,
      employeeSkuDiscount: (json['employeeSkuDiscount'] ?? 0).toDouble(),
      employeeSkuDiscountId: json['employeeSkuDiscountId'] ?? 0,
      plantId: json['plantId'] ?? 0,
      caseToMetricTonValue:
      (json['caseToMetricTonValue'] ?? 0).toDouble(),
      uomId: json['uomId'] ?? 0,
      uom: json['uom'] ?? '',
      divisionId: json['divisionId'] ?? 0,
      salesOrganizationId: json['salesOrganizationId'] ?? 0,
      distributionChannelId: json['distributionChannelId'] ?? 0,
      oilPackGroupTypeId: json['oilPackGroupTypeId'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pricingId': pricingId,
      'skuId': skuId,
      'skuName': skuName,
      'oilTypeId': oilTypeId,
      'price': price,
      'employeeSkuPremium': employeeSkuPremium,
      'employeeSkuPremiumId': employeeSkuPremiumId,
      'employeeSkuDiscount': employeeSkuDiscount,
      'employeeSkuDiscountId': employeeSkuDiscountId,
      'plantId': plantId,
      'caseToMetricTonValue': caseToMetricTonValue,
      'uomId': uomId,
      'uom': uom,
      'divisionId': divisionId,
      'salesOrganizationId': salesOrganizationId,
      'distributionChannelId': distributionChannelId,
      'oilPackGroupTypeId': oilPackGroupTypeId,
    };
  }
}
