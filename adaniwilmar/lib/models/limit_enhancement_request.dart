class LimitEnhancementRequest {
  int? dealerId;
  String? remarks;
  double? requestQuantityLimit;
  double? actualLimit;
  int? createdBy;
  int? salesOrganizationId;
  int? distributionChannelId;
  int? divisionId;

  LimitEnhancementRequest(
      {this.dealerId,
      this.remarks,
      this.requestQuantityLimit,
      this.actualLimit,
      this.createdBy,
      this.salesOrganizationId,
      this.distributionChannelId,
      this.divisionId});

  LimitEnhancementRequest.fromJson(Map<String, dynamic> json) {
    dealerId = json['DealerId'];
    remarks = json['Remarks '];
    requestQuantityLimit = json['RequestQuantityLimit'];
    actualLimit = json['ActualLimit'];
    createdBy = json['CreatedBy'];
    salesOrganizationId = json['salesOrganizationId'];
    distributionChannelId = json['distributionChannelId'];
    divisionId = json['divisionId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['DealerId'] = dealerId;
    data['Remarks '] = remarks;
    data['RequestQuantityLimit'] = requestQuantityLimit;
    data['ActualLimit'] = actualLimit;
    data['CreatedBy'] = createdBy;
    data['salesOrganizationId'] = salesOrganizationId;
    data['distributionChannelId'] = distributionChannelId;
    data['divisionId'] = divisionId;
    return data;
  }
}
