class CreditLimitExposerViewDto {
  CreditLimitExposerViewDto({
    required this.dealerCode,
    required this.dealerName,
    required this.creditAccountNumber,
    required this.creditLimit,
    required this.creditExposure,
    required this.availableCreditLimit,
    required this.salesValue,
    required this.totalReceivable,
  });
  late final String dealerCode;
  late final String dealerName;
  late final String creditAccountNumber;
  late final int creditLimit;
  late final int creditExposure;
  late final int availableCreditLimit;
  late final int salesValue;
  late final int totalReceivable;

  CreditLimitExposerViewDto.fromJson(Map<String, dynamic> json) {
    dealerCode = json['dealerCode'];
    dealerName = json['dealerName'];
    creditAccountNumber = json['creditAccountNumber'];
    creditLimit = json['creditLimit'];
    creditExposure = json['creditExposure'];
    availableCreditLimit = json['availableCreditLimit'];
    salesValue = json['salesValue'];
    totalReceivable = json['totalReceivable'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['dealerCode'] = dealerCode;
    _data['dealerName'] = dealerName;
    _data['creditAccountNumber'] = creditAccountNumber;
    _data['creditLimit'] = creditLimit;
    _data['creditExposure'] = creditExposure;
    _data['availableCreditLimit'] = availableCreditLimit;
    _data['salesValue'] = salesValue;
    _data['totalReceivable'] = totalReceivable;
    return _data;
  }
}
