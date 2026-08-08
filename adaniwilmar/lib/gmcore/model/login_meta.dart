class LoginMeta {
  int statusCode = 0;
  String statusMsg = "";
  String level2token = "";

  LoginMeta({this.statusCode = 0, this.statusMsg = ""});

  LoginMeta.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    statusMsg = json['statusMsg'];
    statusMsg = json['level2token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['statusMsg'] = statusMsg;
    data['level2token'] = level2token;
    return data;
  }
}
