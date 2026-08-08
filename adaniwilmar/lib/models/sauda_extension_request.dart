class SaudaExtensionRequest {
  int? loginUserId;
  String? remarks;
  List<SaudaExtensionList>? saudaExtensionList;

  SaudaExtensionRequest(
      {this.loginUserId, this.remarks, this.saudaExtensionList});

  SaudaExtensionRequest.fromJson(Map<String, dynamic> json) {
    loginUserId = json['LoginUserId'];
    remarks = json['Remarks'];
    if (json['SaudaExtensionList'] != null) {
      saudaExtensionList = <SaudaExtensionList>[];
      json['SaudaExtensionList'].forEach((v) {
        saudaExtensionList!.add(SaudaExtensionList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['LoginUserId'] = loginUserId;
    data['Remarks'] = remarks;
    if (saudaExtensionList != null) {
      data['SaudaExtensionList'] =
          saudaExtensionList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SaudaExtensionList {
  int? extentionDateCount;
  int? pendingContractId;
  String? requestDate;
  String? saudaNumber;
  int? saudaOrderId;

  SaudaExtensionList(
      {this.extentionDateCount,
      this.pendingContractId,
      this.requestDate,
      this.saudaNumber,
      this.saudaOrderId});

  SaudaExtensionList.fromJson(Map<String, dynamic> json) {
    extentionDateCount = json['ExtentionDateCount'];
    pendingContractId = json['PendingContractId'];
    requestDate = json['RequestDate'];
    saudaNumber = json['SaudaNumber'];
    saudaOrderId = json['SaudaOrderId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ExtentionDateCount'] = extentionDateCount;
    data['PendingContractId'] = pendingContractId;
    data['RequestDate'] = requestDate;
    data['SaudaNumber'] = saudaNumber;
    data['SaudaOrderId'] = saudaOrderId;
    return data;
  }
}
