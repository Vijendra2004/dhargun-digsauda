class SupportCategory {
  SupportCategory({
    required this.issueTypes,
    required this.severityTypes,
    required this.modules,
  });
  late final List<IssueTypes> issueTypes;
  late final List<SeverityTypes> severityTypes;
  late final List<Modules> modules;

  SupportCategory.fromJson(Map<String, dynamic> json) {
    issueTypes = List.from(json['issueTypes'])
        .map((e) => IssueTypes.fromJson(e))
        .toList();
    severityTypes = List.from(json['severityTypes'])
        .map((e) => SeverityTypes.fromJson(e))
        .toList();
    modules =
        List.from(json['modules']).map((e) => Modules.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['issueTypes'] = issueTypes.map((e) => e.toJson()).toList();
    _data['severityTypes'] = severityTypes.map((e) => e.toJson()).toList();
    _data['modules'] = modules.map((e) => e.toJson()).toList();
    return _data;
  }
}

class IssueTypes {
  IssueTypes({
    required this.id,
    required this.name,
    required this.code,
    required this.caseToMetricTonValue,
  });
  late final int id;
  late final String name;
  late final String code;
  late final int caseToMetricTonValue;

  IssueTypes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    caseToMetricTonValue = json['caseToMetricTonValue'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['code'] = code;
    _data['caseToMetricTonValue'] = caseToMetricTonValue;
    return _data;
  }
}

class SeverityTypes {
  SeverityTypes({
    required this.id,
    required this.name,
    required this.code,
    required this.caseToMetricTonValue,
  });
  late final int id;
  late final String name;
  late final String code;
  late final int caseToMetricTonValue;

  SeverityTypes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    caseToMetricTonValue = json['caseToMetricTonValue'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['code'] = code;
    _data['caseToMetricTonValue'] = caseToMetricTonValue;
    return _data;
  }
}

class Modules {
  Modules({
    required this.id,
    required this.name,
    required this.code,
    required this.caseToMetricTonValue,
  });
  late final int id;
  late final String name;
  late final String code;
  late final int caseToMetricTonValue;

  Modules.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    caseToMetricTonValue = json['caseToMetricTonValue'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['code'] = code;
    _data['caseToMetricTonValue'] = caseToMetricTonValue;
    return _data;
  }
}
