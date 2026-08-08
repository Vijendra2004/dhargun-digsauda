class DeviationResponse {
  int? mtpDetailId;
  String? dealerId;
  String? dealer;
  int? inHQNoVisitId;
  String? inHQNoVisitName;
  String? actualDate;
  String? revisedDate;
  String? status;
  String? reason;
  String? town;

  DeviationResponse(
      {this.mtpDetailId,
      this.dealerId,
      this.dealer,
      this.inHQNoVisitId,
      this.inHQNoVisitName,
      this.actualDate,
      this.revisedDate,
      this.status,
      this.reason,
      this.town});

  DeviationResponse.fromJson(Map<String, dynamic> json) {
    mtpDetailId = json['mtpDetailId'];
    dealerId = json['dealerId'];
    dealer = json['dealer'];
    inHQNoVisitId = json['inHQNoVisitId'];
    inHQNoVisitName = json['inHQNoVisitName'];
    actualDate = json['actualDate'];
    revisedDate = json['revisedDate'];
    status = json['status'];
    reason = json['reason'];
    town = json['town'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mtpDetailId'] = mtpDetailId;
    data['dealerId'] = dealerId;
    data['dealer'] = dealer;
    data['inHQNoVisitId'] = inHQNoVisitId;
    data['inHQNoVisitName'] = inHQNoVisitName;
    data['actualDate'] = actualDate;
    data['revisedDate'] = revisedDate;
    data['status'] = status;
    data['reason'] = reason;
    data['town'] = town;
    return data;
  }
}
