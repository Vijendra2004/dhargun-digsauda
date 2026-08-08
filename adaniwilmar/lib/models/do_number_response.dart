class DoNumberResponse {
  int? doId;
  String? doValue;
  String? billingNo;

  DoNumberResponse({this.doId, this.doValue});

  DoNumberResponse.fromJson(Map<String, dynamic> json) {
    doId = json['id'];
    doValue = json['value'];
    billingNo = json['billingNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = doId;
    data['value'] = doValue;
    data['billingNo'] = billingNo;
    return data;
  }
}