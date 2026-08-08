class ChequePending {
  ChequePending({
    this.chequeNo,
    this.bankName,
    this.branchName,
    this.dealerName,
    this.dealerCode,
    this.bdoName,
    this.bdoCode,
    this.createdDate,
  });
  String? chequeNo;
  String? bankName;
  String? branchName;
  String? dealerName;
  String? dealerCode;
  String? bdoName;
  String? bdoCode;
  String? createdDate;

  ChequePending.fromJson(Map<String, dynamic> json) {
    chequeNo = json['chequeNo'];
    bankName = json['bankName'];
    branchName = json['branchName'];
    dealerName = json['dealerName'];
    dealerCode = json['dealerCode'];
    bdoName = json['bdoName'];
    bdoCode = json['bdoCode'];
    createdDate = json['createdDate'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['chequeNo'] = chequeNo;
    _data['bankName'] = bankName;
    _data['branchName'] = branchName;
    _data['dealerName'] = dealerName;
    _data['dealerCode'] = dealerCode;
    _data['bdoName'] = bdoName;
    _data['bdoCode'] = bdoCode;
    _data['createdDate'] = createdDate;
    return _data;
  }
}
