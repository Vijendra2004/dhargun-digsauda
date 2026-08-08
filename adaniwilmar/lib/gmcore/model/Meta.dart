// ignore_for_file: prefer_collection_literals

class Meta {
  int statusCode = 0;
  String statusMsg = "";
  Map<String, dynamic> response = Map<String, dynamic>();

  Meta({this.statusCode = 0, this.statusMsg = ""});

  Meta.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    statusMsg = json['statusMsg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['statusCode'] = statusCode;
    data['statusMsg'] = statusMsg;
    return data;
  }
}
