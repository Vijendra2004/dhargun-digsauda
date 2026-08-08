class OilType {
  int? id;
  String? name;
  int? verticalId;
  String? verticalName;
  double? litreConversion;
  bool? isActive;
  double? volumeCapacity;
  int? selectedOilTypeId;
  int? salesOrganizationId;
  String? salesOrganizationName;
  int? distributionChannelId;
  String? distributionChannelName;
  int? dealerId;
  List<int>? nationalHeadIds;
  List<int>? zonalHeadIds;
  List<int>? bdoIds;
  List<int>? dealerIds;
  int? loginUserId;
  bool? isToReturnInactiveData;
  int? isReturnInactiveData;
  int? dueStatus;
  int? stateId;
  int? plantId;
  int? depotId;
  int? intercomId;
  int? cityId;
  int? districtId;
  int? organizationReportingToId;
  String? dealerCode;
  String? fromDate;
  String? toDate;
  int? pageNo;
  List<int>? salesOrganizationIds;
  List<int>? distributionChannelIds;
  List<int>? divisionIds;
  int? distributionId;
  bool? postStatus;
  String? postMessage;

  OilType(
      {this.id,
      this.name,
      this.verticalId,
      this.verticalName,
      this.litreConversion,
      this.isActive,
      this.volumeCapacity,
      this.selectedOilTypeId,
      this.salesOrganizationId,
      this.salesOrganizationName,
      this.distributionChannelId,
      this.distributionChannelName,
      this.dealerId,
      this.nationalHeadIds,
      this.zonalHeadIds,
      this.bdoIds,
      this.dealerIds,
      this.loginUserId,
      this.isToReturnInactiveData,
      this.isReturnInactiveData,
      this.dueStatus,
      this.stateId,
      this.plantId,
      this.depotId,
      this.intercomId,
      this.cityId,
      this.districtId,
      this.organizationReportingToId,
      this.dealerCode,
      this.fromDate,
      this.toDate,
      this.pageNo,
      this.salesOrganizationIds,
      this.distributionChannelIds,
      this.divisionIds,
      this.distributionId,
      this.postStatus,
      this.postMessage});

  OilType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    verticalId = json['verticalId'];
    verticalName = json['verticalName'];
    litreConversion = json['litreConversion'];
    isActive = json['isActive'];
    volumeCapacity = json['volumeCapacity'];
    selectedOilTypeId = json['selectedOilTypeId'];
    salesOrganizationId = json['salesOrganizationId'];
    salesOrganizationName = json['salesOrganizationName'];
    distributionChannelId = json['distributionChannelId'];
    distributionChannelName = json['distributionChannelName'];
    dealerId = json['dealerId'];
    if (json['nationalHeadIds'] != null) {
      nationalHeadIds = json['nationalHeadIds'].cast<int>();
    }
    if (json['zonalHeadIds'] != null) {
      zonalHeadIds = json['zonalHeadIds'].cast<int>();
    }
    if (json['bdoIds'] != null) {
      bdoIds = json['bdoIds'].cast<int>();
    }
    if (json['dealerIds'] != null) {
      dealerIds = json['dealerIds'].cast<int>();
    }
    loginUserId = json['loginUserId'];
    isToReturnInactiveData = json['isToReturnInactiveData'];
    isReturnInactiveData = json['isReturnInactiveData'];
    dueStatus = json['dueStatus'];
    stateId = json['stateId'];
    plantId = json['plantId'];
    depotId = json['depotId'];
    intercomId = json['intercomId'];
    cityId = json['cityId'];
    districtId = json['districtId'];
    organizationReportingToId = json['organizationReportingToId'];
    dealerCode = json['dealerCode'];
    fromDate = json['fromDate'];
    toDate = json['toDate'];
    pageNo = json['pageNo'];
    if (json['salesOrganizationIds'] != null) {
      salesOrganizationIds = json['salesOrganizationIds'].cast<int>();
    }
    if (json['distributionChannelIds'] != null) {
      distributionChannelIds = json['distributionChannelIds'].cast<int>();
    }
    if (json['divisionIds'] != null) {
      divisionIds = json['divisionIds'].cast<int>();
    }
    distributionId = json['distributionId'];
    postStatus = json['postStatus'];
    postMessage = json['postMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['verticalId'] = verticalId;
    data['verticalName'] = verticalName;
    data['litreConversion'] = litreConversion;
    data['isActive'] = isActive;
    data['volumeCapacity'] = volumeCapacity;
    data['selectedOilTypeId'] = selectedOilTypeId;
    data['salesOrganizationId'] = salesOrganizationId;
    data['salesOrganizationName'] = salesOrganizationName;
    data['distributionChannelId'] = distributionChannelId;
    data['distributionChannelName'] = distributionChannelName;
    data['dealerId'] = dealerId;
    data['nationalHeadIds'] = nationalHeadIds;
    data['zonalHeadIds'] = zonalHeadIds;
    data['bdoIds'] = bdoIds;
    data['dealerIds'] = dealerIds;
    data['loginUserId'] = loginUserId;
    data['isToReturnInactiveData'] = isToReturnInactiveData;
    data['isReturnInactiveData'] = isReturnInactiveData;
    data['dueStatus'] = dueStatus;
    data['stateId'] = stateId;
    data['plantId'] = plantId;
    data['depotId'] = depotId;
    data['intercomId'] = intercomId;
    data['cityId'] = cityId;
    data['districtId'] = districtId;
    data['organizationReportingToId'] = organizationReportingToId;
    data['dealerCode'] = dealerCode;
    data['fromDate'] = fromDate;
    data['toDate'] = toDate;
    data['pageNo'] = pageNo;
    data['salesOrganizationIds'] = salesOrganizationIds;
    data['distributionChannelIds'] = distributionChannelIds;
    data['divisionIds'] = divisionIds;
    data['distributionId'] = distributionId;
    data['postStatus'] = postStatus;
    data['postMessage'] = postMessage;
    return data;
  }
}
