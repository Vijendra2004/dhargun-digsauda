class RequestQuantityStatusUpdateReq {
  List<int>? quantityRequestIds;
  int? statusId;
  int? loginUserId;
  int? remainingQuantity;
  int? parentQuantityId;
  int? roleId;
  String? remarks;
  double? updateQuantity;

  RequestQuantityStatusUpdateReq(
      {this.quantityRequestIds,
        this.statusId,
       this.loginUserId,
        this.remainingQuantity,
        this.parentQuantityId,
        this.roleId,
        this.remarks, this.updateQuantity});

  RequestQuantityStatusUpdateReq.fromJson(Map<String, dynamic> json) {
    quantityRequestIds = json['quantityRequestIds'].cast<int>();
    statusId = json['statusId'];
    loginUserId = json['loginUserId'];
    remainingQuantity = json['remainingQuantity'];
    parentQuantityId = json['parentQuantityId'];
    roleId = json['roleId'];
    remarks = json['remarks'];
    updateQuantity = json['updateQuantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['quantityRequestIds'] = quantityRequestIds;
    data['statusId'] = statusId;
    data['loginUserId'] = loginUserId;
    data['remainingQuantity'] = remainingQuantity;
    data['parentQuantityId'] = parentQuantityId;
    data['roleId'] = roleId;
    data['remarks'] = remarks;
    data['updateQuantity'] = updateQuantity;
    return data;
  }
}