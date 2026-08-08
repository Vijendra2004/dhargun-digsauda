class SaudaApprovalRequest {
  String? remarks;
  int? statusId;
  int? modifiedBy;
  int? loginUserId;
  List<int>? saudaOrderIds;
  List<Map<String, dynamic>>? skuList; // Added

  SaudaApprovalRequest({this.remarks, this.statusId, this.modifiedBy, this.saudaOrderIds, this.skuList});

  SaudaApprovalRequest.fromJson(Map<String, dynamic> json) {
    remarks = json['remarks'];
    statusId = json['statusId'];
    modifiedBy = json['modifiedBy'];
    loginUserId = json['loginUserId'];
    if (json['saudaOrderIds'] != null) {
      saudaOrderIds = json['nationalHeadIds'].cast<int>();
    }
    if (json['skuList'] != null) {
      skuList = List<Map<String, dynamic>>.from(
        json['skuList'].map((e) => Map<String, dynamic>.from(e)),
      );
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['remarks'] = remarks;
    data['statusId'] = statusId;
    data['modifiedBy'] = modifiedBy;
    data['saudaOrderIds'] = saudaOrderIds;
    data['loginUserId'] = loginUserId;
    data['skuList'] = skuList; // Added
    return data;
  }
}
