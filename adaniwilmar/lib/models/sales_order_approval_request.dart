class SaveSalesOrderApprovalRequest {
  int? id;
  int? statusId;
  int? loginUserId;

  SaveSalesOrderApprovalRequest({this.id, this.statusId, this.loginUserId});

  SaveSalesOrderApprovalRequest.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    statusId = json['StatusId'];
    loginUserId = json['LoginUserId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['StatusId'] = this.statusId;
    data['LoginUserId'] = this.loginUserId;
    return data;
  }
}
