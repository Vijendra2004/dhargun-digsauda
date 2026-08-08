class OilPackage {
  List<OilPackGroupTypeId>? response;
  String? message;

  OilPackage({this.response, this.message});

  OilPackage.fromJson(Map<String, dynamic> json) {
    if (json['response'] != null) {
      response = <OilPackGroupTypeId>[];
      json['response'].forEach((v) {
        response!.add(OilPackGroupTypeId.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (response != null) {
      data['response'] = response!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    return data;
  }
}

class OilPackGroupTypeId {
  int? id;
  String? name;
  bool? isActive;

  OilPackGroupTypeId({this.id, this.name, this.isActive});

  OilPackGroupTypeId.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['isActive'] = isActive;
    return data;
  }
}
