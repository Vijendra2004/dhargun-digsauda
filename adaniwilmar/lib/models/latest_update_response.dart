class LatestUpdateResponse {
  int? bulletinId;
  String? title;
  String? content;
  bool? isActive;
  int? contentTypeId;
  String? reviewedBy;
  bool? isApproved;
  int? imageCount;
  String? fileDetail;
  bool? postStatus;
  String? postMessage;
  bool? isEdit;
  List<MediaList>? mediaList;
  int? dealerId;
  String? nationalHeadIds;
  String? zonalHeadIds;
  String? bdoIds;
  String? dealerIds;
  int? loginUserId;
  int? roleId;
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
  int? salesOrganizationId;
  int? distributionChannelId;
  int? divisionId;
  String? divisionIds;
  int? verticalId;
  int? distributionId;

  LatestUpdateResponse(
      {this.bulletinId,
        this.title,
        this.content,
        this.isActive,
        this.contentTypeId,
        this.reviewedBy,
        this.isApproved,
        this.imageCount,
        this.fileDetail,
        this.postStatus,
        this.postMessage,
        this.isEdit,
        this.mediaList,
        this.dealerId,
        this.nationalHeadIds,
        this.zonalHeadIds,
        this.bdoIds,
        this.dealerIds,
        this.loginUserId,
        this.roleId,
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
        this.salesOrganizationId,
        this.distributionChannelId,
        this.divisionId,
        this.divisionIds,
        this.verticalId,
        this.distributionId});

  LatestUpdateResponse.fromJson(Map<String, dynamic> json) {
    bulletinId = json['bulletinId'];
    title = json['title'];
    content = json['content'];
    isActive = json['isActive'];
    contentTypeId = json['contentTypeId'];
    reviewedBy = json['reviewedBy'];
    isApproved = json['isApproved'];
    imageCount = json['imageCount'];
    fileDetail = json['fileDetail'];
    postStatus = json['postStatus'];
    postMessage = json['postMessage'];
    isEdit = json['isEdit'];
    if (json['mediaList'] != null) {
      mediaList = <MediaList>[];
      json['mediaList'].forEach((v) {
        mediaList!.add(new MediaList.fromJson(v));
      });
    }
    dealerId = json['dealerId'];
    nationalHeadIds = json['nationalHeadIds'];
    zonalHeadIds = json['zonalHeadIds'];
    bdoIds = json['bdoIds'];
    dealerIds = json['dealerIds'];
    loginUserId = json['loginUserId'];
    roleId = json['roleId'];
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
    salesOrganizationId = json['salesOrganizationId'];
    distributionChannelId = json['distributionChannelId'];
    divisionId = json['divisionId'];
    divisionIds = json['divisionIds'];
    verticalId = json['verticalId'];
    distributionId = json['distributionId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bulletinId'] = this.bulletinId;
    data['title'] = this.title;
    data['content'] = this.content;
    data['isActive'] = this.isActive;
    data['contentTypeId'] = this.contentTypeId;
    data['reviewedBy'] = this.reviewedBy;
    data['isApproved'] = this.isApproved;
    data['imageCount'] = this.imageCount;
    data['fileDetail'] = this.fileDetail;
    data['postStatus'] = this.postStatus;
    data['postMessage'] = this.postMessage;
    data['isEdit'] = this.isEdit;
    if (this.mediaList != null) {
      data['mediaList'] = this.mediaList!.map((v) => v.toJson()).toList();
    }
    data['dealerId'] = this.dealerId;
    data['nationalHeadIds'] = this.nationalHeadIds;
    data['zonalHeadIds'] = this.zonalHeadIds;
    data['bdoIds'] = this.bdoIds;
    data['dealerIds'] = this.dealerIds;
    data['loginUserId'] = this.loginUserId;
    data['roleId'] = this.roleId;
    data['isToReturnInactiveData'] = this.isToReturnInactiveData;
    data['isReturnInactiveData'] = this.isReturnInactiveData;
    data['dueStatus'] = this.dueStatus;
    data['stateId'] = this.stateId;
    data['plantId'] = this.plantId;
    data['depotId'] = this.depotId;
    data['intercomId'] = this.intercomId;
    data['cityId'] = this.cityId;
    data['districtId'] = this.districtId;
    data['organizationReportingToId'] = this.organizationReportingToId;
    data['dealerCode'] = this.dealerCode;
    data['fromDate'] = this.fromDate;
    data['toDate'] = this.toDate;
    data['name'] = this.name;
    data['pageNo'] = this.pageNo;
    data['salesOrganizationId'] = this.salesOrganizationId;
    data['distributionChannelId'] = this.distributionChannelId;
    data['divisionId'] = this.divisionId;
    data['divisionIds'] = this.divisionIds;
    data['verticalId'] = this.verticalId;
    data['distributionId'] = this.distributionId;
    return data;
  }
}

class MediaList {
  String? mediaPath;
  String? mediaTypeName;
  int? mediaTypeId;
  int? bulletinMediaId;

  MediaList(
      {this.mediaPath,
        this.mediaTypeName,
        this.mediaTypeId,
        this.bulletinMediaId});

  MediaList.fromJson(Map<String, dynamic> json) {
    mediaPath = json['mediaPath'];
    mediaTypeName = json['mediaTypeName'];
    mediaTypeId = json['mediaTypeId'];
    bulletinMediaId = json['bulletinMediaId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mediaPath'] = this.mediaPath;
    data['mediaTypeName'] = this.mediaTypeName;
    data['mediaTypeId'] = this.mediaTypeId;
    data['bulletinMediaId'] = this.bulletinMediaId;
    return data;
  }
}
