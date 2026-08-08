class ApprovedMtp {
  int? mtpId;
  String? mtpNumber;

  ApprovedMtp({this.mtpId, this.mtpNumber});

  ApprovedMtp.fromJson(Map<String, dynamic> json) {
    mtpId = json['mtpId'];
    mtpNumber = json['mtpNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mtpId'] = mtpId;
    data['mtpNumber'] = mtpNumber;
    return data;
  }
}

class TourPlanDetail {
  int? mtpId;
  int? mtpDetailId;
  String? dealerId;
  String? dealer;
  int? toDealerId;
  String? toDealer;
  int? inHQNoVisitId;
  String? inHQNoVisitName;
  String? actualDate;
  String? revisedDate;
  String? deviationActualDate;
  String? deviationRevisedDate;
  String? remarks;
  String? approval;
  bool? isChecked;
  int? statusId;
  String? status;
  int? id;
  String? area;
  int? reasonId;
  String? reason;
  String? approverRemarks;
  String? town;
  String? reasons;
  int? createdBy;
  String? createdByUser;
  String? pcpValidFrom;
  String? pcpValidTo;
  String? pcpValidFromString;
  String? pcpValidToString;
  int? approvedBy;
  bool? isApprove;

  TourPlanDetail(
      {this.mtpId,
      this.mtpDetailId,
      this.dealerId,
      this.dealer,
      this.toDealerId,
      this.toDealer,
      this.inHQNoVisitId,
      this.inHQNoVisitName,
      this.actualDate,
      this.revisedDate,
      this.deviationActualDate,
      this.deviationRevisedDate,
      this.remarks,
      this.approval,
      this.isChecked,
      this.statusId,
      this.status,
      this.id,
      this.area,
      this.reasonId,
      this.reason,
      this.approverRemarks,
      this.town,
      this.reasons,
      this.createdBy,
      this.createdByUser,
      this.pcpValidFrom,
      this.pcpValidTo,
      this.pcpValidFromString,
      this.pcpValidToString,
      this.approvedBy,
      this.isApprove});

  TourPlanDetail.fromJson(Map<String, dynamic> json) {
    mtpId = json['mtpId'];
    mtpDetailId = json['mtpDetailId'];
    dealerId = json['dealerId'];
    dealer = json['dealer'];
    toDealerId = json['toDealerId'];
    toDealer = json['toDealer'];
    inHQNoVisitId = json['inHQNoVisitId'];
    inHQNoVisitName = json['inHQNoVisitName'];
    actualDate = json['actualDate'];
    revisedDate = json['revisedDate'];
    deviationActualDate = json['deviationActualDate'];
    deviationRevisedDate = json['deviationRevisedDate'];
    remarks = json['remarks'];
    approval = json['approval'];
    isChecked = json['isChecked'];
    statusId = json['statusId'];
    status = json['status'];
    id = json['id'];
    area = json['area'];
    reasonId = json['reasonId'];
    reason = json['reason'];
    approverRemarks = json['approverRemarks'];
    town = json['town'];
    reasons = json['reasons'];
    createdBy = json['createdBy'];
    createdByUser = json['createdByUser'];
    pcpValidFrom = json['pcpValidFrom'];
    pcpValidTo = json['pcpValidTo'];
    pcpValidFromString = json['pcpValidFromString'];
    pcpValidToString = json['pcpValidToString'];
    approvedBy = json['approvedBy'];
    isApprove = json['isApprove'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mtpId'] = mtpId;
    data['mtpDetailId'] = mtpDetailId;
    data['dealerId'] = dealerId;
    data['dealer'] = dealer;
    data['toDealerId'] = toDealerId;
    data['toDealer'] = toDealer;
    data['inHQNoVisitId'] = inHQNoVisitId;
    data['inHQNoVisitName'] = inHQNoVisitName;
    data['actualDate'] = actualDate;
    data['revisedDate'] = revisedDate;
    data['deviationActualDate'] = deviationActualDate;
    data['deviationRevisedDate'] = deviationRevisedDate;
    data['remarks'] = remarks;
    data['approval'] = approval;
    data['isChecked'] = isChecked;
    data['statusId'] = statusId;
    data['status'] = status;
    data['id'] = id;
    data['area'] = area;
    data['reasonId'] = reasonId;
    data['reason'] = reason;
    data['approverRemarks'] = approverRemarks;
    data['town'] = town;
    data['reasons'] = reasons;
    data['createdBy'] = createdBy;
    data['createdByUser'] = createdByUser;
    data['pcpValidFrom'] = pcpValidFrom;
    data['pcpValidTo'] = pcpValidTo;
    data['pcpValidFromString'] = pcpValidFromString;
    data['pcpValidToString'] = pcpValidToString;
    data['approvedBy'] = approvedBy;
    data['isApprove'] = isApprove;
    return data;
  }
}

class DeviationReason {
  int? id;
  String? reason;
  int? reasonId;
  String? description;
  bool? isActive;

  DeviationReason({this.id, this.reason, this.reasonId, this.description, this.isActive});

  DeviationReason.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    reason = json['reason'];
    reasonId = json['reasonId'];
    description = json['description'];
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['reason'] = reason;
    data['reasonId'] = reasonId;
    data['description'] = description;
    data['isActive'] = isActive;
    return data;
  }
}

class DeviationRequest {
  int? createdBy;
  int? monthlyTourPlanDetailsId;
  String? reasons;
  String? remarks;
  String? revisedDate;

  DeviationRequest({this.createdBy, this.monthlyTourPlanDetailsId, this.reasons, this.remarks, this.revisedDate});

  DeviationRequest.fromJson(Map<String, dynamic> json) {
    createdBy = json['CreatedBy'];
    monthlyTourPlanDetailsId = json['monthlyTourPlanDetailsId'];
    reasons = json['reasons'];
    remarks = json['remarks'];
    revisedDate = json['revisedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CreatedBy'] = createdBy;
    data['monthlyTourPlanDetailsId'] = monthlyTourPlanDetailsId;
    data['reasons'] = reasons;
    data['remarks'] = remarks;
    data['revisedDate'] = revisedDate;
    return data;
  }
}

class DeviationAddResponse {
  int? monthlyTourPlanDetailsId;
  String? plannedDate;
  String? revisedDate;
  String? remarks;
  int? approverId;
  int? statusId;
  int? id;
  String? approval;
  int? reasonId;
  String? reasons;
  int? createdBy;
  String? dealer;
  int? toDealerId;
  String? toDealer;
  String? inHQNoVisitName;

  DeviationAddResponse(
      {this.monthlyTourPlanDetailsId,
      this.plannedDate,
      this.revisedDate,
      this.remarks,
      this.approverId,
      this.statusId,
      this.id,
      this.approval,
      this.reasonId,
      this.reasons,
      this.createdBy,
      this.dealer,
      this.toDealerId,
      this.toDealer,
      this.inHQNoVisitName});

  DeviationAddResponse.fromJson(Map<String, dynamic> json) {
    monthlyTourPlanDetailsId = json['monthlyTourPlanDetailsId'];
    plannedDate = json['plannedDate'];
    revisedDate = json['revisedDate'];
    remarks = json['remarks'];
    approverId = json['approverId'];
    statusId = json['statusId'];
    id = json['id'];
    approval = json['approval'];
    reasonId = json['reasonId'];
    reasons = json['reasons'];
    createdBy = json['createdBy'];
    dealer = json['dealer'];
    toDealerId = json['toDealerId'];
    toDealer = json['toDealer'];
    inHQNoVisitName = json['inHQNoVisitName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['monthlyTourPlanDetailsId'] = monthlyTourPlanDetailsId;
    data['plannedDate'] = plannedDate;
    data['revisedDate'] = revisedDate;
    data['remarks'] = remarks;
    data['approverId'] = approverId;
    data['statusId'] = statusId;
    data['id'] = id;
    data['approval'] = approval;
    data['reasonId'] = reasonId;
    data['reasons'] = reasons;
    data['createdBy'] = createdBy;
    data['dealer'] = dealer;
    data['toDealerId'] = toDealerId;
    data['toDealer'] = toDealer;
    data['inHQNoVisitName'] = inHQNoVisitName;
    return data;
  }
}

class IOSVersionModel {
  int? resultCount;
  List<IOSResults>? results;

  IOSVersionModel({this.resultCount, this.results});

  IOSVersionModel.fromJson(Map<String, dynamic> json) {
    resultCount = json['resultCount'];
    if (json['results'] != null) {
      results = <IOSResults>[];
      json['results'].forEach((v) {
        results!.add(IOSResults.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['resultCount'] = resultCount;
    if (results != null) {
      data['results'] = results!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class IOSResults {
  String? version;

  IOSResults({
    this.version,
  });

  IOSResults.fromJson(Map<String, dynamic> json) {
    version = json['version'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['version'] = version;
    return data;
  }
}
