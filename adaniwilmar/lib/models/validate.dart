class Validate {
  String clientKey = "";
  String clientType = "";

  Validate({this.clientKey = "", this.clientType = ""});

  Validate.fromJson(Map<String, dynamic> json) {
    clientKey = json['clientKey'];
    clientType = json['clientType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['clientKey'] = clientKey;
    data['clientType'] = clientType;
    return data;
  }
}
