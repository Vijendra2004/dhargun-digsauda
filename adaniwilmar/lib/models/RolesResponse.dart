class RolesResponse {
  List<RoleItem>? response;
  String? message;

  RolesResponse({this.response, this.message});

  factory RolesResponse.fromJson(Map<String, dynamic> json) {
    return RolesResponse(
      response: json['response'] != null
          ? List<RoleItem>.from(
          json['response'].map((x) => RoleItem.fromJson(x)))
          : null,
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() => {
    "response": response?.map((x) => x.toJson()).toList(),
    "message": message,
  };
}

class RoleItem {
  int? id;
  String? name;
  String? code;
  String? mobileNumber;
  double? caseToMetricTonValue;
  int? serialNo;
  int? oilTypeId;
  int? packGroupId;

  RoleItem({
    this.id,
    this.name,
    this.code,
    this.mobileNumber,
    this.caseToMetricTonValue,
    this.serialNo,
    this.oilTypeId,
    this.packGroupId,
  });

  factory RoleItem.fromJson(Map<String, dynamic> json) {
    return RoleItem(
        id: json['id'],
        name: json['name'],
        code: json['code'],
        mobileNumber: json['mobileNumber'],
        caseToMetricTonValue: (json['caseToMetricTonValue'] != null)
            ? json['caseToMetricTonValue'].toDouble()
            : null,
        serialNo: json['serialNo'],
        oilTypeId: json['oilTypeId'],
        packGroupId: json['packGroupId']);
  }
  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "code": code,
    "mobileNumber": mobileNumber,
    "caseToMetricTonValue": caseToMetricTonValue,
    "serialNo": serialNo,
    "oilTypeId": oilTypeId,
    "packGroupId": packGroupId,
  };

}
