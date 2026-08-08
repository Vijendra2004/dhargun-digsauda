class ActiveState {
  String? stateName;
  bool? isActive;
  String? postMessage;
  bool? postStatus;
  List? cities;
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
  String? name;
  int? pageNo;
  List<int>? salesOrganizationIds;
  List<int>? distributionChannelIds;
  List<int>? divisionIds;
  int? verticalId;
  int? distributionId;

  ActiveState(
      {this.stateName,
      this.isActive,
      this.postMessage,
      this.postStatus,
      this.cities,
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
      this.name,
      this.pageNo,
      this.salesOrganizationIds,
      this.distributionChannelIds,
      this.divisionIds,
      this.verticalId,
      this.distributionId});

  ActiveState.fromJson(Map<String, dynamic> json) {
    stateName = json['stateName'];
    isActive = json['isActive'];
    postMessage = json['postMessage'];
    postStatus = json['postStatus'];
    if (json['cities'] != null) {
      cities = [];
    }
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
    name = json['name'];
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
    verticalId = json['verticalId'];
    distributionId = json['distributionId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['stateName'] = stateName;
    data['isActive'] = isActive;
    data['postMessage'] = postMessage;
    data['postStatus'] = postStatus;
    if (cities != null) {
      data['cities'] = [];
    }
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
    data['name'] = name;
    data['pageNo'] = pageNo;
    data['salesOrganizationIds'] = salesOrganizationIds;
    data['distributionChannelIds'] = distributionChannelIds;
    data['divisionIds'] = divisionIds;
    data['verticalId'] = verticalId;
    data['distributionId'] = distributionId;
    return data;
  }
}
