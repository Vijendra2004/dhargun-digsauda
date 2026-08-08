class LedgerInfo {
  LedgerInfo({
    required this.currentBalance,
    required this.customerLedger,
    required this.transactionType,
  });
  late final double currentBalance;
  late final int transactionType;
  late final List<CustomerLedger> customerLedger;

  LedgerInfo.fromJson(Map<String, dynamic> json) {
    currentBalance = json['currentBalance'];
    transactionType = json['transactionType'];
    customerLedger = List.from(json['customerLedger'])
        .map((e) => CustomerLedger.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['currentBalance'] = currentBalance;
    _data['transactionType'] = transactionType;
    _data['customerLedger'] = customerLedger.map((e) => e.toJson()).toList();
    return _data;
  }
}

class CustomerLedger {
  CustomerLedger({
    required this.transactionAmount,
    required this.transactionType,
    required this.postingDate,
    required this.reference,
  });
  late final double transactionAmount;
  late final int transactionType;
  late final String postingDate;
  late final String reference;

  CustomerLedger.fromJson(Map<String, dynamic> json) {
    transactionAmount = json['transactionAmount'];
    transactionType = json['transactionType'];
    postingDate = json['postingDate'];
    reference = json['reference'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['transactionAmount'] = transactionAmount;
    _data['transactionType'] = transactionType;
    _data['postingDate'] = postingDate;
    _data['reference'] = reference;
    return _data;
  }
}
