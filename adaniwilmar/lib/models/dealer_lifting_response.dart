class DealerLiftingResponse {
  int? dealerId;
  String? dealer;
  int? liftingRequestId;
  String? liftingRequestNumber;
  String? liftingRequestdate;
  double? requestedQuantity;
  String? createdUser;
  bool? isApproved;
  String? remarks;
  int? statusID;
  String? status;
  bool? hasChildren;
  int? shipToPartyId;
  String? shipToParty;
  bool? isCreatedBy;

  DealerLiftingResponse(
      {this.dealerId,
      this.dealer,
      this.liftingRequestId,
      this.liftingRequestNumber,
      this.liftingRequestdate,
      this.requestedQuantity,
      this.createdUser,
      this.isApproved,
      this.remarks,
      this.statusID,
      this.status,
      this.hasChildren,
      this.shipToPartyId,
      this.shipToParty,
      this.isCreatedBy});

  DealerLiftingResponse.fromJson(Map<String, dynamic> json) {
    dealerId = json['dealerId'];
    dealer = json['dealer'];
    liftingRequestId = json['liftingRequestId'];
    liftingRequestNumber = json['liftingRequestNumber'];
    liftingRequestdate = json['liftingRequestdate'];
    requestedQuantity = json['requestedQuantity'];
    createdUser = json['createdUser'];
    isApproved = json['isApproved'];
    remarks = json['remarks'];
    statusID = json['statusID'];
    status = json['status'];
    hasChildren = json['hasChildren'];
    shipToPartyId = json['shipToPartyId'];
    shipToParty = json['shipToParty'];
    isCreatedBy = json['isCreatedBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dealerId'] = dealerId;
    data['dealer'] = dealer;
    data['liftingRequestId'] = liftingRequestId;
    data['liftingRequestNumber'] = liftingRequestNumber;
    data['liftingRequestdate'] = liftingRequestdate;
    data['requestedQuantity'] = requestedQuantity;
    data['createdUser'] = createdUser;
    data['isApproved'] = isApproved;
    data['remarks'] = remarks;
    data['statusID'] = statusID;
    data['status'] = status;
    data['hasChildren'] = hasChildren;
    data['shipToPartyId'] = shipToPartyId;
    data['shipToParty'] = shipToParty;
    data['isCreatedBy'] = isCreatedBy;
    return data;
  }
}
