class SKUPricing {
  int? pricingId;
  int? skuId;
  String? skuName;
  double? premiumAmount;
  String? storageLocation;
  int? oilTypeId;
  double? price;
  double? exPlantPrice;
  double? forPlantPrice;
  double? exDepotPrice;
  double? forDepotPrice;
  double? exRakePrice;
  double? forRakePrice;
  double? employeeSkuPremium;
  double? employeeSkuDiscount;
  int? plantId;
  int? depotId;
  int? frieghtRouteId;
  double? caseToMetricTonValue;
  double? metricTonToCaseValue;
  int? transportModeId;
  double? loadQuantity;
  int? cityId;
  int? stateId;
  double? hbcLooseDiscount;
  int? uomId;
  String? uom;
  int? divisionId;
  int? salesOrganizationId;
  int? distributionChannelId;
  double? qpsDiscount;
  double? finalRate;

  SKUPricing(
      {this.pricingId,
      this.skuId,
      this.skuName,
      this.premiumAmount,
      this.storageLocation,
      this.oilTypeId,
      this.exPlantPrice,
      this.forPlantPrice,
      this.exDepotPrice,
      this.forDepotPrice,
      this.exRakePrice,
      this.forRakePrice,
      this.employeeSkuPremium,
      this.employeeSkuDiscount,
      this.plantId,
      this.depotId,
      this.frieghtRouteId,
      this.caseToMetricTonValue,
      this.metricTonToCaseValue,
      this.transportModeId,
      this.loadQuantity,
      this.cityId,
      this.stateId,
      this.hbcLooseDiscount,
      this.price,
      this.uomId,
      this.uom,
      this.divisionId,
      this.distributionChannelId,
      this.salesOrganizationId,
      this.qpsDiscount,
      this.finalRate,
      });

  SKUPricing.fromJson(Map<String, dynamic> json) {
    pricingId = json['pricingId'];
    skuId = json['skuId'];
    skuName = json['skuName'];
    premiumAmount = json['premiumAmount'];
    storageLocation = json['storageLocation'];
    oilTypeId = json['oilTypeId'];
    exPlantPrice = json['exPlantPrice'];
    forPlantPrice = json['forPlantPrice'];
    exDepotPrice = json['exDepotPrice'];
    forDepotPrice = json['forDepotPrice'];
    exRakePrice = json['exRakePrice'];
    forRakePrice = json['forRakePrice'];
    employeeSkuPremium = json['employeeSkuPremium'];
    employeeSkuDiscount = json['employeeSkuDiscount'];
    plantId = json['plantId'];
    depotId = json['depotId'];
    frieghtRouteId = json['frieghtRouteId'];
    caseToMetricTonValue = json['caseToMetricTonValue'];
    metricTonToCaseValue = json['metricTonToCaseValue'];
    transportModeId = json['transportModeId'];
    loadQuantity = json['loadQuantity'];
    cityId = json['cityId'];
    stateId = json['stateId'];
    hbcLooseDiscount = json['hbcLooseDiscount'];
    price = json['price'];
    uomId = json['uomId'];
    uom = json['uom'];
    divisionId = json['divisionId'];
    salesOrganizationId = json['salesOrganizationId'];
    distributionChannelId = json['distributionChannelId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pricingId'] = pricingId;
    data['skuId'] = skuId;
    data['skuName'] = skuName;
    data['premiumAmount'] = premiumAmount;
    data['storageLocation'] = storageLocation;
    data['oilTypeId'] = oilTypeId;
    data['exPlantPrice'] = exPlantPrice;
    data['forPlantPrice'] = forPlantPrice;
    data['exDepotPrice'] = exDepotPrice;
    data['forDepotPrice'] = forDepotPrice;
    data['exRakePrice'] = exRakePrice;
    data['forRakePrice'] = forRakePrice;
    data['employeeSkuPremium'] = employeeSkuPremium;
    data['employeeSkuDiscount'] = employeeSkuDiscount;
    data['plantId'] = plantId;
    data['depotId'] = depotId;
    data['frieghtRouteId'] = frieghtRouteId;
    data['caseToMetricTonValue'] = caseToMetricTonValue;
    data['metricTonToCaseValue'] = metricTonToCaseValue;
    data['transportModeId'] = transportModeId;
    data['loadQuantity'] = loadQuantity;
    data['cityId'] = cityId;
    data['stateId'] = stateId;
    data['hbcLooseDiscount'] = hbcLooseDiscount;
    data['price'] = price;
    data['uomId'] = uomId;
    data['uom'] = uom;
    data['divisionId'] = divisionId;
    data['salesOrganizationId'] = salesOrganizationId;
    data['distributionChannelId'] = distributionChannelId;

    return data;
  }
}
