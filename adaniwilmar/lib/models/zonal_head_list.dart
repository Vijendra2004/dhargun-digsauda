class ZonalHeadList {
  int? id;
  String? name;
  String? code;
  double? caseToMetricTonValue;

  ZonalHeadList({this.id, this.name, this.code, this.caseToMetricTonValue});

  ZonalHeadList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    caseToMetricTonValue = json['caseToMetricTonValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['code'] = this.code;
    data['caseToMetricTonValue'] = this.caseToMetricTonValue;
    return data;
  }
}
