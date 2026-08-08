class OilPackGroupType {
  String? name;
  int? id;

  OilPackGroupType({this.name, this.id});

  OilPackGroupType.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['id'] = this.id;
    return data;
  }
}