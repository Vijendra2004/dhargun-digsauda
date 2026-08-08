class CreditLimitExposure {
  String? dealerCode;
  String? dealerName;
  String? creditAccountNumber;
  double? creditLimit;
  double? creditExposure;
  double? availableCreditLimit;
  double? salesValue;
  double? totalReceivable;
  double? grossExposure;
  double? openExposure;

  CreditLimitExposure(
      {this.dealerCode,
      this.dealerName,
      this.creditAccountNumber,
      this.creditLimit,
      this.creditExposure,
      this.availableCreditLimit,
      this.salesValue,
      this.totalReceivable,
      this.grossExposure,
      this.openExposure});

  CreditLimitExposure.fromJson(Map<String, dynamic> json) {
    dealerCode = json['dealerCode'];
    dealerName = json['dealerName'];
    creditAccountNumber = json['creditAccountNumber'];
    creditLimit = json['creditLimit'];
    creditExposure = json['creditExposure'];
    availableCreditLimit = json['availableCreditLimit'];
    salesValue = json['salesValue'];
    totalReceivable = json['totalReceivable'];
    grossExposure = json['grossExposure'];
    openExposure = json['openExposure'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dealerCode'] = dealerCode;
    data['dealerName'] = dealerName;
    data['creditAccountNumber'] = creditAccountNumber;
    data['creditLimit'] = creditLimit;
    data['creditExposure'] = creditExposure;
    data['availableCreditLimit'] = availableCreditLimit;
    data['salesValue'] = salesValue;
    data['totalReceivable'] = totalReceivable;
    data['grossExposure'] = grossExposure;
    data['openExposure'] = openExposure;
    return data;
  }
}
