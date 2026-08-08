class PendingSaudaSlab {
  int? id;
  String? name;
  int? value;
  int? fromValue;
  int? toValue;

  PendingSaudaSlab({this.id, this.name, this.value});

  PendingSaudaSlab.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    value = json['value'];
    fromValue = json['fromValue'];
    toValue = json['toValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['value'] = value;
    data['fromValue'] = fromValue;
    data['toValue'] = toValue;
    return data;
  }
}
