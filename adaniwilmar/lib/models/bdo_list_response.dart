class BdoList {
  int? id;
  String? name;
  String? code;
  double? caseToMetricTonValue;
  bool? selected=false;

  BdoList({this.id, this.name, this.code, this.caseToMetricTonValue,this.selected=false});

  BdoList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    caseToMetricTonValue = json['caseToMetricTonValue'];
    // selected=json['selected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['code'] = code;
    data['caseToMetricTonValue'] = caseToMetricTonValue;
    data['selected']=selected;
    return data;
  }
}

class ZonalEmployeeList {
  int? id;
  String? employeeName;
  String? employeeCode;

  ZonalEmployeeList({this.id, this.employeeName, this.employeeCode});

  ZonalEmployeeList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    employeeName = json['employeeName'];
    employeeCode = json['employeeCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['employeeName'] = employeeName;
    data['employeeCode'] = employeeCode;
    return data;
  }
}

