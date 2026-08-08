class SaudaModApprovalRequest {
  String? remarks;
  int? statusId;
  int? modifiedBy;
  int? loginUserId;
  List<int>? SaudaModificationIds;

  SaudaModApprovalRequest(
      {this.remarks, this.statusId, this.modifiedBy, this.SaudaModificationIds});

  SaudaModApprovalRequest.fromJson(Map<String, dynamic> json) {
    remarks = json['remarks'];
    statusId = json['statusId'];
    modifiedBy = json['modifiedBy'];
    loginUserId = json['loginUserId'];
    if (json['SaudaModificationIds'] != null) {
      SaudaModificationIds = json['SaudaModificationIds'].cast<int>();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['remarks'] = remarks;
    data['statusId'] = statusId;
    data['modifiedBy'] = modifiedBy;
    data['SaudaModificationIds'] = SaudaModificationIds;
    data['loginUserId'] = loginUserId;
    return data;
  }
}
