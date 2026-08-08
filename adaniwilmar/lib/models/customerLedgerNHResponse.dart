class CustomerLedgerNHResponse {
  late final double totalOutStandingBalance;
  late final int transactionType;
  List<CustomerLedgerList> customerLedgerNH = <CustomerLedgerList>[];

  CustomerLedgerNHResponse.fromJson(Map<String, dynamic> json) {
    totalOutStandingBalance = json['totalOutStandingBalance'];
    transactionType = json['transactionType'];
    if (json['customerLedger'] != null) {
      customerLedgerNH = <CustomerLedgerList>[];
      json['customerLedger'].forEach((v) {
        customerLedgerNH!.add(CustomerLedgerList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalOutStandingBalance'] = totalOutStandingBalance;
    data['transactionType'] = transactionType;
    if (customerLedgerNH != null) {
      data['customerLedger'] =
          customerLedgerNH!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  CustomerLedgerNHResponse(
      {required this.totalOutStandingBalance, required this.transactionType, required this.customerLedgerNH});
}

class CustomerLedgerList {
  int? customerLedgerUserId;
  String? customerLedgerUserName;
  int? transactionType;
  double? totalOutStandingBalance;
  String? customerLedgerUserCode;

  CustomerLedgerList.fromJson(Map<String, dynamic> json) {
    customerLedgerUserName = json['customerLedgerUserName'];
    customerLedgerUserId = json['customerLedgerUserId'];
    transactionType = json['transactionType'];
    totalOutStandingBalance = json['userOutStandingBalance'];
    customerLedgerUserCode = json['customerLedgerUserCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customerLedgerUserName'] = customerLedgerUserName;
    data['customerLedgerUserId'] = customerLedgerUserId;
    data['tansactionType'] = transactionType;
    data['userOutStandingBalance'] = totalOutStandingBalance;
    data['customerLedgerUserCode'] = customerLedgerUserCode;
    return data;
  }
}
