class SupportList {
  int? id;
  String? description;
  int? componentId;
  String? component;
  int? impactId;
  String? impact;
  int? featureId;
  String? feature;
  int? statusId;
  String? status;
  int? stateId;
  String? state;
  String? sla;
  String? createdDateTime;
  String? modifiedDateTime;
  int? issueRaisedBy;
  String? issueRaisedByUserName;
  String? resolvedDateTime;
  String? timeTakenToResolve;
  int? deviceId;
  String? issueFromDevice;
  String? issueComments;
  int? loginUserId;
  bool? postStatus;
  String? postMessage;
  List<SupportComments>? comments;
  List<String>? attachments;

  SupportList(
      {this.id,
        this.description,
        this.componentId,
        this.component,
        this.impactId,
        this.impact,
        this.featureId,
        this.feature,
        this.statusId,
        this.status,
        this.stateId,
        this.state,
        this.sla,
        this.createdDateTime,
        this.modifiedDateTime,
        this.issueRaisedBy,
        this.issueRaisedByUserName,
        this.resolvedDateTime,
        this.timeTakenToResolve,
        this.deviceId,
        this.issueFromDevice,
        this.issueComments,
        this.loginUserId,
        this.postStatus,
        this.postMessage,
        this.comments,
        this.attachments});

  SupportList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    componentId = json['componentId'];
    component = json['component'];
    impactId = json['impactId'];
    impact = json['impact'];
    featureId = json['featureId'];
    feature = json['feature'];
    statusId = json['statusId'];
    status = json['status'];
    stateId = json['stateId'];
    state = json['state'];
    sla = json['sla'];
    createdDateTime = json['createdDateTime'];
    modifiedDateTime = json['modifiedDateTime'];
    issueRaisedBy = json['issueRaisedBy'];
    issueRaisedByUserName = json['issueRaisedByUserName'];
    resolvedDateTime = json['resolvedDateTime'];
    timeTakenToResolve = json['timeTakenToResolve'];
    deviceId = json['deviceId'];
    issueFromDevice = json['issueFromDevice'];
    issueComments = json['issueComments'];
    loginUserId = json['loginUserId'];
    postStatus = json['postStatus'];
    postMessage = json['postMessage'];
    if (json['comments'] != null) {
      comments = <SupportComments>[];
      json['comments'].forEach((v) {
        comments!.add(SupportComments.fromJson(v));
      });
    }
    if (json['attachments'] != null) {
      attachments = <String>[];
      json['attachments'].forEach((v) {
        attachments!.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['description'] = this.description;
    data['componentId'] = this.componentId;
    data['component'] = this.component;
    data['impactId'] = this.impactId;
    data['impact'] = this.impact;
    data['featureId'] = this.featureId;
    data['feature'] = this.feature;
    data['statusId'] = this.statusId;
    data['status'] = this.status;
    data['stateId'] = this.stateId;
    data['state'] = this.state;
    data['sla'] = this.sla;
    data['createdDateTime'] = this.createdDateTime;
    data['modifiedDateTime'] = this.modifiedDateTime;
    data['issueRaisedBy'] = this.issueRaisedBy;
    data['issueRaisedByUserName'] = this.issueRaisedByUserName;
    data['resolvedDateTime'] = this.resolvedDateTime;
    data['timeTakenToResolve'] = this.timeTakenToResolve;
    data['deviceId'] = this.deviceId;
    data['issueFromDevice'] = this.issueFromDevice;
    data['issueComments'] = this.issueComments;
    data['loginUserId'] = this.loginUserId;
    data['postStatus'] = this.postStatus;
    data['postMessage'] = this.postMessage;
    if (this.comments != null) {
      data['comments'] = this.comments!;
    }
    if (this.attachments != null) {
      data['attachments'] = this.attachments!;
    }
    return data;
  }
}


class SupportMaster {
  List<IssueTypes>? issueTypes;
  List<IssueTypes>? severityTypes;
  List<IssueTypes>? modules;

  SupportMaster({this.issueTypes, this.severityTypes, this.modules});

  SupportMaster.fromJson(Map<String, dynamic> json) {
    if (json['issueTypes'] != null) {
      issueTypes = <IssueTypes>[];
      json['issueTypes'].forEach((v) {
        issueTypes!.add(new IssueTypes.fromJson(v));
      });
    }
    if (json['severityTypes'] != null) {
      severityTypes = <IssueTypes>[];
      json['severityTypes'].forEach((v) {
        severityTypes!.add(new IssueTypes.fromJson(v));
      });
    }
    if (json['modules'] != null) {
      modules = <IssueTypes>[];
      json['modules'].forEach((v) {
        modules!.add(new IssueTypes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.issueTypes != null) {
      data['issueTypes'] = this.issueTypes!.map((v) => v.toJson()).toList();
    }
    if (this.severityTypes != null) {
      data['severityTypes'] =
          this.severityTypes!.map((v) => v.toJson()).toList();
    }
    if (this.modules != null) {
      data['modules'] = this.modules!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class IssueTypes {
  int? id;
  String? name;
  String? code;
  double? caseToMetricTonValue;

  IssueTypes({this.id, this.name, this.code, this.caseToMetricTonValue});

  IssueTypes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    caseToMetricTonValue = json['caseToMetricTonValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['code'] = this.code;
    data['caseToMetricTonValue'] = this.caseToMetricTonValue;
    return data;
  }
}

class SupportRequest {
  List<String>? attachments;
  int? componentId;
  String? description;
  String? feature;
  int? featureId;
  int? impactId;
  int? loginUserId;

  SupportRequest(
      {this.attachments,
        this.componentId,
        this.description,
        this.feature,
        this.featureId,
        this.impactId,
        this.loginUserId});

  SupportRequest.fromJson(Map<String, dynamic> json) {
    attachments = json['Attachments'].cast<String>();
    componentId = json['ComponentId'];
    description = json['Description'];
    feature = json['Feature'];
    featureId = json['FeatureId'];
    impactId = json['ImpactId'];
    loginUserId = json['LoginUserId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Attachments'] = this.attachments;
    data['ComponentId'] = this.componentId;
    data['Description'] = this.description;
    data['Feature'] = this.feature;
    data['FeatureId'] = this.featureId;
    data['ImpactId'] = this.impactId;
    data['LoginUserId'] = this.loginUserId;
    return data;
  }
}

class SupportComments {
  int? commentId;
  int? supportId;
  String? comments;
  String? commentedDate;
  int? userId;
  String? commentedBy;
  bool? isActive;
  String? postMessage;
  bool? postStatus;
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
  int? salesOrganizationId;
  int? distributionChannelId;
  int? divisionId;
  List<int>? divisionIds;
  int? verticalId;
  int? distributionId;

  SupportComments(
      {this.commentId,
        this.supportId,
        this.comments,
        this.commentedDate,
        this.userId,
        this.commentedBy,
        this.isActive,
        this.postMessage,
        this.postStatus,
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
        this.salesOrganizationId,
        this.distributionChannelId,
        this.divisionId,
        this.divisionIds,
        this.verticalId,
        this.distributionId});

  SupportComments.fromJson(Map<String, dynamic> json) {
    commentId = json['commentId'];
    supportId = json['supportId'];
    comments = json['comments'];
    commentedDate = json['commentedDate'];
    userId = json['userId'];
    commentedBy = json['commentedBy'];
    isActive = json['isActive'];
    postMessage = json['postMessage'];
    postStatus = json['postStatus'];
    dealerId = json['dealerId'];
    nationalHeadIds = json['nationalHeadIds'];
    zonalHeadIds = json['zonalHeadIds'];
    bdoIds = json['bdoIds'];
    dealerIds = json['dealerIds'];
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
    salesOrganizationId = json['salesOrganizationId'];
    distributionChannelId = json['distributionChannelId'];
    divisionId = json['divisionId'];
    divisionIds = json['divisionIds'];
    verticalId = json['verticalId'];
    distributionId = json['distributionId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['commentId'] = this.commentId;
    data['supportId'] = this.supportId;
    data['comments'] = this.comments;
    data['commentedDate'] = this.commentedDate;
    data['userId'] = this.userId;
    data['commentedBy'] = this.commentedBy;
    data['isActive'] = this.isActive;
    data['postMessage'] = this.postMessage;
    data['postStatus'] = this.postStatus;
    data['dealerId'] = this.dealerId;
    data['nationalHeadIds'] = this.nationalHeadIds;
    data['zonalHeadIds'] = this.zonalHeadIds;
    data['bdoIds'] = this.bdoIds;
    data['dealerIds'] = this.dealerIds;
    data['loginUserId'] = this.loginUserId;
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
